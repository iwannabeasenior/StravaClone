//define function help
import 'package:flutter/material.dart';

class Utility {
  static String? formatTime(TimeOfDay? time) {
    if (time == null) return null;
    return '${time.hour} : ${time.minute}';
  }
  static TimeOfDay formatTimeOfDay(String time) {
    int len = time.length;
    return TimeOfDay(hour: int.parse(time.substring(0, len - 5)), minute: int.parse(time.substring(len - 5, len - 2)));
  }
}