import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../branding.dart';

PreferredSizeWidget get brandedAppBar {
  return AppBar(
    backgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.white),
    actionsIconTheme: const IconThemeData(color: Colors.black12),
    actions: const [HomeButton()],
  );
}

class BackButton extends StatelessWidget {
  const BackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        onPressed: () => context.go('/'),
        icon: const Icon(
          Icons.home_outlined,
          color: Colors.black87,
        ),
      ),
    );
  }
}
