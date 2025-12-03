import 'package:flutter/foundation.dart';
import 'package:test_project/newfile.dart';
import 'package:test_project/services/apiService.dart';
import 'package:window_manager/window_manager.dart';
import '../models/alert.dart';
import '../models/alert_history.dart';

/// Alert provider for managing alert state and history
/// Matches the C# StartupForm alert management functionality
class AlertProvider extends ChangeNotifier {
  final List<Alert> _currentAlerts = [];
  final List<AlertHistory> _alertHistory = [];
  final Map<String, DateTime> _silenceAlertMap = {};
  List<String> flagReasons = [];
  bool isFlagReasonsLoading = true;
  bool isFlagImageActive = false;

  int silenceDurationInMinutes = 30;

  Alert? _selectedAlert;

  /// Current active alerts
  List<Alert> get currentAlerts => List.unmodifiable(_currentAlerts);
  Map<String, DateTime> get getSilenceAlertList =>
      Map.unmodifiable(_silenceAlertMap);

  /// Alert history for duplicate detection and window management
  List<AlertHistory> get alertHistory => List.unmodifiable(_alertHistory);
  bool get getFlagImageIsActive => isFlagImageActive;
  Alert? get selectedAlert => _selectedAlert;

  void setFlagImageValue(bool flagStatus) {
    isFlagImageActive = flagStatus;
    notifyListeners();
  }

  void incrementCurrAlertListIndex() {
    if (_selectedAlert == null) return;

    int currentIndex = currentAlerts.indexOf(_selectedAlert!);

    if (currentIndex == -1) return; // Not found

    // Check boundary
    if (currentIndex < currentAlerts.length - 1) {
      resetFlagReason();
      _selectedAlert = currentAlerts[currentIndex + 1];
      notifyListeners();
    }
  }
   Future<bool> onWillPop() async {
    return await ExitDialogChannel.showExitDialog();
  }

  void decrementCurrAlertListIndex() {
    if (_selectedAlert == null) return;

    int currentIndex = currentAlerts.indexOf(_selectedAlert!);

    if (currentIndex > 0) {
      resetFlagReason();
      _selectedAlert = currentAlerts[currentIndex - 1];
      notifyListeners();
    }
  }

  Future<void> fetchFlagReasons() async {
    isFlagReasonsLoading = true;
    notifyListeners();

    final response = await ApiService.getCategories();
    flagReasons = response;
    debugPrint("flagReasons $flagReasons");

    isFlagReasonsLoading = false;
    notifyListeners();
  }

  void submitFlagReason(String reason) {
    // ApiService.postRequest();
    debugPrint("reason selected $reason");
    dismissSelectedAlert();
  }

  void doSilenceAlert() {
    if (_selectedAlert == null) return;
    if (silenceDurationInMinutes <= 4) return;

    final alert = _selectedAlert!;
    final camName = alert.camName;
    if (camName.isEmpty) return;

    // Store silence timer
    _silenceAlertMap[camName] = DateTime.now().add(
      Duration(minutes: silenceDurationInMinutes),
    );

    // Remove ALL alerts of this camera
    _removeAlertsByCamera(camName);
  }

  void dismissSelectedAlert() {
    if (_selectedAlert == null) return;
    _removeSingleAlert(_selectedAlert!);
  }

  void clearAlerts() {
    if (_currentAlerts.isEmpty) return;
    _currentAlerts.clear();
    windowManager.hide();
    debugPrint("All Alert cleared");

    notifyListeners();
  }

  void clearBeforeExit() {
    if (_currentAlerts.isEmpty) return;
    debugPrint("clear all function called");
    _currentAlerts.clear();
    notifyListeners();
  }

  void _removeAlertsByCamera(String camName) {
    // Collect alerts to remove
    final alertsToRemove = _currentAlerts
        .where((a) => a.camName == camName)
        .toList();

    for (var alert in alertsToRemove) {
      _removeSingleAlertInternal(alert);
    }

    _finalizeAlertRemoval();
  }

  void _removeSingleAlert(Alert alert) {
    _removeSingleAlertInternal(alert);
    _finalizeAlertRemoval();
  }

  /// Removes data but does NOT call notifyListeners()
  void _removeSingleAlertInternal(Alert alert) {
    // Remove from active alerts
    _currentAlerts.remove(alert);

    // Remove from history
    _alertHistory.removeWhere((h) => h.key == alert.key);

    // Reset flag reason if this is the selected alert
    if (_selectedAlert == alert) {
      resetFlagReason();
    }
  }

  /// Called once after removal (ensures stable UI updates)
  void _finalizeAlertRemoval() {
    if (_currentAlerts.isEmpty) {
      _selectedAlert = null;
      windowManager.hide();
    } else {
      _selectedAlert = _currentAlerts.last;
    }

    notifyListeners();
  }

  void cleanupExpiredSilencedCameras() {
    final now = DateTime.now();

    _silenceAlertMap.removeWhere((cam, until) => now.isAfter(until));

    notifyListeners();
  }

  bool isCameraSilenced(String camName) {
    cleanupExpiredSilencedCameras();
    print('silence alert ${_silenceAlertMap.containsKey(camName)}');
    return _silenceAlertMap.containsKey(camName);
  }

