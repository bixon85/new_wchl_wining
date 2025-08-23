import Time "mo:base/Time";
import Array "mo:base/Array";

import Types "../types/Types";

module {
  
  public class AnalysisService() {
    
    public func processAIResponse(proposal: Types.ProposalInput, aiResponse: Types.AIResponse) : Types.AnalysisResult {
      
      // Create mock historical matches and live insights
      let mockHistoricalMatches: [Types.HistoricalProposal] = [
        {
          title = "Similar Staking Proposal";
          description = "Previous staking reward increase";
          date = Time.now() - 86400000000000; // 1 day ago in nanoseconds
          dao_name = "MockDAO";
          voting_results = { approved = 1500; rejected = 500; abstained = 100 };
          outcome = "passed";
          community_sentiment = "positive";
          similarity_score = 0.85;
        }
      ];
      
      let mockLiveInsights: [Types.LiveInsight] = [
        {
          source = "twitter";
          content = "Community supports this type of proposal";
          sentiment = "Positive";
          relevance_score = 0.9;
          timestamp = Time.now();
          url = ?"https://twitter.com/example";
        }
      ];
      
      let mockMarketContext: Types.MarketContext = {
        market_trend = "bullish";
        dao_activity_level = 0.75;
        governance_participation = 0.68;
        recent_proposals_success_rate = 0.72;
        community_engagement = 0.80;
      };
      
      // Combine AI response with additional data
      {
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
      }
    };
  }
}