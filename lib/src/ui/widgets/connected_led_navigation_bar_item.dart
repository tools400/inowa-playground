import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ui/settings/internal/color_theme.dart';

/// Icon of the 'Settings' BottomNavigationBarItem widget.
class SettingsIcon extends StatefulWidget {
  const SettingsIcon({
    super.key,
  });

  @override
  State<SettingsIcon> createState() => _SettingsIcon();
}

class _SettingsIcon extends State<SettingsIcon> {
  @override
  Widget build(BuildContext context) =>
      Consumer<ConnectionStateUpdate>(builder: (_, connectionStateUpdate, __) {
        return Icon(
          isConnected(connectionStateUpdate)
              ? Icons.lightbulb_rounded
              : Icons.lightbulb_outline_rounded,
          color: connectionStateUpdate.connectionState ==
                  DeviceConnectionState.connected
              ? ColorTheme.deviceConnectedIconColor
              : null,
        );
      });

  bool isConnected(ConnectionStateUpdate connectionStateUpdate) {
    return connectionStateUpdate.connectionState ==
        DeviceConnectionState.connected;
  }
}
