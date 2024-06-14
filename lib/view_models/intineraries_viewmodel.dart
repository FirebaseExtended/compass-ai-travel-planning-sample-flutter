import 'package:flutter/material.dart';

import '../data/models/itinerary.dart';

class ItinerariesViewModel extends ChangeNotifier {
  final ItineraryClient client;
  List<Itinerary>? itineraries;
  int? selectedItineraryIndex;
  String? errorMessage;

  ItinerariesViewModel(this.client);

  Future<void> loadItineraries() async {
    try {
      itineraries = await client.loadItinerariesFromServer();
    } catch (e) {
      errorMessage = 'Oops we couldn\'t fetch itineraries';
    }
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
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
