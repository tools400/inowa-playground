import 'dart:ui';

import 'package:inowa/src/ble/ble_peripheral_connector.dart';
import 'package:inowa/src/led/hold.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/ui/logging/console_log.dart';

class LEDStripeConnector {
  LEDStripeConnector(this.bleConnector, this.ledSettings);

  static final columnsAsChar = 'ABCDEFGHIJKLMN';
  static final colorStart = 'g';
  static final colorMove1 = 'b';
  static final colorMove2 = 'l';
  static final colorTop = 'r';
  static final delimiterMoves = '/';
  static final eol = '#';

  final BlePeripheralConnector bleConnector;
  final LedSettings ledSettings;

  String sendBoulderToDevice(List<Hold> moves) {
    StringBuffer buffer = StringBuffer();

    var cmd = '';
    for (int i = 1; i <= moves.length; i++) {
      Hold led = moves.elementAt(i - 1);
      cmd = arduinoCommand(led, i, moves.length);
      bleConnector.writeCharacteristicWithResponse(cmd);
      buffer.write(cmd);
    }
    return buffer.toString();
  }

  String arduinoCommand(Hold led, int sequence, length) {
    String color = '';
    String delimiter = '';
    if (sequence <= 2) {
      // start holds
      color = colorStart;
      delimiter = delimiterMoves;
    } else if (sequence == length) {
      // top hold
      color = colorTop;
      delimiter = eol;
    } else {
      // intermediate holds alternating: blue/purple
      if (sequence % 2 == 0) {
        color = colorMove1;
      } else {
        color = colorMove2;
      }
      delimiter = delimiterMoves;
    }

    var arduinoCommand = '${led.ledNbr}:$color$delimiter';

    return arduinoCommand;
  }

  static int _ledsPerRow(bool isHorizontalWireing) {
    var ledsPerRow = 0;
    if (isHorizontalWireing) {
      ledsPerRow = 14;
    } else {
      ledsPerRow = 11;
    }
    return ledsPerRow;
  }

  static Offset ledCoordinatesByName(String name, bool isHorizontalWireing) {
    var row = int.parse(name.substring(1));
    var columnChar = name.substring(0, 1);
    var column = columnsAsChar.indexOf(columnChar) + 1;
    var ledsPerRow = _ledsPerRow(isHorizontalWireing);

    // invert column nummber on reverse wireing
    if (row % 2 == 0) {
      column = (ledsPerRow - column).abs() + 1;
    }

    row = row - 1;

    return Offset(column.toDouble(), row.toDouble());
  }

  static int ledNumberByName(String name, bool isHorizontalWireing) {
    var offset = ledCoordinatesByName(name, isHorizontalWireing);
    int column = offset.dx.toInt();
    int row = offset.dy.toInt();

    var ledsPerRow = _ledsPerRow(isHorizontalWireing);
    var ledNbr = (row * ledsPerRow) + column;

    return ledNbr;
  }

  static Hold ledNumberByUICoordinates(
      Offset position, Size size, bool isHorizontalWireing) {
    var ledNbr = 0;

    // calculate grid coordinates
    var gridHeight = size.height / 14;
    var gridWidth = size.width / 14;
    var rowOffset = 3;

    var positionDX = position.dx;
    var column = (positionDX / gridWidth).toInt();
    if (positionDX % gridWidth > 0) {
      column = column + 1;
    }

    var positionDY = (position.dy - size.height) * -1;
    var row = (positionDY / gridHeight).toInt();
    if (positionDY % gridHeight > 0) {
      row = row + 1;
    }
    row = row - rowOffset;

    int offset;
    String ledID;
    if (isHorizontalWireing) {
      var ledsPerRow = _ledsPerRow(isHorizontalWireing);
      offset = column - 1;
      ledID = columnsAsChar.substring(offset, offset + 1) + row.toString();
      // invert column nummber on reverse wireing
      if (row % 2 == 0) {
        column = (ledsPerRow - column).abs() + 1;
      }
      ledNbr = column + ((row - 1) * ledsPerRow);
    } else {
      var ledsPerColumn = _ledsPerRow(isHorizontalWireing);
      offset = column - 1;
      ledID = columnsAsChar.substring(offset, offset + 1) + row.toString();
      // invert row nummber on reverse wireing
      if (column % 2 == 0) {
        row = (ledsPerColumn - row).abs() + 1;
      }
      ledNbr = row + ((column - 1) * ledsPerColumn);
    }

    ConsoleLog.log(ledID);

    return Hold(uiName: ledID, ledNbr: ledNbr);
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
  ConsoleLog.log('Horizontal => ' + arduinoCommand.join());

  ledConnector.horizontalWireing = false;
  arduinoCommand = ledConnector.arduinoCommand('N5+M6/M9/J9/J10/G10/E8/B9/B11');
  ConsoleLog.log('Vertical => ' + arduinoCommand.join());
*/
}
