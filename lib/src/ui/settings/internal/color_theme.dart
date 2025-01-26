import 'package:flutter/material.dart';

/// Klasse mit den Dark und Light Themes der App.
class ColorTheme {
  static const _seedColor = Colors.blueAccent;
  static const _useMaterial3 = true;

  static Color error(BuildContext context) =>
      Theme.of(context).colorScheme.error;
  static Color errorContainer(BuildContext context) =>
      Theme.of(context).colorScheme.errorContainer;
  static Color inversePrimary(BuildContext context) =>
      Theme.of(context).colorScheme.inversePrimary;
  static Color ok(BuildContext context) => Colors.teal;
  //Theme.of(context).colorScheme.outline;

  static const linkColor = Colors.blue;
  static const navigatorSelectedColor = Colors.orange;
  static const deviceConnectedIconColor = Colors.amber;

  static final light = ThemeData(
    colorSchemeSeed: _seedColor,
    useMaterial3: _useMaterial3,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    colorSchemeSeed: _seedColor,
    useMaterial3: _useMaterial3,
    brightness: Brightness.dark,
  );
}

class BoulderColor {
  static const startHolds = Color.fromARGB(255, 25, 175, 30);
  static const interHolds1 = Color.fromARGB(255, 0, 20, 180);
  static const interHolds2 = Colors.purple;
  static const topHold = Colors.red;
  static const path = Colors.orange;
}
