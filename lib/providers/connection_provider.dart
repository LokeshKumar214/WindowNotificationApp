import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/enhanced_graphql_service.dart';
import '../models/alert.dart';

/// Connection states matching the C# application behavior
enum ConnectionState {
  disconnected,
  connecting,
  connected,
  error,
  reconnecting,
}

/// Connection provider for managing GraphQL connection state
/// Matches the C# StartupForm connection management
class ConnectionProvider extends ChangeNotifier {
  ConnectionState _state = ConnectionState.disconnected;
  String? _errorMessage;
  int _errorCount = 0;
  final EnhancedGraphQLService _graphqlService = EnhancedGraphQLService.instance;
  StreamSubscription<Alert>? _alertSubscription;
  
  // Alert callback for forwarding alerts to AlertProvider
  Function(Alert)? _onAlertReceived;
  
  /// Current connection state
  ConnectionState get state => _state;
  
  /// Current error message (if any)
  String? get errorMessage => _errorMessage;
  
  /// Number of consecutive errors
  int get errorCount => _errorCount;
  
  /// Whether the connection is active
  bool get isConnected => _state == ConnectionState.connected;
  
  /// Whether the service is initialized
  bool get isInitialized => _graphqlService.isInitialized;
  
  /// Set alert callback for forwarding alerts
  void setAlertCallback(Function(Alert) callback) {
    _onAlertReceived = callback;
  }
  
  /// Initialize and start GraphQL connection with enhanced diagnostics
  /// Uses AppConfig for centralized configuration management
  Future<void> initialize([String? graphqlUrl, String? username]) async {
    try {
      _setState(ConnectionState.connecting);
      
      // Initialize enhanced GraphQL service
      await _graphqlService.initialize();
      
      // Start subscription with enhanced service
      await _startEnhancedSubscription();
      
    } catch (e) {
      debugPrint('❌ Enhanced GraphQL initialization failed: $e');
      _handleError('Failed to initialize enhanced connection: $e');
    }
  }
  
  /// Start enhanced alert subscription with comprehensive logging
  Future<void> _startEnhancedSubscription() async {
    try {
      debugPrint('🚀 Enhanced GraphQL: Starting subscription with comprehensive diagnostics');
      debugPrint('✅ Service initialized: ${_graphqlService.isInitialized}');
      
      // Cancel existing subscription
      await _alertSubscription?.cancel();
      
      // Start new subscription with enhanced service
      _alertSubscription = _graphqlService.alertStream.listen(
        (alert) {
          debugPrint('✅ Enhanced Alert received: ${alert.key}');
          debugPrint('📍 Camera: ${alert.camName}, Road: ${alert.roadName}');
          debugPrint('🖼️ Image size: ${alert.image.length} characters');
          _handleAlertReceived(alert);
        },
        onError: (error) {
          debugPrint('❌ Enhanced subscription error: $error');
          _handleError('Enhanced subscription error: $error');
        },
        onDone: () {
          debugPrint('⚠️ Enhanced subscription completed/disconnected');
          _handleDisconnection();
        },
      );
      
      // Set connected state after successful subscription start
      _setState(ConnectionState.connected);
      _errorCount = 0;
      _errorMessage = null;
      debugPrint('✅ Enhanced subscription started successfully');
      
    } catch (e) {
      debugPrint('❌ Failed to start enhanced subscription: $e');
      _handleError('Failed to start enhanced subscription: $e');
    }
  }
  
  /// Handle received alert
  void _handleAlertReceived(Alert alert) {
    print('Received alert: ${alert.key}');
    
    // Ensure we're in connected state
    if (_state != ConnectionState.connected) {
      _setState(ConnectionState.connected);
      _errorCount = 0;
      _errorMessage = null;
    }
    
    // Forward alert to AlertProvider through callback
    _onAlertReceived?.call(alert);
  }
  
  /// Handle connection error
  /// Matches C# auto-reconnection logic
  void _handleError(String error) {
    print('Connection error: $error');
    
    _errorMessage = error;
    _errorCount++;
    _setState(ConnectionState.error);
    
    // Auto-reconnect after delay (matches C# 5-second delay)
    Timer(const Duration(seconds: 5), () {
      if (_state == ConnectionState.error) {
        _attemptReconnection();
      }
    });
  }
  
  /// Handle connection disconnection
  void _handleDisconnection() {
    print('Connection disconnected');
    
    if (_state == ConnectionState.connected) {
      _setState(ConnectionState.disconnected);
      
      // Auto-reconnect after delay
      Timer(const Duration(seconds: 5), () {
        if (_state == ConnectionState.disconnected) {
          _attemptReconnection();
        }
      });
    }
  }
  
  /// Attempt to reconnect
  Future<void> _attemptReconnection() async {
    if (_state == ConnectionState.connecting || _state == ConnectionState.reconnecting) {
      return; // Already attempting connection
    }
    
    print('Attempting reconnection (attempt ${_errorCount + 1})');
    _setState(ConnectionState.reconnecting);
    
    try {
      await Future.delayed(const Duration(seconds: 2)); // Brief delay before retry
      
      // The actual reconnection will be triggered by the main app
      // This provider just manages the state
      
    } catch (e) {
      _handleError('Reconnection failed: $e');
    }
  }
  
  /// Manually trigger reconnection with enhanced diagnostics
  Future<void> reconnect([String? graphqlUrl, String? username]) async {
    print('🔄 Enhanced reconnection requested');
    
    await disconnect();
    await initialize(graphqlUrl, username);
  }
  
  /// Disconnect from enhanced GraphQL service
  Future<void> disconnect() async {
    print('🔌 Disconnecting from enhanced GraphQL service');
    
    await _alertSubscription?.cancel();
    _alertSubscription = null;
    
    _graphqlService.dispose();
    
    _setState(ConnectionState.disconnected);
    _errorMessage = null;
    _errorCount = 0;
  }
  
  /// Set connection state and notify listeners
  void _setState(ConnectionState newState) {
    if (_state != newState) {
      _state = newState;
      print('Connection state changed to: $newState');
      notifyListeners();
    }
  }
  
  /// Clear error state
  void clearError() {
    _errorMessage = null;
    _errorCount = 0;
    notifyListeners();
  }
  
  /// Get connection status text for UI
  String get statusText {
    switch (_state) {
      case ConnectionState.disconnected:
        return 'Disconnected';
      case ConnectionState.connecting:
        return 'Connecting...';
      case ConnectionState.connected:
        return 'Connected';
      case ConnectionState.error:
        return 'Error: $_errorMessage';
      case ConnectionState.reconnecting:
        return 'Reconnecting...';
    }
  }
  
  /// Get connection status color for UI
  String get statusColor {
    switch (_state) {
      case ConnectionState.disconnected:
        return 'gray';
      case ConnectionState.connecting:
      case ConnectionState.reconnecting:
        return 'orange';
      case ConnectionState.connected:
        return 'green';
      case ConnectionState.error:
        return 'red';
    }
  }
  
  /// Test enhanced GraphQL connection with comprehensive diagnostics
  void testEnhancedConnection() {
    debugPrint('🧪 Testing Enhanced GraphQL Connection...');
    debugPrint('🔧 Service initialized: ${_graphqlService.isInitialized}');
    debugPrint('📡 Connection state: $_state');
    debugPrint('🔄 Error count: $_errorCount');
    debugPrint('⚠️ Last error: $_errorMessage');
    
    // Test the enhanced service

  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}