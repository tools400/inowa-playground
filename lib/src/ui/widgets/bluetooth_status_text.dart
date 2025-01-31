import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ui/logging/console_log.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/utils/utils.dart';

class BluetoothStatusText extends StatefulWidget {
  const BluetoothStatusText({
    super.key,
  });

  @override
  State<BluetoothStatusText> createState() => _BluetoothStatusText();
}

class _BluetoothStatusText extends State<BluetoothStatusText> {
  @override
  Widget build(BuildContext context) =>
      Consumer<BleStatus>(builder: (_, bleStatus, __) {
        ConsoleLog.log('BLE status: $bleStatus');

        late String text;
        late Color color;

        switch (bleStatus) {
          case BleStatus.unsupported:
            text = "Bluetooth not supported on device.";
            color = ColorTheme.errorColor;
          case BleStatus.unauthorized:
            text = "Bluetooth permission not granted.";
            color = ColorTheme.errorColor;
          case BleStatus.poweredOff:
            text = "Bluetooth is powered off. Turn it on.";
            color = ColorTheme.errorColor;
          case BleStatus.locationServicesDisabled:
            text = "Enable location services.";
            color = ColorTheme.errorColor;
          case BleStatus.ready:
            return SizedBox.shrink();
          default:
            text = "Waiting for Bluetooth status $bleStatus ...";
            color = Colors.amber;
        }

        return DefaultTextStyle.merge(
          style: Theme.of(NavigationService.context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: color, fontWeight: FontWeight.bold),
          child: Text(text),
        );
      });
}
