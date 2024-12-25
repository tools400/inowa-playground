import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_device_interactor.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/ble/ble_status_monitor.dart';
import 'package:inowa/src/constants.dart';
import 'package:inowa/src/settings/locale_model.dart';
import 'package:inowa/src/ui/ble_status_screen.dart';
import 'package:inowa/src/ui/homepage/home_page.dart';
import 'package:provider/provider.dart';

import 'src/ble/ble_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final _localeModel = LocaleModel();
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
  runApp(MultiProvider(
    providers: [
      Provider.value(value: _localeModel),
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
    child: Consumer<LocaleModel>(builder: (context, localeModel, child) {
      return MaterialApp(
        title: APPLICATION_TITLE,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        darkTheme:
            localeModel.isDarkMode ? ThemeData.dark() : ThemeData.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: localeModel.locale,
        home: const HomeScreen(),
      );
    }),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<BleStatus?, LocaleModel>(
        builder: (_, status, localeModel, __) {
          if (status == BleStatus.ready) {
            return const DeviceListScreen();
          } else {
            // TODO: Umbau als Popup und anzeigen beim Verbinden mit dem Arduino, bzw. in der App
            return BleStatusScreen(status: status ?? BleStatus.unknown);
          }
        },
      );
}
