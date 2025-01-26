import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/main.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/led/hold.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/led/moves.dart';
import 'package:inowa/src/settings/ui_settings.dart';
import 'package:inowa/src/ui/logging/console_log.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/ui/widgets/boulder_wall.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';
import 'package:inowa/src/utils/utils.dart';

class BoulderMovesTab extends StatefulWidget {
  const BoulderMovesTab({
    super.key,
    required boulder,
  }) : _boulderItem = boulder;

  final FbBoulder _boulderItem;

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
    ledStripeConnector = LEDStripeConnector(peripheralConnector, ledSettings);
    isHorizontalWireing = ledSettings.isHorizontalWireing;
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
            flex: 1,
            child: boulderWallPanel(onTapDown, maxSize),
          ),
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
    const double rowHeight = 40;

    return Consumer<UIModel>(builder: (_, uiModel, __) {
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
              isShowLine: uiModel.isShowPath,
              maxSize: Size(Utils.min(maxSize) - rowHeight,
                  Utils.min(maxSize) - rowHeight),
            ),
            // Footer with hide/show switch
            SizedBox(
              height: rowHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(uiModel.isShowPath
                      ? AppLocalizations.of(context)!.hide_path
                      : AppLocalizations.of(context)!.show_path),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: uiModel.isShowPath,
                      onChanged: (value) {
                        setState(() {
                          uiModel.setShowPath(value);
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
    });
  }

  /// Produces the complete moves panel:
  /// start holds:   xx xx
  /// inter holds:   xx xx xx xx ...    <Undo>
  /// start hold:    xx
  ///                                   <Clear>
  ///         xx xx xx xx xx xx xx
  movesPanel() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Flexible(
                flex: 9,
                child:
                    // Holds
                    moves,
              ),
              HSpace(),
              // Buttons
              Flexible(
                flex: 1,
                child: buttons,
              ),
            ],
          ),
          VSpace(flex: 2),
          Text(_moves.allHoldsAsString),
        ],
      ),
    );
  }

  /// Produces a 3-line table with the start, inter and top holds:
  /// start holds:   xx xx
  /// inter holds:   xx xx xx xx ...
  /// start hold:    xx
  Widget get moves {
    EdgeInsets rowHeight = EdgeInsets.symmetric(vertical: 2);

    return Container(
      // color: Colors.greenAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1.0),
              1: FixedColumnWidth(10),
              // 2: FlexColumnWidth(),
              // 2: FixedColumnWidth(100),
              2: FlexColumnWidth(2.5),
            },
            children: [
              TableRow(
                children: [
                  // -------------------
                  // start holds
                  // -------------------
                  Padding(
                    padding: rowHeight,
                    child: Text(
                      'Start holds:',
                      style: TextStyle(
                        color: BoulderColor.startHolds,
                      ),
                    ),
                  ),
                  SizedBox.fromSize(),
                  Padding(
                    padding: rowHeight,
                    child: Text(
                      _moves.startHoldsAsString,
                      style: TextStyle(
                        color: BoulderColor.startHolds,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  // -------------------
                  // intermediate holds
                  // -------------------
                  Padding(
                    padding: rowHeight,
                    child: Row(
                      children: [
                        Text(
                          'Inter',
                          style: TextStyle(
                            color: BoulderColor.interHolds1,
                          ),
                        ),
                        Text(' '),
                        Text(
                          'holds:',
                          style: TextStyle(
                            color: BoulderColor.interHolds2,
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
                  // -------------------
                  // top hold
                  // -------------------
                  Padding(
                    padding: rowHeight,
                    child: Text(
                      'Top hold:',
                      style: TextStyle(
                        color: BoulderColor.topHold,
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
    );
  }

  /// Produces the 'Undo' and 'Clear' buttons.
  Widget get buttons {
    return Container(
      // color: Colors.amber,
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
    );
  }

  /// Produces a wrappable row of hold widgets.
  Widget get rowOfIntermediateHolds {
    // build list of hold widgets
    var holds = _moves.intermediateHolds;
    List<Widget> widgets = [];
    late Color color;
    late String label;
    for (int i = 0; i < holds.length; i++) {
      if (i % 2 == 0) {
        color = BoulderColor.interHolds1;
      } else {
        color = BoulderColor.interHolds2;
      }
      if (i == holds.length - 1) {
        label = holds[i].uiName;
      } else {
        label = '${holds[i].uiName}/';
      }
      widgets.add(Text(label, style: TextStyle(color: color)));
    }

    return Wrap(
      spacing: 0,
      runSpacing: 2.0,
      children: [
        for (Widget widget in widgets) widget,
      ],
    );
  }
}
