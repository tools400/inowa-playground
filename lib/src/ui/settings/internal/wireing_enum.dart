enum Wireing {
  horizontal(label: 'Horizontal', isHorizontal: true),
  vertical(label: 'Vertikal', isHorizontal: false);

  const Wireing({
    required String label,
    required bool isHorizontal,
  })  : _label = label,
        _isHorizontal = isHorizontal;

  final String _label;
  final bool _isHorizontal;

  String get label => _label;
  bool get isHorizontal => _isHorizontal;
}
