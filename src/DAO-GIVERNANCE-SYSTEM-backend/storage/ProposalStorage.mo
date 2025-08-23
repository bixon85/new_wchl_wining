import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Debug "mo:base/Debug";

import Types "../types/types";

module {
  
  public class ProposalStorage() {
    
    private var proposals = HashMap.HashMap<Text, Types.ProposalInput>(10, Text.equal, Text.hash);
    
    public func store(id: Text, proposal: Types.ProposalInput) : () {
      Debug.print("Storing proposal with ID: " # id);
      proposals.put(id, proposal);
    };
    
    public func get(id: Text) : ?Types.ProposalInput {
      proposals.get(id)
    };
    
    public func getAll() : [(Text, Types.ProposalInput)] {
      Iter.toArray(proposals.entries())
    };
    
    public func delete(id: Text) : Bool {
      switch (proposals.remove(id)) {
        case (?_) { 
          Debug.print("Deleted proposal: " # id);
          true 
        };
        case null { false };
      }
    };
    
    public func exists(id: Text) : Bool {
      switch (proposals.get(id)) {
        case (?_) { true };
        case null { false };
      }
    };
    
    public func size() : Nat {
      proposals.size()
    };
    
    public func clear() : () {
      proposals := HashMap.HashMap<Text, Types.ProposalInput>(10, Text.equal, Text.hash);
      Debug.print("Cleared all proposals");
    };
    
    // For stable storage during upgrades
    public func getEntries() : [(Text, Types.ProposalInput)] {
      Iter.toArray(proposals.entries())
    };
    
    public func loadEntries(entries: [(Text, Types.ProposalInput)]) : () {
      proposals := HashMap.fromIter<Text, Types.ProposalInput>(
        entries.vals(), 
        entries.size(), 
        Text.equal, 
        Text.hash
      );
      Debug.print("Loaded " # debug_show(entries.size()) # " proposals from stable storage");
    };
    
    // Search functionality
    public func searchByTitle(searchTerm: Text) : [(Text, Types.ProposalInput)] {
      let searchTermLower = Text.toLowercase(searchTerm);
      let results = Array.filter<(Text, Types.ProposalInput)>(
        getAll(),
        func((id, proposal)) : Bool {
          Text.contains(Text.toLowercase(proposal.title), #text searchTermLower)
        }
      );
      results
    };
    
    public func getRecent(limit: Nat) : [(Text, Types.ProposalInput)] {
      let allProposals = getAll();
      let sorted = Array.sort<(Text, Types.ProposalInput)>(
        allProposals,
        func((_, a), (_, b)) : {#less; #equal; #greater} {
          if (a.timestamp > b.timestamp) { #less }
          else if (a.timestamp < b.timestamp) { #greater }
          else { #equal }
        }
      );
      
      if (Array.size(sorted) <= limit) {
        sorted
      } else {
        Array.subArray<(Text, Types.ProposalInput)>(sorted, 0, limit)
      }
    };
  }
}