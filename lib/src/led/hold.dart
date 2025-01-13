class Hold {
  const Hold({required uiName, ledNbr})
      : _uiName = uiName,
        _ledNbr = ledNbr;

  final String _uiName;
  final int _ledNbr;

  get uiName => _uiName;
  get ledNbr => _ledNbr;

  @override
  String toString() {
    return _uiName;
  }
}
