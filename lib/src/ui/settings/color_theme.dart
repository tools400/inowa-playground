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
