import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_device_interactor.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/ble/ble_status_monitor.dart';
import 'package:inowa/src/inowa_app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/ble/ble_logger.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late PackageInfo packageInfo;
late SharedPreferences preferences;

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);

  final ble = FlutterReactiveBle();
  final bleLogger = BleLogger(ble: ble);
  final scanner = BleScanner(ble: ble, logMessage: bleLogger.info);
  final monitor = BleStatusMonitor(ble);

  final connector = BleDeviceConnector(
    ble: ble,
    logMessage: bleLogger.info,
  );

  final serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: (deviceId) async {
      await ble.discoverAllServices(deviceId);
      return ble.getDiscoveredServices(deviceId);
    },
    logMessage: bleLogger.info,
    readRssi: ble.readRssi,
    requestMtu: ble.requestMtu,
  );

  packageInfo = await PackageInfo.fromPlatform();
  preferences = await SharedPreferences.getInstance();

  runApp(INoWaApp(
      scanner: scanner,
      monitor: monitor,
      connector: connector,
      serviceDiscoverer: serviceDiscoverer,
      bleLogger: bleLogger));
}
