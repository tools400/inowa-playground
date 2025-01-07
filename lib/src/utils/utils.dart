// ignore: avoid_print
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Utils {
  Utils._(); // Private constructor to prevent instantiation

  static DateTime now() {
    return DateTime.now();
  }

  /// Liefert das aktuelle Kalenderjahr als 4-stellige Zeichenfolge.
  static String year() {
    var formatter = DateFormat('yyyy');
    return formatter.format(now());
  }

  /// Öffnet die angegebene Bildschirmseite.
  static void openScreen(BuildContext context, Widget screen) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  /// Veregleicht zwei Zeichenketten ohne Berücksichtigung der
  /// Groß- und Kleinschreibung.
  static bool equalsIgnoreCase(String? string1, String? string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }
}
