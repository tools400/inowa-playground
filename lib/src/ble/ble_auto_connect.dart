import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/constants.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

class BleAutoConnector {
  BleAutoConnector(this._context, this._scanner, this._connector,
      [int? timeout])
      : _timeout = timeout ?? SCANNER_TIMEOUT;

  final BuildContext _context;
  final BleScanner _scanner;
  final BleDeviceConnector _connector;
  final int _timeout;
  Timer? timeoutTimer;

  void scanAndConnect(String serviceName) {
    _scanner.startScan(serviceName, [], _deviceFoundCallback);
    timeoutTimer = Timer(const Duration(seconds: SCANNER_TIMEOUT), () {
      _stopScan();
    });
  }

  void disconnect(String deviceId) {
    _connector.disconnect(deviceId, _disconnectedCallback);
  }

  /// Callback, wird aufgerufen, sobald das gesuchte
  /// Bluetooth Gerät gefunden worden ist.
  _deviceFoundCallback(DiscoveredDevice device) {
    if (timeoutTimer != null) {
      timeoutTimer!.cancel();
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
    ScaffoldSnackbar.of(_context)
        .show(AppLocalizations.of(_context)!.txt_connection_established);
  }

  /// Callback, wird nach erfolgreicher Trennung der
  /// Verbindung zum Bluetooth Gerät aufgerufen.
  _disconnectedCallback(String deviceId) {
    ScaffoldSnackbar.of(_context)
        .show(AppLocalizations.of(_context)!.txt_connection_disconnected);
  }
}
