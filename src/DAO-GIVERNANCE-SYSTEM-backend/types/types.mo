import Time "mo:base/Time";

module {
  
  public type ProposalInput = {
    title: Text;
    description: Text;
    timestamp: Int;
  };
  
  public type HistoricalProposal = {
    title: Text;
    description: Text;
    date: Int;
    dao_name: Text;
    voting_results: VotingResults;
    outcome: Text; // "passed" or "failed"
    community_sentiment: Text;
    similarity_score: Float;
  };
  
  public type VotingResults = {
    approved: Nat;
    rejected: Nat;
    abstained: Nat;
  };
  
  public type LiveInsight = {
    source: Text;
    content: Text;
    sentiment: Text; // "Positive", "Neutral", "Negative"
    relevance_score: Float;
    timestamp: Int;
    url: ?Text;
  };
  
  public type MarketContext = {
    market_trend: Text; // "bullish", "bearish", "neutral"
    dao_activity_level: Float;
    governance_participation: Float;
    recent_proposals_success_rate: Float;
    community_engagement: Float;
  };
  
  public type AnalysisResult = {
    proposal: ProposalInput;
    likelihood_percentage: Float;
    likelihood_level: Text; // "High", "Medium", "Low"
    community_sentiment: Text; // "Positive", "Neutral", "Negative"
    reasoning: Text;
    risks: [Text];
    opportunities: [Text];
    historical_matches: [HistoricalProposal];
    live_insights: [LiveInsight];
    market_context: MarketContext;
    confidence_score: Float;
  };
  
  // HTTP types for external AI service calls
  public type HttpRequest = {
    url: Text;
    method: Text;
    body: ?[Nat8];
    headers: [(Text, Text)];
  };
  
  public type HttpResponse = {
    status: Nat;
    headers: [(Text, Text)];
    body: [Nat8];
  };
  
  // AI service request/response types
  public type AIRequest = {
    title: Text;
    description: Text;
  };
  
  public type AIResponse = {
    likelihood_percentage: Float;
    likelihood_level: Text;
    community_sentiment: Text;
    reasoning: Text;
    risks: [Text];
    opportunities: [Text];
    confidence_score: Float;
  };
}