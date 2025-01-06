import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:inowa/src/ui/settings/internal/settings_drop_down_menu.dart';
import 'package:inowa/src/ui/settings/internal/settings_list_tile.dart';
import 'package:inowa/src/ui/settings/internal/settings_simple_text_field.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

import '/src/firebase/angle_enum.dart';
import '/src/firebase/fb_service.dart';
import '/src/firebase/grade_enum.dart';

class DisplayBoulderScreen extends StatefulWidget {
  const DisplayBoulderScreen({super.key});

  @override
  State<DisplayBoulderScreen> createState() => _DisplayBoulderScreenState();
}

class _DisplayBoulderScreenState extends State<DisplayBoulderScreen> {
  final TextEditingController _nameController = TextEditingController();

  Angle? angle;
  Grade? grade;

  @override
  Widget build(BuildContext context) =>
      Consumer<FirebaseService>(builder: (_, firebase, __) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SettingsListTile(
                  title: 'Name',
                  trailing: SimpleText(),
                ),
                SettingsListTile(
                    title: 'Angle',
                    trailing: AngleDropDownMenu(
                      initialSelection: angle,
                      onSelected: (value) {
                        setState(() {
                          angle = value;
                        });
                      },
                    )),
                SettingsListTile(
                    title: 'Grade',
                    trailing: GradeDropDownMenu(
                      initialSelection: grade,
                      onSelected: (value) {
                        setState(() {
                          grade = value;
                        });
                      },
                    )),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
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