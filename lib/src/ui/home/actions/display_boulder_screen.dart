import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:inowa/src/ui/settings/internal/settings_list_tile.dart';

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
        /// Erzeugt die Menüeinträge für das Drop-Down Menü für die Auswahl der Sprache.
        DropdownMenuEntry<Angle> angleToMenuItem(Angle item) {
          return DropdownMenuEntry(
            label: item.label,
            value: item,
          );
        }

        DropdownMenuEntry<Grade> gradeToMenuItem(Grade item) {
          return DropdownMenuEntry(
            label: item.label,
            value: item,
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Anzeigen Boulder'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
/*
                  controller: _nameController,
*/
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SettingsListTile(
                  title: 'Angle',
                  trailing: DropdownMenu<Angle>(
                      width: 200,
                      initialSelection: angle,
/*
                      onSelected: (Angle? value) {
                        setState(() {
                          angle = value;
                        });
                      },
*/
                      dropdownMenuEntries: Angle.values
                          .map((item) => angleToMenuItem(item))
                          .toList()),
                ),
                SettingsListTile(
                  title: 'Grade',
                  trailing: DropdownMenu<Grade>(
                      width: 200,
                      initialSelection: grade,
/*
                      onSelected: (Grade? value) {
                        setState(() {
                          grade = value;
                        });
                      },
*/
                      dropdownMenuEntries: Grade.values
                          .map((item) => gradeToMenuItem(item))
                          .toList()),
                ),
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
