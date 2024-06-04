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

import 'package:flutter/material.dart';

import '../../results/business/model/destination.dart';
import '../../form_feature/models/travel_query.dart';

class TravelPlan extends ChangeNotifier {
  TravelQuery? query;
  Destination? destination;
  Set<LegacyActivity> activities = {};

  TravelPlan();

  void setQuery(TravelQuery userQuery) {
    query = userQuery;
    notifyListeners();
  }

  void clearQuery() {
    query = null;
    notifyListeners();
  }

  void setDestination(Destination selectedDestination) {
    destination = selectedDestination;
    notifyListeners();
  }

  void clearDestination() {
    destination = null;
    notifyListeners();
  }

  void toggleActivity(LegacyActivity selectedActivity) {
    activities.contains(selectedActivity)
        ? activities.remove(selectedActivity)
        : activities.add(selectedActivity);
    notifyListeners();
  }

  void clearActivities() {
    activities.clear();
    notifyListeners();
  }
}

class LegacyActivity {
  num duration;
  String ref;
  String locationName;
  num price;
  String imageUrl;
  String destination;
  String name;
  String description;
  bool familyFriendly;
  String timeOfDay;

  LegacyActivity({
    required this.duration,
    required this.ref,
    required this.locationName,
    required this.price,
    required this.imageUrl,
    required this.destination,
    required this.name,
    required this.description,
    required this.familyFriendly,
    required this.timeOfDay,
  });

  @override
  String toString() {
    return 'LegacyActivity(ref: $ref, name: $name, duration: $duration, locationName: $locationName, price: $price, destination: $destination, imageUrl: $imageUrl, description: $description, familyFriendly: $familyFriendly, timeOfDay: $timeOfDay)';
  }

  factory LegacyActivity.fromJson(Map<String, dynamic> json) {
    return LegacyActivity(
      duration: json['duration'] as num,
      ref: json['ref'] as String,
      locationName: json['locationName'] as String,
      price: json['price'] as num,
      imageUrl: json['imageUrl'] as String,
      destination: json['destination'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      familyFriendly: json['familyFriendly'] as bool,
      timeOfDay: json['timeOfDay'] as String,
    );
  }
}
