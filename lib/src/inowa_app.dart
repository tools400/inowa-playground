import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ui/settings/color_theme.dart';
import 'package:provider/provider.dart';
import 'package:inowa/src/constants.dart';
import 'package:inowa/src/settings/ui_model.dart';
import 'package:inowa/src/ui/home/home_screen.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_device_interactor.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/ble/ble_status_monitor.dart';

class INoWaApp extends StatelessWidget {
  const INoWaApp({
    super.key,
    required BleScanner scanner,
    required BleStatusMonitor monitor,
    required BleDeviceConnector connector,
    required BleDeviceInteractor serviceDiscoverer,
    required BleLogger bleLogger,
  })  : _scanner = scanner,
        _monitor = monitor,
        _connector = connector,
        _serviceDiscoverer = serviceDiscoverer,
        _bleLogger = bleLogger;

  final BleScanner _scanner;
  final BleStatusMonitor _monitor;
  final BleDeviceConnector _connector;
  final BleDeviceInteractor _serviceDiscoverer;
  final BleLogger _bleLogger;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleLogger),
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
            title: APPLICATION_TITLE,
            theme: ColorTheme.light,
            darkTheme: ColorTheme.dark,
            themeMode: uiModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: uiModel.locale,
            home: const HomeScreen(),
          );
        }),
      ),
    );
  }
}
