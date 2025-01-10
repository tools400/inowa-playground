import 'package:flutter/material.dart';

import 'package:inowa/src/constants.dart';

class BoulderWall extends StatefulWidget {
  const BoulderWall({super.key, required onTapDown}) : _onTapDown = onTapDown;

  final Function(Offset offset, Size size) _onTapDown;

  @override
  State<BoulderWall> createState() => _BoulderBoard();
}

class _BoulderBoard extends State<BoulderWall> {
  final GlobalKey widgetKey = GlobalKey();

  Size getWidgetSize(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (details) {
          final position = details.localPosition;
          final size = getWidgetSize(widgetKey);
          widget._onTapDown(position, size);
        },
        child: Image.asset(
          IMAGE_BOARD_2,
          fit: BoxFit.fitWidth,
          key: widgetKey,
        ));
  }
}
