import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripedia/utilties.dart';

import '../components/thumbnail.dart';

class LegacyFormScreen extends StatefulWidget {
  const LegacyFormScreen({super.key});

  @override
  State<LegacyFormScreen> createState() => _LegacyFormScreenState();
}

class _LegacyFormScreenState extends State<LegacyFormScreen> {
  int numPeople = 1;
  String? selectedLocation;
  DateTimeRange? tripDateRange;

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
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
        ),
      ),
      child: Scaffold(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'When',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            ),
                          ),
                          onPressed: () async {
                            DateTimeRange? tripDates = await showDialog(
                              context: context,
                              builder: (context) {
                                return Theme(
                                  data: ThemeData(
                                    colorScheme: ColorScheme.fromSeed(
                                      seedColor: Colors.black,
                                      dynamicSchemeVariant:
                                          DynamicSchemeVariant.monochrome,
                                    ),
                                  ),
                                  child: DateRangePickerDialog(
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2028-01-01'),
                                  ),
                                );
                              },
                            );

                            if (tripDates == null) return;

                            setState(() {
                              tripDateRange = tripDates;
                            });
                          },
                          child: tripDateRange != null
                              ? Text(
                                  '${shortenedDate(tripDateRange!.start.toString())} – ${shortenedDate(tripDateRange!.end.toString().toString())}')
                              : const Text('Add Dates'),
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
        ),
      ),
    );
  }
}

class LocationPicker extends StatefulWidget {
  const LocationPicker(
      {required this.selected, required this.onSelect, super.key});

  final String? selected;
  final void Function(String) onSelect;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  List<Map<String, String>> destinations = [
    {
      'image': 'https://rstr.in/google/tripedia/TmR12QdlVTT',
      'title': 'Europe',
    },
    {
      'image': 'https://rstr.in/google/tripedia/VJ8BXlQg8O1',
      'title': 'Asia',
    },
    {
      'image': 'https://rstr.in/google/tripedia/flm_-o1aI8e',
      'title': 'South America',
    },
    {
      'image': 'https://rstr.in/google/tripedia/-nzi8yFOBpF',
      'title': 'Africa',
    },
    {
      'image': 'https://rstr.in/google/tripedia/jlbgFDrSUVE',
      'title': 'North America',
    },
    {
      'image': 'https://rstr.in/google/tripedia/vxyrDE-fZVL',
      'title': 'Oceania',
    },
    {
      'image': 'https://rstr.in/google/tripedia/z6vy6HeRyvZ',
      'title': 'Australia',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: List.generate(destinations.length, (index) {
        var destination = destinations[index];
        return LocationItem(
          onTap: widget.onSelect,
          fade: (widget.selected == null ||
                  widget.selected == destination['title'])
              ? false
              : true,
          name: destination['title']!,
          image: NetworkImage(
            destination['image']!,
          ),
        );
      }),
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
  final ImageProvider image;
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
