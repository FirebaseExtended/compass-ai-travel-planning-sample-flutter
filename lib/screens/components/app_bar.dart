import 'package:flutter/material.dart';

import '../branding.dart';

AppBar get brandedAppBar {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {},
    ),
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
              Icons.home_outlined,
            ),
          )),
    ],
  );
}
