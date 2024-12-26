import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ui/settings/ui_theme_mode_enum.dart';

class UIModel extends ChangeNotifier {
  /// Sprache, in der die App angezeigt wird
  Locale _locale = Locale(Platform.localeName);

  Locale get locale {
    if (supportedLocales().contains(_locale)) {
      return _locale;
    }
    return AppLocalizations.supportedLocales
        .firstWhere((locale) => locale.languageCode == 'de');
  }

  void setLocale(Locale? locale) {
    if (locale == null) {
      return;
    }
    _locale = locale;
    notifyListeners();
  }

  List<Locale> supportedLocales() {
    return AppLocalizations.supportedLocales;
  }

  /// Design (System/Hell/Dunkel), mit dem die App angezeigt wird.
  UIThemeMode _themeMode = UIThemeMode.system;

  UIThemeMode get uiThemeMode {
    return _themeMode;
  }

  void setUIThemeMode(UIThemeMode? themeMode) {
    if (themeMode == null) {
      return;
    }
    _themeMode = themeMode;
    notifyListeners();
  }

  List<UIThemeMode> uiThemeModes() {
    return UIThemeMode.values;
  }

  final bool _systemDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  bool get isDarkMode {
    if (_themeMode == UIThemeMode.dark) {
      return true;
    } else if (_themeMode == UIThemeMode.light) {
      return false;
    } else {
      return _systemDarkMode;
    }
  }

  /// Liefert das Label eines UI-Designs.
  String getUIModeLabel(BuildContext context, UIThemeMode uiThemeMode) {
    if (uiThemeMode == UIThemeMode.dark) {
      return AppLocalizations.of(context)!.mode_dark;
    } else if (uiThemeMode == UIThemeMode.light) {
      return AppLocalizations.of(context)!.mode_light;
    } else {
      return AppLocalizations.of(context)!.mode_system;
    }
  }

  /// Liefert das Icon eines UI-Designs.
  IconData getUIModeIconData(BuildContext context, UIThemeMode uiThemeMode) {
    if (uiThemeMode == UIThemeMode.dark) {
      return Icons.dark_mode_outlined;
    } else if (uiThemeMode == UIThemeMode.light) {
      return Icons.light_mode_outlined;
    } else {
      return Icons.brightness_auto;
    }
  }
}
