import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            text = AppLocalizations.of(context)!
                .txt_Bluetooth_not_supported_on_device;
            color = ColorTheme.errorColor;
          case BleStatus.unauthorized:
            text = AppLocalizations.of(context)!
                .txt_Bluetooth_permission_not_granted;
            color = ColorTheme.errorColor;
          case BleStatus.poweredOff:
            text = AppLocalizations.of(context)!
                .txt_Bluetooth_is_powered_off_Turn_it_on;
            color = Colors.amber;
          case BleStatus.locationServicesDisabled:
            text = AppLocalizations.of(context)!.txt_Enable_location_services;
            color = ColorTheme.errorColor;
          case BleStatus.ready:
            return SizedBox.shrink();
          default:
            text =
                '${AppLocalizations.of(context)!.txt_Waiting_for_Bluetooth_status_A} $bleStatus...';
            color = Colors.amber;
        }

        return DefaultTextStyle.merge(
          style: Theme.of(NavigationService.context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: color, fontWeight: FontWeight.bold),
          child: Text(text),
        );
      });
}
