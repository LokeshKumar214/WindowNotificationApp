/// Alert history management class
/// Matches the C# AlertHistory.cs implementation
class AlertHistory {
  /// Unique identifier key for the alert
  final String key;
  
  /// Last time this alert was received
  DateTime lastAlertTime;
  
  /// Reference to the alert window (will be set when window is created)
  int? windowId;
  
  /// Flag to track if window is currently active
  bool isWindowActive;
  
  AlertHistory({
    required this.key,
    DateTime? lastAlertTime,
    this.windowId,
    this.isWindowActive = false,
  }) : lastAlertTime = lastAlertTime ?? DateTime.now();
  
  /// Check if this alert is newer than the last received alert
  bool isNewerThan(DateTime alertTime) {
    return alertTime.isAfter(lastAlertTime);
  }
  
  /// Update the last alert time
  void updateLastAlertTime(DateTime alertTime) {
    lastAlertTime = alertTime;
  }
  
  /// Set the window ID when window is created
  void setWindowId(int id) {
    windowId = id;
    isWindowActive = true;
  }
  
  /// Clear window reference when window is closed
  void clearWindow() {
    windowId = null;
    isWindowActive = false;
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertHistory &&
          runtimeType == other.runtimeType &&
          key == other.key;
  
  @override
  int get hashCode => key.hashCode;
  
  @override
  String toString() {
    return 'AlertHistory{key: $key, lastAlertTime: $lastAlertTime, windowActive: $isWindowActive}';
  }
}