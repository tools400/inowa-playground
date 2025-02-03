import 'package:flutter/material.dart';

import 'package:inowa/src/constants.dart';

class LanguageIcons {
  LanguageIcons._(); // Private constructor to prevent instantiation

  static Image get en => Image.asset(height: 18, width: 18, LANGUAGE_ENGLISH);
  static Image get de => Image.asset(height: 18, width: 18, LANGUAGE_GERMAN);

  static buttonByLanguageCode(String languageCode,
      [Function(String languageCode)? onPressed]) {
    return TextButton.icon(
      iconAlignment: IconAlignment.start,
      icon: LanguageIcons.imageByLanguageCode(languageCode),
      label: Text(languageCode),
      onPressed: onPressed != null ? onPressed(languageCode) : () {},
    );
  }

  static Image imageByLanguageCode(String languageCode) {
    if (languageCode == 'en') {
      return LanguageIcons.en;
    } else {
      return LanguageIcons.de;
    }
  }
}
