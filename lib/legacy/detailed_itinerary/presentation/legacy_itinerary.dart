import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:compass/ai/styles.dart';

import '../../activities_feature/models/activity.dart';
import './components/components.dart';
import '../../../common/services/navigation.dart';

class LegacyItinerary extends StatefulWidget {
  const LegacyItinerary({super.key});

  @override
  State<LegacyItinerary> createState() => _LegacyItineraryState();
}

class _LegacyItineraryState extends State<LegacyItinerary> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var displaySmallLayout = width <= Breakpoints.medium;
    var query = context.watch<TravelPlan>().query;
    var destination = context.watch<TravelPlan>().destination;
    var activities = context.watch<TravelPlan>().activities;

    if (query == null || destination == null) {
      return const Placeholder();
    }

    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
          seedColor: Colors.black,
          brightness: Brightness.dark,
        ),
      ),
      child: Scaffold(
        appBar: !displaySmallLayout
            ? AppBar(
                actions: [
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        style: ButtonStyle(
                          side: WidgetStatePropertyAll(
                            BorderSide(color: Colors.grey[300]!),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () => goToSplashScreen(context),
                        icon: const Icon(
                          Icons.home_outlined,
                        ),
                      )),
                  const SizedBox(
                    width: 8,
                  )
                ],
              )
            : null,
        body: displaySmallLayout
            ? SmallLegacyItinerary(
                query: query,
                destination: destination,
                activities: activities,
              )
            : LargeLegacyItinerary(
                query: query, destination: destination, activities: activities),
        bottomNavigationBar: displaySmallLayout
            ? const SafeArea(
                child: ShareTripButton(),
              )
            : null,
      ),
    );
  }
}

class DayTitle extends StatelessWidget {
  const DayTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 0, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
