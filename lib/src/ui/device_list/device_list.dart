import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/constants.dart';
import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ble/ble_scanner.dart';
import 'package:inowa/src/settings/ui_model.dart';
import 'package:inowa/src/ui/home/home_screen_drawer.dart';
import 'package:provider/provider.dart';

import '../../ble/ble_logger.dart';
import '../../widgets.dart';
import '../device_detail/device_detail_screen.dart';

// TODO: Umbauen zur Anzeige der Boulder
/// Diese Klasse startet und stopped den Scanvorgang und zeigt eine
/// Liste der gefundenen Geräte an.
class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer3<BleScanner, BleScannerState?, BleDeviceConnector>(
        builder: (_, bleScanner, bleScannerState, connector, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
          startScan: bleScanner.startScan,
          stopScan: bleScanner.stopScan,
          connect: connector.connect,
          deviceId: connector.connectedDeviceId,
          disconnect: connector.disconnect,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  // const _DeviceList({
  const _DeviceList({
    required this.scannerState,
    required this.startScan,
    required this.stopScan,
    required this.connect,
    required this.deviceId,
    required this.disconnect,
  });

  final BleScannerState scannerState;
  final void Function(String serviceName, List<Uuid>,
      Function(DiscoveredDevice device) connectCallback) startScan;
  final VoidCallback stopScan;
  final void Function(String deviceId) connect;
  final String Function() deviceId;
  final void Function(String deviceId) disconnect;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  late TextEditingController _nameController;
  late TextEditingController _uuidController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ANDROID_BLE_DEVICE_NAME)
      ..addListener(() => setState(() {}));
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
    _startScanning();
  }

  @override
  void dispose() {
    widget.stopScan();
    if (widget.deviceId().isNotEmpty) {
      widget.disconnect(widget.deviceId()); // deviceId
    }
    _nameController.dispose();
    _uuidController.dispose();
    super.dispose();
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }

  void _startScanning() {
    final name = _nameController.text;
    final uuid = _uuidController.text;
    widget.startScan(
        name,
        uuid.isEmpty ? [] : [Uuid.parse(_uuidController.text)],
        _connectCallback);
  }

  _connectCallback(DiscoveredDevice device) async {
    widget.connect(device.id);
    await openDeviceDetailsPage(device);
  }

  Future<void> openDeviceDetailsPage(DiscoveredDevice device) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => DeviceDetailScreen(device: device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<UIModel>(builder: (_, uiModel, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.hdg_Scan_for_Devices),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          drawer: HomePageDrawer(),
          onDrawerChanged: (isOpen) {
            // call setState() for refreshing the page,
            // if drawer has been closed
            setState(() {});
          },
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(flex: 2),
                    Text(AppLocalizations.of(context)!.service_name_colon),
                    TextField(
                      controller: _nameController,
                      enabled: !widget.scannerState.scanIsInProgress,
                      autocorrect: false,
                    ),
                    const VSpace(flex: 2),
                    Text(AppLocalizations.of(context)!
                        .service_UUID__2__4__16_bytes_colon),
                    TextField(
                      controller: _uuidController,
                      enabled: !widget.scannerState.scanIsInProgress,
                      decoration: InputDecoration(
                          errorText: _uuidController.text.isEmpty ||
                                  _isValidUuidInput()
                              ? null
                              : AppLocalizations.of(context)!
                                  .err_invalid_uuid_format),
                      autocorrect: false,
                    ),
                    const VSpace(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: !widget.scannerState.scanIsInProgress &&
                                  _isValidUuidInput()
                              ? _startScanning
                              : null,
                          child: Text(AppLocalizations.of(context)!.btn_Scan),
                        ),
                        ElevatedButton(
                          onPressed: widget.scannerState.scanIsInProgress
                              ? widget.stopScan
                              : null,
                          child: Text(AppLocalizations.of(context)!.btn_Stop),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const VSpace(flex: 2),
              Flexible(
                child: ListView(
                  children: [
                    Consumer<BleLogger>(
                      builder: (context, bleLogger, child) => SwitchListTile(
                        title:
                            Text(AppLocalizations.of(context)!.enable_logging),
                        value: bleLogger.verboseLogging,
                        onChanged: (_) =>
                            setState(bleLogger.toggleVerboseLogging),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        !widget.scannerState.scanIsInProgress
                            ? AppLocalizations.of(context)!
                                .txt_Enter_a_UUID_above_and_tap_start_to_begin_scanning
                            : AppLocalizations.of(context)!
                                .txt_Tap_a_device_to_connect_to_it,
                      ),
                      trailing: (widget.scannerState.scanIsInProgress ||
                              widget.scannerState.discoveredDevices.isNotEmpty)
                          ? Text(
                              'count: ${widget.scannerState.discoveredDevices.length}',
                            )
                          : null,
                    ),
                    ...widget.scannerState.discoveredDevices.map(
                      (device) => ListTile(
                        title: Text(
                          device.name.isNotEmpty
                              ? device.name
                              : AppLocalizations.of(context)!.unnamed,
                        ),
                        subtitle: Text(
                          """
${device.id}
AppLocalizations.of(context)!.rssi_colon ${device.rssi}
${device.connectable}
                            """,
                        ),
                        leading: const BluetoothIcon(),
                        onTap: () async {
                          if (widget.scannerState.scanIsInProgress) {
                            // Stop scanning for more devices
                            widget.stopScan();
                          }
                          await openDeviceDetailsPage(device);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
