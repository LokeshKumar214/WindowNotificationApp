import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LogService {
  static File? _logFile;

  /// Initialize log file
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/connection_logs.txt";

    _logFile = File(path);

    // Create the file if it doesn't exist
    if (!await _logFile!.exists()) {
      await _logFile!.create(recursive: true);
    }
  }

  /// Write a log entry
  static Future<void> write(String message) async {
    final time = DateTime.now().toIso8601String();
    final logEntry = "[$time] $message\n";

    await _logFile?.writeAsString(
      logEntry,
      mode: FileMode.append,
      flush: true,
    );
  }

  /// Read the log file
  static Future<String> read() async {
    if (_logFile == null) return "Log file not initialized";
    return await _logFile!.readAsString();
  }

  /// Get log file path (to open manually)
  static String? get filePath => _logFile?.path;
}
