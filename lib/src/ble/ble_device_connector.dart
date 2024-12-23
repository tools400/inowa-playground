import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:inowa/src/ble/reactive_state.dart';

class BleDeviceConnector extends ReactiveState<ConnectionStateUpdate> {
  BleDeviceConnector({
    required FlutterReactiveBle ble,
    required void Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;

  @override
  Stream<ConnectionStateUpdate> get state => _deviceConnectionController.stream;

  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  // ignore: cancel_subscriptions
  // Add null check, because _connection is null until the device has been connected.
  StreamSubscription<ConnectionStateUpdate>? _connection;
  String? _connectedDeviceId;

  Future<void> connect(String deviceId) async {
    _logMessage('Start connecting to $deviceId');
    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) {
        _logMessage(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        _deviceConnectionController.add(update);
        _connectedDeviceId = deviceId;
      },
      onError: (Object e) =>
          _logMessage('Connecting to device $deviceId resulted in error $e'),
    );
  }

  Future<void> disconnect(String deviceId) async {
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
    }
  }

  String connectedDeviceId() {
    String deviceId = '';
    if (_connectedDeviceId != null) {
      deviceId = _connectedDeviceId!;
    }
    return deviceId;
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
