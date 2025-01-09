import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_device_interactor.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/ble/ble_settings.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/ui/home/connection_status_handler.dart';
import 'package:inowa/src/ui/settings/internal/settings_simple_integer_field.dart';
import 'package:inowa/src/ui/settings/internal/settings_single_section.dart';
import 'package:inowa/src/ui/settings/internal/wireing_enum.dart';
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
  TextEditingController? timeoutController;

  String error = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    deviceNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer6<
              LedSettings,
              BleLogger,
              ConnectionStateUpdate,
              BleSettings,
              BleScannerState,
              BlePeripheralConnector>(
          builder: (_, ledSettings, logger, connectionStateUpdate, bleSettings,
              scannerState, bleAutoConnector, __) {
        ConnectionStatusCallbackHandler callbackHandler =
            ConnectionStatusCallbackHandler(context);

        // Initialisieren Text Controller für den Geräte-Namen
        deviceNameController ??= TextEditingController()
          ..text = bleSettings.deviceName;
        timeoutController ??= TextEditingController()
          ..text = bleSettings.timeout.toString();

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
          var isFormValid = formKey.currentState?.validate() ?? false;
          if (!isFormValid) {
            setError(
                AppLocalizations.of(context)!.err_missing_or_incorrect_values);
            return;
          } else {
            clearError();
          }

          if (isScanning()) {
            // nichts tun
          } else if (isConnected()) {
            String? deviceId = bleAutoConnector.connectedDeviceId;
            if (deviceId != null) {
              bleAutoConnector.disconnect(deviceId);
            }
          } else {
            var timeout = int.parse(timeoutController!.text);
            String deviceName = deviceNameController!.text;
            bleAutoConnector.scanAndConnect(
                serviceName: deviceName,
                timeout: timeout,
                statusCallback: callbackHandler.statusCallback);
          }
        }

        return SingleSection(
          title: AppLocalizations.of(context)!.bluetooth,
          children: [
            ErrorBanner(
              errorMessage: error,
              onClearError: clearError,
            ),
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // Timeout
                  SettingsListTile(
                    title: AppLocalizations.of(context)!.scanner_timeout,
                    trailing: SimpleInteger(
                      controller: timeoutController!,
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            bleSettings.timeout = int.parse(value);
                          } else {
                            bleSettings.timeout = 0;
                          }
                        });
                      },
                      validator: (value) {
                        return validateIntRange(
                            context: context,
                            value: value,
                            minValue: 15,
                            maxValue: 120);
                      },
                    ),
                  ),
                  // Gerätename
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
                        validator: (value) {
                          return validateTextLength(
                              context: context, value: value);
                        }),
                  ),
                ],
              ),
            ),
            // Auto-connect
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
            // Connect/Disconnect
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

            SettingsListTile(
              title: AppLocalizations.of(context)!.wireing,
              trailing: WireingDropDownMenu(
                initialSelection: ledSettings.isHorizontalWireing
                    ? Wireing.horizontal
                    : Wireing.vertical,
                onSelected: (wireing) {
                  setState(() {
                    ledSettings.isHorizontalWireing = wireing!.isHorizontal;
                  });
                },
              ),
            ),
          ],
        );
      });

  void clearError() {
    setError('');
  }

  void setError(String errorText) {
    setState(() {
      error = errorText;
    });
  }
}
