import 'package:flutter/material.dart';

/// Klasse mit den Dark und Light Themes der App.
class ColorTheme {
  static const seedColor = Colors.blueAccent;
  static const useMaterial3 = true;

  static final light = ThemeData(
    colorSchemeSeed: seedColor,
    useMaterial3: useMaterial3,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    colorSchemeSeed: seedColor,
    useMaterial3: useMaterial3,
    brightness: Brightness.dark,
  );
}
