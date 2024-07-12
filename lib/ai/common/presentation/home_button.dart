import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
