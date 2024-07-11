// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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


