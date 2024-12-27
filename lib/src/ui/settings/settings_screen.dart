import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/settings/ui_settings.dart';
import 'package:inowa/src/ui/settings/dark_mode_enum.dart';
import 'package:inowa/src/widgets.dart';

/// Diese Klasse pflegt die Einstellungen der App.
/// Basiert auf: [Simple Settings Page](https://www.fluttertemplates.dev/widgets/must_haves/settings_page#settings_page_2).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer<BleLogger>(builder: (_, bleLogger, __) => _SettingsScreen());
}

class _SettingsScreen extends StatefulWidget {
  const _SettingsScreen();

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  @override
  Widget build(BuildContext context) =>
      Consumer<UIModel>(builder: (_, uiModel, __) {
        /// Erzeugt die Menüeinträge für das Drop-Down Menü für die Auswahl der Sprache.
        DropdownMenuEntry<Locale> localeToMenuItem(Locale item) {
          return DropdownMenuEntry(
            label: item.languageCode,
            value: item,
          );
        }

        /// Erzeugt die Menüeinträge für das Drop-Down Menü für die Auswahl des UI-Designs.
        DropdownMenuEntry<DarkMode> modeToMenuItem(DarkMode uiThemeMode) {
          return DropdownMenuEntry(
            label: uiModel.getDarkModeLabel(context, uiThemeMode),
            value: uiThemeMode,
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.mnu_Settings),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: AppLocalizations.of(context)!.general,
                  children: [
                    _CustomListTile(
                      title: AppLocalizations.of(context)!.ui_theme_mode,
                      icon: uiModel.getDarkModeIconData(
                          context, uiModel.darkMode),
                      trailing: DropdownMenu<DarkMode>(
                          width: 200,
                          initialSelection: uiModel.darkMode,
                          onSelected: (DarkMode? UIThemeMode) {
                            setState(() {
                              uiModel.setDarkMode(UIThemeMode);
                            });
                          },
                          dropdownMenuEntries: uiModel.darkModes
                              .map((item) => modeToMenuItem(item))
                              .toList()),
                    ),
                    VSpace(),
                    _CustomListTile(
                      title: AppLocalizations.of(context)!.language,
                      icon: Icons.language,
                      trailing: DropdownMenu<Locale>(
                          width: 200,
                          initialSelection: uiModel.locale,
                          onSelected: (Locale? locale) {
                            setState(() {
                              uiModel.setLocale(locale);
                            });
                          },
                          dropdownMenuEntries: uiModel.supportedLocales
                              .map((item) => localeToMenuItem(item))
                              .toList()),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      });
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile(
      {super.key, required this.title, required this.icon, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {},
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
