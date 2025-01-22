import 'package:inowa/src/led/hold.dart';

class Moves {
  Moves();

  final List<Hold> _moves = [];
  final delimiterStartHolds = '+';
  final delimiterHolds = '/';

  bool get isEmpty => _moves.isEmpty;

  bool get isNotEmpty => _moves.isNotEmpty;

  List<Hold> get all => _moves;

  List<Hold> get startHolds {
    return _holds(1, 2);
  }

  List<Hold> get intermediateHolds {
    if (_moves.isEmpty || _moves.length < 3) {
      return [];
    }
    return _holds(3, _moves.length - 1);
  }

  List<Hold> get topHold {
    if (_moves.isEmpty || _moves.length < 3) {
      return [];
    }
    return _holds(_moves.length, _moves.length);
  }

  List<Hold> _holds(int from, int to) {
    var fromOffset = from <= _moves.length ? from - 1 : 0;
    var toOffset = to <= _moves.length ? to - 1 : _moves.length - 1;

    List<Hold> holds = [];
    for (int i = fromOffset; i < toOffset + 1; i++) {
      holds.add(_moves[i]);
    }
    return holds;
  }

  add(Hold move) {
    _moves.add(move);
  }

  removeLast() {
    _moves.removeLast();
  }

  clear() {
    _moves.clear();
  }

  String get startHoldsAsString {
    return _holdsAsString(startHolds, delimiterStartHolds);
  }

  String get intermediateHoldsAsString {
    return _holdsAsString(intermediateHolds, delimiterHolds);
  }

  String get topHoldAsString {
    return _holdsAsString(topHold, delimiterHolds);
  }

  String get allHoldsAsString {
    var buffer = StringBuffer();

    var tHolds = startHoldsAsString;
    if (tHolds.isNotEmpty) {
      buffer.write(tHolds);
    }

    tHolds = intermediateHoldsAsString;
    if (tHolds.isNotEmpty) {
      buffer.write('/');
      buffer.write(tHolds);
    }

    tHolds = topHoldAsString;
    if (tHolds.isNotEmpty) {
      buffer.write('/');
      buffer.write(tHolds);
    }

    return buffer.toString();
  }

  String _holdsAsString(List<Hold> holds, String delimiter) {
    var buffer = StringBuffer();
    for (int i = 0; i < holds.length; i++) {
      if (buffer.isNotEmpty) {
        buffer.write(delimiter);
      }
      buffer.write(_moves[i].uiName);
    }
    return buffer.toString();
  }

  @override
  String toString() {
    return allHoldsAsString;
  }
}
