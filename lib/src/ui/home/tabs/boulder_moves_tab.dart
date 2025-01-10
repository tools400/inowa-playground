import 'package:flutter/material.dart';

import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/ui/widgets/boulder_board.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

/// Widget for selecting the wireing of the LED stripe.
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

  int _led = 0;
  String _ledID = '';

  final columnID = 'ABCDEFGHIJKLMN';

  @override
  void initState() {
    ledStripeConnector =
        LEDStripeConnector(widget._bleConnector, widget._ledSettings);
    super.initState();
  }

  String ledNumberToID(int led) {
    var rows = 0;
    var columns = 0;

    if (true) {
      var numLedsPerRow = 14;
      rows = (led / numLedsPerRow).toInt();
      columns = led % numLedsPerRow;
      if (led % numLedsPerRow == 0) {
        columns = numLedsPerRow;
      }

      // adjust offset for 'columnID' array
      columns--;

      if (led % numLedsPerRow > 0) {
        rows++;
      }
/*
    } else {
      var numLedsPerColumn = 11;
      columns = (led / numLedsPerColumn).toInt();
      rows = led % numLedsPerColumn;
      if (led % numLedsPerColumn == 0) {
        rows = numLedsPerColumn;
      }

      // adjust offset for 'columnID' array
      columns--;

      if (led % numLedsPerColumn > 0) {
        rows++;
      }
*/
    }
    var ledID = columnID.substring(columns, columns + 1) + rows.toString();

    return ledID;
  }

  @override
  Widget build(BuildContext context) {
    // Executed on tapping the boulder wall image
    void onTapDown(Offset position, Size size) {
      setState(() {
        _led = ledStripeConnector.ledNumberByUICoordinates(position, size);
        _ledID = ledNumberToID(_led);
      });
    }

    return Column(
      children: [
        BoulderWall(onTapDown: onTapDown),
        VSpace(),
        Text('LED: $_led -> $_ledID'),
      ],
    );
  }
}
