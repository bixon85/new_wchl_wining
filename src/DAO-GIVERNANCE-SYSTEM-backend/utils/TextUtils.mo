import Text "mo:base/Text";
import Char "mo:base/Char";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

module {
  
  public func trim(text: Text) : Text {
    let chars = Text.toIter(text);
    let charArray = Iter.toArray(chars);
    
    if (Array.size(charArray) == 0) {
      return "";
    };
    
    var start = 0;
    var end = Array.size(charArray) - 1;
    
    // Find first non-whitespace character
    while (start <= end and isWhitespace(charArray[start])) {
      start += 1;
    };
    
    // Find last non-whitespace character
    while (end >= start and isWhitespace(charArray[end])) {
      end -= 1;
    };
    
    if (start > end) {
      return "";
    };
    
    let trimmedArray = Array.subArray<Char>(charArray, start, end - start + 1);
    Text.fromIter(trimmedArray.vals())
  };
  
  public func isWhitespace(char: Char) : Bool {
    char == ' ' or char == '\t' or char == '\n' or char == '\r'
  };
  
  public func split(text: Text, delimiter: Char) : [Text] {
    let chars = Text.toIter(text);
    var current = "";
    var parts: [Text] = [];
    
    for (char in chars) {
      if (char == delimiter) {
        parts := Array.append(parts, [current]);
        current := "";
      } else {
        current #= Char.toText(char);
      };
    };
    
    // Add the last part
    parts := Array.append(parts, [current]);
    parts
  };
  
  public func contains(text: Text, substring: Text) : Bool {
    Text.contains(text, #text substring)
  };
  
  public func startsWith(text: Text, prefix: Text) : Bool {
    let textSize = Text.size(text);
    let prefixSize = Text.size(prefix);
    
    if (prefixSize > textSize) {
      return false;
    };
    
    let textPrefix = Text.take(text, prefixSize);
    textPrefix == prefix
  };
  
  public func endsWith(text: Text, suffix: Text) : Bool {
    let textSize = Text.size(text);
    let suffixSize = Text.size(suffix);
    
    if (suffixSize > textSize) {
      return false;
    };
    
    let textSuffix = Text.drop(text, textSize - suffixSize);
    textSuffix == suffix
  };
  
  public func capitalize(text: Text) : Text {
    if (Text.size(text) == 0) {
      return text;
    };
    
    let chars = Text.toIter(text);
    let charArray = Iter.toArray(chars);
    
    if (Array.size(charArray) == 0) {
      return text;
    };
    
    let firstChar = charArray[0];
    let capitalizedFirst = Char.toUpper(firstChar);
    
    if (Array.size(charArray) == 1) {
      return Char.toText(capitalizedFirst);
    };
    
    let restArray = Array.subArray<Char>(charArray, 1, Array.size(charArray) - 1);
    let rest = Text.fromIter(restArray.vals());
    
    Char.toText(capitalizedFirst) # rest
  };
  
  public func wordCount(text: Text) : Nat {
    let trimmed = trim(text);
    if (Text.size(trimmed) == 0) {
      return 0;
    };
    
    let words = split(trimmed, ' ');
    var count = 0;
    
    for (word in words.vals()) {
      if (Text.size(trim(word)) > 0) {
        count += 1;
      };
    };
    
    count
  };
  
  public func truncate(text: Text, maxLength: Nat) : Text {
    if (Text.size(text) <= maxLength) {
      return text;
    };
    
    let truncated = Text.take(text, maxLength - 3);
    truncated # "..."
  };
}