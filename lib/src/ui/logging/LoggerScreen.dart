import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ui/device_detail/device_log_tab.dart';
import 'package:inowa/src/ui/settings/color_theme.dart';
import 'package:provider/provider.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/settings/ui_settings.dart';

/// Diese Klasse zeigt das App Protokoll an.
class LoggerScreen extends StatefulWidget {
  const LoggerScreen({super.key});

  @override
  State<LoggerScreen> createState() => _LoggerScreenState();
}

class _LoggerScreenState extends State<LoggerScreen> {
  @override
  Widget build(BuildContext context) => Consumer2<UIModel, BleLogger>(
        builder: (_, uiModel, bleLogger, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.mnu_Logging),
              backgroundColor: ColorTheme.inversePrimary(context),
            ),
            body: DeviceLogTab(),
          );
        },
      );
}
