import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';

/// Settings provider for managing application configuration
/// Matches the C# Properties.Settings functionality
class SettingsProvider extends ChangeNotifier {
  static const String _settingsKey = 'app_settings';
  
  AppSettings _settings = AppSettings();
  bool _isLoaded = false;
  
  /// Current application settings
  AppSettings get settings => _settings;
  
  /// Whether settings have been loaded from storage
  bool get isLoaded => _isLoaded;
  
  /// GraphQL API URL (matches C# GraphQLApiRequestUrl)
  String get graphQLApiRequestUrl => _settings.graphQLApiRequestUrl;
  
  /// Username (matches C# UserName)
  String get userName => _settings.userName;
  
  /// Password (matches C# Password)
  String get password => _settings.password;
  
  /// Web page URL (matches C# WebPageUrl)
  String get webPageUrl => _settings.webPageUrl;
  
  /// Web API URL (matches C# WebApiRequestUrl)
  String get webApiRequestUrl => _settings.webApiRequestUrl;
  
  /// Filter by setting (matches C# FilterBy)
  String get filterBy => _settings.filterBy;
  
  /// Polling interval in seconds (matches C# PollingIntervalSeconds)
  int get pollingIntervalSeconds => _settings.pollingIntervalSeconds;
  
  /// Web API retry count (matches C# WebApiRetryCount)
  int get webApiRetryCount => _settings.webApiRetryCount;
  
  /// WebSocket URL derived from GraphQL URL
  String get webSocketUrl => _settings.webSocketUrl;
  
  /// Load settings from SharedPreferences
  /// Equivalent to loading from App.config in C#
  // Future<void> loadSettings() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final settingsJson = prefs.getString(_settingsKey);
      
  //     if (settingsJson != null) {
  //       final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
  //       _settings = AppSettings.fromJson(settingsMap);
  //     } else {
  //       // Use default settings if none saved
  //       _settings = AppSettings();
  //       await saveSettings(); // Save defaults
  //     }
      
  //     _isLoaded = true;
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('Error loading settings: $e');
  //     // Use default settings on error
  //     _settings = AppSettings();
  //     _isLoaded = true;
  //     notifyListeners();
  //   }
  // }
  
  /// Save current settings to SharedPreferences
  // Future<void> saveSettings() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final settingsJson = jsonEncode(_settings.toJson());
  //     await prefs.setString(_settingsKey, settingsJson);
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('Error saving settings: $e');
  //   }
  // }
  
  /// Update GraphQL API URL
  // Future<void> updateGraphQLApiUrl(String url) async {
  //   _settings = _settings.copyWith(graphQLApiRequestUrl: url);
  //   await saveSettings();
  // }
  
  /// Update username
  // Future<void> updateUserName(String username) async {
  //   _settings = _settings.copyWith(userName: username);
  //   await saveSettings();
  // }
  
  /// Update password
  // Future<void> updatePassword(String password) async {
  //   _settings = _settings.copyWith(password: password);
  //   await saveSettings();
  // }
  
  /// Update web page URL
  // Future<void> updateWebPageUrl(String url) async {
  //   _settings = _settings.copyWith(webPageUrl: url);
  //   await saveSettings();
  // }
  
  /// Update web API URL
  // Future<void> updateWebApiUrl(String url) async {
  //   _settings = _settings.copyWith(webApiRequestUrl: url);
  //   await saveSettings();
  // }
  
  /// Update filter by setting
  // Future<void> updateFilterBy(String filter) async {
  //   _settings = _settings.copyWith(filterBy: filter);
  //   await saveSettings();
  // }
  
  /// Update polling interval
  // Future<void> updatePollingInterval(int seconds) async {
  //   _settings = _settings.copyWith(pollingIntervalSeconds: seconds);
  //   await saveSettings();
  // }
  
  /// Update retry count
  // Future<void> updateRetryCount(int count) async {
  //   _settings = _settings.copyWith(webApiRetryCount: count);
  //   await saveSettings();
  // }
  
  /// Update multiple settings at once
  // Future<void> updateSettings(AppSettings newSettings) async {
  //   _settings = newSettings;
  //   await saveSettings();
  // }
  
  /// Reset settings to defaults
  // Future<void> resetToDefaults() async {
  //   _settings = AppSettings();
  //   await saveSettings();
  // }
  
  /// Build web page URL with authentication parameters
  /// Matches AlertForm.cs:105 implementation
  String buildWebPageUrlWithAuth() {
    return _settings.buildWebPageUrlWithAuth();
  }
  

}