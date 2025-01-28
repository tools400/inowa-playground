import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as ble;
import 'package:intl/intl.dart';

import '/main.dart';
import '/src/logging/log_level_enum.dart';
import '/src/utils/utils.dart';

class AppLogger {
  AppLogger({
    required ble,
  }) : _ble = ble;

  static final keyIsActive = 'isActive';
  static final keyLogLevel = 'logLevel';

  final ble.FlutterReactiveBle _ble;

  final List<String> _logMessages = [];
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.sss');

  final defaultLogLevel = LogLevel.info;

  int? _cachedLogLevel;

  /// Liefert die Liste der aufgezeichneten Nachrichten.
  List<String> get messages => _logMessages;

  /// Liefert 'true', wenn die Protokollierung grundsätzlich
  /// eingeschaltet ist, sonst 'false'.
  bool get loggingEnabled {
    bool isActive = preferences.getBool(keyIsActive) ?? true;
    return isActive;
  }

  /// Schaltet die Protokollierung grundsätzlich ein oder aus.
  set loggingEnabled(bool enabled) {
    preferences.setBool(keyIsActive, enabled);
  }

  /// Liefert die eingestellte Protokollierungsstufe.
  LogLevel get logLevel {
    int level = preferences.getInt(keyLogLevel) ?? -1;
    for (int i = 0; i < LogLevel.values.length; i++) {
      LogLevel logLevel = LogLevel.values[i];
      if (logLevel.level == level) {
        return logLevel;
      }
    }

    // Default Protokollierungsstufe:
    return LogLevel.info;
  }

  /// Liefert den numerischen Wert der Protokollierungsstufe.
  int get cachedLogLevel {
    _cachedLogLevel ??= logLevel.level;
    return _cachedLogLevel!;
  }

  /// Setzt die Protokollierungsstufe.
  set logLevel(LogLevel? logLevel) {
    logLevel ??= defaultLogLevel;

    preferences.setInt(keyLogLevel, logLevel.level);
    _cachedLogLevel = logLevel.level;

    if (_isLoggingEnabledFor(LogLevel.verbose)) {
      _bleLoggingEnabled = true;
    } else {
      _bleLoggingEnabled = false;
    }
  }

  /// Protokolliert eine Fehlernachricht.
  void error(String message) {
    if (_isLoggingEnabledFor(LogLevel.error)) {
      _addToLog(LogLevel.error, message);
    }
  }

  /// Protokolliert eine Informationsnachricht.
  void info(String message) {
    if (_isLoggingEnabledFor(LogLevel.info)) {
      _addToLog(LogLevel.info, message);
    }
  }

  /// Protokolliert eine Debug-Nachricht.
  void debug(String message) {
    if (_isLoggingEnabledFor(LogLevel.verbose)) {
      _addToLog(LogLevel.verbose, message);
    }
  }

  /// Fügt eine Nachricht zum Nachrichtenliste hinzu.
  void _addToLog(LogLevel level, String message) {
    final now = Utils.now();
    _logMessages.add('[${level.label}] ${formatter.format(now)} - $message');
  }

  void clearLogs() => _logMessages.clear();

  /// Liefert 'true', wenn die Protokollierung für die angegebene
  /// Protokollierungsstufe eingeschaltet ist, sonst 'false'.
  bool _isLoggingEnabledFor(LogLevel logLevel) {
    if (!loggingEnabled) {
      return false;
    }
    return cachedLogLevel >= logLevel.level;
  }

  /// Turns logging on or off.
  set _bleLoggingEnabled(bool enabled) =>
      _ble.logLevel = enabled ? ble.LogLevel.verbose : ble.LogLevel.none;
}