  void selectAlert(Alert alert) {
    resetFlagReason();
    _selectedAlert = alert;
    notifyListeners();
  }

  void resetFlagReason() {
    isFlagImageActive = false;
    flagReasons.clear();
    notifyListeners();
  }

  //---------remove afte the testing on provided machine---------//

  // void dismissSelectedAlert1() {
  //   if (_selectedAlert == null) return;

  //   final alert = _selectedAlert!;

  //   print("_currentAlerts before: $_currentAlerts");
  //   print("_alertHistory before: $_alertHistory");
  //   print("_silenceAlertMap before: $_silenceAlertMap");

  //   // Remove ONLY the matching object (not all identical copies)
  //   _currentAlerts.remove(alert);

  //   // Remove from history using key instead of fields
  //   _alertHistory.removeWhere((item) => item.key == alert.key);
  //   resetFlagReason();

  //   print("_currentAlerts after: $_currentAlerts");
  //   print("_alertHistory after: $_alertHistory");

  //   if (_currentAlerts.isEmpty) {
  //     print("list is empty");
  //     windowManager.hide();
  //     _selectedAlert = null;
  //   } else {
  //     // pick next alert
  //     _selectedAlert = _currentAlerts.last;
  //   }

  //   notifyListeners();
  // }

  // void doSilenceAlert() {
  //   debugPrint("_selectedAlert: $_selectedAlert");

  //   if (_selectedAlert == null) return;
  //   if (silenceDurationInMinutes <= 4) return;

  //   final alert = _selectedAlert!;
  //   final camName = alert.camName;

  //   if (camName.isEmpty) return;

  //   // Calculate silence end time
  //   final silenceUntil = DateTime.now().add(
  //     Duration(minutes: silenceDurationInMinutes),
  //   );

  //   debugPrint("silenceUntil: $silenceUntil ---->");

  //   // Save silence info
  //   _silenceAlertMap[camName] = silenceUntil;
  //   debugPrint("_silenceAlertMap After added: $_silenceAlertMap ---->");

  //   // Dismiss the current alert
  //   // dismissSelectedAlert1();
  //   removeSilenceAlertFromList(camName);

  //   notifyListeners();
  // }

  // void removeSilenceAlertFromList(String camName) {
  //   // Remove all alerts belonging to this camera
  //   _currentAlerts.removeWhere((alert) => alert.camName == camName);

  //   // If no alerts left → close UI and clear selected alert
  //   if (_currentAlerts.isEmpty) {
  //     _selectedAlert = null;
  //     windowManager.hide();
  //     notifyListeners();
  //     return;
  //   }

  //   // If alerts still exist → select the last one safely
  //   _selectedAlert = _currentAlerts.last;

  //   notifyListeners();
  // }

  //---------remove afte the testing on provided machine---------//

  bool addAlert(Alert alert) {
    debugPrint('Processing alert: ${alert.key}');

    if (alert.key.isEmpty) {
      debugPrint('❌ Alert key is empty. Ignoring alert.');
      return false;
    }

    // ---- 1. Find existing history entry safely & quickly ----
    final existingIndex = _alertHistory.indexWhere((h) => h.key == alert.key);
    AlertHistory? existingHistory = existingIndex != -1
        ? _alertHistory[existingIndex]
        : null;

    // ---- 2. Detect duplicate alert (C# logic equivalent) ----
    if (existingHistory != null &&
        !existingHistory.isNewerThan(alert.detectionDateTime)) {
      debugPrint('⚠️ Duplicate alert ignored: ${alert.key}');
      return false;
    }

    // ---- 3. Add to current alerts (append safely) ----
    _currentAlerts.add(alert);

    // ---- 4. Update or create alert history ----
    if (existingHistory == null) {
      final history = AlertHistory(
        key: alert.key,
        lastAlertTime: alert.detectionDateTime,
      );
      _alertHistory.add(history);

      debugPrint('🟢 Created new alert history: ${alert.key}');
    } else {
      existingHistory.updateLastAlertTime(alert.detectionDateTime);
      debugPrint('🟡 Updated history for alert: ${alert.key}');
    }

    notifyListeners();
    return true;
  }

  /// Remove an alert from current alerts
  void removeAlert(String alertKey) {
    _currentAlerts.removeWhere((alert) => alert.key == alertKey);
    notifyListeners();
  }

  /// Clear all current alerts
  void clearCurrentAlerts() {
    _currentAlerts.clear();
    notifyListeners();
  }

  /// Get alert history by key
  AlertHistory? getAlertHistory(String key) {
    try {
      return _alertHistory.firstWhere((h) => h.key == key);
    } catch (e) {
      return null;
    }
  }

  /// Get count of active alerts
  int get activeAlertCount => _currentAlerts.length;

  /// Get count of alert histories
  int get alertHistoryCount => _alertHistory.length;

  /// Check if an alert key has an active window
  bool hasActiveWindow(String alertKey) {
    final history = getAlertHistory(alertKey);
    return history?.isWindowActive ?? false;
  }

  /// Clear all alert history (for testing/reset purposes)
  void clearAllHistory() {
    _alertHistory.clear();
    _currentAlerts.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _currentAlerts.clear();
    _alertHistory.clear();
    super.dispose();
  }
}
