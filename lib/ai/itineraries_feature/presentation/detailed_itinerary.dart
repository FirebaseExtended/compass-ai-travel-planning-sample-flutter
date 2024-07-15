import 'package:flutter/material.dart';
import 'package:tripedia/ai/styles.dart';

import '../models/models.dart';
import './components/components.dart';

class DetailedItineraryScreen extends StatefulWidget {
  const DetailedItineraryScreen({required this.itinerary, super.key});

  final Itinerary itinerary;

  @override
  State<DetailedItineraryScreen> createState() =>
      _DetailedItineraryScreenState();
}

class _DetailedItineraryScreenState extends State<DetailedItineraryScreen> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    return (width <= Breakpoints.expanded)
        ? SmallDetailedItinerary(itinerary: widget.itinerary)
        : LargeDetailedItinerary(itinerary: widget.itinerary);
  }
}
