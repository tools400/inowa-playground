import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/main.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/led/led_settings.dart';

import '/src/ble/ble_device_interactor.dart';
import '/src/ble/ble_status_monitor.dart';
import '/src/firebase/fb_service.dart';
import '/src/settings/ui_settings.dart';
import '/src/ui/authentication/auth_gate.dart';
import 'ble/ble_settings.dart';
import 'ui/settings/internal/color_theme.dart';

class INoWaApp extends StatelessWidget {
  const INoWaApp({
    super.key,
    required BleSettings settings,
    required LedSettings ledSettings,
    required BleScanner scanner,
    required BleStatusMonitor monitor,
    required BleDeviceConnector connector,
    required BleDeviceInteractor serviceDiscoverer,
    required BlePeripheralConnector bleAutoConnector,
    required BleLogger bleLogger,
    required FirebaseService firebaseService,
  })  : _settings = settings,
        _ledSettings = ledSettings,
        _scanner = scanner,
        _monitor = monitor,
        _connector = connector,
        _serviceDiscoverer = serviceDiscoverer,
        _bleAutoConnector = bleAutoConnector,
        _bleLogger = bleLogger,
        _firebaseService = firebaseService;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final BleSettings _settings;
  final LedSettings _ledSettings;
  final BleScanner _scanner;
  final BleStatusMonitor _monitor;
  final BleDeviceConnector _connector;
  final BleDeviceInteractor _serviceDiscoverer;
  final BlePeripheralConnector _bleAutoConnector;
  final BleLogger _bleLogger;
  final FirebaseService _firebaseService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: _settings),
        Provider.value(value: _ledSettings),
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleAutoConnector),
        Provider.value(value: _bleLogger),
        Provider.value(value: _firebaseService),
        StreamProvider<BleScannerState?>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => UIModel(),
        child: Consumer<UIModel>(builder: (context, uiModel, child) {
          return MaterialApp(
            title: packageInfo.appName,
            theme: ColorTheme.light,
            darkTheme: ColorTheme.dark,
            themeMode: uiModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: uiModel.locale,
            home: const AuthGate(),
            navigatorKey: INoWaApp.navigatorKey,
          );
        }),
      ),
    );
  }
}
