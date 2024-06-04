import 'package:flutter/material.dart';

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
