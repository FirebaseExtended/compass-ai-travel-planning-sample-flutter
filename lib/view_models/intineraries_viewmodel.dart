import 'package:flutter/material.dart';

import '../data/models/itinerary.dart';

class ItinerariesViewModel extends ChangeNotifier {
  final ItineraryClient client;
  List<Itinerary>? itineraries;
  int? selectedItineraryIndex;
  String? errorMessage;

  ItinerariesViewModel(this.client);

  Future<void> loadItineraries() async {
    itineraries = await client.loadItinerariesFromServer();
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
