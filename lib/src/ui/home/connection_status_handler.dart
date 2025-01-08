import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

class ConnectionStatusCallbackHandler {
  const ConnectionStatusCallbackHandler(
    this.context,
  );

  final BuildContext context;

  statusCallback(status, value) async {
    switch (status) {
      case Status.connected:
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.txt_connection_established);
        break;
      case Status.disconnected:
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.txt_connection_disconnected);
        break;
      case Status.deviceNotFound:
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.err_device_not_found);
        break;
      case Status.serviceNotFound:
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.err_service_not_found);
        break;
      case Status.characteristicNotFound:
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.err_characteristic_not_found);
        break;
    }
  }
}