import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../internal/settings_list_tile.dart';
import '../internal/settings_simple_text_field.dart';
import '../internal/settings_single_section.dart';

import '/src/ble/ble_device_connector.dart';
import '/src/ble/ble_logger.dart';
import '/src/constants.dart';

class BluetoothSection extends StatefulWidget {
  const BluetoothSection({
    super.key,
  });

  @override
  State<BluetoothSection> createState() => _BluetoothSectionState();
}

class _BluetoothSectionState extends State<BluetoothSection> {
  bool _isAutoConnect = false;
  TextEditingController deviceNameController =
      TextEditingController(text: ANDROID_BLE_DEVICE_NAME);

  @override
  void dispose() {
    deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<BleLogger, ConnectionStateUpdate, BleDeviceConnector>(
        builder: (_, logger, connectionStateUpdate, deviceConnector, __) {
      bool isConnected() {
        return connectionStateUpdate.connectionState ==
            DeviceConnectionState.connected;
      }

      /// Liefert die Beschriftung für den 'Connect' Button.
      String titleConnectButton() {
        if (isConnected()) {
          return AppLocalizations.of(context)!.bluetooth_disconnect;
        } else {
          return AppLocalizations.of(context)!.bluetooth_connect;
        }
      }

      connectedCallback(String deviceId) {
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.txt_connection_established);
      }

      disconnectedCallback(String deviceId) {
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.txt_connection_disconnected);
      }

      deviceFoundCallback(DiscoveredDevice device) {
        deviceConnector.connect(device.id, connectedCallback);
      }

      /// Schaltet die Bluetoothverbindung hin und hher.
      void toggleConnection() {
        if (isConnected()) {
          String deviceId = deviceConnector.connectedDeviceId();
          deviceConnector.disconnect(deviceId, disconnectedCallback);
        } else {
          deviceConnector.autoConnect(
              deviceNameController.text, deviceFoundCallback);
        }
      }

      return SingleSection(
        title: AppLocalizations.of(context)!.bluetooth,
        children: [
          SettingsListTile(
            title: AppLocalizations.of(context)!.bluetooth_device_name,
            trailing: SimpleText(
              controller: deviceNameController,
              hintText: AppLocalizations.of(context)!.generic_value,
            ),
          ),
          SettingsListTile(
            title: AppLocalizations.of(context)!.bluetooth_auto_connect,
            trailing: Switch(
              value: _isAutoConnect,
              onChanged: (enabled) {
                setState(() {
                  _isAutoConnect = enabled;
                });
              },
            ),
          ),
          SettingsListTile(
            title: AppLocalizations.of(context)!.bluetooth_connection,
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  toggleConnection();
                });
              },
              child: Text(titleConnectButton()),
            ),
          ),
        ],
      );
    });
  }
}
