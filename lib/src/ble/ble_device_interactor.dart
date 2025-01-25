import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:inowa/main.dart';

//Future<int> requestMtu2(String deviceId, int mtu) async {
//  return 123;
//}

class BleDeviceInteractor {
  BleDeviceInteractor({
    required Future<List<Service>> Function(String deviceId)
        bleDiscoverServices,
    required this.readRssi,
    required this.requestMtu,
  }) : _bleDiscoverServices = bleDiscoverServices;

  final Future<List<Service>> Function(String deviceId) _bleDiscoverServices;
  final Future<int> Function(String deviceId) readRssi;
  final Future<int> Function({required String deviceId, required int mtu})
      requestMtu;

  Future<List<Service>> discoverServices(String deviceId) async {
    try {
      bleLogger.debug('Start discovering services for: $deviceId');
      final result = await _bleDiscoverServices(deviceId);
      bleLogger.debug('Discovering services finished');
      return result;
    } on Exception catch (e) {
      bleLogger.error('Error occurred when discovering services: $e');
      rethrow;
    }
  }
}
