import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/ui/home/tabs/boulder_moves_tab.dart';
import 'package:inowa/src/ui/home/tabs/boulder_properties_tab.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';

import '/src/firebase/fb_service.dart';

class DisplayBoulderScreen extends StatefulWidget {
  const DisplayBoulderScreen({super.key, required boulder})
      : _boulderItem = boulder;

  final FbBoulder _boulderItem;

  @override
  State<DisplayBoulderScreen> createState() => _DisplayBoulderScreenState();
}

class _DisplayBoulderScreenState extends State<DisplayBoulderScreen>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  late TabController _tabBarController;

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);
    _tabBarController.addListener(() {
      if (_tabBarController.indexIsChanging) {
        setState(() {
          if (_tabBarController.previousIndex != 0 &&
              _tabBarController.index == 0) {
            print('Saving boulder');
          }
        });
        print("Selected Index: " + _tabBarController.index.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      Consumer3<FirebaseService, BlePeripheralConnector, LedSettings>(
          builder: (_, firebase, bleConnector, ledSettings, __) {
        var isHorizontalWireing = ledSettings.isHorizontalWireing;
        var ledConnector = LEDStripeConnector(bleConnector, ledSettings);

        // Send boulder to Bluetooth device
        ledConnector.sendBoulderToDevice(
            widget._boulderItem.moves(isHorizontalWireing).all);

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.mnu_Display_Problem),
              backgroundColor: ColorTheme.inversePrimary(context),
              bottom: TabBar(
                controller: _tabBarController,
                onTap: (value) {
                  return;
                },
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.properties),
                  Tab(text: AppLocalizations.of(context)!.moves),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabBarController,
                      children: [
                        BoulderPropertiesTab(boulder: widget._boulderItem),
                        BoulderMovesTab(
                          boulder: widget._boulderItem,
                          bleConnector: bleConnector,
                          ledSettings: ledSettings,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
