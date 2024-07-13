import 'package:flutter/material.dart';
import '../../../common/services/navigation.dart';
import 'package:tripedia/ai/styles.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: IconButton(
        style: appBarSquareButtonStyle,
        onPressed: () => goToSplashScreen(context),
        icon: const Icon(
          Icons.home_outlined,
        ),
      ),
    );
  }
}
