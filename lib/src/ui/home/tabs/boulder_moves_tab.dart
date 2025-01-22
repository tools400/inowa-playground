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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: boulderWallPanel(onTapDown, maxSize),
          ),
          Flexible(
            child: movesPanel(),
          ),
        ],
      );
    }
  }

  boulderWallPanel(
      void Function(Offset position, Size size) onTapDown, Size maxSize) {
    const double rowHeight = 40;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: Utils.min(maxSize),
        maxHeight: Utils.min(maxSize),
      ),
      child: Column(
        children: [
          // Boulder wall picture
          BoulderWall(
            holds: _moves.all,
            onTapDown: onTapDown,
            isShowLine: _isShowLine,
            maxSize: Size(
                Utils.min(maxSize) - rowHeight, Utils.min(maxSize) - rowHeight),
          ),
          // Footer with hide/show switch
          SizedBox(
            height: rowHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle.merge(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ColorTheme.linkColor),
                  child: Text(_isShowLine
                      ? AppLocalizations.of(context)!.hide_line
                      : AppLocalizations.of(context)!.show_line),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: _isShowLine,
                    onChanged: (value) {
                      setState(() {
                        _isShowLine = !_isShowLine;
                        ConsoleLog.log('Changed _isShowLine: $_isShowLine');
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  movesPanel() {
    EdgeInsets rowHeight = EdgeInsets.symmetric(vertical: 8);

    return Padding(
      padding: EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              // Holds
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(),
                      1: FixedColumnWidth(50),
                      2: IntrinsicColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: rowHeight,
                            child: Text(
                              'Start holds:',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 25, 175, 30),
                              ),
                            ),
                          ),
                          SizedBox.fromSize(),
                          Padding(
                            padding: rowHeight,
                            child: Text(
                              _moves.startHoldsAsString,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 25, 175, 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: rowHeight,
                            child: Row(
                              children: [
                                Text(
                                  'Intermediate',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 0, 20, 180),
                                  ),
                                ),
                                Text(' '),
                                Text(
                                  'holds:',
                                  style: TextStyle(
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox.fromSize(),
                          Padding(
                            padding: rowHeight,
                            child: rowOfIntermediateHolds,
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: rowHeight,
                            child: Text(
                              'Top hold:',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox.fromSize(),
                          Padding(
                            padding: rowHeight,
                            child: Text(
                              _moves.topHoldAsString,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // Buttons
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Undo button
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
                    // Clear button
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
              ),
            ],
          ),
          VSpace(flex: 4),
          Text('${_moves.allHoldsAsString}'),
        ],
      ),
    );
  }

  Row get rowOfIntermediateHolds {
    var holds = _moves.intermediateHolds;
    List<Widget> widgets = [];
    late Color color;
    late String label;
    for (int i = 0; i < holds.length; i++) {
      if (i % 2 == 0) {
        color = const Color.fromARGB(255, 0, 20, 180);
      } else {
        color = Colors.purple;
      }
      if (i == holds.length - 1) {
        label = holds[i].uiName;
      } else {
        label = '${holds[i].uiName}/';
      }
      widgets.add(Text(label, style: TextStyle(color: color)));
    }

    return Row(
      children: [
        for (Widget widget in widgets) widget,
      ],
    );
  }
}
