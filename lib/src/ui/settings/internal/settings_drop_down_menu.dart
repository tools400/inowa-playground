import 'package:flutter/material.dart';

import 'package:inowa/src/ui/widgets/widgets.dart';

class SettingsDropDownMenu<T> extends StatelessWidget {
  const SettingsDropDownMenu({
    super.key,
    this.initialSelection,
    this.onSelected,
    required this.dropdownMenuEntries,
  });

  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      width: 200,
      inputDecorationTheme: inputDecorationTheme,
      initialSelection: initialSelection,
      onSelected: onSelected,
      dropdownMenuEntries: dropdownMenuEntries,
    );
  }
}
