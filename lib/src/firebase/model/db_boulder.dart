import 'package:inowa/src/firebase/angle_enum.dart';
import 'package:inowa/src/firebase/grade_enum.dart';
import 'package:uuid/uuid.dart';

// TODO: kann man das noch brauchen?
class Boulder {
  Boulder(
      {uuid, required String name, required Angle angle, required Grade grade})
      : _grade = grade,
        _angle = angle,
        _name = name,
        _id = uuid ?? Uuid().v7();

  String _id;
  String _name;
  Angle _angle;
  Grade _grade;

  String get id => _id;
  String get name => _name;
  Angle get angle => _angle;
  Grade get grade => _grade;
}
