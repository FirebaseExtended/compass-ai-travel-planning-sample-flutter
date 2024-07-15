import 'package:flutter/material.dart';

class NoItinerariesMessage extends StatelessWidget {
  const NoItinerariesMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_outlined,
            color: Theme.of(context).colorScheme.error,
            size: 72,
          ),
          const SizedBox.square(
            dimension: 8,
          ),
          const Center(
              child: Text(
            textAlign: TextAlign.center,
            'Something went wrong and we don\'t have\nany trips for you. Please try again!',
          )),
        ],
      ),
    );
  }
}
