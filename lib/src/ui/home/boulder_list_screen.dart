import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_auto_connector.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/ble/ble_settings.dart';
import 'package:inowa/src/firebase/fb_service.dart';
import 'package:inowa/src/ui/home/actions/add_boulder_screen.dart';
import 'package:inowa/src/ui/home/boulder_list_drawer.dart';
import 'package:inowa/src/ui/home/boulder_list_panel.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/ui/settings/sections/settings_bluetooth_section.dart';

enum PageMode { boulderList, sort, addBoulder, settings }

class BoulderListScreen extends StatefulWidget {
  const BoulderListScreen({super.key});

  @override
  State<BoulderListScreen> createState() => _BoulderListScreenState();
}

class _BoulderListScreenState extends State<BoulderListScreen> {
  final ScrollController scrollController = ScrollController();

  bool _isSelected = false;
  int _currentIndex = 0;
  PageMode _pageMode = PageMode.boulderList;

  BleAutoConnector? bleAutoConnector;

  @override
  Widget build(BuildContext context) => Consumer5<
              FirebaseService,
              ConnectionStateUpdate,
              BleSettings,
              BleScanner,
              BleDeviceConnector>(
          builder: (_, firebase, connectionStateUpdate, bleSettings, bleScanner,
              bleDeviceConnector, __) {
        /// Gibt an, ob auto-connect eingeschaltet ist.
        bool isConnected() {
          bool isConnected = connectionStateUpdate.connectionState ==
              DeviceConnectionState.connected;
          return isConnected;
        }

        /// Stellt die Verbindung her, insofern auto-connect aktiviert ist.
        /// Nur einmal, beim ersten Anzeigend des Bildschirms.
        if (bleAutoConnector == null &&
            !isConnected() &&
            bleSettings.isAutoConnect) {
          bleAutoConnector =
              BleAutoConnector(context, bleScanner, bleDeviceConnector);
          var timeout = bleSettings.timeout;
          String deviceName = bleSettings.deviceName;
          bleAutoConnector!
              .scanAndConnect(serviceName: deviceName, timeout: timeout);
        }

        Widget panel;
        switch (_pageMode) {
          case PageMode.sort:
            panel = BoulderListPanel();
          case PageMode.addBoulder:
            panel = AddBoulderScreen();
          case PageMode.settings:
            panel = BluetoothSection();
          default:
            panel = BoulderListPanel();
        }

        return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.mnu_Problems),
              backgroundColor: ColorTheme.inversePrimary(context),
            ),
            drawer: HomePageDrawer(),
            onDrawerChanged: (isOpen) {
              // call setState() for refreshing the page,
              // if drawer has been closed
              setState(() {});
            },
            bottomNavigationBar: bottomNavigationBar(isConnected()),
            body: panel);
      });

  /// Navigationsmenü am unteren Bildschirmrand.
  BottomNavigationBar bottomNavigationBar(bool isConnected) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: _isSelected ? ColorTheme.navigatorSelectedColor : null,
      onTap: (int index) {
        setState(() {
          if (_isSelected && index == _currentIndex) {
            _isSelected = false;
            _pageMode = PageMode.boulderList;
            return;
          }
          _currentIndex = index;

          switch (_currentIndex) {
            case 0:
              _pageMode = PageMode.sort;
              _isSelected = true;
            case 1:
              _pageMode = PageMode.addBoulder;
              _isSelected = true;
            case 2:
              _pageMode = PageMode.settings;
              _isSelected = true;
            default:
              throw UnsupportedError(
                'Unsupported navigation item.',
              );
          }
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.sort),
          label: AppLocalizations.of(context)!.mnu_BottomNavigator_Sort,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.plus_one),
          label: AppLocalizations.of(context)!.mnu_BottomNavigator_Add,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            isConnected
                ? Icons.lightbulb_rounded
                : Icons.lightbulb_outline_rounded,
            color: isConnected ? ColorTheme.deviceConnectedIconColor : null,
          ),
          label: AppLocalizations.of(context)!.mnu_BottomNavigator_Settings,
        ),
      ],
    );
  }
}
