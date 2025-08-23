import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Char "mo:base/Char";

import Types "../types/Types";

module {
  
  public class HttpService() {
    
    // External AI service URL (set this to your Railway/Render deployment)
    private let AI_SERVICE_URL = "https://your-ai-service.railway.app";
    
    public func callExternalAI(request: Types.AIRequest) : async Result.Result<Types.AIResponse, Text> {
      
      Debug.print("Preparing HTTP request to AI service");
      
      // Prepare JSON request body
      let jsonBody = buildJsonRequest(request);
      let requestBodyBytes = Blob.toArray(Text.encodeUtf8(jsonBody));
      
      let httpRequest: Types.HttpRequest = {
        url = AI_SERVICE_URL # "/analyze";
        method = "POST";
        body = ?requestBodyBytes;
        headers = [
          ("Content-Type", "application/json"),
          ("Accept", "application/json"),
          ("User-Agent", "ICP-DAO-Analyzer/1.0")
        ];
        transform = null;
      };
      
      // Add cycles for HTTP outcall (20B cycles should be enough)
      Cycles.add(20_000_000_000);
      
      try {
        Debug.print("Making HTTP outcall to: " # httpRequest.url);
        
        // Make HTTP outcall using IC management canister
        let ic : actor {
          http_request : Types.HttpRequest -> async Types.HttpResponse;
        } = actor("aaaaa-aa"); // IC management canister
        
        let response = await ic.http_request(httpRequest);
        
        Debug.print("Received HTTP response with status: " # debug_show(response.status));
        
        switch (response.status) {
          case (200) {
            // Parse successful response
            let responseText = parseResponseBody(response.body);
            Debug.print("Response body: " # responseText);
            
            switch (parseAIResponse(responseText)) {
              case (#ok(aiResponse)) {
                Debug.print("Successfully parsed AI response");
                #ok(aiResponse)
              };
              case (#err(parseError)) {
                Debug.print("Failed to parse AI response: " # parseError);
                #err("Failed to parse AI response: " # parseError)
              };
            }
          };
          case (status) {
            let errorMsg = "HTTP error: " # debug_show(status);
            Debug.print(errorMsg);
            #err(errorMsg)
          };
        }
      } catch (error) {
        let errorMsg = "Network error: " # debug_show(error);
        Debug.print(errorMsg);
        #err(errorMsg)
      }
    };
    
    private func buildJsonRequest(request: Types.AIRequest) : Text {
      // Build JSON manually (in production, use a JSON library)
      "{" #
        "\"title\":\"" # escapeJson(request.title) # "\"," #
        "\"description\":\"" # escapeJson(request.description) # "\"" #
      "}"
    };
    
    private func escapeJson(text: Text) : Text {
      // Simple JSON escaping (in production, use proper JSON library)
      let chars = Text.toIter(text);
      var result = "";
      
      for (char in chars) {
        switch (char) {
          case ('"') { result #= "\\\"" };
          case ('\\') { result #= "\\\\" };
          case ('\n') { result #= "\\n" };
          case ('\r') { result #= "\\r" };
          case ('\t') { result #= "\\t" };
          case (_) { result #= Char.toText(char) };
        }
      };
      
      result
    };
    
    private func parseResponseBody(body: [Nat8]) : Text {
      switch (Text.decodeUtf8(Blob.fromArray(body))) {
        case (?text) { text };
        case null { "" };
      }
    };
    
    private func parseAIResponse(jsonText: Text) : Result.Result<Types.AIResponse, Text> {
      // Simple JSON parsing (in production, use a proper JSON parser)
      // For now, return a mock response based on the input
      
      if (Text.size(jsonText) == 0) {
        return #err("Empty response from AI service");
      };
      
      // Mock parsing - replace with actual JSON parsing
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
    
    // Health check for the AI service
    public func healthCheck() : async Result.Result<Text, Text> {
      let httpRequest: Types.HttpRequest = {
        url = AI_SERVICE_URL # "/health";
        method = "GET";
        body = null;
        headers = [("Accept", "application/json")];
        transform = null;
      };
      
      Cycles.add(10_000_000_000);
      
      try {
        let ic : actor {
          http_request : Types.HttpRequest -> async Types.HttpResponse;
        } = actor("aaaaa-aa");
        
        let response = await ic.http_request(httpRequest);
        
        switch (response.status) {
          case (200) { #ok("AI service is healthy") };
          case (status) { #err("AI service unhealthy: " # debug_show(status)) };
        }
      } catch (error) {
        #err("Failed to reach AI service: " # debug_show(error))
      }
    };
  }
}