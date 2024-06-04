import 'package:flutter/material.dart';
import '../../../common/components.dart';

AppBar buildTransparentAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.white),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    ),
    actionsIconTheme: const IconThemeData(color: Colors.black12),
    actions: const [HomeButton()],
  );
}
