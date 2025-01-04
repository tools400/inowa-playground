import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '/src/firebase/angle_enum.dart';
import '/src/firebase/grade_enum.dart';

class FbBoulder {
  FbBoulder(QueryDocumentSnapshot<Object?> this.boulderItem)
      : _id = boulderItem[keyID] ?? Uuid().toString();

  static const String keyID = 'id';
  static const String keyName = 'name';
  static const String keyAngle = 'angle';
  static const String keyGrade = 'grade';
  static const String keyStars = 'stars';

  dynamic boulderItem;
  final String _id;

  String get id => _id;
  String get name => boulderItem[keyName];
  Angle get angle => Angle.byID(boulderItem[keyAngle]);
  Grade get grade => Grade.byID(boulderItem[keyGrade]);
  String get angleUI => angle.label;
  String get gradeUI => grade.label;
  int get stars => boulderItem[keyStars].round();
}
