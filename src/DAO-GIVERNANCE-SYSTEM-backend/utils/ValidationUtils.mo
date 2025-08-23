import Text "mo:base/Text";
import Float "mo:base/Float";
import Array "mo:base/Array";

import Types "../types/types";
import TextUtils "TextUtils";

module {
  
  public func validateProposalInput(proposal: Types.ProposalInput) : ?Text {
    // Validate title
    let trimmedTitle = TextUtils.trim(proposal.title);
    if (Text.size(trimmedTitle) < 10) {
      return ?"Title must be at least 10 characters long";
    };
    
    if (Text.size(trimmedTitle) > 200) {
      return ?"Title must be less than 200 characters long";
    };
    
    // Validate description
    let trimmedDescription = TextUtils.trim(proposal.description);
    if (Text.size(trimmedDescription) < 50) {
      return ?"Description must be at least 50 characters long";
    };
    
    if (Text.size(trimmedDescription) > 5000) {
      return ?"Description must be less than 5000 characters long";
    };
    
    // Check for meaningful content
    if (TextUtils.wordCount(trimmedTitle) < 3) {
      return ?"Title must contain at least 3 words";
    };
    
    if (TextUtils.wordCount(trimmedDescription) < 10) {
      return ?"Description must contain at least 10 words";
    };
    
    null // No validation errors
  };
  
  public func validateAnalysisResult(result: Types.AnalysisResult) : ?Text {
    // Validate likelihood percentage
    if (result.likelihood_percentage < 0.0 or result.likelihood_percentage > 100.0) {
      return ?"Likelihood percentage must be between 0 and 100";
    };
    
    // Validate confidence score
    if (result.confidence_score < 0.0 or result.confidence_score > 100.0) {
      return ?"Confidence score must be between 0 and 100";
    };
    
    // Validate likelihood level
    if (not isValidLikelihoodLevel(result.likelihood_level)) {
      return ?"Invalid likelihood level";
    };
    
    // Validate community sentiment
    if (not isValidSentiment(result.community_sentiment)) {
      return ?"Invalid community sentiment";
    };
    
    // Validate reasoning
    if (Text.size(TextUtils.trim(result.reasoning)) < 20) {
      return ?"Reasoning must be at least 20 characters long";
    };
    
    // Validate risks and opportunities
    if (Array.size(result.risks) == 0) {
      return ?"At least one risk must be identified";
    };
    
    if (Array.size(result.opportunities) == 0) {
      return ?"At least one opportunity must be identified";
    };
    
    null // No validation errors
  };
  
  public func isValidLikelihoodLevel(level: Text) : Bool {
    level == "High" or level == "Medium" or level == "Low"
  };
  
  public func isValidSentiment(sentiment: Text) : Bool {
    sentiment == "Positive" or sentiment == "Neutral" or sentiment == "Negative"
  };
  
  public func isValidMarketTrend(trend: Text) : Bool {
    trend == "bullish" or trend == "bearish" or trend == "neutral"
  };
  
  public func validateFloat(value: Float, min: Float, max: Float) : Bool {
    value >= min and value <= max
  };
  
  public func validateMarketContext(context: Types.MarketContext) : ?Text {
    if (not isValidMarketTrend(context.market_trend)) {
      return ?"Invalid market trend";
    };
    
    if (not validateFloat(context.dao_activity_level, 0.0, 1.0)) {
      return ?"DAO activity level must be between 0.0 and 1.0";
    };
    
    if (not validateFloat(context.governance_participation, 0.0, 1.0)) {
      return ?"Governance participation must be between 0.0 and 1.0";
    };
    
    if (not validateFloat(context.recent_proposals_success_rate, 0.0, 1.0)) {
      return ?"Recent proposals success rate must be between 0.0 and 1.0";
    };
    
    if (not validateFloat(context.community_engagement, 0.0, 1.0)) {
      return ?"Community engagement must be between 0.0 and 1.0";
    };
    
    null // No validation errors
  };
  
  public func sanitizeText(text: Text) : Text {
    // Basic text sanitization
    let trimmed = TextUtils.trim(text);
    
    // Remove excessive whitespace
    // This is a simplified implementation
    trimmed
  };
}