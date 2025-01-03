import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_auto_connect.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/ble/ble_settings.dart';
import 'package:inowa/src/ui/settings/internal/settings_single_section.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

import 'package:inowa/src/ui/settings//internal/settings_list_tile.dart';
import 'package:inowa/src/ui/settings//internal/settings_simple_text_field.dart';

class BluetoothSection extends StatefulWidget {
  const BluetoothSection({
    super.key,
  });

  @override
  State<BluetoothSection> createState() => _BluetoothSectionState();
}

class _BluetoothSectionState extends State<BluetoothSection> {
  TextEditingController? deviceNameController;

  BleAutoConnector? bleAutoConnector;

  @override
  void dispose() {
    deviceNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer6<BleLogger, ConnectionStateUpdate, BleDeviceConnector,
            BleSettings, BleScanner, BleScannerState>(
        builder: (_, logger, connectionStateUpdate, deviceConnector,
            bleSettings, bleScanner, scannerState, __) {
      // Initialisieren Text Controller für den Geräte-Namen
      deviceNameController ??= TextEditingController()
        ..text = bleSettings.deviceName;

      /// Manager für die automatische Herstellung einer Bluetooth Verbindung.
      bleAutoConnector ??=
          BleAutoConnector(context, bleScanner, deviceConnector);

      /// Gibt an, ob der Scanner läuft.
      bool isScanning() {
        bool isScanning = scannerState.scanIsInProgress;
        return isScanning;
      }

      /// Gibt an, ob auto-connect eingeschaltet ist.
      bool isConnected() {
        bool isConnected = connectionStateUpdate.connectionState ==
            DeviceConnectionState.connected;
        return isConnected;
      }

      /// Liefert die Beschriftung für den 'Connect' Button.
      String titleConnectButton() {
        if (isScanning()) {
          return AppLocalizations.of(context)!.scanning;
        } else if (isConnected()) {
          return AppLocalizations.of(context)!.bluetooth_disconnect;
        } else {
          return AppLocalizations.of(context)!.bluetooth_connect;
        }
      }

      /// Schaltet die Bluetoothverbindung hin und her.
      toggleConnection() {
        if (isScanning()) {
          // nichts tun
        } else if (isConnected()) {
          String? deviceId = deviceConnector.connectedDeviceId;
          if (deviceId != null) {
            bleAutoConnector!.disconnect(deviceId);
          }
        } else {
          String? deviceName = deviceNameController!.text;
          bleAutoConnector!.scanAndConnect(deviceName);
        }
      }

      return SingleSection(
        title: AppLocalizations.of(context)!.bluetooth,
        children: [
          SettingsListTile(
            title: AppLocalizations.of(context)!.bluetooth_device_name,
            trailing: SimpleText(
              controller: deviceNameController!,
              hintText: AppLocalizations.of(context)!.generic_value,
              onChanged: (value) {
                setState(() {
                  bleSettings.deviceName = value;
                });
              },
            ),
          ),
          SettingsListTile(
            title: AppLocalizations.of(context)!.bluetooth_auto_connect,
            trailing: Switch(
              value: bleSettings.isAutoConnect,
              onChanged: (enabled) {
                setState(() {
                  bleSettings.autoConnectEnabled = enabled;
                });
              },
            ),
          ),
          SettingsListTile(
            title: AppLocalizations.of(context)!.bluetooth_connection,
            trailing: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: isScanning()
                    ? null
                    : () {
                        setState(() {
                          toggleConnection();
                        });
                      },
                child: Text(titleConnectButton()),
              ),
            ),
          ),
        ],
      );
    });
  }
}
