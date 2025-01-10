import 'package:flutter/material.dart';

import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/ui/widgets/boulder_board.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

/// Widget for selecting the wireing of the LED stripe.
class BoulderMovesTab extends StatefulWidget {
  BoulderMovesTab({super.key, required boulder}) : _boulderItem = boulder;

  final FbBoulder _boulderItem;

  // variable to hold the
  // value of coordinate x.
  double _posx = 0;

  // variable to hold the
  // value of coordinate y.
  double _posy = 0;

  @override
  State<BoulderMovesTab> createState() => _BoulderMovesTab();
}

class _BoulderMovesTab extends State<BoulderMovesTab> {
  @override
  Widget build(BuildContext context) {
    // Executed on tapping the boulder wall image
    void onTapDown(Offset position, Size size) {
      setState(() {
        widget._posx = position.dx;
        widget._posy = position.dy;
      });
    }

    return Column(
      children: [
        BoulderWall(onTapDown: onTapDown),
        VSpace(),
        Text('Pos-X: ${widget._posx}'),
        Text('Pos-X: ${widget._posy}'),
      ],
    );
  }
}
