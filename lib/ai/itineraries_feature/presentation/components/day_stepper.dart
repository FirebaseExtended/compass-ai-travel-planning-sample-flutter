import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/models.dart';
import './custom_stepper.dart' as custom_stepper;

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
                placeholder: const AssetImage('assets/images/stars.png'),
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
              title: Text(
                widget.activities[index].title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(widget.activities[index].description)
                  .animate()
                  .fadeIn(duration: 750.milliseconds),
            );
          }),
        ],
      ),
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
