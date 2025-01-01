/// Definiert die Detailierungsstufe der Logausgaben.
enum LogLevel {
  /// Protokollierung von 'Fehler' Nachrichten..
  error(level: 1, label: 'ERROR'),

  /// Protokollierung von 'Informations' Nachrichten..
  info(level: 2, label: 'INFO'),

  /// Protokollierung von 'Debug' Nachrichten..
  verbose(level: 3, label: 'VERBOSE');

  const LogLevel({
    required this.level,
    required this.label,
  });

  final int level;
  final String label;
}
