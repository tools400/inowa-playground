import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/settings/ui_settings.dart';
import 'package:inowa/src/ui/widgets/language_icons.dart';

/// Widget Connecting/Disconnecting the Bluetooth device.
class LanguagePopupMenu extends StatefulWidget {
  const LanguagePopupMenu();

  @override
  State<LanguagePopupMenu> createState() => _LanguagePopupMenu();
}

class _LanguagePopupMenu extends State<LanguagePopupMenu> {
  @override
  Widget build(BuildContext context) =>
      Consumer<UIModel>(builder: (_, uiModel, __) {
        return PopupMenuButton<Locale>(
          icon: const Icon(Icons.language), // Icon for the popup menu
          onSelected: (Locale locale) {
            setState(() {
              uiModel.setLocale(locale);
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
            for (var locale in AppLocalizations.supportedLocales)
              PopupMenuItem<Locale>(
                value: locale,
                child: LanguageIcons.buttonByLanguageCode(
                  locale.languageCode,
                ),
              ),
          ],
        );
      });
}
