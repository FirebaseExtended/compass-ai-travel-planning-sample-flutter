import 'package:flutter/material.dart';
import 'package:compass/ai/itineraries_feature/presentation/components/components.dart';
import 'package:compass/ai/styles.dart';
import '../../../activities_feature/models/activity.dart';
import '../../../form_feature/models/travel_query.dart';
import '../../../results/business/model/destination.dart';
import 'package:compass/common/utilties.dart';
import '../../../../common/services/navigation.dart';
import 'package:compass/legacy/common/widgets/tag_chip.dart';
import 'package:compass/legacy/activities_feature/presentation/activity_list_tile.dart';

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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${prettyDate(query.dates.start.toString())} - ${prettyDate(query.dates.end.toString())}',
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
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
            delegate: SliverChildListDelegate(
              buildActivitiesList(destination, activities),
            ),
          ),
        )
      ],
    );
  }
}

class LargeLegacyItinerary extends StatelessWidget {
  const LargeLegacyItinerary(
      {required this.query,
      required this.destination,
      required this.activities,
      super.key});

  final TravelQuery query;
  final Destination destination;
  final Set<LegacyActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Breakpoints.large),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: ItineraryCover(
                  destination: destination,
                  query: query,
                ),
              ),
              const SizedBox.square(
                dimension: 32,
              ),
              SizedBox(
                width: 500,
                child: ListView(
                  children: [
                    Text(
                      destination.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${prettyDate(query.dates.start.toString())} - ${prettyDate(query.dates.end.toString())}',
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    ...buildActivitiesList(destination, activities),
                    const ShareTripButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItineraryCover extends StatelessWidget {
  const ItineraryCover(
      {required this.destination, required this.query, super.key});

  final Destination destination;
  final TravelQuery query;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                colors: [Color.fromARGB(165, 0, 0, 0), Colors.transparent],
                stops: [0.2, 1]),
          ),
        ),
      ),
    );
  }
}

List<Widget> buildActivitiesList(
    Destination destination, Set<LegacyActivity> activities) {
  return [
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
  ];
}
