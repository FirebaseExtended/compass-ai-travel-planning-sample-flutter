import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tripedia/screens/components/app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DetailedItinerary extends StatefulWidget {
  const DetailedItinerary({super.key});

  @override
  State<DetailedItinerary> createState() => _DetailedItineraryState();
}

class _DetailedItineraryState extends State<DetailedItinerary> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: brandedAppBar,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DayTitle(title: 'Day 1'),
            Stepper(
              controlsBuilder: (context, details) {
                return Container();
              },
              stepIconWidth: 80,
              stepIconHeight: 80,
              currentStep: activeStep,
              stepIconBuilder: (stepIndex, stepState) {
                if (stepIndex == activeStep) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/louvre.png'),
                      ),
                      color: Colors.green, // b
                    ),
                  );
                }

                return Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.yellow, // border color
                    shape: BoxShape.circle,
                  ),
                );
              },
              onStepTapped: (value) {
                setState(() {
                  activeStep = value;
                });
              },
              steps: const [
                Step(
                  title: Text('Louvre Museum Guided Tour'),
                  content: Text(
                      "Explore the Louvre's treasures with a guided tour unveils art's rich history."),
                ),
                Step(
                  title: Text('Seine River Cruise'),
                  content: Text(
                    "Parisian allure awaits on the Seine River aboard traditional, luxurious vessels.",
                  ),
                ),
                Step(
                  title: Text('Louvre Museum Guided Tour'),
                  content: Text(
                      "Explore the Louvre's treasures with a guided tour unveils art's rich history."),
                ),
              ],
            ),
            const DayTitle(title: 'Day 2'),
            const DayTitle(title: 'Day 3'),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant))),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
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
        ));
  }
}

class DayTitle extends StatelessWidget {
  const DayTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
