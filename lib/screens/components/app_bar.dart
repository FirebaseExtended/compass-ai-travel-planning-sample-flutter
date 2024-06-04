import 'package:flutter/material.dart';

import '../branding.dart';

AppBar get brandedAppBar {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: const AppLogo(dimension: 38),
    actions: [
      Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
            ),
            onPressed: () => {},
            icon: const Icon(
              Icons.home,
            ),
          )),
    ],
  );
}
