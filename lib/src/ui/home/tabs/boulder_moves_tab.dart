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
  // TODO: remove debug code
  late LEDStripeConnector ledStripeConnector;
  late bool isHorizontalWireing;
  final TextEditingController _nameController = TextEditingController();

  Hold? _led;
  Moves _moves = Moves();
  bool _isShowLine = false;

  @override
  void initState() {
    // TODO: remove debug code
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

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          VSpace(),
          BoulderWall(
            holds: _moves.all,
            onTapDown: onTapDown,
            isShowLine: _isShowLine,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                            ConsoleLog.log('Changed _isShowLine: $_isShowLine');
                          });
                        },
                    ),
                  ],
                ),
              ),
              HSpace(),
            ],
          ),
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
/*
                  SizedBox(
                    child: SwitchListTile(
                      title: const Text('Lights'),
                      value: _isShowLine,
                      onChanged: (bool value) {
                        setState(() {
                          _isShowLine = value;
                        });
                      },
                      secondary: const Icon(Icons.lightbulb_outline),
                    ),
                  ),
*/
                ],
              ),
            ],
          ),
          VSpace(),
          Text('Moves: ${_moves.toString()}'),
          VSpace(),
          // TODO: remove debug code
          Text(ledStripeConnector.sendBoulderToDevice(_moves.all)),
        ],
      ),
    );
  }
}
