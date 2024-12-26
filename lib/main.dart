import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_device_interactor.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/ble/ble_status_monitor.dart';
import 'package:inowa/src/inowa_app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'src/ble/ble_logger.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late PackageInfo packageInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final _ble = FlutterReactiveBle();
  final _bleLogger = BleLogger(ble: _ble);
  final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
  final _monitor = BleStatusMonitor(_ble);

  final _connector = BleDeviceConnector(
    ble: _ble,
    logMessage: _bleLogger.addToLog,
  );

  final _serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: (deviceId) async {
      await _ble.discoverAllServices(deviceId);
      return _ble.getDiscoveredServices(deviceId);
    },
    logMessage: _bleLogger.addToLog,
    readRssi: _ble.readRssi,
    requestMtu: _ble.requestMtu,
  );

  packageInfo = await PackageInfo.fromPlatform();

  runApp(INoWaApp(
      scanner: _scanner,
      monitor: _monitor,
      connector: _connector,
      serviceDiscoverer: _serviceDiscoverer,
      bleLogger: _bleLogger));
}
