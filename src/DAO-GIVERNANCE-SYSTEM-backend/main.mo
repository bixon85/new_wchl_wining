import Debug "mo:base/Debug";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Int "mo:base/Int";

// Import custom modules
import Types "types/Types";
import ProposalService "services/ProposalService";
import AnalysisService "services/AnalysisService";
import HttpService "services/HttpService";

actor DAOAnalyzer {
  
  // Stable storage for upgrades
  private stable var proposals: [(Text, Types.ProposalInput)] = [];
  private stable var analyses: [(Text, Types.AnalysisResult)] = [];
  
  // Initialize services
  private let proposalService = ProposalService.ProposalService();
  private let analysisService = AnalysisService.AnalysisService();
  private let httpService = HttpService.HttpService();
  
  // Main analysis function
  public func analyzeProposal(title: Text, description: Text) : async Result.Result<Types.AnalysisResult, Text> {
    try {
      // Create proposal input
      let proposal: Types.ProposalInput = {
        title = title;
        description = description;
        timestamp = Time.now();
      };
      
      // Generate unique ID
      let proposalId = title # "_" # Int.toText(Time.now());
      
      // Store proposal
      proposals := Array.append(proposals, [(proposalId, proposal)]);
      
      // Call external AI service via HTTP outcall
      let aiRequest = {
        title = title;
        description = description;
      };
      
      switch (await httpService.callExternalAI(aiRequest)) {
        case (#ok(aiResponse)) {
          // Process AI response into AnalysisResult
          let analysis = analysisService.processAIResponse(proposal, aiResponse);
          
          // Store analysis
          analyses := Array.append(analyses, [(proposalId, analysis)]);
          
          #ok(analysis)
        };
        case (#err(error)) {
          #err("AI service error: " # error)
        };
      }
    } catch (error) {
      #err("Analysis failed: " # debug_show(error))
    }
  };
  
  // Query functions
  public query func getProposals() : async [(Text, Types.ProposalInput)] {
    proposals
  };
  
  public query func getAnalyses() : async [(Text, Types.AnalysisResult)] {
    analyses
  };
  
  public query func getAnalysis(proposalId: Text) : async ?Types.AnalysisResult {
    switch (Array.find<(Text, Types.AnalysisResult)>(analyses, func((id, _)) = id == proposalId)) {
      case (?(_, analysis)) { ?analysis };
      case null { null };
    }
  };
  
  // Health check
  public query func health() : async { status: Text; timestamp: Int } {
    {
      status = "healthy";
      timestamp = Time.now();
    }
  };
}