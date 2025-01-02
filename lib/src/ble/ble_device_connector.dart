import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:inowa/src/ble/ble_scanner.dart';

import 'ble_reactive_state.dart';

class BleDeviceConnector extends ReactiveState<ConnectionStateUpdate> {
  BleDeviceConnector({
    required FlutterReactiveBle ble,
    required BleScanner scanner,
    required void Function(String message) logMessage,
  })  : _ble = ble,
        _scanner = scanner,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final BleScanner _scanner;
  final void Function(String message) _logMessage;

  @override
  Stream<ConnectionStateUpdate> get state => _deviceConnectionController.stream;

  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  // ignore: cancel_subscriptions
  // Add null check, because _connection is null until the device has been connected.
  StreamSubscription<ConnectionStateUpdate>? _connection;
  String? _connectedDeviceId;

  /// Stellt automatisch eine Verbindung zu einem benannten Gerät her.
  Future<void> autoConnect(String deviceName,
      void Function(DiscoveredDevice device)? deviceFoundCallback) async {
    _logMessage('Start auto-connecting to: $deviceName');
    _scanner.startScan(deviceName, [], deviceFoundCallback);
  }

  /// Stellt die Verbindung zu einem Geräte her. Die Identifizierung
  /// erfolgt über die Geräte-ID.
  Future<void> connect(String deviceId,
      [void Function(String deviceId)? connectedCallback]) async {
    _logMessage('Start connecting to $deviceId');
    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) {
        _logMessage(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        _deviceConnectionController.add(update);
        _connectedDeviceId = deviceId;
        if (connectedCallback != null) {
          _logMessage('Calling: connected callback');
          connectedCallback(deviceId);
        }
      },
      onError: (Object e) =>
          _logMessage('Connecting to device $deviceId resulted in error $e'),
    );
  }

  /// Trennt die BLuetoothVerbindung zu dem verbundenem Gerät.
  Future<void> disconnect(String deviceId,
      [void Function(String deviceId)? disconnectedCallback]) async {
    try {
      _logMessage('disconnecting to device: $deviceId');
      await _connection?.cancel();
      _connectedDeviceId = null;
    } on Exception catch (e, _) {
      _logMessage("Error disconnecting from a device: $e");
    } finally {
      // Since [_connection] subscription is terminated, the "disconnected" state cannot be received and propagated
      _deviceConnectionController.add(
        ConnectionStateUpdate(
          deviceId: deviceId,
          connectionState: DeviceConnectionState.disconnected,
          failure: null,
        ),
      );
      if (disconnectedCallback != null) {
        _logMessage('Calling: disconnected callback');
        disconnectedCallback(deviceId);
      }
    }
  }

  /// Liefert die ID des verbundenen Geräts.
  String? get connectedDeviceId {
    return _connectedDeviceId;
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
