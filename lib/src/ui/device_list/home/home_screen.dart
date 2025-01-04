import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ui/ble_status_screen.dart';
import 'package:inowa/src/ui/home_OBSOLETE/device_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
        builder: (_, status, __) {
          if (status == BleStatus.ready) {
            return const DeviceListScreen();
          } else {
            // TODO: Umbau als Popup und anzeigen beim Verbinden mit dem Arduino, bzw. in der App
            return BleStatusScreen(status: status ?? BleStatus.unknown);
          }
        },
      );
}
