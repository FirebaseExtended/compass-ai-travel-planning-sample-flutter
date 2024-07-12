import 'package:flutter/material.dart';
import 'package:tripedia/ai/services/image_handling.dart';

import '../models/itinerary.dart';

class ItinerariesViewModel extends ChangeNotifier {
  final ItineraryClient client;
  List<Itinerary>? itineraries;
  int? selectedItineraryIndex;
  String? errorMessage;

  ItinerariesViewModel(this.client);

  Future<void> loadItineraries(
    String query,
    List<UserSelectedImage>? images,
  ) async {
    try {
      var base64EncodedImages = (images != null)
          ? await ImageClient.base64EncodeImages(images)
          : null;

      debugPrint('Loading Itineraries from server: $query');
      itineraries = await client.loadItinerariesFromServer(
        query,
        images: base64EncodedImages,
      );
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
