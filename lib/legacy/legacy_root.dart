import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/legacy/activities_feature/view_models/activities_viewmodel.dart';
import 'package:tripedia/legacy/activities_feature/models/activity.dart';
import 'package:tripedia/legacy/results/presentation/results_viewmodel.dart';
import './results/business/usecases/search_destination_usecase.dart';
import './results/data/destination_repository_local.dart';
import './activities_feature/data/search_activity_usecase.dart';
import './activities_feature/data/legacy_activity_repository_local.dart';
import 'package:tripedia/legacy/form_feature/presentation/legacy_form.dart';

class LegacyApp extends StatefulWidget {
  const LegacyApp({super.key});

  @override
  State<LegacyApp> createState() => _LegacyAppState();
}

class _LegacyAppState extends State<LegacyApp> {
  final _legacyNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
            searchActivityUsecase:
                SearchActivityUsecase(repository: ActivityRepositoryLocal()),
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
        child: Navigator(
          key: _legacyNavKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const LegacyFormScreen(),
          ),
        ),
      ),
    );
  }
}
