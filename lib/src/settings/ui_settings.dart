import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:inowa/main.dart';
import 'package:inowa/src/ui/settings/internal/dark_mode_enum.dart';

/// Klasse mit den Einstellungen für die Darstellung der App. Die hier
/// verwalteten Einstellungen werden lokal auf dem Smartphone gespeichert
/// und können auf dem Smartphone durch Löschen des Speichers der App
/// gelöscht werden.
/// Einstellungen -> Apps -> iNoWa -> Speicher und Cache -> Speicherinhalt löschen
class UIModel extends ChangeNotifier {
  static final keyDarkMode = 'darkMode';
  static final keyLocale = 'locale';
  static final keyShowPath = 'showPath';

  /// Liefert die Sprache, in der die App angezeigt wird.
  Locale get locale {
    Locale systemLocale = Locale(Platform.localeName);

    String languageCode =
        preferences.getString(keyLocale) ?? systemLocale.languageCode;

    for (int i = 0; i < supportedLocales.length; i++) {
      if (supportedLocales[i].languageCode == languageCode) {
        return supportedLocales[i];
      }
    }

    if (languageCode.length > 2) {
      for (int i = 0; i < supportedLocales.length; i++) {
        if (languageCode.startsWith(supportedLocales[i].countryCode ?? '')) {
          return supportedLocales[i];
        }
      }
    }

    return systemLocale;
  }

  /// Liefert den 'Language Code' der eingestellten Sprache.
  String get languageCode => locale.languageCode;

  /// Setzt die Sprache, in der die App angezeigt wird.
  void setLocale(Locale? locale) {
    if (locale == null) {
      return;
    }

    preferences.setString(keyLocale, locale.languageCode);
    notifyListeners();
  }

  /// Liefert eine Liste der unterstützten Sprachen.
  List<Locale> get supportedLocales {
    return AppLocalizations.supportedLocales;
  }

  /// Design (System/Hell/Dunkel), mit dem die App angezeigt wird.
  DarkMode get darkMode {
    String themeModeName =
        preferences.getString(keyDarkMode) ?? DarkMode.system.name;

    for (int i = 0; i < darkModes.length; i++) {
      if (darkModes[i].name == themeModeName) {
        return darkModes[i];
      }
    }

    return DarkMode.system;
  }

  /// Setzt den Dark Mode der App.
  void setDarkMode(DarkMode? darkMode) {
    if (darkMode == null) {
      return;
    }

    preferences.setString(keyDarkMode, darkMode.name);
    notifyListeners();
  }

  /// Liefert den Dark Mode der App.
  List<DarkMode> get darkModes {
    return DarkMode.values;
  }

  /// Liefert 'true', wenn der Dark Mode aktiviert ist, sonst 'false'.
  bool get isDarkMode {
    if (darkMode == DarkMode.dark) {
      return true;
    } else if (darkMode == DarkMode.light) {
      return false;
    } else {
      bool isSystemDarkMode =
          SchedulerBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
      return isSystemDarkMode;
    }
  }

  /// Liefert das Label eines DarkMode Wertes.
  String getDarkModeLabel(BuildContext context, DarkMode darkMode) {
    if (darkMode == DarkMode.dark) {
      return AppLocalizations.of(context)!.mode_dark;
    } else if (darkMode == DarkMode.light) {
      return AppLocalizations.of(context)!.mode_light;
    } else {
      return AppLocalizations.of(context)!.mode_system;
    }
  }

  /// Liefert das Icon eines DarkMode Wertes.
  IconData getDarkModeIconData(BuildContext context, DarkMode darkMode) {
    if (darkMode == DarkMode.dark) {
      return Icons.dark_mode_outlined;
    } else if (darkMode == DarkMode.light) {
      return Icons.light_mode_outlined;
    } else {
      return Icons.brightness_auto;
    }
  }

  /// Stores the value for showing/hiding the path on the boulder
  /// wall.
  void setShowPath(bool show) {
    preferences.setBool(keyShowPath, show);
    notifyListeners();
  }

  /// Specifies whether to show the path on the boulder wall.
  bool get isShowPath {
    return preferences.getBool(keyShowPath) ?? true;
  }
}
