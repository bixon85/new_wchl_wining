import Time "mo:base/Time";
import Int "mo:base/Int";

module {
  
  public func now() : Int {
    Time.now()
  };
  
  public func secondsAgo(seconds: Int) : Int {
    Time.now() - (seconds * 1_000_000_000)
  };
  
  public func minutesAgo(minutes: Int) : Int {
    secondsAgo(minutes * 60)
  };
  
  public func hoursAgo(hours: Int) : Int {
    minutesAgo(hours * 60)
  };
  
  public func daysAgo(days: Int) : Int {
    hoursAgo(days * 24)
  };
  
  public func isRecent(timestamp: Int, thresholdSeconds: Int) : Bool {
    let threshold = secondsAgo(thresholdSeconds);
    timestamp >= threshold
  };
  
  public func formatDuration(nanoseconds: Int) : Text {
    let seconds = nanoseconds / 1_000_000_000;
    
    if (seconds < 60) {
      Int.toText(seconds) # " seconds"
    } else if (seconds < 3600) {
      let minutes = seconds / 60;
      Int.toText(minutes) # " minutes"
    } else if (seconds < 86400) {
      let hours = seconds / 3600;
      Int.toText(hours) # " hours"
    } else {
      let days = seconds / 86400;
      Int.toText(days) # " days"
    }
  };
  
  public func timeSince(timestamp: Int) : Text {
    let duration = Time.now() - timestamp;
    formatDuration(duration) # " ago"
  };
  
  public func isExpired(timestamp: Int, validityPeriod: Int) : Bool {
    let expirationTime = timestamp + validityPeriod;
    Time.now() > expirationTime
  };
}