import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:inowa/src/constants.dart';
import 'package:inowa/src/led/hold.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/ui/logging/console_log.dart';
import 'package:inowa/src/utils/utils.dart';

class BoulderWall extends StatefulWidget {
  const BoulderWall(
      {super.key,
      required List<Hold> holds,
      required onTapDown,
      required bool isShowLine,
      required ui.Size maxSize})
      : _holds = holds,
        _onTapDown = onTapDown,
        _isShowLine = isShowLine,
        _maxSize = maxSize;

  final List<Hold> _holds;
  final Function(Offset offset, Size size) _onTapDown;
  final bool _isShowLine;
  final ui.Size _maxSize;

  @override
  State<BoulderWall> createState() => _BoulderBoard();
}

class _BoulderBoard extends State<BoulderWall> {
  final GlobalKey _imageKey = GlobalKey();

  //Size? _widgetSize;

  late Image _image;
  bool _isImageLoaded = false;
  bool _isPainterVisible = false;

  @override
  void initState() {
    super.initState();

    ConsoleLog.log('Initializing state...');
    ConsoleLog.log('isShowLine: ${widget._isShowLine}');
    ConsoleLog.log('isImageLoaded: $_isImageLoaded');
    ConsoleLog.log('isPainterVisible: $_isPainterVisible');

    if (!_isImageLoaded) {
      _image = Image.asset(
        IMAGE_BOARD_2,
        fit: BoxFit.fill,
      );

      Completer<ui.Image> completer = Completer<ui.Image>();
      _image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(info.image);
            setState(
              () {
                _isImageLoaded = true;
                ConsoleLog.log('*** Image has been loaded. ***');
              },
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      if (_isImageLoaded) {
        _isPainterVisible = true;
        ConsoleLog.log('Painter is visible, now.');
      } else {
        _isPainterVisible = false;
        ConsoleLog.log('Painter is hidden, now.');
      }

      Size widgetSize =
          Size(Utils.min(widget._maxSize), Utils.min(widget._maxSize));

      return SizedBox(
        height: widgetSize.height,
        width: widgetSize.width,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Stack(
            children: [
              GestureDetector(
                key: _imageKey,
                onTapDown: !_isImageLoaded
                    ? null
                    : (details) {
                        final position = details.localPosition;
                        widget._onTapDown(position, widgetSize);
                      },
                child: _isImageLoaded ? _image : CircularProgressIndicator(),
              ),
              // Custom overlay drawing the boulder
              if (_isPainterVisible)
                CustomPaint(
                  painter: HoldsPainter(
                    isShowLine: widget._isShowLine,
                    size: widgetSize,
                    holds: widget._holds,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

/// Painter that paints circles around the holds and optionally the boulder line.
class HoldsPainter extends CustomPainter {
  HoldsPainter({required List<Hold> holds, this.size, this.isShowLine = true})
      : _holds = holds;

  final List<Hold> _holds;
  final Size? size;
  final bool isShowLine;

  @override
  void paint(Canvas canvas, Size size) {
    if (this.size == null) {
      return;
    }

    size = this.size!;

    ConsoleLog.log('paint() size: ${size.width}/${size.height})...');

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

    for (int i = 0; i < _holds.length; i++) {
      var offset =
          LEDStripeConnector.ledCoordinatesByName(_holds[i].uiName, true);

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
      } else if (sequence == _holds.length) {
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
          if (isShowLine) {
            canvas.drawLine(startPos, endPos, path);
          }
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
