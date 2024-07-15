import 'package:flutter/material.dart';

class PlanTripButton extends StatelessWidget {
  const PlanTripButton(
      {required this.loading, required this.onPressed, super.key});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextButton(
          style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.transparent;
                }

                if (states.contains(WidgetState.pressed)) {
                  return Theme.of(context).colorScheme.primaryFixedDim;
                }

                return Theme.of(context).colorScheme.primary;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return loading
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary;
              })),
          onPressed: loading ? null : onPressed,
          child: Text(
            loading ? 'Loading...' : 'Plan my dream trip',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    ]);
  }
}
