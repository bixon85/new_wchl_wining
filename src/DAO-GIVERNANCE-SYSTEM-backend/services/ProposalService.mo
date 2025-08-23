import Time "mo:base/Time";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Debug "mo:base/Debug";

import Types "../types/Types";

module {
  
  public class ProposalService() {
    
    public func validateProposal(proposal: Types.ProposalInput) : Result.Result<(), Text> {
      // Validate title
      if (Text.size(proposal.title) < 10) {
        return #err("Title must be at least 10 characters long");
      };
      
      if (Text.size(proposal.title) > 200) {
        return #err("Title must be less than 200 characters long");
      };
      
      // Validate description
      if (Text.size(proposal.description) < 50) {
        return #err("Description must be at least 50 characters long");
      };
      
      if (Text.size(proposal.description) > 5000) {
        return #err("Description must be less than 5000 characters long");
      };
      
      // Check for basic content quality
      if (not containsAlphanumeric(proposal.title)) {
        return #err("Title must contain alphanumeric characters");
      };
      
      if (not containsAlphanumeric(proposal.description)) {
        return #err("Description must contain alphanumeric characters");
      };
      
      #ok(())
    };
    
    public func categorizeProposal(proposal: Types.ProposalInput) : Text {
      let titleLower = Text.toLowercase(proposal.title);
      let descriptionLower = Text.toLowercase(proposal.description);
      let content = titleLower # " " # descriptionLower;
      
      // Categorize based on keywords
      if (containsKeywords(content, ["staking", "stake", "reward", "apy", "yield"])) {
        return "staking";
      } else if (containsKeywords(content, ["treasury", "fund", "funding", "budget", "allocation"])) {
        return "treasury";
      } else if (containsKeywords(content, ["governance", "voting", "proposal", "democracy", "participation"])) {
        return "governance";
      } else if (containsKeywords(content, ["token", "emission", "inflation", "supply", "burn", "mint"])) {
        return "tokenomics";
      } else if (containsKeywords(content, ["security", "audit", "bug", "bounty", "vulnerability"])) {
        return "security";
      } else if (containsKeywords(content, ["partnership", "collaboration", "integration", "alliance"])) {
        return "partnership";
      } else {
        return "general";
      }
    };
    
    public func calculateComplexityScore(proposal: Types.ProposalInput) : Float {
      var score: Float = 0.0;
      
      // Base score from length
      let titleLength = Text.size(proposal.title);
      let descriptionLength = Text.size(proposal.description);
      
      // Title complexity
      if (titleLength > 50) {
        score += 0.2;
      };
      
      // Description complexity
      if (descriptionLength > 500) {
        score += 0.3;
      };
      
      if (descriptionLength > 1000) {
        score += 0.2;
      };
      
      // Technical terms increase complexity
      let content = Text.toLowercase(proposal.title # " " # proposal.description);
      let technicalTerms = ["implementation", "protocol", "algorithm", "consensus", "cryptographic", "blockchain"];
      
      for (term in technicalTerms.vals()) {
        if (Text.contains(content, #text term)) {
          score += 0.1;
        };
      };
      
      // Cap at 1.0
      if (score > 1.0) {
        score := 1.0;
      };
      
      score
    };
    
    public func generateProposalId(proposal: Types.ProposalInput) : Text {
      // Generate a unique ID based on title and timestamp
      let titleHash = Text.hash(proposal.title);
      let timestampText = debug_show(proposal.timestamp);
      
      "proposal_" # debug_show(titleHash) # "_" # timestampText
    };
    
    private func containsAlphanumeric(text: Text) : Bool {
      let chars = Text.toIter(text);
      for (char in chars) {
        if (char >= 'a' and char <= 'z') return true;
        if (char >= 'A' and char <= 'Z') return true;
        if (char >= '0' and char <= '9') return true;
      };
      false
    };
    
    private func containsKeywords(text: Text, keywords: [Text]) : Bool {
      for (keyword in keywords.vals()) {
        if (Text.contains(text, #text keyword)) {
          return true;
        };
      };
      false
    };
  }
}