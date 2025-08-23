import Debug "mo:base/Debug";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Int "mo:base/Int";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";

// Import custom modules
import Types "types/types";
import ProposalService "services/ProposalService";
import AnalysisService "services/AnalysisService";
import HttpService "services/HttpService";
import ProposalStorage "storage/ProposalStorage";
import AnalysisStorage "storage/AnalysisStorage";

actor DAOAnalyzer {
  
  // Stable storage for upgrades
  private stable var proposalsEntries: [(Text, Types.ProposalInput)] = [];
  private stable var analysesEntries: [(Text, Types.AnalysisResult)] = [];
  
  // Initialize storage
  private var proposalStorage = ProposalStorage.ProposalStorage();
  private var analysisStorage = AnalysisStorage.AnalysisStorage();
  
  // Initialize services
  private let proposalService = ProposalService.ProposalService();
  private let analysisService = AnalysisService.AnalysisService();
  private let httpService = HttpService.HttpService();
  
  // System functions for upgrades
  system func preupgrade() {
    proposalsEntries := proposalStorage.getEntries();
    analysesEntries := analysisStorage.getEntries();
  };
  
  system func postupgrade() {
    proposalStorage.loadEntries(proposalsEntries);
    analysisStorage.loadEntries(analysesEntries);
    proposalsEntries := [];
    analysesEntries := [];
  };
  
  // Main analysis function
  public func analyzeProposal(title: Text, description: Text) : async Result.Result<Types.AnalysisResult, Text> {
    try {
      Debug.print("Starting proposal analysis: " # title);
      
      // Validate input
      if (Text.size(title) < 10) {
        return #err("Title must be at least 10 characters");
      };
      
      if (Text.size(description) < 50) {
        return #err("Description must be at least 50 characters");
      };
      
      // Create proposal input
      let proposal: Types.ProposalInput = {
        title = title;
        description = description;
        timestamp = Time.now();
      };
      
      // Generate unique ID
      let proposalId = title # "_" # Int.toText(Time.now());
      
      // Store proposal
      proposalStorage.store(proposalId, proposal);
      
      // Call external AI service via HTTP outcall
      let aiRequest: Types.AIRequest = {
        title = title;
        description = description;
      };
      
      Debug.print("Calling external AI service...");
      
      switch (await httpService.callExternalAI(aiRequest)) {
        case (#ok(aiResponse)) {
          Debug.print("AI service responded successfully");
          
          // Process AI response into AnalysisResult
          let analysis = analysisService.processAIResponse(proposal, aiResponse);
          
          // Store analysis
          analysisStorage.store(proposalId, analysis);
          
          Debug.print("Analysis completed successfully");
          #ok(analysis)
        };
        case (#err(error)) {
          Debug.print("AI service error: " # error);
          #err("AI service error: " # error)
        };
      }
    } catch (error) {
      let errorMsg = "Analysis failed: " # debug_show(error);
      Debug.print(errorMsg);
      #err(errorMsg)
    }
  };
  
  // Query functions
  public query func getProposals() : async [(Text, Types.ProposalInput)] {
    proposalStorage.getAll()
  };
  
  public query func getAnalyses() : async [(Text, Types.AnalysisResult)] {
    analysisStorage.getAll()
  };
  
  public query func getAnalysis(proposalId: Text) : async ?Types.AnalysisResult {
    analysisStorage.get(proposalId)
  };
  
  public query func getProposal(proposalId: Text) : async ?Types.ProposalInput {
    proposalStorage.get(proposalId)
  };
  
  // Statistics functions
  public query func getStats() : async Types.SystemStats {
    let totalProposals = proposalStorage.size();
    let totalAnalyses = analysisStorage.size();
    
    {
      totalProposals = totalProposals;
      totalAnalyses = totalAnalyses;
      systemUptime = Time.now();
      version = "1.0.0";
    }
  };
  
  // Health check
  public query func health() : async Types.HealthStatus {
    {
      status = "healthy";
      timestamp = Time.now();
      version = "1.0.0";
      services = {
        proposalService = true;
        analysisService = true;
        httpService = true;
        storage = true;
      };
    }
  };
  
  // Admin functions
  public func clearData() : async Result.Result<Text, Text> {
    try {
      proposalStorage.clear();
      analysisStorage.clear();
      #ok("All data cleared successfully")
    } catch (error) {
      #err("Failed to clear data: " # debug_show(error))
    }
  };
}