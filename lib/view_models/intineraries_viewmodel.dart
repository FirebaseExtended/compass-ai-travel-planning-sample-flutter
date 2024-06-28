import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripedia/image_handling.dart';
import 'dart:io';

import '../data/models/itinerary.dart';

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
      var imageUrls =
          (images != null) ? await ImageClient.uploadImagesBytes(images) : null;

      print('Loading Itineraries from server: $query');
      itineraries = await client.loadItinerariesFromServer(
        query,
        imageUrls: imageUrls,
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
