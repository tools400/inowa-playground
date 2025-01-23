import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'ble_reactive_state.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner({
    required FlutterReactiveBle ble,
    required void Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final StreamController<BleScannerState> _stateStreamController =
      StreamController();

  final _devices = <DiscoveredDevice>[];
  bool _isScanning = false;

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  /// Startet die Suche nach Bluetooth Geräten.
  void startScan(String serviceName, List<Uuid> serviceIds,
      [Function(DiscoveredDevice device)? deviceFoundCallback]) {
    _logMessage('Start ble discovery');
    _devices.clear();
    _subscription?.cancel();
    _isScanning = true;
    _subscription =
        _ble.scanForDevices(withServices: serviceIds).listen((device) {
      _logMessage('Testing for matched device: ${device.name}');
      if (_matches(device, serviceName)) {
        final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
        if (knownDeviceIndex >= 0) {
          _devices[knownDeviceIndex] = device;
        } else {
          _devices.add(device);
        }
        if (deviceFoundCallback != null) {
          deviceFoundCallback(device);
        }
      }
      _pushState();
    }, onError: (Object e) => _logMessage('Device scan fails with error: $e'));
    _pushState();
    _logMessage('Leaving ble discovery');
  }

  bool _matches(DiscoveredDevice device, String serviceName) {
    var serviceNamePattern = serviceName.replaceAll('*', '.*');
    var regExp = RegExp(serviceNamePattern, caseSensitive: false);
    var stringMatch = regExp.stringMatch(device.name);
    if (stringMatch != null) {
      return true;
    }
    return false;
  }

  /// Aktualisiert den Bluetooth Status Stream.
  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  /// Beendet die Suche nach Bluetooth Geräten.
  Future<void> stopScan() async {
    _logMessage('Stop ble discovery');

    await _subscription?.cancel();
    _subscription = null;
    _isScanning = false;
    _pushState();
  }

  /// Liefert 'true', wenn der Scann Vorgang läuft, sonst 'false'.
  bool get isScanning => _isScanning;

  /// Gibt allokierte Resourcen frei.
  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  StreamSubscription<DiscoveredDevice>? _subscription;
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}
