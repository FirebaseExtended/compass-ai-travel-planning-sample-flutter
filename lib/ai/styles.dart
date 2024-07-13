import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Component Styles
ButtonStyle get appBarSquareButtonStyle => ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
      iconColor: const WidgetStatePropertyAll(Colors.black87),
    );

// Whitespace & Padding

// App Theme
ThemeData get compassAITheme => ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff7B4E7F),
      ),
      textTheme: GoogleFonts.rubikTextTheme(),
      useMaterial3: true,
    );
