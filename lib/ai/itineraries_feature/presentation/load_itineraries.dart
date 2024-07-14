import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/ai/dreaming_feature/presentation/dreaming.dart';
import 'package:tripedia/ai/itineraries_feature/presentation/itineraries.dart';
import '../view_models/intineraries_viewmodel.dart';

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
