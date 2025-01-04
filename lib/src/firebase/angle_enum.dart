enum Angle {
  angle7_5(label: '7.5', id: 7.5),
  angle15(label: '15', id: 15),
  angle30(label: '30', id: 30),
  angle45(label: '45', id: 45);

  const Angle({
    required this.id,
    required this.label,
  });

  final double id;
  final String label;

  static Angle byID(double id) {
    for (int i = 0; i < values.length; i++) {
      Angle angle = values[i];
      if (angle.id == id) {
        return angle;
      }
    }
    throw ArgumentError.value(id, 'id', 'Invalid angle.');
  }
}
