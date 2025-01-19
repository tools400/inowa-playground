import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:measured_size/measured_size.dart';

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
      required bool isShowLine})
      : _holds = holds,
        _onTapDown = onTapDown,
        _isShowLine = isShowLine;

  final List<Hold> _holds;
  final Function(Offset offset, Size size) _onTapDown;
  final bool _isShowLine;

  @override
  State<BoulderWall> createState() => _BoulderBoard();
}

class _BoulderBoard extends State<BoulderWall> {
  final GlobalKey _imageKey = GlobalKey();

  Size? _widgetSize;

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

    _image = Image.asset(
      IMAGE_BOARD_2,
      fit: BoxFit.fitWidth,
    );

    Completer<ui.Image> completer = Completer<ui.Image>();
    _image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      setState(() {
        _isImageLoaded = true;
        ConsoleLog.log('Image has been loaded.');
      });
    }));
  }

  void initWidgetSize(BuildContext context) {
    if (_widgetSize == null) {
      double fraction = 0.9;
      double imageWidth = 0;
      double imageHeight = 0;
      double screenWidth = PlatformUI.screenWidth(context);
      double screenHeight = PlatformUI.screenHeight(context);
      if (screenWidth > screenHeight) {
        imageWidth = screenWidth * fraction;
        imageHeight = imageWidth;
      } else {
        imageWidth = screenHeight * fraction;
        imageHeight = imageWidth;
      }

      _widgetSize = Size(imageWidth, imageHeight);
      ConsoleLog.log(
          'initWidgetSize() size: ${_widgetSize!.width}/${_widgetSize!.height})...');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: fix code when device is in horizontal position

    initWidgetSize(context);

    if (_isImageLoaded) {
      _isPainterVisible = true;
      ConsoleLog.log('Painter is visible, now.');
    } else {
      _isPainterVisible = false;
      ConsoleLog.log('Painter is hidden, now.');
    }

    return LayoutBuilder(builder: (context, boxContrains) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _widgetSize!.width,
          maxHeight: _widgetSize!.height,
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            MeasuredSize(
              onChange: (size) {
                if (_isImageLoaded) {
                  setState(() {
                    _widgetSize = Size(size.width, size.height);
                    ConsoleLog.log(
                        'MeasuredSize.onChange() size: ${_widgetSize!.width}/${_widgetSize!.height})...');
                  });
                }
              },
              child: GestureDetector(
                key: _imageKey,
                onTapDown: !_isImageLoaded
                    ? null
                    : (details) {
                        final position = details.localPosition;
                        widget._onTapDown(position, _widgetSize!);
                      },
                child: _isImageLoaded ? _image : CircularProgressIndicator(),
              ),
            ),
            // Custom overlay drawing the boulder
            if (_isPainterVisible)
              CustomPaint(
                painter: HoldsPainter(
                  isShowLine: widget._isShowLine,
                  size: _widgetSize,
                  holds: widget._holds,
                ),
              ),
          ],
        ),
      );
    });
  }
}

class HoldsPainter extends CustomPainter {
  HoldsPainter(
      {required List<Hold> holds, this.size, this.isShowLine = true})
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
