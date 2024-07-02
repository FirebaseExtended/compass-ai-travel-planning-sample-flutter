import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/screens/legacy/activities/activity_list_tile.dart';
import 'package:tripedia/screens/legacy/detailed_itinerary/legacy_itinerary.dart';
import '../activities/activities_viewmodel.dart';

import '../activities/activity.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    //print(context.watch<TravelPlan>().query.toString());
    var activities = context.watch<ActivitiesViewModel>().activities;

    var morningActivities = activities.where((activity) {
      return activity.timeOfDay == 'morning';
    }).toList();

    var afternoonActivities = activities.where((activity) {
      return activity.timeOfDay == 'afternoon';
    }).toList();

    var eveningActivities = activities.where((activity) {
      return activity.timeOfDay == 'evening';
    }).toList();

    var anyTimeActivities = activities.where((activity) {
      return activity.timeOfDay == 'any';
    }).toList();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Activities'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
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
                onPressed: () => context.go('/'),
                icon: const Icon(
                  Icons.home_outlined,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'Morning',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ...List.generate(morningActivities.length, (index) {
                return ActivityTile(
                  activity: morningActivities[index],
                );
              }),
              SizedBox.square(
                dimension: 16,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'Afternoon',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ...List.generate(afternoonActivities.length, (index) {
                return ActivityTile(
                  activity: afternoonActivities[index],
                );
              }),
              SizedBox.square(
                dimension: 16,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'Evening',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ...List.generate(eveningActivities.length, (index) {
                return ActivityTile(
                  activity: eveningActivities[index],
                );
              }),
              SizedBox.square(
                dimension: 16,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'Anytime',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ...List.generate(anyTimeActivities.length, (index) {
                return ActivityTile(
                  activity: anyTimeActivities[index],
                );
              }),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.watch<TravelPlan>().activities.length} Selected',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push(
                      '/legacy/itinerary',
                    );

                    /*LegacyItinerary(
                        travelPlan: TravelPlan(
                          query: TravelQuery(
                              location: 'Europe',
                              dates: DateTimeRange(
                                  start: DateTime.now(), end: DateTime.now()),
                              numPeople: 2),
                        ),
                        destination: Destination(),
          
                      );*/
                  },
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 18,
                      ),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
