// ignore: avoid_print
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:inowa/src/inowa_app.dart';

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

class NavigationService {
  NavigationService._(); // Private constructor to prevent instantiation
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get context => INoWaApp.navigatorKey.currentContext!;
}

class PlatformUI {
  PlatformUI._(); // Private constructor to prevent instantiation

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(NavigationService.context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(NavigationService.context).size.height;
  }
}
