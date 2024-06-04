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
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  // Note: original Figma file uses Nikkei Maru
  // which is not available on GoogleFonts
  static final cardTitleStyle = GoogleFonts.rubik(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 15.0,
      color: Colors.white,
      letterSpacing: 1,
      shadows: [
        // Helps to read the text a bit better
        Shadow(
          blurRadius: 3.0,
          color: Colors.black,
        )
      ],
    ),
  );

  // Note: original Figma file uses Google Sans
  // which is not available on GoogleFonts
  static final chipTagStyle = GoogleFonts.openSans(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: Colors.white,
      textBaseline: TextBaseline.alphabetic,
    ),
  );
}
