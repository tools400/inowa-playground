import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UIModel extends ChangeNotifier {
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

  bool _isDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  bool get isDarkMode => _isDarkMode;

  void darkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    notifyListeners();
  }
}
