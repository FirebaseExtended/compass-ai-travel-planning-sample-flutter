import 'package:flutter/material.dart';

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
