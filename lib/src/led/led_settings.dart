import 'package:inowa/main.dart';

class LedSettings {
  static final keyIsHorizontalWireing = 'isHorizontalWireing';

  /// Setzt den Typ der Verdrahtung der LED Kette.
  set isHorizontalWireing(bool enabled) {
    preferences.setBool(keyIsHorizontalWireing, enabled);
  }

  /// Liefert 'true', wenn die LED Kette horizontal verdrahtet,
  /// sonst false.
  bool get isHorizontalWireing {
    bool isHorizontalWireing =
        preferences.getBool(keyIsHorizontalWireing) ?? true;
    return isHorizontalWireing;
  }
}
