import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/screens/legacy/activities/activity_list_tile.dart';
import 'package:tripedia/screens/legacy/common/widgets/tag_chip.dart';
import 'package:tripedia/utilties.dart';

import '../activities/activity.dart';

class LegacyItinerary extends StatefulWidget {
  const LegacyItinerary({super.key});

  @override
  State<LegacyItinerary> createState() => _LegacyItineraryState();
}

class _LegacyItineraryState extends State<LegacyItinerary> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              collapsedHeight: kToolbarHeight + 20,
              expandedHeight: 240,
              pinned: false,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                expandedTitleScale: 2.25,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        '${prettyDate(query.dates.start.toString())} - ${prettyDate(query.dates.end.toString())}',
                        style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: destination.tags.length,
                          itemBuilder: (context, index) =>
                              TagChip(tag: destination.tags[index]),
                        ),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        destination.imageUrl,
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 240,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            colors: [
                              Color.fromARGB(165, 0, 0, 0),
                              Colors.transparent
                            ],
                            stops: [
                              0,
                              1
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.grey[300]),
                      ),
                      onPressed: () => context.go('/ai'),
                      icon: const Icon(
                        Icons.home_outlined,
                      ),
                    )),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(destination.knownFor),
                  const Text('Your Chosen Activities'),
                  ...List.generate(
                    activities.length,
                    (activityIndex) {
                      return ActivityDetailTile(
                        activity: activities.elementAt(activityIndex),
                      );
                    },
                  )
                ]),
              ),
            )
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceTint,
                border: Border(
                    top: BorderSide(
                        color: Theme.of(context).colorScheme.outline))),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surface,
                ),
              ),
              child: Text(
                'Share Trip',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
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
