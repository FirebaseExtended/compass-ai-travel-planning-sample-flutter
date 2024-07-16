import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:compass/ai/common/components.dart';
import './components.dart';

class SmallFormLayout extends StatelessWidget {
  const SmallFormLayout(
      {required this.appBar, required this.children, super.key});

  final AppBar appBar;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GradientTitle('Dream Your\nVacation'),
            const SizedBox.square(
              dimension: 16,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class LargeFormLayout extends StatelessWidget {
  const LargeFormLayout(
      {required this.appBar, required this.children, super.key});

  final AppBar appBar;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayXLTextTheme = GoogleFonts.rubikTextTheme()
        .displayLarge
        ?.copyWith(
            fontSize: 90, fontWeight: FontWeight.w900, fontFamily: "Rubik");

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const AppLogo(dimension: 72),
                    GradientTitle(
                      "Dream Your Vacation",
                      textStyle: displayXLTextTheme,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
            const SizedBox(
              width: 32,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 48, bottom: 48, right: 32),
                child: Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerLowest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: children),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
