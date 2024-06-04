import 'package:flutter/material.dart';
import '../branding.dart';
import '../components/app_bar.dart';

class DreamingScreen extends StatefulWidget {
  const DreamingScreen({super.key});

  @override
  State<DreamingScreen> createState() => _DreamingScreenState();
}

class _DreamingScreenState extends State<DreamingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff352F34),
      appBar: brandedAppBar,
      body: Stack(children: [
        Positioned(
          top: 0,
          right: 0,
          child: Image.network(
              width: 300, 'https://rstr.in/google/tripedia/x9b8ZmlQhod'),
        ),
        Positioned(
          top: 100,
          left: 0,
          child: Image.network(
              width: 300, 'https://rstr.in/google/tripedia/llRpA9RuvTy'),
        ),
        Positioned(
          top: 400,
          right: 0,
          child: Image.network(
              width: 300, 'https://rstr.in/google/tripedia/Y292jg7Wr69'),
        ),
        Positioned(
          top: 600,
          left: 0,
          child: Image.network(
              width: 300, 'https://rstr.in/google/tripedia/ANNOvZaekFJ'),
        ),
        Row(
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
        ),
      ]),
    );
  }
}
