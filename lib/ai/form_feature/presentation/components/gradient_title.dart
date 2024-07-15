import 'package:flutter/material.dart';
import '../../../common/components.dart';

class GradientTitle extends StatelessWidget {
  const GradientTitle(this.title, {this.textStyle, this.textAlign, super.key});

  final String title;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return BrandGradientShaderMask(
      child: Text(
        textAlign: textAlign ?? TextAlign.left,
        style: (textStyle != null)
            ? textStyle
            : TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
        title,
      ),
    );
  }
}
