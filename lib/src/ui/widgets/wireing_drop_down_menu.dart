import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/ui/settings/internal/settings_drop_down_menu.dart';
import 'package:inowa/src/ui/settings/internal/wireing_enum.dart';

/// Widget for selecting the wireing of the LED stripe.
class WireingDropDownMenu extends StatefulWidget {
  const WireingDropDownMenu({
    super.key,
  });

  @override
  State<WireingDropDownMenu> createState() => _WireingDownMenu();
}

class _WireingDownMenu extends State<WireingDropDownMenu> {
  Wireing? wireing;

  @override
  Widget build(BuildContext context) =>
      Consumer<LedSettings>(builder: (_, ledSettings, __) {
        return SettingsDropDownMenu<Wireing>(
          initialSelection: ledSettings.isHorizontalWireing
              ? Wireing.horizontal
              : Wireing.vertical,
          onSelected: (value) {
            setState(() {
              ledSettings.isHorizontalWireing = (value == Wireing.horizontal);
            });
          },
          dropdownMenuEntries:
              Wireing.values.map((item) => wireingToMenuItem(item)).toList(),
        );
      });

  DropdownMenuEntry<Wireing> wireingToMenuItem(Wireing item) {
    return DropdownMenuEntry(
      label: item.label,
      value: item,
    );
  }
}
