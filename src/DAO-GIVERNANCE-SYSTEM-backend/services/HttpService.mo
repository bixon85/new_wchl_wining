import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Text "mo:base/Text";
import Result "mo:base/Result";

import Types "../types/types";

module {

  public class HttpService() {

    // External AI service URL - UPDATE THIS WITH YOUR RAILWAY URL
    private let AI_SERVICE_URL = "https://your-ai-service.railway.app";

    public func callExternalAI(request : Types.AIRequest) : async Result.Result<Types.AIResponse, Text> {

      Debug.print("Calling AI service at: " # AI_SERVICE_URL);

      // Build JSON request
      let jsonBody = buildJsonRequest(request);
      let requestBodyBytes = Blob.toArray(Text.encodeUtf8(jsonBody));

      let httpRequest : Types.HttpRequest = {
        url = AI_SERVICE_URL # "/analyze";
        method = "POST";
        body = ?requestBodyBytes;
        headers = [
          ("Content-Type", "application/json"),
          ("Accept", "application/json"),
        ];
        transform = null;
      };

      try {
        // Make HTTP outcall using IC management canister
        let ic : actor {
          http_request : Types.HttpRequest -> async Types.HttpResponse;
        } = actor ("aaaaa-aa");

        // Attach cycles using new syntax
        let response = await (ic.http_request(httpRequest) with (20_000_000_000));

        Debug.print("HTTP response status: " # Debug.show(response.status));

        switch (response.status) {
          case (200) {
            let responseText = parseResponseBody(response.body);
            Debug.print("Response received: " # responseText);

            // For now, return a mock response
            // In production, parse the actual JSON response
            let mockResponse : Types.AIResponse = {
              likelihood_percentage = 75.0;
              likelihood_level = "High";
              community_sentiment = "Positive";
              reasoning = "Analysis completed based on historical data and market conditions.";
              risks = ["Implementation complexity", "Market volatility"];
              opportunities = ["Community engagement", "Protocol improvement"];
              confidence_score = 85.0;
            };

            #ok(mockResponse);
          };
          case (status) {
            let errorMsg = "HTTP error: " # Debug.show(status);
            Debug.print(errorMsg);
            #err(errorMsg);
          };
        };
      } catch (error) {
        let errorMsg = "Network error: " # Error.message(error);
        Debug.print(errorMsg);
        #err(errorMsg);
      };
    };

    private func buildJsonRequest(request : Types.AIRequest) : Text {
      "{" #
      "\"title\":\"" # escapeJson(request.title) # "\"," #
      "\"description\":\"" # escapeJson(request.description) # "\"" #
      "}";
    };

    private func escapeJson(text : Text) : Text {
      // Simple JSON escaping - replace quotes with escaped quotes
      let step1 = Text.replace(text, #char '\"', "\\\"");
      let step2 = Text.replace(step1, #char '\n', "\\n");
      let step3 = Text.replace(step2, #char '\r', "\\r");
      step3;
    };

    private func parseResponseBody(body : [Nat8]) : Text {
      let blob = Blob.fromArray(body);
      switch (Text.decodeUtf8(blob)) {
        case (?text) { text };
        case (null) { "" };
      };
    };
  };
};
