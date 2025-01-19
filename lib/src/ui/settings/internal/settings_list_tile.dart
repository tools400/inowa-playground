import 'package:flutter/material.dart';

import 'package:inowa/src/ui/settings/internal/settings_constrained_box.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  const SettingsListTile(
      {super.key, required this.title, this.icon, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SimpleConstrainedBox(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: false,
        visualDensity: VisualDensity(vertical: 0),
        title: Text(title),
        leading: Icon(icon),
        trailing: trailing,
        onTap: () {},
      ),
    );
  }
}
