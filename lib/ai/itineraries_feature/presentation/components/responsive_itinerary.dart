import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tripedia/ai/styles.dart';
import '../../models/models.dart';
import 'package:flutter/services.dart';
import '../../../../common/utilties.dart';
import '../../../../common/services/navigation.dart';
import './components.dart';
import '../../../common/components.dart';

class SmallSliverAppBar extends StatelessWidget {
  const SmallSliverAppBar({required this.itinerary, super.key});

  final Itinerary itinerary;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: true,
      ),
      collapsedHeight: kToolbarHeight,
      backgroundColor: Colors.transparent,
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
                itinerary.name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                '${prettyDate(itinerary.startDate)} - ${prettyDate(itinerary.endDate)}',
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
                itinerary.heroUrl,
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
                    colors: [Color.fromARGB(165, 0, 0, 0), Colors.transparent],
                    stops: [0, 1]),
              ),
            ),
          ),
        ),
      ),
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
                backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
              ),
              onPressed: () => goToSplashScreen(context),
              icon: const Icon(
                Icons.home_outlined,
              ),
            )),
      ],
    );
  }
}

List<Widget> buildDayPlanSteppers(Itinerary itinerary) {
  return List.generate(
    itinerary.dayPlans.length,
    (day) {
      var dayPlan = itinerary.dayPlans[day];

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DayTitle(title: 'Day ${dayPlan.dayNum.toString()}'),
        DayStepper(
          key: Key('stepper$day'),
          activities: dayPlan.planForDay,
        )
      ]);
    },
  );
}

class SmallDetailedItinerary extends StatelessWidget {
  const SmallDetailedItinerary({
    super.key,
    required this.itinerary,
  });

  final Itinerary itinerary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SmallSliverAppBar(itinerary: itinerary),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  buildDayPlanSteppers(itinerary),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: const ShareTripButton());
  }
}

class LargeDetailedItinerary extends StatelessWidget {
  const LargeDetailedItinerary({
    super.key,
    required this.itinerary,
  });

  final Itinerary itinerary;

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actionsIconTheme: const IconThemeData(color: Colors.black12),
      actions: const [HomeButton()],
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: colorScheme.surface,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Breakpoints.large),
            child: Row(children: [
              const SizedBox.square(
                dimension: 24,
              ),
              Expanded(
                child: ItineraryCard(itinerary: itinerary, onTap: () {}),
              ),
              const SizedBox(
                width: 32,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
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
                            ...buildDayPlanSteppers(itinerary),
                            const SizedBox.square(
                              dimension: 64,
                            ),
                          ]),
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: ShareTripButton(),
                        ),
                      ])),
                ),
              )
            ]),
          ),
        ));
  }
}
