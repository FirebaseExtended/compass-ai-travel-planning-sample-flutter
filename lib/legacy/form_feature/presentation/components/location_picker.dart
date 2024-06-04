import 'package:flutter/material.dart';

import '../../../../common/presentation/components/thumbnail.dart';
import '../../models/models.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker(
      {required this.selected,
      required this.onSelect,
      super.key,
      required this.width,
      required this.height});

  final String? selected;
  final void Function(String) onSelect;
  final int width;
  final int height;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> with Destinations {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: List.generate(destinations.length, (index) {
        var destination = destinations[index];
        return LocationItem(
          height: widget.height,
          width: widget.width,
          onTap: widget.onSelect,
          fade: (widget.selected == null ||
                  widget.selected == destination['title'])
              ? false
              : true,
          name: destination['title']!,
          image: AssetImage(
            destination['image']!,
          ),
        );
      }),
    );
  }
}

class LocationPickerGrid extends StatefulWidget {
  const LocationPickerGrid(
      {required this.selected,
      required this.onSelect,
      super.key,
      required this.width,
      required this.height});

  final String? selected;
  final void Function(String) onSelect;
  final int width;
  final int height;

  @override
  State<LocationPickerGrid> createState() => _LocationPickerGridState();
}

class _LocationPickerGridState extends State<LocationPickerGrid>
    with Destinations {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 8, maxCrossAxisExtent: 300),
        itemBuilder: (context, index) {
          if (index < destinations.length) {
            final destination = destinations[index];
            return LocationItem(
              height: widget.height,
              width: widget.width,
              onTap: widget.onSelect,
              fade: (widget.selected == null ||
                      widget.selected == destination['title'])
                  ? false
                  : true,
              name: destination['title']!,
              image: AssetImage(
                destination['image']!,
              ),
            );
          }
          return null;
        });
  }
}

class LocationItem extends StatelessWidget {
  const LocationItem({
    required this.name,
    required this.image,
    required this.onTap,
    this.fade = false,
    required this.width,
    required this.height,
    super.key,
  });

  final String name;
  final ImageProvider image;
  final Function(String) onTap;
  final bool fade;
  final int height;
  final int width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(name),
      child: Thumbnail(
        width: width,
        height: height,
        faded: fade,
        image: image,
        title: name,
      ),
    );
  }
}
