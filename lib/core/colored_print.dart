// For Printing A Color Logger
import 'package:flutter/foundation.dart';

void coloredPrint(String msg, {LogColors color = LogColors.yellow}) {
  if (kDebugMode) {
    print('${_convertEnumToValue(color)} $msg\x1B[0m');
  }
}

// Log Colors
enum LogColors { black, red, green, yellow, blue, magenta, cyan, white }

// LogColor.black.
// Convert Enum To Color
String _convertEnumToValue(LogColors color) {
  switch (color) {
    case LogColors.black:
      return "\x1B[30m";
    case LogColors.red:
      return "\x1B[31m";
    case LogColors.green:
      return "\x1B[32m";
    case LogColors.yellow:
      return "\x1B[33m";
    case LogColors.blue:
      return "\x1B[34m";
    case LogColors.magenta:
      return "\x1B[35m";
    case LogColors.cyan:
      return "\x1B[36m";
    default:
      return "\x1B[37m";
  }
}
