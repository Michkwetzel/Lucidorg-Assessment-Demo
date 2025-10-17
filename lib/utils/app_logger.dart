import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

/// Centralized logging utility for the application
///
/// Usage:
/// ```dart
/// final logger = AppLogger.getLogger('MyClassName');
/// logger.info('Information message');
/// logger.warning('Warning message');
/// logger.severe('Error message');
/// ```
class AppLogger {
  /// Initialize the logging system
  /// Should be called once during app initialization
  static void initialize() {
    Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        // Format: [LEVEL] LoggerName: message
        debugPrint('${_formatLevel(record.level)} ${record.loggerName}: ${record.message}');
        if (record.error != null) {
          debugPrint('Error: ${record.error}');
        }
        if (record.stackTrace != null) {
          debugPrint('Stack trace:\n${record.stackTrace}');
        }
      }
    });
  }

  /// Get a logger instance for a specific class or module
  static Logger getLogger(String name) {
    return Logger(name);
  }

  /// Format log level for consistent output
  static String _formatLevel(Level level) {
    if (level == Level.INFO) return '[INFO]';
    if (level == Level.WARNING) return '[WARN]';
    if (level == Level.SEVERE) return '[ERROR]';
    if (level == Level.FINE) return '[DEBUG]';
    return '[${level.name}]';
  }
}
