import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:inowa/src/ui/settings/internal/settings_list_tile.dart';

import '/src/firebase/angle_enum.dart';
import '/src/firebase/fb_service.dart';
import '/src/firebase/grade_enum.dart';

class AddBoulderScreen extends StatefulWidget {
  const AddBoulderScreen({super.key});

  @override
  State<AddBoulderScreen> createState() => _AddBoulderScreenState();
}

class _AddBoulderScreenState extends State<AddBoulderScreen> {
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

        Future<void> addData(String name, Angle angle, Grade grade) async {
          firebase.addBoulder(name, angle, grade);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Daten hinzufügen'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SettingsListTile(
                  title: 'Angle',
                  trailing: DropdownMenu<Angle>(
                      width: 200,
                      initialSelection: angle,
                      onSelected: (Angle? value) {
                        setState(() {
                          angle = value;
                        });
                      },
                      dropdownMenuEntries: Angle.values
                          .map((item) => angleToMenuItem(item))
                          .toList()),
                ),
                SettingsListTile(
                  title: 'Grade',
                  trailing: DropdownMenu<Grade>(
                      width: 200,
                      initialSelection: grade,
                      onSelected: (Grade? value) {
                        setState(() {
                          grade = value;
                        });
                      },
                      dropdownMenuEntries: Grade.values
                          .map((item) => gradeToMenuItem(item))
                          .toList()),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final title = _nameController.text;

                    if (isValidated()) {
                      addData(title, angle!, grade!);
                    } else {
                      print('Bitte alle Felder ausfüllen');
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
