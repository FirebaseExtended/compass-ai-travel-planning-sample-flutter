import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/ai/ai_root.dart';
import 'package:tripedia/ai/itineraries_feature/models/itinerary.dart';
import 'package:go_router/go_router.dart';
import 'package:tripedia/common/presentation/splash.dart';
import 'package:tripedia/common/utilties.dart';
import 'package:tripedia/legacy/legacy_root.dart';

import 'ai/form_feature/presentation/form.dart';
import 'ai/itineraries_feature/view_models/intineraries_viewmodel.dart';

void main() {
  Animate.restartOnHotReload = true;
  runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Splash(),
      routes: [
        GoRoute(
          path: 'ai',
          builder: (context, state) => const AIApp(),
        ),
        GoRoute(
          path: 'legacy',
          builder: (context, state) => const LegacyApp(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      routerConfig: _router,
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
