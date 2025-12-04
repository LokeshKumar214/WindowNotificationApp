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
  
  String buildWebPageUrlWithAuth() {
    return _settings.buildWebPageUrlWithAuth();
  }
  

}