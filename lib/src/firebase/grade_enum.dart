enum Grade {
  grade2(label: '2', id: 200),
  grade3a(label: '3a', id: 310),
  grade3b(label: '3b', id: 320),
  grade3c(label: '3c', id: 330),
  grade4a(label: '4a', id: 410),
  grade4b(label: '4b', id: 420),
  grade4c(label: '4c', id: 430),
  grade5a(label: '5a', id: 510),
  grade5aPlus(label: '5a+', id: 511),
  grade5b(label: '5b', id: 520),
  grade5bPlus(label: '5b+', id: 521),
  grade5c(label: '5c', id: 530),
  grade5cPlus(label: '5c+', id: 531),
  grade6a(label: '6a', id: 610),
  grade6aPlus(label: '6a+', id: 611),
  grade6b(label: '6b', id: 620),
  grade6bPlus(label: '6b+', id: 621),
  grade6c(label: '6c', id: 630),
  grade6cPlus(label: '6c+', id: 631),
  grade7a(label: '7a', id: 710),
  grade7aPlus(label: '7a+', id: 711),
  grade7b(label: '7b', id: 720),
  grade7bPlus(label: '7b+', id: 721),
  grade7c(label: '7c', id: 730),
  grade7cPlus(label: '7c+', id: 731),
  grade8a(label: '8a', id: 810),
  grade8aPlus(label: '8a+', id: 811),
  grade8b(label: '8b', id: 820),
  grade8bPlus(label: '8b+', id: 821),
  grade8c(label: '8c', id: 830),
  grade8cPlus(label: '8c+', id: 831);

  const Grade({
    required this.id,
    required this.label,
  });

  final int id;
  final String label;

  static Grade byID(int id) {
    for (int i = 0; i < values.length; i++) {
      Grade angle = values[i];
      if (angle.id == id) {
        return angle;
      }
    }
    throw ArgumentError.value(id, 'id', 'Invalid angle.');
  }
}
