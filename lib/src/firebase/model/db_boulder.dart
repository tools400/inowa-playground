import '/src/firebase/angle_enum.dart';
import '/src/firebase/grade_enum.dart';
import 'package:uuid/uuid.dart';

// TODO: kann man das noch brauchen?
class Boulder {
  Boulder(
      {uuid, required String name, required Angle angle, required Grade grade})
      : _grade = grade,
        _angle = angle,
        _name = name,
        _id = uuid ?? Uuid().v7();

  final String _id;
  final String _name;
  final Angle _angle;
  final Grade _grade;

  String get id => _id;
  String get name => _name;
  Angle get angle => _angle;
  Grade get grade => _grade;
}
