import 'package:flutter/material.dart';
import 'package:tripedia/ai/styles.dart';

import './components/splash_components.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Center(
        child: (shortestSide < Breakpoints.expanded)
            ? const SmallSplashLayout()
            : const LargeSplashLayout(),
      ),
    );
  }
}

class SmallSplashLayout extends StatelessWidget {
  const SmallSplashLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 72),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SplashCards(),
          const SizedBox.square(
            dimension: 16,
          ),
          ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 52, minWidth: 320, maxWidth: 360),
              child: const LegacyFindMyTripButton()),
          const SizedBox.square(
            dimension: 16,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
                maxHeight: 52, minWidth: 320, maxWidth: 360),
            child: const AIDreamTripButton(),
          ),
        ],
      ),
    );
  }
}

class LargeSplashLayout extends StatelessWidget {
  const LargeSplashLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Breakpoints.expanded),
      child: Row(children: [
        const SplashCards(),
        const SizedBox(width: 120),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 52, minWidth: 360, maxWidth: 540),
                child: const LegacyFindMyTripButton()),
            const SizedBox(height: 24),
            ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 52, minWidth: 360, maxWidth: 540),
                child: const AIDreamTripButton())
          ],
        ),
        const SizedBox(width: 120),
      ]),
    );
  }
}
