import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:inowa/src/constants.dart';
import 'package:inowa/src/led/hold.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/utils/utils.dart';

class BoulderWall extends StatefulWidget {
  const BoulderWall({super.key, required List<Hold> holds, required onTapDown})
      : _holds = holds,
        _onTapDown = onTapDown;

  final List<Hold> _holds;
  final Function(Offset offset, Size size) _onTapDown;

  // TODO: pass as parameter
  final bool isHorizontalWireing = true;

  @override
  State<BoulderWall> createState() => _BoulderBoard();
}

class _BoulderBoard extends State<BoulderWall> {
  Size? widgetSize;

  late Image image;
  bool isImageloaded = false;

  @override
  void initState() {
    super.initState();

    image = Image.asset(
      IMAGE_BOARD_2,
      fit: BoxFit.fitWidth,
    );

    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      setState(() {
        isImageloaded = true;
      });
    }));
  }

  Size getWidgetSize(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: fix code when device is in horizontal position

    double fraction = 0.9;
    double imageWidth = 0;
    double imageHeight = 0;
    if (PlatformUI.screenWidth > PlatformUI.screenHeight) {
      imageWidth = PlatformUI.screenWidth * fraction;
      imageHeight = imageWidth;
    } else {
      imageWidth = PlatformUI.screenHeight * fraction;
      imageHeight = imageWidth;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: imageWidth,
        maxHeight: imageHeight,
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          GestureDetector(
            onTapDown: !isImageloaded
                ? null
                : (details) {
                    final position = details.localPosition;
                    widget._onTapDown(position, widgetSize!);
                  },
            child: image,
          ),
          // Custom overlay
          CustomPaint(
            painter: !isImageloaded
                ? null
                : HoldsPainter(
                    holds: widget._holds,
                    isHorizontalWireing: widget.isHorizontalWireing),
          ),
        ],
      ),
    );
  }
}

class HoldsPainter extends CustomPainter {
  HoldsPainter(
      {required List<Hold> this.holds,
      Size? this.size,
      required bool this.isHorizontalWireing});

  final List<Hold> holds;
  final Size? size;
  final bool isHorizontalWireing;

  @override
  void paint(Canvas canvas, Size size) {
    if (this.size == null) {
      return;
    }

    size = this.size!;

    // Set up paint
    final strokeWidth = 2.0;

    // start holds
    final Paint startHoldsBorder = Paint()
      ..color = const ui.Color.fromARGB(255, 25, 175, 30)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // intermediate holds
    final Paint intermediateMovesBorder1 = Paint()
      ..color = const ui.Color.fromARGB(255, 0, 20, 180)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Paint intermediateMovesBorder2 = Paint()
      ..color = Colors.purple
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // top hold
    final Paint topHoldBorder = Paint()
      ..color = Colors.red
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // line
    final Paint path = Paint()
      ..color = Colors.orange
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw a holds
    var rowOffset = 3;
    var ledsPerRow = 14;
    var gridHeight = size.height / 14;
    var gridWidth = size.width / 14;

    Offset? startPos;
    Offset? endPos;

    for (int i = 0; i < holds.length; i++) {
      var offset = LEDStripeConnector.ledCoordinatesByName(
          holds[i].uiName, isHorizontalWireing);

      int column = offset.dx.toInt();
      int row = offset.dy.toInt() + rowOffset;

      // invert column nummber on reverse wireing
      if (row % 2 == 0) {
        column = (ledsPerRow - column).abs() + 1;
      }

      var posX = column * gridWidth;
      var posY = row * gridHeight;
      posY = (posY - size.height) * -1;

      var radius = gridWidth / 2;
      posX = posX - radius;
      posY = posY - radius;

      Paint? circle;
      var sequence = i + 1;
      if (sequence <= 2) {
        circle = startHoldsBorder;
      } else if (sequence == holds.length) {
        circle = topHoldBorder;
      } else {
        if (sequence % 2 == 0) {
          circle = intermediateMovesBorder1;
        } else {
          circle = intermediateMovesBorder2;
        }
      }

      canvas.drawCircle(
        Offset(posX, posY),
        radius - (strokeWidth / 2),
        circle,
      );

      endPos = Offset(posX, posY);
      if (sequence > 2) {
        if (startPos != null) {
          canvas.drawLine(startPos, endPos, path);
        }
      }
      // skip second start hold to draw the first line from
      // the first start hold to the first intermediate hold
      if (sequence != 2) {
        startPos = Offset(posX, posY);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Return true if the painting logic changes and you want to repaint
    return false;
  }
}

class ImageEditor extends CustomPainter {
  ImageEditor({
    required this.image,
  });

  ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset(0.0, 0.0), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
