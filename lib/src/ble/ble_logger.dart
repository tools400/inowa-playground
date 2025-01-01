import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as ble;
import 'package:intl/intl.dart';

import '/src/logging/log_level_enum.dart';
import '/src/utils/utils.dart';

class BleLogger {
  BleLogger({
    required ble,
  }) : _ble = ble;

  final ble.FlutterReactiveBle _ble;

  bool _isLoggingEnabled = true;
  LogLevel _logLevel = LogLevel.info;
  final List<String> _logMessages = [];
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.sss');

  /// Liefert die Liste der aufgezeichneten Nachrichten.
  List<String> get messages => _logMessages;

  /// Liefert 'true', wenn die Protokollierung grundsätzlich
  /// eingeschaltet ist, sonst 'false'.
  bool get loggingEnabled {
    return _isLoggingEnabled;
  }

  /// Schaltet die Protokollierung grundsätzlich ein oder aus.
  set loggingEnabled(bool enabled) {
    _isLoggingEnabled = enabled;
  }

  /// Liefert die eingestellte Protokollierungsstufe.
  LogLevel get logLevel => _logLevel;

  /// Setzt die Protokollierungsstufe.
  set logLevel(LogLevel? logLevel) {
    if (logLevel == null) {
      return;
    }

    _logLevel = logLevel;
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
    if (!_isLoggingEnabled) {
      return false;
    }
    return _logLevel.level >= logLevel.level;
  }

  /// Schaltet die Protokollierung der 'flutter_reactive_ble' Bibliothek
  /// ein, bzw. aus.
  set _bleLoggingEnabled(bool enabled) =>
      _ble.logLevel = enabled ? ble.LogLevel.verbose : ble.LogLevel.none;
}
