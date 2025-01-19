import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/firebase/angle_enum.dart';
import 'package:inowa/src/ui/logging/console_log.dart';
import 'package:inowa/src/ui/settings/internal/settings_list_tile.dart';
import 'package:inowa/src/ui/settings/internal/settings_simple_editable_text_field.dart';
import 'package:inowa/src/ui/widgets/angle_drop_down_menu.dart';
import 'package:inowa/src/ui/widgets/grade_drop_down_menu.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

import '/src/firebase/fb_service.dart';
import '/src/firebase/grade_enum.dart';

class AddBoulderScreen extends StatefulWidget {
  const AddBoulderScreen({super.key});

  @override
  State<AddBoulderScreen> createState() => _AddBoulderScreenState();
}

class _AddBoulderScreenState extends State<AddBoulderScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _movesController = TextEditingController();

  Angle? angle = Angle.angle7_5;
  Grade? grade = Grade.grade2;

  FocusNode nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) =>
      Consumer<FirebaseService>(builder: (_, firebase, __) {
        Future<void> addData(String name, Angle angle, Grade grade) async {
          firebase.addBoulder(name, angle, grade);
        }

        nameFocus.requestFocus();

        return SingleChildScrollView(
          child: Padding(
            padding: appBorder,
            child: Column(
              children: [
                SettingsListTile(
                  title: AppLocalizations.of(context)!.name,
                  trailing: SimpleEditableText(
                    controller: _nameController,
                    focusNode: nameFocus,
                    validator: (value) {
                      return validateTextNotEmpty(
                          context: context, value: value);
                    },
                  ),
                ),
                SettingsListTile(
                  title: AppLocalizations.of(context)!.angle,
                  trailing: AngleDropDownMenu(
                    initialSelection: angle,
                    onSelected: (value) {
                      setState(() {
                        angle = value;
                      });
                    },
                  ),
                ),
                SettingsListTile(
                  title: AppLocalizations.of(context)!.grade,
                  trailing: GradeDropDownMenu(
                    initialSelection: grade,
                    onSelected: (Grade? value) {
                      setState(() {
                        grade = value;
                      });
                    },
                  ),
                ),
                SettingsListTile(
                  title: AppLocalizations.of(context)!.moves,
                  trailing: SimpleEditableText(
                    controller: _movesController,
                  ),
                ),
                VSpace(),
                ElevatedButton(
                  onPressed: () {
                    final title = _nameController.text;

                    if (isValidated()) {
                      addData(title, angle!, grade!);
                    } else {
                      // TODO: display error message on screen
                      ConsoleLog.log('Bitte alle Felder ausfüllen');
                    }
                  },
                  child: Text('Hinzufügen'),
                ),
              ],
            ),
          ),
        );
      });

  bool isValidated() {
    return _nameController.text.isNotEmpty && angle != null && grade != null;
  }
}
