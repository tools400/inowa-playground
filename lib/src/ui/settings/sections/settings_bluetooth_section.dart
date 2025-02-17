import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/main.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/permissions/permissions.dart';
import 'package:inowa/src/ui/settings/internal/settings_simple_editable_text_field.dart';
import 'package:inowa/src/ui/settings/internal/settings_simple_integer_field.dart';
import 'package:inowa/src/ui/settings/internal/settings_single_section.dart';
import 'package:inowa/src/ui/widgets/connect_disconnect_button.dart';
import 'package:inowa/src/ui/widgets/error_banner.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';
import 'package:inowa/src/ui/widgets/wireing_drop_down_menu.dart';

import 'package:inowa/src/ui/settings//internal/settings_list_tile.dart';

class BluetoothSection extends StatefulWidget {
  const BluetoothSection({
    super.key,
  });

  @override
  State<BluetoothSection> createState() => _BluetoothSectionState();
}

class _BluetoothSectionState extends State<BluetoothSection> {
  TextEditingController? _deviceNameController;
  TextEditingController? _timeoutController;

  String _error = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _deviceNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer2<ConnectionStateUpdate, BleScannerState>(
          builder: (_, connectionStateUpdate, scannerState, __) {
        // Initialisieren Text Controller für den Geräte-Namen
        _deviceNameController ??= TextEditingController()
          ..text = bleSettings.deviceName;
        _timeoutController ??= TextEditingController()
          ..text = bleSettings.timeout.toString();

        /// Schaltet die Bluetoothverbindung hin und her.
        toggleConnection() {
          var isFormValid = _formKey.currentState?.validate() ?? false;
          if (!isFormValid) {
            setError(
                AppLocalizations.of(context)!.err_missing_or_incorrect_values);
            return;
          } else {
            clearError();
          }

          if (isScanning(scannerState)) {
            peripheralConnector.stopScan();
          } else if (isConnected(connectionStateUpdate)) {
            String? deviceId = peripheralConnector.connectedDeviceId;
            if (deviceId != null) {
              peripheralConnector.disconnectArduino(deviceId);
            }
          } else {
            Permissions.callWithPermissions(connectArduino, askUser: true);
          }
        }

        return SingleSection(
          title: AppLocalizations.of(context)!.bluetooth,
          children: [
            ErrorBanner(
              errorMessage: _error,
              onClearError: clearError,
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // Timeout
                  SettingsListTile(
                    title: AppLocalizations.of(context)!.scanner_timeout,
                    trailing: SimpleInteger(
                      controller: _timeoutController!,
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
                    trailing: SimpleEditableText(
                        controller: _deviceNameController!,
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
                  if (enabled) {
                    connectArduino();
                  }
                },
              ),
            ),
            // Connect/Disconnect
            SettingsListTile(
              title: AppLocalizations.of(context)!.bluetooth_connection,
              trailing: SizedBox(
                width: 150,
                child: ConnectDisconnectButton(
                  onPressed: () {
                    setState(() {
                      toggleConnection();
                    });
                  },
                ),
              ),
            ),
            // Wireing: horizontal/vertical
            SettingsListTile(
              title: AppLocalizations.of(context)!.wireing,
              trailing: WireingDropDownMenu(),
            ),
          ],
        );
      });

  void connectArduino() {
    if (bleSettings.deviceName.isNotEmpty) {
      peripheralConnector.connectArduino(bleSettings.deviceName);
    }
  }

  bool isScanning(BleScannerState scannerState) =>
      scannerState.scanIsInProgress;

  bool isConnected(ConnectionStateUpdate connectionStateUpdate) {
    return connectionStateUpdate.connectionState ==
        DeviceConnectionState.connected;
  }

  void clearError() {
    setError('');
  }

  void setError(String errorText) {
    setState(() {
      _error = errorText;
    });
  }
}
