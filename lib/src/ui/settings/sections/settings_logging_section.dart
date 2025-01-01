import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/logging/log_level_enum.dart';
import 'package:inowa/src/ui/settings/internal/settings_drop_down_menu.dart';

import '../internal/settings_list_tile.dart';
import '../internal/settings_single_section.dart';

import '/src/settings/ui_settings.dart';
import '/src/ui/settings/internal/dark_mode_enum.dart';
import '/src/ui/widgets/widgets.dart';

class LoggingSection extends StatefulWidget {
  const LoggingSection({
    super.key,
  });

  @override
  State<LoggingSection> createState() => _LoggingSectionState();
}

class _LoggingSectionState extends State<LoggingSection> {
  @override
  Widget build(BuildContext context) {
    /// Erzeugt die Menüeinträge für das Drop-Down Menü für die Auswahl der Sprache.
    DropdownMenuEntry<LogLevel> logLevelToMenuItem(LogLevel item) {
      return DropdownMenuEntry(
        label: item.label,
        value: item,
      );
    }

    return Consumer<BleLogger>(builder: (_, logger, __) {
      return SingleSection(
        title: AppLocalizations.of(context)!.logging,
        children: [
          SettingsListTile(
            title: AppLocalizations.of(context)!.logging_active,
            trailing: Switch(
              value: logger.loggingEnabled,
              onChanged: (enabled) {
                setState(() {
                  logger.loggingEnabled = enabled;
                });
              },
            ),
          ),
          VSpace(),
          SettingsListTile(
            title: AppLocalizations.of(context)!.logging_log_level,
            trailing: SettingsDropDownMenu<LogLevel>(
              initialSelection: logger.logLevel,
              onSelected: (LogLevel? logLevel) {
                setState(() {
                  logger.logLevel = logLevel;
                });
              },
              dropdownMenuEntries: LogLevel.values
                  .map((item) => logLevelToMenuItem(item))
                  .toList(),
            ),
          ),
        ],
      );
    });
  }
}
