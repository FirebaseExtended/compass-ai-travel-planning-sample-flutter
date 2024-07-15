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
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: onPressed,
          child: loading
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                )
              : Text(
                  'Plan my dream trip',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    ]);
  }
}
