enum Grade {
  grade2(label: '2', id: '2.0.0'),
  grade3a(label: '3a', id: '3.a.0'),
  grade3b(label: '3b', id: '3.b.0'),
  grade3c(label: '3c', id: '3.c.0'),
  grade4a(label: '4a', id: '4.a.0'),
  grade4b(label: '4b', id: '4.b.0'),
  grade4c(label: '4c', id: '4.c.0'),
  grade5a(label: '5a', id: '5.a.0'),
  grade5aPlus(label: '5a+', id: '5.a.1'),
  grade5b(label: '5b', id: '5.b.0'),
  grade5bPlus(label: '5b+', id: '5.b.1'),
  grade5c(label: '5c', id: '5.c.0'),
  grade5cPlus(label: '5c+', id: '5.c.1'),
  grade6a(label: '6a', id: '6.a.0'),
  grade6aPlus(label: '6a+', id: '6.a.1'),
  grade6b(label: '6b', id: '6.b.0'),
  grade6bPlus(label: '6b+', id: '6.b.1'),
  grade6c(label: '6c', id: '6.c.0'),
  grade6cPlus(label: '6c+', id: '6.c.1'),
  grade7a(label: '7a', id: '7.a.0'),
  grade7aPlus(label: '7a+', id: '7.a.1'),
  grade7b(label: '7b', id: '7.b.0'),
  grade7bPlus(label: '7b+', id: '7.b.1'),
  grade7c(label: '7c', id: '7.c.0'),
  grade7cPlus(label: '7c+', id: '7.c.1'),
  grade8a(label: '8a', id: '8.a.0'),
  grade8aPlus(label: '8a+', id: '8.a.1'),
  grade8b(label: '8b', id: '8.b.0'),
  grade8bPlus(label: '8b+', id: '8.b.1'),
  grade8c(label: '8c', id: '8.c.0'),
  grade8cPlus(label: '8c+', id: '8.c.1');

  const Grade({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;

  static Grade byID(String id) {
    for (int i = 0; i < values.length; i++) {
      Grade angle = values[i];
      if (angle.id == id) {
        return angle;
      }
    }
    throw ArgumentError.value(id, 'id', 'Invalid angle.');
  }
}
