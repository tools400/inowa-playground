import 'package:inowa/src/led/hold.dart';

class Moves {
  Moves();

  final List<Hold> _moves = [];
  final delimiterStartHolds = '+';
  final delimiterHolds = '/';

  get isEmpty => _moves.isEmpty;

  get isNotEmpty => _moves.isNotEmpty;

  get all => _moves;

  add(Hold move) {
    _moves.add(move);
  }

  removeLast() {
    _moves.removeLast();
  }

  clear() {
    _moves.clear();
  }

  get startHolds {
    if (_moves.isEmpty) {
      return '';
    }
    return _holds(1, 2, delimiterStartHolds);
  }

  get intermediateHolds {
    if (_moves.isEmpty || _moves.length < 3) {
      return '';
    }
    return _holds(3, _moves.length - 1, delimiterHolds);
  }

  get topHold {
    if (_moves.isEmpty || _moves.length < 3) {
      return '';
    }
    return _holds(_moves.length, _moves.length, delimiterHolds);
  }

  get allHolds {
    return toString();
  }

  _holds(int from, int to, String delimiter) {
    var fromOffset = from <= _moves.length ? from - 1 : 0;
    var toOffset = to <= _moves.length ? to - 1 : _moves.length - 1;

    var buffer = new StringBuffer();
    for (int i = fromOffset; i < toOffset + 1; i++) {
      if (buffer.isNotEmpty) {
        buffer.write(delimiter);
      }
      buffer.write(_moves[i].uiName);
    }
    return buffer.toString();
  }

  @override
  String toString() {
    var buffer = StringBuffer();

    var tHolds = startHolds;
    if (tHolds.isNotEmpty) {
      buffer.write(tHolds);
    }

    tHolds = intermediateHolds;
    if (tHolds.isNotEmpty) {
      buffer.write('/');
      buffer.write(tHolds);
    }

    tHolds = topHold;
    if (tHolds.isNotEmpty) {
      buffer.write('/');
      buffer.write(tHolds);
    }

    return buffer.toString();
  }
}
