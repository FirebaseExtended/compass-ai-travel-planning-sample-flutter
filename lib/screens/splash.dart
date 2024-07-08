import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.sizeOf(context).width;
    if (shortestSide < 1024) {
      return _buildSmallSplash();
    } else {
      return _buildLargeSplash();
    }
  }

  Widget _buildSmallSplash() {
    return Scaffold(
        body: Center(child:Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 72),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset('assets/images/splash-image.png'),
          ),
          ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 52, minWidth: 320, maxWidth: 360),
              child: FindMyTripButton()),
          const SizedBox.square(
            dimension: 16,
          ),
          ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 52, minWidth: 320, maxWidth: 360),
              child: DreamTripButton()),
        ],
      ),
    )));
  }

  Widget _buildLargeSplash() {
    return Scaffold(
        body: Row(children: [
      Expanded(
        child: Image.asset('assets/images/splash-image.png'),
      ),
      const SizedBox(
        width: 120,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 52, minWidth: 360, maxWidth: 540),
              child: const FindMyTripButton()),
          const SizedBox(height: 24),
          ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 52, minWidth: 360, maxWidth: 540),
              child: const DreamTripButton())
        ],
      ),
      const SizedBox(
        width: 120,
      ),
    ]));
  }
}

class DreamTripButton extends StatelessWidget {
  const DreamTripButton({
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff59B7EC),
                    Color(0xff9A62E1),
                    Color(0xffE66CF9),
                  ],
                  stops: [
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
        onPressed: () => context.push('/ai'),
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

class FindMyTripButton extends StatelessWidget {
  const FindMyTripButton({
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
