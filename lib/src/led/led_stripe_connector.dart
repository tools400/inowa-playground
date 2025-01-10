import 'dart:ui';

import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/led/led_settings.dart';

class LEDStripeConnector {
  LEDStripeConnector(this.bleConnector, this.ledSettings);

  final BlePeripheralConnector bleConnector;
  final LedSettings ledSettings;

  static final colorStart = 'g';
  static final colorMove1 = 'b';
  static final colorMove2 = 'l';
  static final color_top = 'r';
  static final delimiterMoves = '/';
  static final eol = '#';

  void sendBoulderToDevice(String ledCommand) {
    var arduinoCommand2 = arduinoCommand(ledCommand);
    for (var value in arduinoCommand2) {
      bleConnector.writeCharacteristicWithResponse(value);
    }
  }

  List<String> arduinoCommand(String appCommand) {
    final regex = RegExp(r'[+/]');
    List<String> parts = appCommand.split(regex);
    List<String> arduinoCommand = [];

    for (int i = 0; i < parts.length; i++) {
      String color = '';
      String delimiter = '';
      if (i < 2) {
        // Startgriffe
        color = colorStart;
        delimiter = delimiterMoves;
      } else if (i == parts.length - 1) {
        // Top Griff
        color = color_top;
        delimiter = eol;
      } else {
        // Boulderzüge, qbwechselnd blau/lila
        if (i % 2 == 0) {
          color = colorMove1;
        } else {
          color = colorMove2;
        }
        delimiter = delimiterMoves;
      }
      arduinoCommand.add('${_ledNumber(parts[i])}:$color$delimiter');
    }

    return arduinoCommand;
  }

  int ledNumberByUICoordinates(Offset position, Size size) {
    var ledNbr = 0;

    // calculate grid coordinates
    var gridHeight = size.height / 14;
    var gridWidth = size.width / 14;
    var rowOffset = 3;

    var positionDX = position.dx;
    var widget__x = (positionDX / gridWidth).toInt();
    if (positionDX % gridWidth > 0) {
      widget__x = widget__x + 1;
    }

    var positionDY = (position.dy - size.height) * -1;
    var widget__y = (positionDY / gridHeight).toInt();
    if (positionDY % gridHeight > 0) {
      widget__y = widget__y + 1;
    }
    widget__y = widget__y - rowOffset;

    if (ledSettings.isHorizontalWireing) {
      var ledsPerRow = 14;
      ledNbr = widget__x + ((widget__y - 1) * ledsPerRow);
    } else {
      var ledsPerColumn = 11;
      ledNbr = widget__y + ((widget__x - 1) * ledsPerColumn);
    }

    return ledNbr;
  }

  String _ledNumber(String coordinate) {
    var column = coordinate.substring(0, 1).toUpperCase();
    var row = coordinate.substring(1);

    int ledNbr = 0;

    int colNbr = 0;
    int rowNbr = 0;

    if (ledSettings.isHorizontalWireing) {
      int ledsPerRow = 14;
      colNbr = column.codeUnits[0] - 'A'.codeUnits[0] + 1;
      rowNbr = int.parse(row);
      ledNbr = colNbr + ((rowNbr - 1) * ledsPerRow);
    } else {
      int ledsPerColumn = 11;
      colNbr = int.parse(row);
      rowNbr = column.codeUnits[0] - 'A'.codeUnits[0] + 1;
      ledNbr = colNbr + ((rowNbr - 1) * ledsPerColumn);
    }

    return ledNbr.toString();
  }
}

void main(List<String> arguments) {
/*  
  var ble = FlutterReactiveBle();
  // var bleLogger = BleLogger(ble: ble);
  var scanner = BleScanner(ble: ble);
  var connector = BleDeviceConnector(
    ble: ble,
    scanner: scanner,
  );
  var serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: (deviceId) async {
      await ble.discoverAllServices(deviceId);
      return ble.getDiscoveredServices(deviceId);
    },
    readRssi: ble.readRssi,
    requestMtu: ble.requestMtu,
  );
  var bleConnector =
      BleConnector(scanner, connector, serviceDiscoverer);
  var ledConnector = LEDConnector(bleConnector);

  List<String> arduinoCommand;

  ledConnector.horizontalWireing = true;
  arduinoCommand = ledConnector.arduinoCommand('N5+M6/M9/J9/J10/G10/E8/B9/B11');
  print('Horizontal => ' + arduinoCommand.join());

  ledConnector.horizontalWireing = false;
  arduinoCommand = ledConnector.arduinoCommand('N5+M6/M9/J9/J10/G10/E8/B9/B11');
  print('Vertical => ' + arduinoCommand.join());
*/
}
