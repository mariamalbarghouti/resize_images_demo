// For making GetX log
import 'package:flutter/foundation.dart';

mixin Logger {
  static void write(String text, {bool isError = false}) {
    Future.microtask(() {
    if(kDebugMode) print('** $text. isError: [$isError]');
    });
  }
}