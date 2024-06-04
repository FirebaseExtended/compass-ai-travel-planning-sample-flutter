import 'package:flutter/material.dart';
import '../../../common/components.dart';

class DreamingTitleWidget extends StatelessWidget {
  const DreamingTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppLogo(dimension: 38),
            Text(
              'Dreaming',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox.square(
              dimension: 8,
            ),
            const SizedBox(
              width: 150,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ],
    );
  }
}
