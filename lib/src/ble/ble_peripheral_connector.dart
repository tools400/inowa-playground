import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:inowa/main.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_device_interactor.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/constants.dart';
import 'package:inowa/src/ui/home/internal/connection_status_handler.dart';
import 'package:inowa/src/utils/utils.dart';

class BlePeripheralConnector {
  BlePeripheralConnector(
      this._scanner, this._connector, this._serviceDiscoverer);

  final BleScanner _scanner;
  final BleDeviceConnector _connector;
  final BleDeviceInteractor _serviceDiscoverer;

  Function(Status, String)? _statusCallback;
  static Timer? _timeoutTimer;
  Characteristic? _characteristic;

  void connectArduino(String deviceName) {
    _scanAndConnect(
        serviceName: deviceName,
        timeout: bleSettings.timeout,
        statusCallback: ConnectionStatusCallbackHandler.statusCallback);
  }

  String? get connectedDeviceId => _connector.connectedDeviceId;

  void disconnectArduino(String deviceId) {
    _disconnect(deviceId);
  }

  void _scanAndConnect(
      {required String serviceName,
      int? timeout,
      Function(Status, String)? statusCallback}) {
    timeout = timeout ?? SCANNER_TIMEOUT;
    _statusCallback = statusCallback;
    _scanner.startScan(serviceName, [], _deviceFoundCallback);
    _timeoutTimer = Timer(Duration(seconds: timeout), () {
      stopScan();
      _statusCallback!(Status.deviceNotFound, serviceName);
      bleLogger.error('Device not found: $serviceName');
    });
  }

  void _disconnect(String deviceId) {
    _connector.disconnect(deviceId, _disconnectedCallback);
  }

  Future<void> writeCharacteristicWithResponse(String value) async {
    await _characteristic?.write(
      value.codeUnits,
      withResponse: true,
    );
  }

  /// Callback, wird aufgerufen, sobald das gesuchte
  /// Bluetooth Gerät gefunden worden ist.
  _deviceFoundCallback(DiscoveredDevice device) {
    stopScan();
    _connector.connect(device.id, _connectedCallback);
  }

  void stopScan() {
    if (_timeoutTimer != null) {
      _timeoutTimer!.cancel();
      _timeoutTimer = null;
    }
    _scanner.stopScan();
  }

  /// Callback, wird nach erfolgreicher Verbindung zum
  /// Bluetooth Gerät aufgerufen.
  _connectedCallback(String deviceId) {
    bool isDone = false;
    bool isError = false;

    int s = 0;
    int c = 0;
    _characteristic = null;

    // Ermitteln der Characteristic 'LED Value'
    _serviceDiscoverer.discoverServices(deviceId).then((services) {
      while (!isDone && s < services.length) {
        Service service = services[s];
        if (Utils.equalsIgnoreCase(service.id.toString(), SERVICE_UUID)) {
          var characteristics = service.characteristics;
          while (!isDone && c < characteristics.length) {
            var characteristic = characteristics[c];
            if (Utils.equalsIgnoreCase(
                characteristic.id.toString(), CHARACTERISTICS_UUID)) {
              stopScan();
              print('DEBUG: Connected');
              // store characteristic for further usage
              _characteristic = characteristic;
              if (_statusCallback != null) {
                _statusCallback!(Status.connected, service.id.toString());
              }
              isDone;
            }
            c++;
          }
          if (_characteristic == null) {
            if (!isError) {
              isError = true;
              bleLogger
                  .error('\'$CHARACTERISTICS_UUID\' characteristic not found.');
              if (_statusCallback != null) {
                _statusCallback!(
                    Status.characteristicNotFound, CHARACTERISTICS_UUID);
              }
              isDone = true;
            }
          }
        }
        s++;
      }

      if (_characteristic == null) {
        if (!isError) {
          isError = true;
          bleLogger.error('\'$SERVICE_UUID\' service not found.');
          if (_statusCallback != null) {
            _statusCallback!(Status.serviceNotFound, SERVICE_UUID);
          }
        }
        // Trennen der Verbindung ohne Aufruf
        // der Status Callback
        _connector.disconnect(deviceId);
      }
    });
  }

  /// Callback, wird nach erfolgreicher Trennung der
  /// Verbindung zum Bluetooth Gerät aufgerufen.
  _disconnectedCallback(String deviceId) {
    _characteristic = null;
    if (_statusCallback != null) {
      _statusCallback!(Status.disconnected, deviceId);
    }
  }
}

enum Status {
  connected(isError: false),
  disconnected(isError: false),
  deviceNotFound(isError: true),
  serviceNotFound(isError: true),
  characteristicNotFound(isError: true);

  const Status({
    required bool isError,
  }) : _isError = isError;

  final bool _isError;

  bool get isError => _isError;
}
