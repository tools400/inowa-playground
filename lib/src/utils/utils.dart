// ignore: avoid_print
import 'package:intl/intl.dart';

class Utils {
  Utils._(); // Private constructor to prevent instantiation

  void log(String text) => print("[FlutterReactiveBLEApp] $text");

  static DateTime now() {
    return DateTime.now();
  }

  static String year() {
    var formatter = DateFormat('yyyy');
    return formatter.format(now());
  }
}
