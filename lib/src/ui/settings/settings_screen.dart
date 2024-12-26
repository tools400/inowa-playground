import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ble/ble_logger.dart';
import 'package:inowa/src/settings/ui_model.dart';
import 'package:inowa/src/ui/settings/ui_theme_mode_enum.dart';
import 'package:inowa/src/widgets.dart';
import 'package:provider/provider.dart';

/// Diese Klasse pflegt die Einstellungen der App.
/// Basiert auf: [Simple Settings Page](https://www.fluttertemplates.dev/widgets/must_haves/settings_page#settings_page_2).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer<BleLogger>(builder: (_, bleLogger, __) => _SettingsScreen());
}

class _SettingsScreen extends StatefulWidget {
  _SettingsScreen();

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  @override
  Widget build(BuildContext context) =>
      Consumer<UIModel>(builder: (_, uiModel, __) {
        /// Erzeugt die Menüeinträge für das Drop-Down Menü für die Auswahl der Sprache.
        DropdownMenuEntry<Locale> _localeToMenuItem(Locale item) {
          return DropdownMenuEntry(
            label: item.languageCode,
            value: item,
          );
        }

        /// Erzeugt die Menüeinträge für das Drop-Down Menü für die Auswahl des UI-Designs.
        DropdownMenuEntry<UIThemeMode> _modeToMenuItem(
            UIThemeMode uiThemeMode) {
          return DropdownMenuEntry(
            label: uiModel.getUIModeLabel(context, uiThemeMode),
            value: uiThemeMode,
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.mnu_Settings),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ListView(
                children: [
                  _SingleSection(
                    title: AppLocalizations.of(context)!.general,
                    children: [
                      _CustomListTile(
                        title: AppLocalizations.of(context)!.ui_theme_mode,
                        icon: uiModel.getUIModeIconData(
                            context, uiModel.uiThemeMode),
                        trailing: DropdownMenu<UIThemeMode>(
                            initialSelection: uiModel.uiThemeMode,
                            onSelected: (UIThemeMode? UIThemeMode) {
                              setState(() {
                                uiModel.setUIThemeMode(UIThemeMode);
                              });
                            },
                            dropdownMenuEntries: uiModel
                                .uiThemeModes()
                                .map((item) => _modeToMenuItem(item))
                                .toList()),
                      ),
                      VSpace(),
                      _CustomListTile(
                        title: AppLocalizations.of(context)!.language,
                        icon: Icons.language,
                        trailing: DropdownMenu<Locale>(
                            initialSelection: uiModel.locale,
                            onSelected: (Locale? locale) {
                              setState(() {
                                uiModel.setLocale(locale);
                              });
                            },
                            dropdownMenuEntries: uiModel
                                .supportedLocales()
                                .map((item) => _localeToMenuItem(item))
                                .toList()),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
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
      {Key? key, required this.title, required this.icon, this.trailing})
      : super(key: key);

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
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

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
