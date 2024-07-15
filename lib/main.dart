import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tripedia/common/utilties.dart';
import './common/services/navigation.dart';

void main() {
  Animate.restartOnHotReload = true;
  runApp(const CompassApp());
}

class CompassApp extends StatelessWidget {
  const CompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      routerConfig: router,
      title: 'Compass',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff7B4E7F),
        ),
        textTheme: GoogleFonts.rubikTextTheme(),
        useMaterial3: true,
      ),
    );
  }
}
