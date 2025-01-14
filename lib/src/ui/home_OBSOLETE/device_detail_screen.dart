import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_device_connector.dart';
import 'package:inowa/src/ui/home_OBSOLETE/device_interaction_tab.dart';
import 'package:inowa/src/ui/logging/device_log_tab.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';

/// Diese Klasse zeigt die die Details eines gefundenen Geräts.
/// In der unteren Hälfte wird das Widget zur Interaktion mit
/// dem Gerät angezeigt.
class DeviceDetailScreen extends StatelessWidget {
  final DiscoveredDevice device;

  const DeviceDetailScreen({required this.device, super.key});

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceConnector>(
        builder: (_, deviceConnector, __) => _DeviceDetail(
          device: device,
          disconnect: deviceConnector.disconnect,
        ),
      );
}

class _DeviceDetail extends StatelessWidget {
  const _DeviceDetail({
    required this.device,
    required this.disconnect,
  });

  final DiscoveredDevice device;
  final void Function(String deviceId) disconnect;
  @override
  Widget build(BuildContext context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            disconnect(device.id);
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(device.name.isNotEmpty ? device.name : "Unnamed"),
              backgroundColor: ColorTheme.inversePrimary(context),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.bluetooth_connected,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.find_in_page_sharp,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                DeviceInteractionTab(
                  device: device,
                ),
                const DeviceLogTab(),
              ],
            ),
          ),
        ),
      );
}
