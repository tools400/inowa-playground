import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/constants.dart';

class BleAutoConnector {
  BleAutoConnector(this._scanner, this._connector);

  final BleScanner _scanner;
  final BleDeviceConnector _connector;
  Function(Status)? _statusCallback;
  Timer? _timeoutTimer;

  void scanAndConnect(
      {required String serviceName,
      int? timeout,
      Function(Status)? statusCallback}) {
    timeout = timeout ?? SCANNER_TIMEOUT;
    _statusCallback = statusCallback;
    _scanner.startScan(serviceName, [], _deviceFoundCallback);
    _timeoutTimer = Timer(Duration(seconds: timeout), () {
      _stopScan();
    });
  }

  void disconnect(String deviceId) {
    _connector.disconnect(deviceId, _disconnectedCallback);
  }

  /// Callback, wird aufgerufen, sobald das gesuchte
  /// Bluetooth Gerät gefunden worden ist.
  _deviceFoundCallback(DiscoveredDevice device) {
    if (_timeoutTimer != null) {
      _timeoutTimer!.cancel();
    }
    _stopScan();
    _connector.connect(device.id, _connectedCallback);
  }

  void _stopScan() {
    _scanner.stopScan();
  }

  /// Callback, wird nach erfolgreicher Verbindung zum
  /// Bluetooth Gerät aufgerufen.
  _connectedCallback(String deviceId) {
    if (_statusCallback != null) {
      // Ermitteln der Characteristic 'LED Value'

      _statusCallback!(Status.connected);
    }
  }

  /// Callback, wird nach erfolgreicher Trennung der
  /// Verbindung zum Bluetooth Gerät aufgerufen.
  _disconnectedCallback(String deviceId) {
    if (_statusCallback != null) {
      _statusCallback!(Status.disconnected);
    }
  }
}

enum Status {
  connected,
  disconnected;
}
