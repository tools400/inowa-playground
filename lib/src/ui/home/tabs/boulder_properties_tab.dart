import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:inowa/src/firebase/angle_enum.dart';
import 'package:inowa/src/firebase/grade_enum.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/ui/settings/internal/settings_list_tile.dart';
import 'package:inowa/src/ui/widgets/angle_drop_down_menu.dart';
import 'package:inowa/src/ui/widgets/grade_drop_down_menu.dart';

/// Widget for selecting the wireing of the LED stripe.
class BoulderPropertiesTab extends StatefulWidget {
  const BoulderPropertiesTab({super.key, required boulder})
      : _boulderItem = boulder;

  final FbBoulder _boulderItem;

  @override
  State<BoulderPropertiesTab> createState() => _BoulderPropertiesTab();
}

class _BoulderPropertiesTab extends State<BoulderPropertiesTab> {
  final TextEditingController _nameController = TextEditingController();

  Angle? _angle;
  Grade? _grade;

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget._boulderItem.name;
    _angle = widget._boulderItem.angle;
    _grade = widget._boulderItem.grade;

    return Column(
      children: [
        SettingsListTile(
          title: AppLocalizations.of(context)!.name,
          trailing: Text(widget._boulderItem.name),
/*          
          SimpleText(
            controller: _nameController,
          ),
*/
        ),
        SettingsListTile(
            title: AppLocalizations.of(context)!.angle,
            trailing: AngleDropDownMenu(
              initialSelection: _angle,
              onSelected: (value) {
                setState(() {
                  _angle = value;
                });
              },
            )),
        SettingsListTile(
            title: AppLocalizations.of(context)!.grade,
            trailing: GradeDropDownMenu(
              initialSelection: _grade,
              onSelected: (value) {
                setState(() {
                  _grade = value;
                });
              },
            )),
      ],
    );
  }
}
