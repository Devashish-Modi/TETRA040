import 'package:flutter/foundation.dart';

/// Simple debug logger for core / infrastructure layers.
class AppLogger {
  AppLogger._();

  static void info(String message, [Object? data]) {
    debugPrint('[AgriShield] $message${data != null ? ' → $data' : ''}');
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    debugPrint('[AgriShield][ERROR] $message');
    if (error != null) debugPrint('  cause: $error');
    if (stack != null) debugPrintStack(stackTrace: stack);
  }
}
