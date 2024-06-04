import 'package:flutter/material.dart';

class ShareTripButton extends StatelessWidget {
  const ShareTripButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var isLarge = MediaQuery.sizeOf(context).width >= 1024;

    if (isLarge) {
      return SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: isLarge
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12))
                        : null,
                    color: isLarge
                        ? Theme.of(context).colorScheme.surfaceContainerLow
                        : null,
                    border: Border(
                        top: BorderSide(
                            color:
                                Theme.of(context).colorScheme.outlineVariant))),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        'Share Trip',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color:
                              Theme.of(context).colorScheme.outlineVariant))),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Text(
                  'Share Trip',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
