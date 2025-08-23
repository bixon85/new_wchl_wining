import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Text "mo:base/Text";
import Result "mo:base/Result";

import Types "../types/Types";

module {
  
  public class HttpService() {
    
    // External AI service URL (Railway/Render deployment)
    private let AI_SERVICE_URL = "https://your-ai-service.railway.app";
    
    public func callExternalAI(request: Types.AIRequest) : async Result.Result<Types.AIResponse, Text> {
      
      // Prepare HTTP request
      let requestBody = "{\"title\":\"" # request.title # "\",\"description\":\"" # request.description # "\"}";
      let requestBodyBytes = Blob.toArray(Text.encodeUtf8(requestBody));
      
      let httpRequest: Types.HttpRequest = {
        url = AI_SERVICE_URL # "/analyze";
        method = "POST";
        body = ?requestBodyBytes;
        headers = [
          ("Content-Type", "application/json"),
          ("Accept", "application/json")
        ];
      };
      
      // Add cycles for HTTP outcall
      Cycles.add(20_000_000_000);
      
      try {
        // Make HTTP outcall (this is a simplified version)
        // In production, you'd use the IC management canister
        let response = await makeHttpCall(httpRequest);
        
        switch (response.status) {
          case (200) {
            // Parse response (simplified - you'd use proper JSON parsing)
            let mockResponse: Types.AIResponse = {
              likelihood_percentage = 75.0;
              likelihood_level = "High";
              community_sentiment = "Positive";
              reasoning = "Analysis completed successfully based on historical data and current market conditions.";
              risks = ["Standard governance risks", "Implementation complexity"];
              opportunities = ["Community engagement", "Protocol improvement"];
              confidence_score = 85.0;
            };
            #ok(mockResponse)
          };
          case (_) {
            #err("HTTP error: " # debug_show(response.status))
          };
        }
      } catch (error) {
        #err("Network error: " # debug_show(error))
      }
    };
    
    // Simplified HTTP call function
    // In production, use IC management canister's http_request method
    private func makeHttpCall(request: Types.HttpRequest) : async Types.HttpResponse {
      // This is a mock implementation
      // Replace with actual IC HTTP outcall
      {
        status = 200;
        headers = [("Content-Type", "application/json")];
        body = [];
      }
    };
  }
}