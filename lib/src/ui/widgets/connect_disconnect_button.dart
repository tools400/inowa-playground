import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_scanner.dart';

/// Widget Connecting/Disconnecting the Bluetooth device.
class ConnectDisconnectButton extends StatefulWidget {
  const ConnectDisconnectButton({
    super.key,
    onPressed,
  }) : _onPressed = onPressed;

  final VoidCallback? _onPressed;

  @override
  State<ConnectDisconnectButton> createState() => _ConnectDisconnectButton();
}

class _ConnectDisconnectButton extends State<ConnectDisconnectButton> {
  TextEditingController? deviceNameController;
  TextEditingController? timeoutController;

  @override
  Widget build(BuildContext context) =>
      Consumer2<ConnectionStateUpdate, BleScannerState>(
          builder: (_, connectionStateUpdate, scannerState, __) {
        /// Liefert die Beschriftung für den 'Connect' Button.
        String titleConnectButton() {
          if (isScanning(scannerState)) {
            return AppLocalizations.of(context)!.scanning;
          } else if (isConnected(connectionStateUpdate)) {
            return AppLocalizations.of(context)!.bluetooth_disconnect;
          } else {
            return AppLocalizations.of(context)!.bluetooth_connect;
          }
        }

        return ElevatedButton(
          onPressed: widget._onPressed,
          child: Text(titleConnectButton()),
        );
      });

  bool isScanning(BleScannerState scannerState) {
    return scannerState.scanIsInProgress;
  }

  bool isConnected(ConnectionStateUpdate connectionStateUpdate) {
    return connectionStateUpdate.connectionState ==
        DeviceConnectionState.connected;
  }
}
