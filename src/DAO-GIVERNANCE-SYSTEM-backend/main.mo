import Debug "mo:base/Debug";
import Time "mo:base/Time";
import Result "mo:base/Result";
import HTTP "mo:base/HTTP";

actor DAOAnalyzer {
  
  // Types
  public type ProposalInput = {
    title: Text;
    description: Text;
    timestamp: Int;
  };
  
  public type AnalysisResult = {
    proposal: ProposalInput;
    likelihood_percentage: Float;
    likelihood_level: Text;
    community_sentiment: Text;
    reasoning: Text;
    risks: [Text];
    opportunities: [Text];
    confidence_score: Float;
  };
  
  // Storage
  private stable var proposals: [(Text, ProposalInput)] = [];
  private stable var analyses: [(Text, AnalysisResult)] = [];
  
  // Main analysis function
  public func analyzeProposal(title: Text, description: Text) : async Result.Result<AnalysisResult, Text> {
    try {
      // Create proposal
      let proposal: ProposalInput = {
        title = title;
        description = description;
        timestamp = Time.now();
      };
      
      // Generate unique ID
      let proposalId = title # "_" # Int.toText(Time.now());
      
      // Store proposal
      proposals := (proposalId, proposal) # proposals;
      
      // Call external AI service
      let aiRequest = {
        title = title;
        description = description;
      };
      
      let aiResult = await callExternalAI(aiRequest);
      
      switch (aiResult) {
        case (#ok(analysis)) {
          // Store analysis
          analyses := (proposalId, analysis) # analyses;
          #ok(analysis)
        };
        case (#err(error)) {
          #err("AI service error: " # error)
        };
      }
    } catch (error) {
      #err("Analysis failed")
    }
  };
  
  // HTTP outcall to external AI service
  private func callExternalAI(request: {title: Text; description: Text}) : async Result.Result<AnalysisResult, Text> {
    let host = "your-ai-service.railway.app";
    let url = "https://" # host # "/analyze";
    
    let requestBody = "{\"title\":\"" # request.title # "\",\"description\":\"" # request.description # "\"}";
    
    let httpRequest = {
      url = url;
      method = #POST;
      body = ?Text.encodeUtf8(requestBody);
      headers = [
        ("Content-Type", "application/json"),
        ("Accept", "application/json")
      ];
    };
    
    try {
      let response = await HTTP.request(httpRequest);
      
      switch (response.status) {
        case (200) {
          // Parse response and create AnalysisResult
          // This is simplified - you'd need proper JSON parsing
          let mockResult: AnalysisResult = {
            proposal = {
              title = request.title;
              description = request.description;
              timestamp = Time.now();
            };
            likelihood_percentage = 75.0;
            likelihood_level = "High";
            community_sentiment = "Positive";
            reasoning = "Analysis completed successfully";
            risks = ["Standard governance risks"];
            opportunities = ["Community engagement"];
            confidence_score = 85.0;
          };
          #ok(mockResult)
        };
        case (_) {
          #err("HTTP error: " # Nat.toText(response.status))
        };
      }
    } catch (error) {
      #err("Network error")
    }
  };
  
  // Query functions
  public query func getProposals() : async [(Text, ProposalInput)] {
    proposals
  };
  
  public query func getAnalyses() : async [(Text, AnalysisResult)] {
    analyses
  };
  
  public query func getAnalysis(proposalId: Text) : async ?AnalysisResult {
    switch (Array.find<(Text, AnalysisResult)>(analyses, func((id, _)) = id == proposalId)) {
      case (?(_, analysis)) { ?analysis };
      case null { null };
    }
  };
}