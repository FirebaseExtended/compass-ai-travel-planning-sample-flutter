import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/data/models/itinerary.dart';
import 'package:go_router/go_router.dart';
import 'package:tripedia/screens/ai/detailed_itinerary.dart';
import 'package:tripedia/screens/ai/load_itineraries.dart';

import 'screens/ai/form.dart';
import 'screens/ai/itineraries.dart';
import 'screens/ai/dreaming.dart';
import 'view_models/intineraries_viewmodel.dart';

void main() {
  Animate.restartOnHotReload = true;
  runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FormScreen(),
      routes: [
        GoRoute(
          path: 'itineraries',
          builder: (context, state) => const LoadItinerariesScreen(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ItinerariesViewModel(ItineraryClient()),
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Tripedia',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff7B4E7F),
          ),
          textTheme: GoogleFonts.rubikTextTheme(),
          useMaterial3: true,
        ),
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
/*
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
    return ChangeNotifierProvider(
      create: (context) => ItinerariesViewModel(ItineraryClient()),
      child: PageView(
        controller: pageController,
        children: const [
          FormScreen(),
          DreamingScreen(),
          Itineraries(),
          //DetailedItinerary(),
        ],
      ),
    );
  }
}*/
