import 'dart:convert';
import 'dart:typed_data';

import 'package:test_project/services/logFile.dart';

/// Alert data model matching the C# Alert class
/// Represents a road event detection alert from GraphQL subscription
class Alert {
  final String camName;
  final String alertType;
  final String roadName;
  final String detectionDatetime;
  final String image; // Base64 encoded image data
  
  Alert({
    required this.camName,
    required this.alertType,
    required this.roadName,
    required this.detectionDatetime,
    required this.image,
  });
  
  /// Unique key for alert identification: "{RoadName} {CameraName} - {AlertType}"
  /// Matches the C# implementation
  String get key => '$roadName $camName - $alertType-$detectionDatetime';
  
  /// Parse detection datetime from string format
  DateTime get detectionDateTime {
    try {
      // Handle the format from GraphQL: "dd-MM-yyyy HH:mm:ss"
      final parts = detectionDatetime.split(' ');
      if (parts.length == 2) {
        final dateParts = parts[0].split('-');
        final timeParts = parts[1].split(':');
        
        if (dateParts.length == 3 && timeParts.length == 3) {
          return DateTime(
            int.parse(dateParts[0]), // year
            int.parse(dateParts[1]), // month
            int.parse(dateParts[2]), // day
            int.parse(timeParts[0]), // hour
            int.parse(timeParts[1]), // minute
            int.parse(timeParts[2]), // second
          );
        }
      }
      
      // Fallback to ISO format if needed
      return DateTime.tryParse(detectionDatetime) ?? DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }
  
  /// Format datetime for display: "yyyy-MM-dd HH:mm:ss"
  /// Matches the C# display format
  String get formattedDateTime {
    final dt = detectionDateTime;
    return '${dt.year.toString().padLeft(4, '0')}/'
           '${dt.month.toString().padLeft(2, '0')}/'
           '${dt.day.toString().padLeft(2, '0')} '
           '${dt.hour.toString().padLeft(2, '0')}:'
           '${dt.minute.toString().padLeft(2, '0')}:'
           '${dt.second.toString().padLeft(2, '0')}';
  }
  
  /// Convert base64 image string to bytes
  Uint8List get imageBytes {
  void logFileWrite(String message)async{
    await LogService.write(message);

  }
    try {
      // Remove data URL prefix if present
      String base64String = image;
      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
        logFileWrite("imageBytes: ----------->>>\n");
        logFileWrite("base64String: $base64String");


      }
      
      // Decode base64 to bytes
      return base64Decode(base64String);
    } catch (e) {
      return Uint8List(0);
    }
  }

  
  /// Create Alert from JSON (GraphQL response)
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      camName: json['camName'] as String? ?? '',
      alertType: json['alertType'] as String? ?? '',
      roadName: json['roadName'] as String? ?? '',
      // Handle both field name variations from different servers
      detectionDatetime: json['detectionDatetime'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
  
  /// Convert Alert to JSON
  Map<String, dynamic> toJson() {
    return {
      'camName': camName,
      'alertType': alertType,
      'roadName': roadName,
      'detectionDatetime': detectionDatetime,
      'image': image,
    };
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Alert &&
          runtimeType == other.runtimeType &&
          key == other.key;
  
  @override
  int get hashCode => key.hashCode;
  
  @override
  String toString() {
    return 'Alert{key: $key, detectionDateTime: $formattedDateTime}';
  }
}