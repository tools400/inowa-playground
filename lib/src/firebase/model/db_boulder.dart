import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:inowa/src/led/hold.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/led/moves.dart';

import '/src/firebase/angle_enum.dart';
import '/src/firebase/grade_enum.dart';

class FbBoulder {
  FbBoulder(QueryDocumentSnapshot<Object?> this.boulderItem)
      : _id = boulderItem[keyID] ?? Uuid().toString(),
        _moves = boulderItem[keyMoves];

  static const String keyID = 'id';
  static const String keyName = 'name';
  static const String keyAngle = 'angle';
  static const String keyGrade = 'grade';
  static const String keyStars = 'stars';
  static const String keyMoves = 'moves';

  dynamic boulderItem;
  final String _id;
  final String _moves;

  String get id => _id;
  String get name => boulderItem[keyName];
  Angle get angle => Angle.byID(boulderItem[keyAngle]);
  Grade get grade => Grade.byID(boulderItem[keyGrade]);
  String get angleUI => angle.label;
  String get gradeUI => grade.label;
  int get stars => boulderItem[keyStars].toInt();
  Moves moves(bool isHorizontalWireing) {
    return _parseMoves(_moves, isHorizontalWireing);
  }

  static _parseMoves(String movesAsString, bool isHorizontalWireing) {
    Moves moves = Moves();

    final regex = RegExp(r'[+/]');
    if (movesAsString.isNotEmpty) {
      List<String> listOfMoves = movesAsString.split(regex);
      if (listOfMoves.isNotEmpty) {
        for (var moveItem in listOfMoves) {
          var ledNbr =
              LEDStripeConnector.ledNumberByName(moveItem, isHorizontalWireing);
          Hold hold = Hold(uiName: moveItem, ledNbr: ledNbr);
          moves.add(hold);
        }
      }
    }

    return moves;
  }
}
