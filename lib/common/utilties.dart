// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

// Date Formatters

final DateFormat dateFormatter = DateFormat('MMMM dd, yyyy');
final DateFormat shortenedDateFormatter = DateFormat('MMM dd, yyyy');
final DateFormat datesWithSlash = DateFormat('MM/dd/yyyy');

String prettyDate(String dateStr) {
  return dateFormatter.format(DateTime.parse(dateStr));
}

String shortenedDate(String dateStr) {
  return shortenedDateFormatter.format(DateTime.parse(dateStr));
}

// App Behaviors

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
