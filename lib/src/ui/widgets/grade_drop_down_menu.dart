import 'package:flutter/material.dart';
import 'package:inowa/src/firebase/grade_enum.dart';
import 'package:inowa/src/ui/settings/internal/settings_drop_down_menu.dart';

/// Widgets zur Eingabe der Schwierigkeitsgrades.
class GradeDropDownMenu extends StatefulWidget {
  const GradeDropDownMenu({
    super.key,
    this.initialSelection,
    this.onSelected,
  });

  final Grade? initialSelection;
  final ValueChanged<Grade?>? onSelected;

  @override
  State<GradeDropDownMenu> createState() => _GradeDropDownMenu();
}

class _GradeDropDownMenu extends State<GradeDropDownMenu> {
  Grade? angle;

  @override
  Widget build(BuildContext context) => SettingsDropDownMenu<Grade>(
        initialSelection: widget.initialSelection,
        onSelected: widget.onSelected,
        dropdownMenuEntries:
            Grade.values.map((item) => gradeToMenuItem(item)).toList(),
      );

  DropdownMenuEntry<Grade> gradeToMenuItem(Grade item) {
    return DropdownMenuEntry(
      label: item.label,
      value: item,
    );
  }
}
