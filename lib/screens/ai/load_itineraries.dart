import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/screens/ai/dreaming.dart';
import 'package:tripedia/screens/ai/itineraries.dart';
import '../../view_models/intineraries_viewmodel.dart';

class LoadItinerariesScreen extends StatelessWidget {
  const LoadItinerariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var itineraries = context.watch<ItinerariesViewModel>().itineraries;

    if (itineraries == null) {
      return const DreamingScreen();
    } else {
      return const Itineraries();
    }
  }
}
