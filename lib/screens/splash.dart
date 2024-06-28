import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => context.go('/legacy'),
            child: const Text('Find my dream trip.'),
          ),
          TextButton(
            onPressed: () => context.go('/ai'),
            child: const Text('Plan my dream trip with AI'),
          )
        ],
      ),
    );
  }
}
