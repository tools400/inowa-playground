import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/ui/settings/internal/settings_list_tile.dart';
import 'package:inowa/src/ui/settings/internal/settings_simple_text_field.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

import '/src/firebase/angle_enum.dart';
import '/src/firebase/fb_service.dart';
import '/src/firebase/grade_enum.dart';

class DisplayBoulderScreen extends StatefulWidget {
  const DisplayBoulderScreen({super.key, required boulder})
      : this._boulderItem = boulder;

  final FbBoulder _boulderItem;

  @override
  State<DisplayBoulderScreen> createState() => _DisplayBoulderScreenState();
}

class _DisplayBoulderScreenState extends State<DisplayBoulderScreen> {
  final TextEditingController _nameController = TextEditingController();

  Angle? _angle;
  Grade? _grade;

  @override
  Widget build(BuildContext context) =>
      Consumer3<FirebaseService, BlePeripheralConnector, LedSettings>(
          builder: (_, firebase, bleConnector, ledSettings, __) {
        var ledConnector = LEDStripeConnector(bleConnector, ledSettings);

        _nameController.text = widget._boulderItem.name;
        _angle = widget._boulderItem.angle;
        _grade = widget._boulderItem.grade;

        ledConnector.sendBoulderToDevice('N5+M6/M9/J9/J10/G10/E8/B9/B11');

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.mnu_Display_Problem),
            backgroundColor: ColorTheme.inversePrimary(context),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SettingsListTile(
                  title: AppLocalizations.of(context)!.name,
                  trailing: SimpleText(
                    controller: _nameController,
                  ),
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
    return _nameController.text.isNotEmpty && _angle != null && _grade != null;
  }
}
