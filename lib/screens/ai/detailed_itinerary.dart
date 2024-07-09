import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripedia/utilties.dart';

import '../components/custom_stepper.dart' as custom_stepper;
import '../../data/models/itinerary.dart';
import 'itineraries.dart';
import '../components/app_bar.dart';

class DetailedItinerary extends StatefulWidget {
  const DetailedItinerary({required this.itinerary, super.key});

  final Itinerary itinerary;

  @override
  State<DetailedItinerary> createState() => _DetailedItineraryState();
}

class _DetailedItineraryState extends State<DetailedItinerary> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    return (width < 1024)
        ? SmallDetailedItinerary(widget: widget)
        : LargeDetailedItinerary(widget: widget);
  }
}

class SmallDetailedItinerary extends StatelessWidget {
  const SmallDetailedItinerary({
    super.key,
    required this.widget,
  });

  final DetailedItinerary widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              collapsedHeight: kToolbarHeight + 20,
              expandedHeight: 240,
              pinned: false,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                expandedTitleScale: 2.25,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //const AppLogo(dimension: 24),
                      Text(
                        widget.itinerary.name,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        '${prettyDate(widget.itinerary.startDate)} - ${prettyDate(widget.itinerary.endDate)}',
                        style: TextStyle(
                          fontSize: 8,
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
                      image: CachedNetworkImageProvider(
                        widget.itinerary.heroUrl,
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
                      onPressed: () => context.go('/'),
                      icon: const Icon(
                        Icons.home_outlined,
                      ),
                    )),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(List.generate(
                  widget.itinerary.dayPlans.length,
                  (day) {
                    var dayPlan = widget.itinerary.dayPlans[day];

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DayTitle(title: 'Day ${dayPlan.dayNum.toString()}'),
                          DayStepper(
                            key: Key('stepper$day'),
                            activities: dayPlan.planForDay,
                          )
                        ]);
                  },
                )),
              ),
            )
          ],
        ),
        bottomNavigationBar: const ShareTrip());
  }
}

class ShareTrip extends StatelessWidget {
  const ShareTrip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var isLarge = MediaQuery.sizeOf(context).width >= 1024;

    if (isLarge) {
      return SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: isLarge
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12))
                        : null,
                    color: isLarge
                        ? Theme.of(context).colorScheme.surfaceContainerLow
                        : null,
                    border: Border(
                        top: BorderSide(
                            color:
                                Theme.of(context).colorScheme.outlineVariant))),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        'Share Trip',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color:
                              Theme.of(context).colorScheme.outlineVariant))),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Text(
                  'Share Trip',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LargeDetailedItinerary extends StatelessWidget {
  const LargeDetailedItinerary({
    super.key,
    required this.widget,
  });

  final DetailedItinerary widget;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: brandedAppBar,
      backgroundColor: colorScheme.surface,
      body: Row(children: [
        const SizedBox.square(
          dimension: 24,
        ),
        ItineraryCard(itinerary: widget.itinerary, onTap: () {}),
        const SizedBox(
          width: 32,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
                elevation: 4.0,
                color: colorScheme.surfaceContainerLowest,
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 48, horizontal: 24),
                    child: ListView(children: [
                      ...List.generate(
                        widget.itinerary.dayPlans.length,
                        (day) {
                          var dayPlan = widget.itinerary.dayPlans[day];

                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayTitle(
                                    title: 'Day ${dayPlan.dayNum.toString()}'),
                                DayStepper(
                                  key: Key('stepper$day'),
                                  activities: dayPlan.planForDay,
                                )
                              ]);
                        },
                      ),
                      const SizedBox.square(
                        dimension: 64,
                      ),
                    ]),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: ShareTrip(),
                  ),
                ])),
          ),
        )

        // ),
      ]),
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

class DayStepper extends StatefulWidget {
  const DayStepper({required this.activities, super.key});

  final List<Activity> activities;

  @override
  State<DayStepper> createState() => _DayStepperState();
}

class _DayStepperState extends State<DayStepper> {
  int activeStep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: custom_stepper.Stepper(
        key: widget.key,
        stepIconWidth: 80,
        stepIconHeight: 80,
        margin: const EdgeInsets.all(0),
        controlsBuilder: (context, details) {
          return const SizedBox.shrink();
        },
        currentStep: activeStep,
        stepIconBuilder: (stepIndex, stepState) {
          if (stepIndex == activeStep) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: FadeInImage(
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: MemoryImage(kTransparentImage),
                image: CachedNetworkImageProvider(
                    widget.activities[activeStep].imageUrl),
              ),
            );
          }
          return Icon(
            Icons.circle,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );
        },
        onStepTapped: (value) {
          setState(() {
            activeStep = value;
          });
        },
        steps: [
          ...List.generate(widget.activities.length, (index) {
            return Step(
              stepStyle: const StepStyle(
                connectorThickness: 0,
                color: Colors.transparent,
              ),
              title: Text(widget.activities[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text(widget.activities[index].ref),
              content: Text(widget.activities[index].description),
            );
          }),
        ],
      ),
    );
  }
}
