import 'package:flutter/material.dart';
import 'package:inowa/src/firebase/angle_enum.dart';
import 'package:inowa/src/ui/settings/internal/settings_drop_down_menu.dart';

/// Widgets zur Eingabe der Wandneigung.
class AngleDropDownMenu extends StatefulWidget {
  const AngleDropDownMenu({
    super.key,
    this.initialSelection,
    this.onSelected,
  });

  final Angle? initialSelection;
  final ValueChanged<Angle?>? onSelected;

  @override
  State<AngleDropDownMenu> createState() => _AngleDropDownMenu();
}

class _AngleDropDownMenu extends State<AngleDropDownMenu> {
  Angle? angle;

  @override
  Widget build(BuildContext context) => SettingsDropDownMenu<Angle>(
        initialSelection: widget.initialSelection,
        onSelected: widget.onSelected,
        dropdownMenuEntries:
            Angle.values.map((item) => angleToMenuItem(item)).toList(),
      );

  DropdownMenuEntry<Angle> angleToMenuItem(Angle item) {
    return DropdownMenuEntry(
      label: item.label,
      value: item,
    );
  }
}
