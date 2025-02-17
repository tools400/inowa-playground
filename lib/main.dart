import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_device_interactor.dart';
import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/ble/ble_status_monitor.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/logging/logger.dart';
import 'package:inowa/src/utils/utils.dart';

import '/src/firebase/fb_service.dart';
import '/src/inowa_app.dart';
import 'firebase_options.dart';
import 'src/ble/ble_settings.dart';

// Global variables
late PackageInfo packageInfo;
late SharedPreferences preferences;
late final FirebaseApp app;
late final FirebaseAuth auth;

late final BlePeripheralConnector peripheralConnector;
late final BleSettings bleSettings;
late final LedSettings ledSettings;
late final AppLogger bleLogger;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);

  final firebaseService = FirebaseService();

  final ble = FlutterReactiveBle();
  // Status: unknown, unsupported, unauthorized, poweredOff, locationServicesDisabled, ready
  final monitor = BleStatusMonitor(ble);
  // Status: scanIsInProgress
  final scanner = BleScanner(ble: ble);
  // Status: connecting, connected, disconnecting, disconnected
  final connector = BleDeviceConnector(
    ble: ble,
  );

  final serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: (deviceId) async {
      await ble.discoverAllServices(deviceId);
      return ble.getDiscoveredServices(deviceId);
    },
    readRssi: ble.readRssi,
    requestMtu: ble.requestMtu,
  );

  // Initialize global variables
  packageInfo = await PackageInfo.fromPlatform();
  preferences = await SharedPreferences.getInstance();
  bleSettings = BleSettings();
  ledSettings = LedSettings();
  peripheralConnector =
      BlePeripheralConnector(scanner, connector, serviceDiscoverer);
  bleLogger = AppLogger(ble: ble);

  runApp(INoWaApp(
    navigatorKey: NavigationService.navigatorKey,
    firebaseService: firebaseService,
    monitor: monitor,
    scanner: scanner,
    connector: connector,
    serviceDiscoverer: serviceDiscoverer,
    ledSettings: ledSettings,
    bleLogger: bleLogger,
  ));
}
