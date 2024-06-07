import 'package:flutter/material.dart';

import '../data/models/itinerary.dart';

class ItinerariesViewModel extends ChangeNotifier {
  final ItineraryClient client;
  List<Itinerary>? itineraries;
  int? selectedItineraryIndex;
  String? errorMessage;

  ItinerariesViewModel(this.client);

  Future<void> init() async {
    try {
      itineraries = await client.loadItinerariesFromServer();
    } catch (e) {
      errorMessage = 'Could not initialize counter';
    }
    notifyListeners();
  }

  Future<void> selectItinerary(int index) async {
    try {
      selectedItineraryIndex = index;
    } catch (e) {
      errorMessage = 'Count not update count';
    }
    notifyListeners();
  }
}
