import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:inowa/main.dart';
import 'package:inowa/src/permissions/permissions.dart';
import 'package:inowa/src/ui/home/internal/boulder_list_drawer.dart';
import 'package:inowa/src/ui/home/panels/add_boulder_panel.dart';
import 'package:inowa/src/ui/home/panels/boulder_list_panel.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/ui/settings/sections/settings_bluetooth_section.dart';
import 'package:inowa/src/ui/widgets/connected_led_navigation_bar_item.dart';

enum PageMode { boulderList, sort, addBoulder, settings }

class BoulderListScreen extends StatefulWidget {
  const BoulderListScreen({super.key});

  @override
  State<BoulderListScreen> createState() => _BoulderListScreenState();
}

class _BoulderListScreenState extends State<BoulderListScreen> {
  bool _isSelected = false;
  int _currentIndex = 0;
  PageMode _pageMode = PageMode.boulderList;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bleSettings.isAutoConnect) {
        bleLogger.info('Attempting to connect to Arduino on startup...');
        Permissions.callWithPermissions(connectArduino, askUser: true);
      }
    });
  }

  void connectArduino() {
    if (bleSettings.deviceName.isNotEmpty) {
      peripheralConnector.connectArduino(bleSettings.deviceName);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget panel;
    switch (_pageMode) {
      case PageMode.sort:
        panel = BoulderListPanel();
      case PageMode.addBoulder:
        panel = AddBoulderPanel();
      case PageMode.settings:
        panel = SingleChildScrollView(
          child: BluetoothSection(),
        );
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
          // if the drawer has been closed
          setState(() {});
        },
        bottomNavigationBar: bottomNavigationBar(),
        body: panel);
  }

  /// Navigation bar at the bottom of the screen.
  BottomNavigationBar bottomNavigationBar() {
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
          icon: const SettingsIcon(),
          label: AppLocalizations.of(context)!.mnu_BottomNavigator_Settings,
        ),
      ],
    );
  }
}
