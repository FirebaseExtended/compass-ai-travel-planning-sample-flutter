// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:typed_data';
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
