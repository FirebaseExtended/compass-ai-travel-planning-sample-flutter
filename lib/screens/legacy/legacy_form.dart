import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/thumbnail.dart';

class LegacyFormScreen extends StatefulWidget {
  const LegacyFormScreen({super.key});

  @override
  State<LegacyFormScreen> createState() => _LegacyFormScreenState();
}

class _LegacyFormScreenState extends State<LegacyFormScreen> {
  int numPeople = 1;

  void decreaseNumPeople() {
    setState(() {
      numPeople -= 1;
    });
  }

  void increaseNumPeople() {
    setState(() {
      numPeople += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  style: ButtonStyle(
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey[300]!),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () => context.go('/'),
                  icon: const Icon(
                    Icons.home_outlined,
                  ),
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 120, child: LocationPicker()),
              const SizedBox.square(
                dimension: 24,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'When',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Add Dates',
                    ),
                  ],
                ),
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Who',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    QuantityInput(
                      value: numPeople,
                      onDecrease: decreaseNumPeople,
                      onIncrease: increaseNumPeople,
                      min: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class LocationPicker extends StatelessWidget {
  const LocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        Thumbnail(
          image: AssetImage(
            'assets/images/coronado-island.jpeg',
          ),
          title: 'Europe',
        ),
        Thumbnail(
          image: AssetImage(
            'assets/images/la-jolla.jpeg',
          ),
          title: 'Asia',
        ),
        Thumbnail(
          image: AssetImage(
            'assets/images/louvre.png',
          ),
          title: 'South America',
        ),
        Thumbnail(
          image: AssetImage(
            'assets/images/san-diego.jpeg',
          ),
          title: 'Africa',
        ),
        Thumbnail(
          image: AssetImage(
            'assets/images/seine.png',
          ),
          title: 'North America',
        ),
        Thumbnail(
          image: AssetImage(
            'assets/images/paris.png',
          ),
          title: 'Oceania',
        ),
        Thumbnail(
          image: AssetImage(
            'assets/images/marine-life.jpeg',
          ),
          title: 'Australia',
        )
      ],
    );
  }
}

class QuantityInput extends StatelessWidget {
  const QuantityInput({
    required this.value,
    required this.onIncrease,
    required this.onDecrease,
    this.min,
    this.max,
    super.key,
  });

  final VoidCallback onDecrease, onIncrease;
  final int value;
  final int? min, max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            int? minValue = min;
            if (minValue != null && value <= minValue) return;

            onDecrease();
          },
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(value.toString()),
        IconButton(
          onPressed: onIncrease,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
