import 'package:flutter/material.dart';
import '../../common/services/navigation.dart';
import 'package:tripedia/ai/styles.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({required this.dimension, super.key});

  final double dimension;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Image(
        width: dimension,
        height: dimension,
        image: const AssetImage('assets/images/stars.png'),
      ),
    );
  }
}

class BrandGradientShaderMask extends StatelessWidget {
  const BrandGradientShaderMask({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          LinearGradient(colors: brandGradientColorList, stops: const [
        0.0,
        0.05,
        0.9,
      ]).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}

PreferredSizeWidget get brandedAppBar {
  return AppBar(
    backgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.white),
    actionsIconTheme: const IconThemeData(color: Colors.black12),
    actions: const [HomeButton()],
  );
}

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
