import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/legacy/activities_feature/presentation/activity_list_tile.dart';
import 'package:tripedia/legacy/common/widgets/tag_chip.dart';
import 'package:tripedia/common/utilties.dart';

import '../../activities_feature/models/activity.dart';
import '../../../common/services/navigation.dart';
import './components/components.dart';
import '../../form_feature/models/travel_query.dart';
import '../../results/business/model/destination.dart';

class LegacyItinerary extends StatefulWidget {
  const LegacyItinerary({super.key});

  @override
  State<LegacyItinerary> createState() => _LegacyItineraryState();
}

class _LegacyItineraryState extends State<LegacyItinerary> {
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
        body: SmallLegacyItinerary(
          query: query,
          destination: destination,
          activities: activities,
        ),
        bottomNavigationBar: const SafeArea(
          child: ShareTripButton(),
        ),
      ),
    );
  }
}

class SmallLegacyItinerary extends StatelessWidget {
  const SmallLegacyItinerary(
      {required this.query,
      required this.destination,
      required this.activities,
      super.key});

  final TravelQuery query;
  final Destination destination;
  final Set<LegacyActivity> activities;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 240,
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
            centerTitle: true,
            expandedTitleScale: 2.25,
            title: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    '${prettyDate(query.dates.start.toString())} - ${prettyDate(query.dates.end.toString())}',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onPrimary,
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
                  height: 210,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.topCenter,
                        colors: [
                          Color.fromARGB(165, 0, 0, 0),
                          Colors.transparent
                        ],
                        stops: [
                          0.2,
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
                backgroundColor: const WidgetStatePropertyAll(
                    Color.fromARGB(170, 148, 136, 136)),
              ),
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onPrimary,
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
                    backgroundColor: const WidgetStatePropertyAll(
                        Color.fromARGB(170, 148, 136, 136)),
                  ),
                  onPressed: () => goToSplashScreen(context),
                  icon: Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Text(
                  destination.knownFor,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              SizedBox(
                height: 30,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: destination.tags.length,
                  itemBuilder: (context, index) =>
                      DetailTagChip(tag: destination.tags[index]),
                  separatorBuilder: (context, index) {
                    return const SizedBox.square(
                      dimension: 8,
                    );
                  },
                ),
              ),
              const SizedBox.square(
                dimension: 24,
              ),
              const Text(
                'Your Chosen Activities',
                style: TextStyle(fontSize: 18),
              ),
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
    );
  }
}

class LargeLegacyItinerary extends StatelessWidget {
  const LargeLegacyItinerary({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
