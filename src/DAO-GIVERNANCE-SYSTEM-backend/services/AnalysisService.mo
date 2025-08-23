import Time "mo:base/Time";
import Array "mo:base/Array";
import Debug "mo:base/Debug";

import Types "../types/Types";

module {
  
  public class AnalysisService() {
    
    public func processAIResponse(proposal: Types.ProposalInput, aiResponse: Types.AIResponse) : Types.AnalysisResult {
      
      Debug.print("Processing AI response for proposal: " # proposal.title);
      
      // Create mock historical matches (in production, these would come from the AI service)
      let mockHistoricalMatches: [Types.HistoricalProposal] = [
        {
          title = "Similar Staking Proposal";
          description = "Previous staking reward increase proposal";
          date = Time.now() - 86400000000000; // 1 day ago in nanoseconds
          dao_name = "MockDAO";
          voting_results = { approved = 1500; rejected = 500; abstained = 100 };
          outcome = "passed";
          community_sentiment = "positive";
          similarity_score = 0.85;
        },
        {
          title = "Treasury Management Proposal";
          description = "Previous treasury diversification proposal";
          date = Time.now() - 172800000000000; // 2 days ago
          dao_name = "ExampleDAO";
          voting_results = { approved = 2200; rejected = 800; abstained = 200 };
          outcome = "passed";
          community_sentiment = "positive";
          similarity_score = 0.72;
        }
      ];
      
      // Create mock live insights
      let mockLiveInsights: [Types.LiveInsight] = [
        {
          source = "twitter";
          content = "Community supports this type of proposal based on recent discussions";
          sentiment = "Positive";
          relevance_score = 0.9;
          timestamp = Time.now();
          url = ?"https://twitter.com/example";
        },
        {
          source = "reddit";
          content = "Mixed reactions but generally positive sentiment in governance forums";
          sentiment = "Neutral";
          relevance_score = 0.75;
          timestamp = Time.now() - 3600000000000; // 1 hour ago
          url = ?"https://reddit.com/r/dao";
        },
        {
          source = "governance_forum";
          content = "Expert analysis suggests this proposal aligns with community interests";
          sentiment = "Positive";
          relevance_score = 0.95;
          timestamp = Time.now() - 7200000000000; // 2 hours ago
          url = ?"https://forum.example.com";
        }
      ];
      
      // Create market context
      let mockMarketContext: Types.MarketContext = {
        market_trend = "bullish";
        dao_activity_level = 0.75;
        governance_participation = 0.68;
        recent_proposals_success_rate = 0.72;
        community_engagement = 0.80;
      };
      
      // Combine AI response with additional context data
      let analysisResult: Types.AnalysisResult = {
        proposal = proposal;
        likelihood_percentage = aiResponse.likelihood_percentage;
        likelihood_level = aiResponse.likelihood_level;
        community_sentiment = aiResponse.community_sentiment;
        reasoning = aiResponse.reasoning;
        risks = aiResponse.risks;
        opportunities = aiResponse.opportunities;
        historical_matches = mockHistoricalMatches;
        live_insights = mockLiveInsights;
        market_context = mockMarketContext;
        confidence_score = aiResponse.confidence_score;
      };
      
      Debug.print("Analysis processing completed");
      analysisResult
    };
    
    public func validateAnalysisResult(result: Types.AnalysisResult) : Bool {
      // Validate the analysis result
      if (result.likelihood_percentage < 0.0 or result.likelihood_percentage > 100.0) {
        return false;
      };
      
      if (result.confidence_score < 0.0 or result.confidence_score > 100.0) {
        return false;
      };
      
      if (Array.size(result.risks) == 0 or Array.size(result.opportunities) == 0) {
        return false;
      };
      
      true
    };
    
    public func calculateConfidenceAdjustment(result: Types.AnalysisResult) : Float {
      // Adjust confidence based on data quality
      var adjustment: Float = 1.0;
      
      // Reduce confidence if few historical matches
      if (Array.size(result.historical_matches) < 3) {
        adjustment *= 0.9;
      };
      
      // Reduce confidence if few live insights
      if (Array.size(result.live_insights) < 3) {
        adjustment *= 0.95;
      };
      
      // Boost confidence for high market engagement
      if (result.market_context.community_engagement > 0.8) {
        adjustment *= 1.05;
      };
      
      adjustment
    };
  }
}