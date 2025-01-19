import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class ConsoleLog {
  ConsoleLog._(); // Private constructor to prevent instantiation

  static log(message) {
    // kDebugMode is set, if the application is compiled
    // without: '-Ddart.vm.product=true'
    if (kDebugMode) {
      developer.log(message);
    }
  }
}
