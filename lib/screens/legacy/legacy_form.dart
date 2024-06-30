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
  String selectedLocation = '';

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

  void selectLocation(String location) {
    setState(() {
      selectedLocation = location;
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
          child: Column(
            children: [
              Expanded(
                child: Column(children: [
                  SizedBox(
                      height: 120,
                      child: LocationPicker(
                        selected: selectedLocation,
                        onSelect: selectLocation,
                      )),
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
                ]),
              ),
              Row(children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primaryContainer),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                        Colors.black,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ));
  }
}

class LocationPicker extends StatelessWidget {
  const LocationPicker(
      {required this.selected, required this.onSelect, super.key});

  final String? selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        LocationItem(
          onTap: onSelect,
          fade: (selected == 'Europe' || selected == null) ? false : true,
          name: 'Europe',
          image: const AssetImage(
            'assets/images/coronado-island.jpeg',
          ),
        ),
        LocationItem(
          onTap: onSelect,
          fade: (selected == 'Asia' || selected == null) ? false : true,
          name: 'Asia',
          image: const AssetImage(
            'assets/images/la-jolla.jpeg',
          ),
        ),
        LocationItem(
          onTap: onSelect,
          fade:
              (selected == 'South America' || selected == null) ? false : true,
          image: const AssetImage(
            'assets/images/louvre.png',
          ),
          name: 'South America',
        ),
        LocationItem(
          onTap: onSelect,
          fade: (selected == 'Africa' || selected == null) ? false : true,
          image: const AssetImage(
            'assets/images/san-diego.jpeg',
          ),
          name: 'Africa',
        ),
        LocationItem(
          onTap: onSelect,
          fade:
              (selected == 'North America' || selected == null) ? false : true,
          image: const AssetImage(
            'assets/images/seine.png',
          ),
          name: 'North America',
        ),
        LocationItem(
          onTap: onSelect,
          fade: (selected == 'Oceania' || selected == null) ? false : true,
          image: const AssetImage(
            'assets/images/paris.png',
          ),
          name: 'Oceania',
        ),
        LocationItem(
          onTap: onSelect,
          fade: (selected == 'Australia' || selected == null) ? false : true,
          image: const AssetImage(
            'assets/images/marine-life.jpeg',
          ),
          name: 'Australia',
        )
      ],
    );
  }
}

class LocationItem extends StatelessWidget {
  const LocationItem({
    required this.name,
    required this.image,
    required this.onTap,
    this.fade = false,
    super.key,
  });

  final String name;
  final AssetImage image;
  final Function(String) onTap;
  final bool fade;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(name),
      child: Thumbnail(
        faded: fade,
        image: image,
        title: name,
      ),
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
          icon: const Icon(
            Icons.remove_circle_outline,
          ),
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
