import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripedia/ai/styles.dart';

class AIDreamTripButton extends StatelessWidget {
  const AIDreamTripButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color(0xff9A62E1).withOpacity(0.3),
          spreadRadius: 8,
          blurRadius: 16,
        )
      ]),
      child: TextButton(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          backgroundBuilder: (context, states, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: brandGradientColorList,
                  stops: const [
                    0.0,
                    0.20,
                    0.9,
                  ],
                ),
              ),
              child: child,
            );
          },
        ),
        onPressed: () => context.go('/ai'),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Plan my dream trip with AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LegacyFindMyTripButton extends StatelessWidget {
  const LegacyFindMyTripButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shadowColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.primaryContainer),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        backgroundColor: const WidgetStatePropertyAll(
          Colors.black,
        ),
      ),
      onPressed: () => context.go('/legacy'),
      child:
          const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Text(
            'Find my dream trip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ]),
    );
  }
}

class SplashCards extends StatelessWidget {
  const SplashCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Image.asset('assets/images/splash-image.png'));
  }
}
