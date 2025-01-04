import '/main.dart';
import '/src/constants.dart';

class BleSettings {
  static final key_is_auto_connect = 'isAutoConnect';
  static final key_device_name = 'deviceName';
  static final key_timeout = 'scannerTimeout';

  /// Schaltet das automatische Herstellen der Bluetooth Verbindung
  /// ein oder aus.
  set autoConnectEnabled(bool enabled) {
    preferences.setBool(key_is_auto_connect, enabled);
  }

  /// Liefert 'true', wenn die Bluetooth Verbindung automatisch
  /// hergestellt werden soll.
  bool get isAutoConnect {
    bool isAutoConnect = preferences.getBool(key_is_auto_connect) ?? true;
    return isAutoConnect;
  }

  /// Setzt den Namen des Bluetooth Geräts.
  set deviceName(String deviceName) {
    preferences.setString(key_device_name, deviceName);
  }

  /// Liefert den Namen des Bluetooth Geräts.
  String get deviceName {
    String deviceName =
        preferences.getString(key_device_name) ?? ANDROID_BLE_DEVICE_NAME;
    return deviceName;
  }

  /// Setzt den das Timeout in Sekunden für den Scanner.
  set timeout(int timeout) {
    preferences.setInt(key_timeout, timeout);
  }

  /// Liefert das Timeout in Sekunden für den Scanner.
  int get timeout {
    int timeout = preferences.getInt(key_timeout) ?? SCANNER_TIMEOUT;
    return timeout;
  }
}
