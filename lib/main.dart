import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripedia/screens/ai/dreaming.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'screens/ai/form.dart';

void main() {
  Animate.restartOnHotReload = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripedia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff7B4E7F),
        ),
        textTheme: GoogleFonts.rubikTextTheme(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(controller: pageController, children: const [
      FormScreen(),
      DreamingScreen(),
    ]);
  }
}
