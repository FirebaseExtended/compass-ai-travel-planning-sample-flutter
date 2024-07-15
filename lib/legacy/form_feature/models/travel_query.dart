import 'package:flutter/material.dart';

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
