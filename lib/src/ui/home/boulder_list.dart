import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/firebase/fb_service.dart';
import 'package:inowa/src/ui/device_detail/boulder_list_panel.dart.dart';
import 'package:inowa/src/ui/home/add_boulder_screen.dart';
import 'package:inowa/src/ui/home/boulder_list_drawer.dart';
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

  @override
  Widget build(BuildContext context) =>
      Consumer2<FirebaseService, ConnectionStateUpdate>(
          builder: (_, firebase, connectionStateUpdate, __) {
        /// Gibt an, ob auto-connect eingeschaltet ist.
        bool isConnected() {
          bool isConnected = connectionStateUpdate.connectionState ==
              DeviceConnectionState.connected;
          return isConnected;
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

  BottomNavigationBar bottomNavigationBar(bool isConnected) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: _isSelected ? Colors.orange : null,
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
          label: 'Sort',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.plus_one),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(isConnected
              ? Icons.lightbulb_rounded
              : Icons.lightbulb_outline_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}