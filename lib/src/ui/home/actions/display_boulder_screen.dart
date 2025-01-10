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

class _DisplayBoulderScreenState extends State<DisplayBoulderScreen> {
  @override
  Widget build(BuildContext context) =>
      Consumer3<FirebaseService, BlePeripheralConnector, LedSettings>(
          builder: (_, firebase, bleConnector, ledSettings, __) {
        var ledConnector = LEDStripeConnector(bleConnector, ledSettings);

        // Send boulder to Bluetooth device
        ledConnector.sendBoulderToDevice('N5+M6/M9/J9/J10/G10/E8/B9/B11');

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.mnu_Display_Problem),
              backgroundColor: ColorTheme.inversePrimary(context),
              bottom: TabBar(
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
