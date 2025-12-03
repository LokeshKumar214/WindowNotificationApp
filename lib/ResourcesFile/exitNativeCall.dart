import 'package:flutter/services.dart';

class ExitDialogChannel {
  static const MethodChannel _channel =
      MethodChannel('com.example.exit_dialog');

  static Future<bool> showExitDialog() async {
    final result = await _channel.invokeMethod<bool>('showExitDialog');
    return result ?? false;
  }
}
