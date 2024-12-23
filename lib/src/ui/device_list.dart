import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_constants.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_device_connector.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_scanner.dart';
import 'package:provider/provider.dart';

import '../ble/ble_logger.dart';
import '../widgets.dart';
import 'device_detail/device_detail_screen.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer4<BleScanner, BleScannerState?, BleDeviceConnector, BleLogger>(
        builder: (_, bleScanner, bleScannerState, connector, bleLogger, __) =>
            _DeviceList(
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
          toggleVerboseLogging: bleLogger.toggleVerboseLogging,
          verboseLogging: bleLogger.verboseLogging,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  // const _DeviceList({
  _DeviceList({
    required this.scannerState,
    required this.startScan,
    required this.stopScan,
    required this.connect,
    required this.deviceId,
    required this.disconnect,
    required this.toggleVerboseLogging,
    required this.verboseLogging,
  });

  final BleScannerState scannerState;
  final void Function(String serviceName, List<Uuid>,
      Function(DiscoveredDevice device) connectCallback) startScan;
  final VoidCallback stopScan;
  final void Function(String deviceId) connect;
  final String Function() deviceId;
  final void Function(String deviceId) disconnect;
  final VoidCallback toggleVerboseLogging;
  final bool verboseLogging;

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

  bool _isValidNameInput() {
    final nameText = _nameController.text;
    if (nameText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(nameText);
        return true;
      } on Exception {
        return false;
      }
    }
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Scan for devices'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Service name:'),
                  TextField(
                    controller: _nameController,
                    enabled: !widget.scannerState.scanIsInProgress,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  const Text('Service UUID (2, 4, 16 bytes):'),
                  TextField(
                    controller: _uuidController,
                    enabled: !widget.scannerState.scanIsInProgress,
                    decoration: InputDecoration(
                        errorText:
                            _uuidController.text.isEmpty || _isValidUuidInput()
                                ? null
                                : 'Invalid UUID format'),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Text('Scan'),
                        onPressed: !widget.scannerState.scanIsInProgress &&
                                _isValidUuidInput()
                            ? _startScanning
                            : null,
                      ),
                      ElevatedButton(
                        child: const Text('Stop'),
                        onPressed: widget.scannerState.scanIsInProgress
                            ? widget.stopScan
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                children: [
                  SwitchListTile(
                    title: const Text("Verbose logging"),
                    value: widget.verboseLogging,
                    onChanged: (_) => setState(widget.toggleVerboseLogging),
                  ),
                  ListTile(
                    title: Text(
                      !widget.scannerState.scanIsInProgress
                          ? 'Enter a UUID above and tap start to begin scanning'
                          : 'Tap a device to connect to it',
                    ),
                    trailing: (widget.scannerState.scanIsInProgress ||
                            widget.scannerState.discoveredDevices.isNotEmpty)
                        ? Text(
                            'count: ${widget.scannerState.discoveredDevices.length}',
                          )
                        : null,
                  ),
                  ...widget.scannerState.discoveredDevices
                      .map(
                        (device) => ListTile(
                          title: Text(
                            device.name.isNotEmpty ? device.name : "Unnamed",
                          ),
                          subtitle: Text(
                            """
${device.id}
RSSI: ${device.rssi}
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
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      );
}
