import 'package:inowa/src/ble/ble_auto_connector.dart';

class LEDConnector {
  LEDConnector(this.bleConnector);

  final BleConnector bleConnector;

  bool _isHorizontal = true;

  static final color_start = 'g';
  static final color_move1 = 'b';
  static final color_move2 = 'l';
  static final color_top = 'r';
  static final delimiter_moves = '/';
  static final eol = '#';

  set horizontalWireing(enabled) => _isHorizontal = enabled;

  void sendBoulderToDevice(String ledCommand) {
    var arduinoCommand2 = arduinoCommand(ledCommand);
    arduinoCommand2.forEach((value) {
      bleConnector.writeCharacteristicWithResponse(value);
    });
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
        color = color_start;
        delimiter = delimiter_moves;
      } else if (i == parts.length - 1) {
        // Top Griff
        color = color_top;
        delimiter = eol;
      } else {
        // Boulderzüge, qbwechselnd blau/lila
        if (i % 2 == 0) {
          color = color_move1;
        } else {
          color = color_move2;
        }
        delimiter = delimiter_moves;
      }
      arduinoCommand.add(_ledNumber(parts[i]) + ':' + color + delimiter);
    }

    return arduinoCommand;
  }

  String _ledNumber(String coordinate) {
    var column = coordinate.substring(0, 1).toUpperCase();
    var row = coordinate.substring(1);

    int ledNbr = 0;

    int colNbr = 0;
    int rowNbr = 0;

    print('_isHorizontal => $_isHorizontal');

    if (_isHorizontal) {
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
  var ledConnector = LEDConnector();

  List<String> arduinoCOmmand;

  ledConnector.horizontalWireing = true;
  arduinoCOmmand = ledConnector.arduinoCommand('N5+M6/M9/J9/J10/G10/E8/B9/B11');
  print('Horizontal => ' + arduinoCOmmand.join());

  ledConnector.horizontalWireing = false;
  arduinoCOmmand = ledConnector.arduinoCommand('N5+M6/M9/J9/J10/G10/E8/B9/B11');
  print('Vertical => ' + arduinoCOmmand.join());
*/
}
