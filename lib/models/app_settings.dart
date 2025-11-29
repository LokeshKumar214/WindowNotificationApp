/// Application settings model matching the C# App.config structure
/// Manages all configuration values from the original Windows Forms application
class AppSettings {
  // GraphQL Connection Settings
  final String graphQLApiRequestUrl;
  
  // Authentication Information
  final String userName;
  final String password;
  
  // Web Page Settings
  final String webPageUrl;
  
  // REST API Settings (Currently unused but maintained for compatibility)
  final String webApiRequestUrl;
  final String filterBy;
  
  // Timing & Retry Settings
  final int pollingIntervalSeconds;
  final int webApiRetryCount;
  
  AppSettings({
    // Production environment configuration - FIXED to match working windowapp
    this.graphQLApiRequestUrl = 'http://192.168.65.11/graphql',
    this.userName = 'admin',
    this.password = 'admin',
    this.webPageUrl = 'https://www.futurestandard.co.jp/',
    this.webApiRequestUrl = 'https://localhost:44349/api/alerts',
    this.filterBy = 'all',
    this.pollingIntervalSeconds = 60,
    this.webApiRetryCount = 2,
  });
  
  /// Create settings from JSON (for persistence)
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      graphQLApiRequestUrl: json['graphQLApiRequestUrl'] as String? ?? 'http://192.168.65.11/graphql',
      userName: json['userName'] as String? ?? 'admin',
      password: json['password'] as String? ?? 'admin',
      webPageUrl: json['webPageUrl'] as String? ?? 'https://www.futurestandard.co.jp/',
      webApiRequestUrl: json['webApiRequestUrl'] as String? ?? 'https://localhost:44349/api/alerts',
      filterBy: json['filterBy'] as String? ?? 'all',
      pollingIntervalSeconds: json['pollingIntervalSeconds'] as int? ?? 60,
      webApiRetryCount: json['webApiRetryCount'] as int? ?? 2,
    );
  }
  
  /// Convert settings to JSON (for persistence)
  Map<String, dynamic> toJson() {
    return {
      'graphQLApiRequestUrl': graphQLApiRequestUrl,
      'userName': userName,
      'password': password,
      'webPageUrl': webPageUrl,
      'webApiRequestUrl': webApiRequestUrl,
      'filterBy': filterBy,
      'pollingIntervalSeconds': pollingIntervalSeconds,
      'webApiRetryCount': webApiRetryCount,
    };
  }
  
  /// Create a copy with updated values
  AppSettings copyWith({
    String? graphQLApiRequestUrl,
    String? userName,
    String? password,
    String? webPageUrl,
    String? webApiRequestUrl,
    String? filterBy,
    int? pollingIntervalSeconds,
    int? webApiRetryCount,
  }) {
    return AppSettings(
      graphQLApiRequestUrl: graphQLApiRequestUrl ?? this.graphQLApiRequestUrl,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      webPageUrl: webPageUrl ?? this.webPageUrl,
      webApiRequestUrl: webApiRequestUrl ?? this.webApiRequestUrl,
      filterBy: filterBy ?? this.filterBy,
      pollingIntervalSeconds: pollingIntervalSeconds ?? this.pollingIntervalSeconds,
      webApiRetryCount: webApiRetryCount ?? this.webApiRetryCount,
    );
  }
  
  /// Get WebSocket URL from HTTP GraphQL URL
  String get webSocketUrl {
    return graphQLApiRequestUrl.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://');
  }
  
  /// Build web page URL with authentication parameters
  /// Matches the C# implementation in AlertForm.cs
  String buildWebPageUrlWithAuth() {
    final uri = Uri.parse(webPageUrl);
    final queryParams = Map<String, String>.from(uri.queryParameters);
    queryParams['user'] = userName;
    queryParams['pass'] = password;
    
    return uri.replace(queryParameters: queryParams).toString();
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          graphQLApiRequestUrl == other.graphQLApiRequestUrl &&
          userName == other.userName &&
          password == other.password &&
          webPageUrl == other.webPageUrl &&
          webApiRequestUrl == other.webApiRequestUrl &&
          filterBy == other.filterBy &&
          pollingIntervalSeconds == other.pollingIntervalSeconds &&
          webApiRetryCount == other.webApiRetryCount;
  
  @override
  int get hashCode =>
      graphQLApiRequestUrl.hashCode ^
      userName.hashCode ^
      password.hashCode ^
      webPageUrl.hashCode ^
      webApiRequestUrl.hashCode ^
      filterBy.hashCode ^
      pollingIntervalSeconds.hashCode ^
      webApiRetryCount.hashCode;
  
  @override
  String toString() {
    return 'AppSettings{graphQLApiRequestUrl: $graphQLApiRequestUrl, userName: $userName, webPageUrl: $webPageUrl}';
  }
}