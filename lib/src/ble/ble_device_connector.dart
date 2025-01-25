import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:inowa/main.dart';

import 'ble_reactive_state.dart';

class BleDeviceConnector extends ReactiveState<ConnectionStateUpdate> {
  BleDeviceConnector({
    required FlutterReactiveBle ble,
  }) : _ble = ble;

  final FlutterReactiveBle _ble;

  @override
  Stream<ConnectionStateUpdate> get state => _deviceConnectionController.stream;

  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  // ignore: cancel_subscriptions
  // Add null check, because _connection is null until the device has been connected.
  StreamSubscription<ConnectionStateUpdate>? _connection;
  String? _connectedDeviceId;

  /// Stellt die Verbindung zu einem Geräte her. Die Identifizierung
  /// erfolgt über die Geräte-ID.
  Future<void> connect(String deviceId,
      [void Function(String deviceId)? connectedCallback]) async {
    bleLogger.info('Start connecting to $deviceId');
    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) {
        bleLogger.info(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        _deviceConnectionController.add(update);
        _connectedDeviceId = deviceId;
        if (connectedCallback != null &&
            update.connectionState == DeviceConnectionState.connected) {
          bleLogger.debug('Calling: connected callback');
          connectedCallback(deviceId);
        }
      },
      onError: (Object e) => bleLogger
          .error('Connecting to device $deviceId resulted in error $e'),
    );
  }

  /// Trennt die BLuetoothVerbindung zu dem verbundenem Gerät.
  Future<void> disconnect(String deviceId,
      [void Function(String deviceId)? disconnectedCallback]) async {
    try {
      bleLogger.info('disconnecting to device: $deviceId');
      await _connection?.cancel();
      _connectedDeviceId = null;
    } on Exception catch (e, _) {
      bleLogger.error("Error disconnecting from a device: $e");
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
        bleLogger.debug('Calling: disconnected callback');
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
