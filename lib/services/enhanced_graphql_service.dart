import 'dart:async';
import 'dart:convert';
import '../models/alert.dart';
import 'package:logger/logger.dart';
import '../models/alert_history.dart';
import 'package:flutter/foundation.dart';
import 'package:test_project/services/logFile.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EnhancedGraphQLService extends ChangeNotifier {
  static EnhancedGraphQLService? _instance;
  static EnhancedGraphQLService get instance =>
      _instance ??= EnhancedGraphQLService._();

  EnhancedGraphQLService._();

  final List<AlertHistory> _historyList = [];
  List<AlertHistory> get historyList => List.unmodifiable(_historyList);

  GraphQLClient? _client;
  StreamSubscription? _subscription;
  DateTime? _connectionStartTime;
  int _reconnectionAttempts = 0;

  final Logger _logger = Logger();

  // Stream controller for alert events
  final StreamController<Alert> _alertController =
      StreamController<Alert>.broadcast();
  Stream<Alert> get alertStream => _alertController.stream;

  /// Initialize GraphQL client with comprehensive logging
  void logFileWrite(String message) async {
    await LogService.write(message);
  }

  Future<void> initialize({required String graphQLUrl}) async {
    try {
      logFileWrite(' Initializing Enhanced GraphQL Service...');

      await _initializeGraphQLClient(graphQLUrl);
      _startGraphQLSubscription(graphQLUrl);

      _logger.i('✅ Enhanced GraphQL Service initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(' Failed to initialize Enhanced GraphQL Service: $e');
      logFileWrite('Failed to initialize Enhanced GraphQL Service: $e');
    }
  }

  /// Enhanced URL normalization with comprehensive logging
  String _normalizeGraphQLUrl(String url) {
    final originalUrl = url;

    logFileWrite('Starting URL normalization $originalUrl');

    // Remove trailing slash if present
    String normalizedUrl = url.endsWith('/')
        ? url.substring(0, url.length - 1)
        : url;

    // Ensure it's HTTP/HTTPS for GraphQL endpoint
    if (!normalizedUrl.startsWith('http://') &&
        !normalizedUrl.startsWith('https://')) {
      normalizedUrl = 'http://$normalizedUrl';
    }

    // Log URL transformation
    if (normalizedUrl != originalUrl) {
      logFileWrite('URL normalized for compatibility: $originalUrl');
    }

    _logger.i('🔗 URL normalized: $originalUrl -> $normalizedUrl');
    return normalizedUrl;
  }

  /// Initialize GraphQL client with enhanced configuration
  Future<void> _initializeGraphQLClient(String graphQLUrl) async {
    final connectionStartTime = DateTime.now();
    logFileWrite('_initializeGraphQLClient : $graphQLUrl');
    _logger.i('_initializeGraphQLClient 006 : $graphQLUrl');

    try {
      final httpUrl = _normalizeGraphQLUrl(graphQLUrl);
      final wsUrl = httpUrl.replaceFirst('http', 'ws');
      logFileWrite('httpUrl : $httpUrl');
      logFileWrite('wsUrl : $wsUrl');
      _logger.i('httpUrl 007 : $httpUrl');
      _logger.i('wsUrl 008 : $wsUrl');

      final httpLink = HttpLink(httpUrl);
      final websocketLink = WebSocketLink(
        wsUrl,
        config: const SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(minutes: 5),
        ),
      );

      final link = Link.split(
        (request) => request.isSubscription,
        websocketLink,
        httpLink,
      );
      _client = GraphQLClient(link: link, cache: GraphQLCache());
      final connectionTime = DateTime.now().difference(connectionStartTime);
      logFileWrite('wsUrl: $wsUrl ,: connectionTime $connectionTime ');
      _logger.i('✅ GraphQL client initialized successfully');
    } catch (e, stackTrace) {
      logFileWrite('error: $e');
      _logger.e('Failed to initialize GraphQL client: $e');
      rethrow;
    }
  }

  /// Start GraphQL subscription with enhanced logging and error handling
  void _startGraphQLSubscription(String graphQLUrl) {
    if (_client == null) {
      logFileWrite('client is null');
      return;
    }

    _logger.i('_startGraphQLSubscription 0010');

    _connectionStartTime = DateTime.now();
    final endpoint = _normalizeGraphQLUrl(graphQLUrl);

    logFileWrite('_startGraphQLSubscription:  $endpoint');
    _logger.i('_startGraphQLSubscription:  $endpoint');

    // Use the exact same GraphQL query as working project
    const query = r'''
      subscription GetAlertsSub($username: String!) {
        getAlertsSub(username: $username) {
          camName
          alertType
          roadName
          detectionDatetime
          image
        }
      }
    ''';

    final options = SubscriptionOptions(
      document: gql(query),
      variables: {'username': 'admin'},
      fetchPolicy: FetchPolicy.noCache,
    );

    logFileWrite('username: admin');

    _subscription = _client!
        .subscribe(options)
        .listen(
          (result) => _handleSubscriptionResponse(result, endpoint),
          onError: (e) {
            logFileWrite('$endpoint, ${e.toString()}');

            _handleSubscriptionError(e, endpoint);
          },
          onDone: () {
            _logger.w('⚠️ Subscription closed by server');
            final uptime = _connectionStartTime != null
                ? DateTime.now().difference(_connectionStartTime!)
                : Duration.zero;

            _handleSubscriptionError('Connection closed', endpoint);
          },
        );
  }

  /// Enhanced subscription response handler with field mapping analysis
  void _handleSubscriptionResponse(QueryResult result, String endpoint) {
    _logger.i(' Received GraphQL response at ${DateTime.now()}');
    logFileWrite('Received GraphQL response at ${DateTime.now()}');

    if (result.hasException) {
      _logger.e('Subscription exception: ${result.exception}');
      return;
    }

    final data = result.data;
    if (data == null || data['getAlertsSub'] == null) {
      logFileWrite('Subscription data empty');
      logFileWrite('Available fields: ${data?.keys.toList() ?? 'null'}');
      return;
    }

    final alertJson = data['getAlertsSub'] as Map<String, dynamic>;
    logFileWrite('📋 Alert JSON received: ${alertJson.keys.toList()}');
    final fieldIssues = <String>[];
    if (alertJson.containsKey('image')) {
      final imageValue = alertJson['image'];
      final imageType = imageValue.runtimeType.toString();
      logFileWrite(
        '🖼️ Image field analysis - Type: $imageType, IsNull: ${imageValue == null}',
      );

      if (imageValue == null) {
        fieldIssues.add('image_field_is_null');

        logFileWrite('Image field is null');
      } else if (imageValue is! String) {
        fieldIssues.add('image_field_wrong_type');

        logFileWrite('imageType: $imageType , imageValue: $imageValue');

        _logger.e(' Image field wrong type: $imageType');
      } else if (imageValue.isEmpty) {
        fieldIssues.add('image_field_empty_string');
        _logger.e(' Image field is empty string');
      } else {
        _logger.i('Image field received: ${imageValue.length} characters');
        final preview = imageValue.length > 50
            ? imageValue.substring(0, 50)
            : imageValue;
        _logger.i('Image preview: $preview...');
      }
    } else {
      fieldIssues.add('image_field_missing');

      _logger.e('Image field missing from response');
    }

    // Log detailed response analysis

    try {
      // Create Alert object with enhanced error handling
      final alert = _createAlertFromJson(alertJson);
      _logger.i('✅ Alert parsed successfully');
      _logger.i('📍 Camera: ${alert.camName}, Type: ${alert.alertType}');
      _logger.i('🛣️ Road: ${alert.roadName}');
      _logger.i('🖼️ Image size: ${alert.image.length} characters');

      _displayAlert(alert);
    } catch (e, stackTrace) {
      _logger.e('❌ Error parsing alert: $e');
    }
  }

  /// Enhanced Alert creation with field mapping fixes (from working project)
  Alert _createAlertFromJson(Map<String, dynamic> json) {
    _logger.i('Creating Alert from JSON data...');

    // Handle image field conversion (C# byte[] vs Flutter String)
    String imageData = '';

    if (json['image'] != null) {
      final imageValue = json['image'];

      if (imageValue is String) {
        imageData = imageValue;
        _logger.i('Image received as string: ${imageData.length} characters');
        logFileWrite(
          'Image received as string: ${imageData.length} characters',
        );
      } else if (imageValue is List) {
        // If it comes as byte array, convert to base64
        try {
          final bytes = List<int>.from(imageValue);
          imageData = base64Encode(bytes);
          _logger.i(
            'Converted byte array to base64: ${bytes.length} bytes -> ${imageData.length} chars',
          );
          logFileWrite(
          'Converted byte array to base64: ${bytes.length} bytes -> ${imageData.length} chars',
        );
        } catch (e) {
          _logger.e('Failed to convert byte array to base64: $e');
          imageData = '';
        }
      } else {
        _logger.w(' Unexpected image field type: ${imageValue.runtimeType}');
        imageData = imageValue.toString();
      }
    } else {
      _logger.e(' Image field is null or missing');
    }

    // Handle datetime field (keep as string as per Alert model)
    String detectionTime = '';
    try {
      if (json['detectionDatetime'] is String) {
        detectionTime = json['detectionDatetime'];
      } else {
        detectionTime = DateTime.now().toIso8601String();
        _logger.w('⚠️ Invalid detectionDatetime format, using current time');
      }
    } catch (e) {
      detectionTime = DateTime.now().toIso8601String();
      _logger.e('❌ Failed to parse detectionDatetime: $e');
    }

    return Alert(
      camName: json['camName']?.toString() ?? '',
      alertType: json['alertType']?.toString() ?? '',
      roadName: json['roadName']?.toString() ?? '',
      detectionDatetime: detectionTime,
      image: imageData,
    );
  }

  /// Enhanced error handling with detailed logging
  void _handleSubscriptionError(dynamic error, String endpoint) async {
    _reconnectionAttempts++;

    _logger.e('❌ Subscription Error: ${error.toString()}');

    // Log reconnection attempt with detailed info
    const delay = Duration(seconds: 5);

    _logger.i(
      '🔄 Retrying GraphQL subscription (attempt $_reconnectionAttempts) in ${delay.inSeconds}s...',
    );
    await Future.delayed(delay);

    _startGraphQLSubscription(endpoint);
  }

  /// Display alert with processing time logging
  void _displayAlert(Alert alert) {
    final processingStart = DateTime.now();

    try {
      _logger.i(
        '🚨 Processing Alert: ${alert.roadName} ${alert.camName} ${alert.alertType}',
      );

      // Find existing alert history
      final existingHistoryIndex = _historyList.indexWhere(
        (h) => h.key == alert.key,
      );
      AlertHistory? history;

      if (existingHistoryIndex != -1) {
        history = _historyList[existingHistoryIndex];

        if (history.lastAlertTime.isAfter(alert.detectionDateTime) ||
            history.lastAlertTime.isAtSameMomentAs(alert.detectionDateTime)) {
          _logger.i('⏭️ Already alerted for this detection time');
          return;
        }
      } else {
        history = AlertHistory(
          key: alert.key,
          lastAlertTime: alert.detectionDateTime,
        );
        _historyList.add(history);
      }

      history.lastAlertTime = alert.detectionDateTime;

      // Emit alert event
      _alertController.add(alert);

      _logger.i('✅ Alert displayed successfully');
      notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('❌ Error displaying alert: $e');
    }
  }

  void closeAllAlerts() {
    notifyListeners();
  }

  @override
  void dispose() {
    final uptime = _connectionStartTime != null
        ? DateTime.now().difference(_connectionStartTime!)
        : Duration.zero;
    _subscription?.cancel();
    _alertController.close();
    super.dispose();
  }

  /// Check if the service is initialized
  bool get isInitialized => _client != null;

  /// Get the current GraphQL client (for testing purposes)
  GraphQLClient? get client => _client;
}
