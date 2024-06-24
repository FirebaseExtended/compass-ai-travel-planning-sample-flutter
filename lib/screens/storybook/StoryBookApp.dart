import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:tripedia/screens/ai/dreaming.dart';
import 'package:tripedia/screens/ai/form.dart';

import '../../data/models/itinerary.dart';
import '../../main.dart';
import '../../view_models/intineraries_viewmodel.dart';

void main() => runApp(StorybookApp());


class StorybookApp extends StatelessWidget {
  const StorybookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Storybook(
    initialStory: 'Dreaming',
    stories: [
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
    ],
  );
}