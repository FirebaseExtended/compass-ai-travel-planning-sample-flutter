import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/legacy/activities_feature/presentation/activity_list_tile.dart';
import 'package:tripedia/legacy/detailed_itinerary/legacy_itinerary.dart';
import '../view_models/activities_viewmodel.dart';

import '../models/activity.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  late List<LegacyActivity> activities;
  late List<LegacyActivity> morningActivities;
  late List<LegacyActivity> afternoonActivities;
  late List<LegacyActivity> eveningActivities;
  late List<LegacyActivity> anyTimeActivities;

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.sizeOf(context).width < 800;
    ;
    activities = context.watch<ActivitiesViewModel>().activities;

    morningActivities = activities.where((activity) {
      return activity.timeOfDay == 'morning';
    }).toList();

    afternoonActivities = activities.where((activity) {
      return activity.timeOfDay == 'afternoon';
    }).toList();

    eveningActivities = activities.where((activity) {
      return activity.timeOfDay == 'evening';
    }).toList();

    anyTimeActivities = activities.where((activity) {
      return activity.timeOfDay == 'any';
    }).toList();

    return PopScope(
      onPopInvoked: (val) {
        context.read<TravelPlan>().clearDestination();
        context.read<TravelPlan>().clearActivities();
      },
      child: Scaffold(
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
          child: isSmall ? _buildSmallUI(context) : _buildLargeUI(context),
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
                    if (context.read<TravelPlan>().activities.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          icon: Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          title: const Text(
                            'No activities selected!',
                          ),
                        ),
                      );
                      return;
                    }
                    context.push(
                      '/legacy/itinerary',
                    );
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
        ),
      ),
    );
  }

  Widget _buildSmallUI(BuildContext context) {
    return ListView(
      children: [
        const Padding(
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
        const SizedBox.square(
          dimension: 16,
        ),
        const Padding(
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
        const SizedBox.square(
          dimension: 16,
        ),
        const Padding(
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
        const SizedBox.square(
          dimension: 16,
        ),
        const Padding(
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
        const SizedBox.square(
          dimension: 16,
        ),
      ],
    );
  }

  Widget _buildCardList(List<LegacyActivity>? list) {
    if (list!.isNotEmpty) {
      List<Object> objects = [];

      for (var la in list) {
        objects.add(la);
        objects.add(const SizedBox(
          width: 16,
        ));
      }

      return SizedBox(
          height: 400,
          width: 500,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(objects.length, (index) {
                if (objects[index] is LegacyActivity) {
                  return ActivityCard(
                    activity: objects[index] as LegacyActivity,
                  );
                } else {
                  return objects[index] as SizedBox;
                }
              }),
            ],
          ));
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildLargeUI(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            'Anytime',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox.square(
          dimension: 8,
        ),
        _buildCardList(anyTimeActivities),
        const SizedBox.square(
          dimension: 16,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            'Morning',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox.square(
          dimension: 8,
        ),
        _buildCardList(morningActivities),
        const SizedBox.square(
          dimension: 16,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            'Afternoon',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox.square(
          dimension: 8,
        ),
        _buildCardList(afternoonActivities),
        const SizedBox.square(
          dimension: 16,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            'Evening',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox.square(
          dimension: 8,
        ),
        _buildCardList(eveningActivities),
        const SizedBox.square(
          dimension: 16,
        ),
      ],
    );
  }
}
