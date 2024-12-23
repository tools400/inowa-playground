import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:inowa/src/ble/reactive_state.dart';
import 'package:meta/meta.dart';

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

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  void startScan(String serviceName, List<Uuid> serviceIds,
      void Function(DiscoveredDevice device)? connectCallback) {
    _logMessage('Start ble discovery');
    _devices.clear();
    _subscription?.cancel();
    _subscription =
        _ble.scanForDevices(withServices: serviceIds).listen((device) {
      if (matches(device, serviceName)) {
        final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
        if (knownDeviceIndex >= 0) {
          _devices[knownDeviceIndex] = device;
        } else {
          _devices.add(device);
        }
        if ((serviceName.isNotEmpty || serviceIds.isNotEmpty) &&
            connectCallback != null) {
          stopScan();
          connectCallback(device);
        }
      }
      _pushState();
    }, onError: (Object e) => _logMessage('Device scan fails with error: $e'));
    _pushState();
  }

  bool matches(DiscoveredDevice device, String serviceName) {
    var serviceNamePattern = serviceName.replaceAll('*', '.*');
    var regExp = RegExp(serviceNamePattern, caseSensitive: false);
    var stringMatch = regExp.stringMatch(device.name);
    if (stringMatch != null) {
      return true;
    }
    return false;
  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Stop ble discovery');

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

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
