import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/led/hold.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/led/moves.dart';
import 'package:inowa/src/ui/logging/console_log.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/ui/widgets/boulder_wall.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';
import 'package:inowa/src/utils/utils.dart';

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
  // TODO: remove debug code
  late LEDStripeConnector ledStripeConnector;
  late bool isHorizontalWireing;

  Hold? _led;
  Moves _moves = Moves();
  bool _isShowLine = false;

  @override
  void initState() {
    super.initState();
    // TODO: remove debug code
    ledStripeConnector =
        LEDStripeConnector(widget._bleConnector, widget._ledSettings);
    isHorizontalWireing = widget._ledSettings.isHorizontalWireing;
    _moves = widget._boulderItem.moves(isHorizontalWireing);
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: getPanel(PlatformUI.isPortait(context),
            Size(boxConstraints.maxWidth, boxConstraints.maxHeight)),
      );
    });
  }

  getPanel(bool isPortrait, Size maxSize) {
    if (isPortrait) {
      return Column(
        // Boulderwall
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          boulderWallPanel(onTapDown, maxSize),
          movesPanel(),
        ],
      );
    } else {
      return Row(
        // Boulderwall
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
/*
          Flexible(
            flex: 2,
            child: 
          ),
*/
          boulderWallPanel(onTapDown, maxSize),
          Flexible(
            flex: 2,
            child: movesPanel(),
          ),
        ],
      );
    }
  }

  boulderWallPanel(
      void Function(Offset position, Size size) onTapDown, Size maxSize) {
    const double rowHeight = 18;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: Utils.min(maxSize),
        maxHeight: Utils.min(maxSize),
      ),
      child: Column(
        children: [
          BoulderWall(
            holds: _moves.all,
            onTapDown: onTapDown,
            isShowLine: _isShowLine,
            maxSize: Size(
                Utils.min(maxSize) - rowHeight, Utils.min(maxSize) - rowHeight),
          ),
          SizedBox(
            height: rowHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _isShowLine
                            ? AppLocalizations.of(context)!.hide_line
                            : AppLocalizations.of(context)!.show_line,
                        style: const TextStyle(
                          color: ColorTheme.linkColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              _isShowLine = !_isShowLine;
                              ConsoleLog.log(
                                  'Changed _isShowLine: $_isShowLine');
                            });
                          },
                      ),
                    ],
                  ),
                ),
                HSpace(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  movesPanel() {
    return Column(
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
              icon: Icon(Icons.undo),
            ),
            IconButton(
              onPressed: _moves.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _moves.clear();
                      });
                    },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
        VSpace(),
        Text('Moves: ${_moves.toString()}'),
        VSpace(),
        // TODO: remove debug code
        Text(ledStripeConnector.sendBoulderToDevice(_moves.all)),
      ],
    );
  }
}
