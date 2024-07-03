import 'package:flutter/material.dart';

import '../results/business/model/destination.dart';

class TravelQuery {
  String location;
  DateTimeRange dates;
  int numPeople;

  TravelQuery({
    required this.location,
    required this.dates,
    required this.numPeople,
  });

  @override
  String toString() {
    return 'TravelQuery(location: $location, dates: start: ${dates.start} end: ${dates.end}, numPeople: $numPeople)';
  }
}

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
