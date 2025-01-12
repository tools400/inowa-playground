import 'package:flutter/material.dart';

import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/led/led.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/led/moves.dart';
import 'package:inowa/src/ui/settings/internal/settings_simple_text_field.dart';
import 'package:inowa/src/ui/widgets/boulder_board.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

/// Widget for editing the boulder moves.
class BoulderMovesTab extends StatefulWidget {
  const BoulderMovesTab(
      {super.key,
      required boulder,
      required bleConnector,
      required ledSettings})
      : _boulderItem = boulder,
        _bleConnector = bleConnector,
        _ledSettings = ledSettings;

  final FbBoulder _boulderItem;
  final BlePeripheralConnector _bleConnector;
  final LedSettings _ledSettings;

  @override
  State<BoulderMovesTab> createState() => _BoulderMovesTab();
}

class _BoulderMovesTab extends State<BoulderMovesTab> {
  late LEDStripeConnector ledStripeConnector;
  late bool isHorizontalWireing;
  final TextEditingController _nameController = TextEditingController();

  LED? _led;
  Moves _moves = Moves();

  @override
  void initState() {
    ledStripeConnector =
        LEDStripeConnector(widget._bleConnector, widget._ledSettings);
    isHorizontalWireing = widget._ledSettings.isHorizontalWireing;
    _moves = widget._boulderItem.moves(isHorizontalWireing);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget._boulderItem.name;

    // Executed on tapping the boulder wall image
    void onTapDown(Offset position, Size size) {
      setState(() {
        _led = LEDStripeConnector.ledNumberByUICoordinates(
            position, size, isHorizontalWireing);
        if (_led != null) {
          _moves.add(_led!);
        }
      });
    }

    return Column(
      children: [
        Text(widget._boulderItem.name),
        VSpace(),
        BoulderWall(holds: _moves.all, onTapDown: onTapDown),
        VSpace(),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _moves.isEmpty
                      ? null
                      : () {
                          setState(() {
                            _moves.removeLast();
                          });
                        },
                  icon: Icon(Icons.clear),
                ),
                IconButton(
                  onPressed: _moves.isEmpty
                      ? null
                      : () {
                          setState(() {
                            _moves.clear();
                          });
                        },
                  icon: Icon(Icons.clear_all),
                ),
              ],
            ),
          ],
        ),
        VSpace(),
        Text('LED: ${_led?.uiName} -> ${_led?.ledNbr}'),
        Text('Moves: ${_moves.toString()}'),
        Text('Arduiono: ${ledStripeConnector.sendBoulderToDevice(_moves.all)}'),
      ],
    );
  }
}
