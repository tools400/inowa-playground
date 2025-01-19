import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:inowa/src/ui/settings/internal/settings_constrained_box.dart';
import 'package:inowa/src/ui/settings/sections/settings_bluetooth_section.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

import 'internal/color_theme.dart';
import 'sections/settings_common_section.dart';
import 'sections/settings_logging_section.dart';

/// Diese Klasse pflegt die Einstellungen der App.
/// Basiert auf: [Simple Settings Page](https://www.fluttertemplates.dev/widgets/must_haves/settings_page#settings_page_2).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => _SettingsScreen();
}

class _SettingsScreen extends StatefulWidget {
  const _SettingsScreen();

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.mnu_Settings),
          backgroundColor: ColorTheme.inversePrimary(context),
        ),
        body: Padding(
          padding: appBorder,
          child: SimpleConstrainedBox(
            child: ListView(
              children: [
                CommonSection(),
                const Divider(),
                const BluetoothSection(),
                const Divider(),
                const LoggingSection(),
                const Divider(),
              ],
            ),
          ),
        ),
      );
}
