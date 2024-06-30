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
                child:  buildSmallItineraries(context, model)
              );
            }),
      ],
    );
  }
}


