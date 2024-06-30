import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:tripedia/screens/ai/dreaming.dart';
import 'package:tripedia/screens/ai/form.dart';
import 'package:tripedia/screens/ai/itineraries.dart';

import '../../data/models/itinerary.dart';
import '../../main.dart';
import '../../view_models/intineraries_viewmodel.dart';
import '../ai/detailed_itinerary.dart';
import '../splash.dart';

void main() => runApp(StorybookApp());

class StorybookApp extends StatelessWidget {
  const StorybookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = ItinerariesViewModel(ItineraryClient());
    model.loadItineraries("pizza", null);

    return Storybook(
      initialStory: 'Splash',
      stories: [
        Story(name: 'Splash', builder: (context) => const Splash()),
        Story(
            name: "FormScreen",
            description: "FormScreen",
            builder: (context) {
              return const MyApp();
            }),
        Story(
            name: "Dreaming",
            description: "FormScreen",
            builder: (context) {
              return buildDreamScreen(context);
            }),
        Story(
            name: 'Itineraries',
            description: "Itineraries",
            builder: (context) {
              var width = MediaQuery.sizeOf(context).width;
              print(width);
              return ChangeNotifierProvider(
                create: (context) => model,
                lazy: true,
                child: (width < 1000)
                    ? buildSmallItineraries(model)
                    : buildLargesItineraries(model),
              );
            }),
        Story(
            name: 'Detailed Itinerary',
            builder: (context) {
              var colorScheme = Theme.of(context).colorScheme;
              return ChangeNotifierProvider(
                  create: (context) => model,
                  lazy: true,
                  child: Row(children: [
                    ItineraryCard(
                        itinerary: model.itineraries!.first, onTap: () {}),
                    const SizedBox(
                      width: 48,
                    ),
                    Expanded(
                        child: Card(
                            elevation: 0.0,
                            color: colorScheme.surfaceContainerLowest,
                            child: Scaffold(
                                backgroundColor:
                                    colorScheme.surfaceContainerLowest,
                                body: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 48, left: 24),
                                    child: ListView(
                                        children: List.generate(
                                      model.itineraries!.first.dayPlans.length,
                                      (day) {
                                        var dayPlan = model
                                            .itineraries!.first.dayPlans[day];

                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DayTitle(
                                                  title:
                                                      'Day ${dayPlan.dayNum.toString()}'),
                                              DayStepper(
                                                key: Key('stepper$day'),
                                                activities: dayPlan.planForDay,
                                              )
                                            ]);
                                      },
                                    )))))

                        // ),
                        )
                  ]));
            }),
      ],
    );
  }
}
