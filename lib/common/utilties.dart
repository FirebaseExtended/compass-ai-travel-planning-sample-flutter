import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

final DateFormat dateFormatter = DateFormat('MMMM dd, yyyy');
final DateFormat shortenedDateFormatter = DateFormat('MMM dd, yyyy');

String prettyDate(String dateStr) {
  return dateFormatter.format(DateTime.parse(dateStr));
}

String shortenedDate(String dateStr) {
  return shortenedDateFormatter.format(DateTime.parse(dateStr));
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
