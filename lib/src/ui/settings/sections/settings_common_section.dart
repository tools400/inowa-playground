import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ui/settings/internal/settings_drop_down_menu.dart';

import '../internal/settings_list_tile.dart';
import '../internal/settings_single_section.dart';

import '/src/settings/ui_settings.dart';
import '/src/ui/settings/internal/dark_mode_enum.dart';
import '/src/ui/widgets/widgets.dart';

class CommonSection extends StatefulWidget {
  const CommonSection({
    super.key,
  });

  @override
  State<CommonSection> createState() => _CommonSectionState();
}

class _CommonSectionState extends State<CommonSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UIModel>(builder: (_, uiModel, __) {
      /// Erzeugt die Menüeinträge für das Drop-Down Menü für die Auswahl des UI-Designs.
      DropdownMenuEntry<DarkMode> modeToMenuItem(DarkMode uiThemeMode) {
        return DropdownMenuEntry(
          label: uiModel.getDarkModeLabel(context, uiThemeMode),
          value: uiThemeMode,
        );
      }

      /// Erzeugt die Menüeinträge für das Drop-Down Menü für die Auswahl der Sprache.
      DropdownMenuEntry<Locale> localeToMenuItem(Locale item) {
        return DropdownMenuEntry(
          label: item.languageCode,
          value: item,
        );
      }

      return SingleSection(
        title: AppLocalizations.of(context)!.general,
        children: [
          SettingsListTile(
            title: AppLocalizations.of(context)!.ui_theme_mode,
            icon: uiModel.getDarkModeIconData(context, uiModel.darkMode),
            trailing: SettingsDropDownMenu<DarkMode>(
              initialSelection: uiModel.darkMode,
              onSelected: (DarkMode? UIThemeMode) {
                setState(() {
                  uiModel.setDarkMode(UIThemeMode);
                });
              },
              dropdownMenuEntries: uiModel.darkModes
                  .map((item) => modeToMenuItem(item))
                  .toList(),
            ),
          ),
          VSpace(),
          SettingsListTile(
            title: AppLocalizations.of(context)!.language,
            icon: Icons.language,
            trailing: SettingsDropDownMenu<Locale>(
              initialSelection: uiModel.locale,
              onSelected: (Locale? locale) {
                setState(() {
                  uiModel.setLocale(locale);
                });
              },
              dropdownMenuEntries: uiModel.supportedLocales
                  .map((item) => localeToMenuItem(item))
                  .toList(),
            ),
          ),
        ],
      );
    });
  }
}
