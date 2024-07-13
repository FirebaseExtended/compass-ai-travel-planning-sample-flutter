import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './itineraries_feature/view_models/intineraries_viewmodel.dart';
import './form_feature/presentation/form.dart';
import './itineraries_feature/models/itinerary.dart';

class AIApp extends StatefulWidget {
  const AIApp({super.key});

  @override
  State<AIApp> createState() => _AIAppState();
}

class _AIAppState extends State<AIApp> {
  final _aiNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ItinerariesViewModel(ItineraryClient()),
      child: Navigator(
        key: _aiNavKey,
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) => const FormScreen(),
        ),
      ),
    );
  }
}
