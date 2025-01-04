import '/main.dart';
import '/src/constants.dart';

class BleSettings {
  static final keyIsAutoConnect = 'isAutoConnect';
  static final keyDeviceName = 'deviceName';
  static final keyTimeout = 'scannerTimeout';

  /// Schaltet das automatische Herstellen der Bluetooth Verbindung
  /// ein oder aus.
  set autoConnectEnabled(bool enabled) {
    preferences.setBool(keyIsAutoConnect, enabled);
  }

  /// Liefert 'true', wenn die Bluetooth Verbindung automatisch
  /// hergestellt werden soll.
  bool get isAutoConnect {
    bool isAutoConnect = preferences.getBool(keyIsAutoConnect) ?? true;
    return isAutoConnect;
  }

  /// Setzt den Namen des Bluetooth Geräts.
  set deviceName(String deviceName) {
    preferences.setString(keyDeviceName, deviceName);
  }

  /// Liefert den Namen des Bluetooth Geräts.
  String get deviceName {
    String deviceName =
        preferences.getString(keyDeviceName) ?? ANDROID_BLE_DEVICE_NAME;
    return deviceName;
  }

  /// Setzt den das Timeout in Sekunden für den Scanner.
  set timeout(int timeout) {
    preferences.setInt(keyTimeout, timeout);
  }

  /// Liefert das Timeout in Sekunden für den Scanner.
  int get timeout {
    int timeout = preferences.getInt(keyTimeout) ?? SCANNER_TIMEOUT;
    return timeout;
  }
}
