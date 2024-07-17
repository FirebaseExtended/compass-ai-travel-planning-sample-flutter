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
            backgroundColor:
                WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
            foregroundColor:
                WidgetStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
          ),
          onPressed: loading ? null : onPressed,
          child: loading
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )
              : const Text(
                  'Plan my dream trip',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    ]);
  }
}
