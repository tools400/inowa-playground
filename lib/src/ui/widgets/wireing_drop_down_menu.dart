import 'package:flutter/material.dart';
import 'package:inowa/src/ui/settings/internal/settings_drop_down_menu.dart';
import 'package:inowa/src/ui/settings/internal/wireing_enum.dart';

/// Widget for selecting the wireing of the LED stripe.
class WireingDropDownMenu extends StatefulWidget {
  const WireingDropDownMenu({
    super.key,
    this.initialSelection,
    this.onSelected,
  });

  final Wireing? initialSelection;
  final ValueChanged<Wireing?>? onSelected;

  @override
  State<WireingDropDownMenu> createState() => _WireingDownMenu();
}

class _WireingDownMenu extends State<WireingDropDownMenu> {
  Wireing? wireing;

  @override
  Widget build(BuildContext context) => SettingsDropDownMenu<Wireing>(
        initialSelection: widget.initialSelection,
        onSelected: widget.onSelected,
        dropdownMenuEntries:
            Wireing.values.map((item) => wireingToMenuItem(item)).toList(),
      );

  DropdownMenuEntry<Wireing> wireingToMenuItem(Wireing item) {
    return DropdownMenuEntry(
      label: item.label,
      value: item,
    );
  }
}
