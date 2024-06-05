import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tripedia/screens/components/app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../branding.dart';
import '../components/custom_stepper.dart' as customStepper;

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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 240,
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppLogo(dimension: 24),
                      Text(
                        'Romantic Parisian Getaway',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        '14th May - 21st May, 2024',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/paris.png',
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            colors: [
                              Color.fromARGB(150, 49, 49, 49),
                              Colors.transparent
                            ],
                            stops: [
                              0.0,
                              0.75
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () {},
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
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.home_outlined,
                      ),
                    )),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const DayTitle(title: 'Day 1'),
                    const DayStepper(key: Key('Stepper1')),
                    const DayTitle(title: 'Day 2'),
                    const DayStepper(key: Key('Stepper2')),
                    const DayTitle(title: 'Day 3'),
                    const DayStepper(key: Key('Stepper3')),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant))),
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
  const DayStepper({super.key});

  @override
  State<DayStepper> createState() => _DayStepperState();
}

class _DayStepperState extends State<DayStepper> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: customStepper.Stepper(
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
            return Container(
              width: 80,
              height: 80,
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
        steps: const [
          Step(
            stepStyle: StepStyle(
              connectorThickness: 0,
              color: Colors.transparent,
            ),
            title: Text('Louvre Museum Guided Tour',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text('May 14, Morning'),
            content: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 8, 0),
              child: Text(
                  "Explore the Louvre's treasures with a guided tour unveils art's rich history."),
            ),
          ),
          Step(
            stepStyle: StepStyle(
              connectorThickness: 0,
              color: Colors.transparent,
            ),
            title: Text('Seine River Cruise',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text('May 14, Afternoon'),
            content: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 8, 0),
              child: Text(
                "Parisian allure awaits on the Seine River aboard traditional, luxurious vessels.",
              ),
            ),
          ),
          Step(
            stepStyle: StepStyle(
              connectorThickness: 0,
              color: Colors.transparent,
            ),
            title: Text('Louvre Museum Guided Tour',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text('May 14, Evening'),
            content: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 8, 0),
              child: Text(
                  "Explore the Louvre's treasures with a guided tour unveils art's rich history."),
            ),
          ),
        ],
      ),
    );
  }
}
