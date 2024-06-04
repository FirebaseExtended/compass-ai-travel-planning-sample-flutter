import 'package:flutter/material.dart';

class ShareTripButton extends StatelessWidget {
  const ShareTripButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceTint,
          border: Border(
              top: BorderSide(color: Theme.of(context).colorScheme.outline))),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.surface,
          ),
        ),
        child: Text(
          'Share Trip',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
