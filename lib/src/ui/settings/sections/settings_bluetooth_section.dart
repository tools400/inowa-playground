import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_settings.dart';

import '../../../ble/ble_scanner.dart';
import '../../widgets/widgets.dart';
import '../internal/settings_list_tile.dart';
import '../internal/settings_simple_text_field.dart';
import '../internal/settings_single_section.dart';

import '/src/ble/ble_device_connector.dart';
import '/src/ble/ble_logger.dart';

class BluetoothSection extends StatefulWidget {
  const BluetoothSection({
    super.key,
  });

  @override
  State<BluetoothSection> createState() => _BluetoothSectionState();
}

class _BluetoothSectionState extends State<BluetoothSection> {
  TextEditingController? deviceNameController;

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
          return AppLocalizations.of(context)!.btn_Stop;
        } else if (isConnected()) {
          return AppLocalizations.of(context)!.bluetooth_disconnect;
        } else {
          return AppLocalizations.of(context)!.bluetooth_connect;
        }
      }

      /// Callback, wird nach erfolgreicher Verbindung zum
      /// Bluetooth Gerät aufgerufen.
      connectedCallback(String deviceId) {
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.txt_connection_established);
      }

      /// Callback, wird nach erfolgreicher Trennung der
      /// Verbindung zum Bluetooth Gerät aufgerufen.
      disconnectedCallback(String deviceId) {
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context)!.txt_connection_disconnected);
      }

      /// Callback, wird aufgerufen, sobald das gesuchte
      /// Bluetooth Gerät gefunden worden ist.
      deviceFoundCallback(DiscoveredDevice device) {
        bleScanner.stopScan();
        deviceConnector.connect(device.id, connectedCallback);
      }

      /// Schaltet die Bluetoothverbindung hin und her.
      void toggleConnection() {
        if (isScanning()) {
          bleScanner.stopScan();
        } else if (isConnected()) {
          String? deviceId = deviceConnector.connectedDeviceId;
          if (deviceId != null) {
            deviceConnector.disconnect(deviceId, disconnectedCallback);
          }
        } else {
          String? deviceName = deviceNameController!.text;
          deviceConnector.autoConnect(deviceName, deviceFoundCallback);
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
                onPressed: () {
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
