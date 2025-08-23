import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Debug "mo:base/Debug";

import Types "../types/types";

module {
  
  public class AnalysisStorage() {
    
    private var analyses = HashMap.HashMap<Text, Types.AnalysisResult>(10, Text.equal, Text.hash);
    
    public func store(id: Text, analysis: Types.AnalysisResult) : () {
      Debug.print("Storing analysis with ID: " # id);
      analyses.put(id, analysis);
    };
    
    public func get(id: Text) : ?Types.AnalysisResult {
      analyses.get(id)
    };
    
    public func getAll() : [(Text, Types.AnalysisResult)] {
      Iter.toArray(analyses.entries())
    };
    
    public func delete(id: Text) : Bool {
      switch (analyses.remove(id)) {
        case (?_) { 
          Debug.print("Deleted analysis: " # id);
          true 
        };
        case null { false };
      }
    };
    
    public func exists(id: Text) : Bool {
      switch (analyses.get(id)) {
        case (?_) { true };
        case null { false };
      }
    };
    
    public func size() : Nat {
      analyses.size()
    };
    
    public func clear() : () {
      analyses := HashMap.HashMap<Text, Types.AnalysisResult>(10, Text.equal, Text.hash);
      Debug.print("Cleared all analyses");
    };
    
    // For stable storage during upgrades
    public func getEntries() : [(Text, Types.AnalysisResult)] {
      Iter.toArray(analyses.entries())
    };
    
    public func loadEntries(entries: [(Text, Types.AnalysisResult)]) : () {
      analyses := HashMap.fromIter<Text, Types.AnalysisResult>(
        entries.vals(), 
        entries.size(), 
        Text.equal, 
        Text.hash
      );
      Debug.print("Loaded " # debug_show(entries.size()) # " analyses from stable storage");
    };
    
    // Analytics functions
    public func getAnalysesByLikelihood(level: Text) : [(Text, Types.AnalysisResult)] {
      let results = Array.filter<(Text, Types.AnalysisResult)>(
        getAll(),
        func((id, analysis)) : Bool {
          analysis.likelihood_level == level
        }
      );
      results
    };
    
    public func getAnalysesBySentiment(sentiment: Text) : [(Text, Types.AnalysisResult)] {
      let results = Array.filter<(Text, Types.AnalysisResult)>(
        getAll(),
        func((id, analysis)) : Bool {
          analysis.community_sentiment == sentiment
        }
      );
      results
    };
    
    public func getHighConfidenceAnalyses(threshold: Float) : [(Text, Types.AnalysisResult)] {
      let results = Array.filter<(Text, Types.AnalysisResult)>(
        getAll(),
        func((id, analysis)) : Bool {
          analysis.confidence_score >= threshold
        }
      );
      results
    };
    
    public func getRecent(limit: Nat) : [(Text, Types.AnalysisResult)] {
      let allAnalyses = getAll();
      let sorted = Array.sort<(Text, Types.AnalysisResult)>(
        allAnalyses,
        func((_, a), (_, b)) : {#less; #equal; #greater} {
          if (a.proposal.timestamp > b.proposal.timestamp) { #less }
          else if (a.proposal.timestamp < b.proposal.timestamp) { #greater }
          else { #equal }
        }
      );
      
      if (Array.size(sorted) <= limit) {
        sorted
      } else {
        Array.subArray<(Text, Types.AnalysisResult)>(sorted, 0, limit)
      }
    };
    
    // Statistics
    public func getAverageLikelihood() : Float {
      let allAnalyses = getAll();
      if (Array.size(allAnalyses) == 0) {
        return 0.0;
      };
      
      var total: Float = 0.0;
      for ((_, analysis) in allAnalyses.vals()) {
        total += analysis.likelihood_percentage;
      };
      
      total / Float.fromInt(Array.size(allAnalyses))
    };
    
    public func getAverageConfidence() : Float {
      let allAnalyses = getAll();
      if (Array.size(allAnalyses) == 0) {
        return 0.0;
      };
      
      var total: Float = 0.0;
      for ((_, analysis) in allAnalyses.vals()) {
        total += analysis.confidence_score;
      };
      
      total / Float.fromInt(Array.size(allAnalyses))
    };
  }
}