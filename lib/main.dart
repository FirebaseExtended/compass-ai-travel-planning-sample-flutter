import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/ai/itineraries_feature/models/itinerary.dart';
import 'package:go_router/go_router.dart';
import 'package:tripedia/legacy/activities_feature/presentation/activities_screen.dart';
import 'package:tripedia/legacy/activities_feature/view_models/activities_viewmodel.dart';
import 'package:tripedia/legacy/activities_feature/models/activity.dart';
import 'package:tripedia/legacy/detailed_itinerary/legacy_itinerary.dart';
import 'package:tripedia/legacy/legacy_form.dart';
import 'package:tripedia/legacy/results/presentation/results_screen.dart';
import 'package:tripedia/legacy/results/presentation/results_viewmodel.dart';
import 'package:tripedia/common/presentation/splash.dart';
import 'package:tripedia/common/utilties.dart';

import 'ai/form_feature/presentation/form.dart';
import 'ai/itineraries_feature/presentation/itineraries.dart';
import 'ai/form_feature/presentation/dreaming.dart';
import 'ai/itineraries_feature/view_models/intineraries_viewmodel.dart';
import 'legacy/results/business/usecases/search_destination_usecase.dart';
import 'legacy/results/data/destination_repository_local.dart';
import 'legacy/activities_feature/data/search_activity_usecase.dart';
import 'legacy/activities_feature/data/legacy_activity_repository_local.dart';

void main() {
  Animate.restartOnHotReload = true;
  runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Splash()),
    ShellRoute(
      builder: (context, state, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ResultsViewModel>(
              create: (_) => ResultsViewModel(
                searchDestinationUsecase: SearchDestinationUsecase(
                    repository: DestinationRepositoryLocal()),
              ),
            ),
            ChangeNotifierProvider<ActivitiesViewModel>(
              create: (_) => ActivitiesViewModel(
                searchActivityUsecase: SearchActivityUsecase(
                    repository: ActivityRepositoryLocal()),
              ),
            ),
            ChangeNotifierProvider<TravelPlan>(
              create: (_) => TravelPlan(),
            ),
          ],
          child: Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.black,
                dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
              ),
            ),
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/legacy',
          builder: (context, state) => const LegacyFormScreen(),
          routes: [
            GoRoute(
              path: 'results',
              builder: (context, state) => const ResultsScreen(),
            ),
            GoRoute(
              path: 'activities',
              builder: (context, state) => const ActivitiesScreen(),
            ),
            GoRoute(
              path: 'itinerary',
              builder: (context, state) => const LegacyItinerary(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/ai',
      builder: (context, state) => const FormScreen(),
      routes: [
        GoRoute(
          path: 'dreaming',
          builder: (context, state) => const DreamingScreen(),
        ),
        GoRoute(
          path: 'itineraries',
          builder: (context, state) => const Itineraries(),
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
