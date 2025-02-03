enum Grade {
  grade2(label: '2', value: 200),
  grade3a(label: '3a', value: 310),
  grade3b(label: '3b', value: 320),
  grade3c(label: '3c', value: 330),
  grade4a(label: '4a', value: 410),
  grade4b(label: '4b', value: 420),
  grade4c(label: '4c', value: 430),
  grade5a(label: '5a', value: 510),
  grade5aPlus(label: '5a+', value: 511),
  grade5b(label: '5b', value: 520),
  grade5bPlus(label: '5b+', value: 521),
  grade5c(label: '5c', value: 530),
  grade5cPlus(label: '5c+', value: 531),
  grade6a(label: '6a', value: 610),
  grade6aPlus(label: '6a+', value: 611),
  grade6b(label: '6b', value: 620),
  grade6bPlus(label: '6b+', value: 621),
  grade6c(label: '6c', value: 630),
  grade6cPlus(label: '6c+', value: 631),
  grade7a(label: '7a', value: 710),
  grade7aPlus(label: '7a+', value: 711),
  grade7b(label: '7b', value: 720),
  grade7bPlus(label: '7b+', value: 721),
  grade7c(label: '7c', value: 730),
  grade7cPlus(label: '7c+', value: 731),
  grade8a(label: '8a', value: 810),
  grade8aPlus(label: '8a+', value: 811),
  grade8b(label: '8b', value: 820),
  grade8bPlus(label: '8b+', value: 821),
  grade8c(label: '8c', value: 830),
  grade8cPlus(label: '8c+', value: 831);

  const Grade({
    required this.value,
    required this.label,
  });

  final int value;
  final String label;

  static Grade get min => values[0];
  static Grade get max => values[values.length - 1];

  static Grade byID(int id) {
    for (int i = 0; i < values.length; i++) {
      Grade angle = values[i];
      if (angle.value == id) {
        return angle;
      }
    }
    throw ArgumentError.value(id, 'id', 'Invalid angle.');
  }
}
