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

import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:compass/config.dart';

import './day_plan.dart';

class Itinerary {
  List<DayPlan> dayPlans = [];
  String place = '';
  String name = '';
  String startDate = '';
  String endDate = '';
  List<String> tags = [];
  String heroUrl = '';
  String placeRef = '';

  Itinerary(this.dayPlans, this.place, this.name, this.startDate, this.endDate,
      this.tags, this.heroUrl, this.placeRef);

  @override
  String toString() {
    return '''
      place: $place,
      name: $name,
      startDate: $startDate,
      endDate: $endDate,
      tags: ${tags.toString()},
      heroUrl: $heroUrl,
      placeRef: $placeRef
    ''';
  }
}

class ItineraryClient {
  Uri endpoint = Uri.https(
    // TODO(@nohe427): Use env vars to set this. ==> see config.dart
    backendEndpoint,
    '/itineraryGenerator2',
  );

  Future<List<Itinerary>> loadItinerariesFromServer(String query,
      {List<String>? images}) async {
    var jsonBody = jsonEncode({
      'data': {
        'request': query,
        if (images != null) 'images': images,
      },
    });

    try {
      var response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      List<Itinerary> allItineraries = parseItineraries(response.body);

      return allItineraries;
    } catch (e) {
      debugPrint("Couldn't get itineraries.");
      throw ("Couldn't get itineraries.");
    }
  }

  List<Itinerary> parseItineraries(String jsonStr) {
    try {
      final jsonData = jsonDecode(jsonStr);
      final itineraries = <Itinerary>[];

      final itineraryList = jsonData['result']['itineraries'];
      for (final itineraryData in itineraryList) {
        final days = <DayPlan>[];
        for (final dayData in itineraryData['itinerary']) {
          final event = DayPlan.fromJson(dayData);
          days.add(event);
        }

        debugPrint(itineraryData['itineraryImageUrl']);

        final itinerary = Itinerary(
          days,
          itineraryData['place'] as String,
          itineraryData['itineraryName'] as String,
          itineraryData['startDate'] as String,
          itineraryData['endDate'] as String,
          List<String>.from(itineraryData['tags'] as List),
          itineraryData['itineraryImageUrl'] as String,
          itineraryData['placeRef'] as String,
        );
        itineraries.add(itinerary);
      }

      return itineraries;
    } catch (e) {
      debugPrint('There was an error parsing the response:\n$jsonStr');
      throw ('There was an error parsing the response');
    }
  }
}

void main() async {
  List<Itinerary> itineraries = await ItineraryClient()
      .loadItinerariesFromServer(
          'I want a vacation at the beach with beautiful views and good food');
  debugPrint(itineraries.toString());
}
