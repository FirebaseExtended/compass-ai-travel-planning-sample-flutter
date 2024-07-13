import 'package:flutter/material.dart';

import './home_button.dart';

PreferredSizeWidget get brandedAppBar {
  return AppBar(
    backgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.white),
    actionsIconTheme: const IconThemeData(color: Colors.black12),
    actions: const [HomeButton()],
  );
}
