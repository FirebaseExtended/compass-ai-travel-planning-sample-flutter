import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Itinerary {
  List<DayPlan> days = [];
  String place = '';
  String name = '';
  String startDate = '';
  String endDate = '';
  List<String> tags = [];
  String heroUrl = '';
  String placeRef = '';

  Itinerary(days, place, name);
}

class DayPlan {
  int dayNum;
  String date;
  List<Activity> planForDay;

  DayPlan({required this.dayNum, required this.date, required this.planForDay});

  static DayPlan fromJson(Map<String, dynamic> jsonMap) {
    int localDayNum;
    String localDate;
    List<dynamic> localPlan;

    {
      'day': localDayNum,
      'date': localDate,
      'planForDay': localPlan,
    } = jsonMap;

    return DayPlan(
      dayNum: localDayNum,
      date: localDate,
      planForDay: List<Activity>.from(
        localPlan.map(
          (activity) => Activity.fromJson(activity),
        ),
      ),
    );
  }
}

class Activity {
  String ref = '';
  String title = '';
  String description = '';
  String imageUrl = '';

  Activity(
      {required this.ref,
      required this.title,
      required this.description,
      required this.imageUrl});

  static Activity fromJson(Map<String, dynamic> jsonMap) {
    String localRef, localTitle, localDescription, localImageUrl;

    {
      'activityRef': localRef,
      'activityTitle': localTitle,
      'activityDesc': localDescription,
      'imgUrl': localImageUrl
    } = jsonMap;

    return Activity(
        ref: localRef,
        title: localTitle,
        description: localDescription,
        imageUrl: localImageUrl);
  }
}

List<Itinerary> parseItineraries(String jsonStr) {
  final jsonData = jsonDecode(jsonStr);
  final itineraries = <Itinerary>[];

  final itineraryList = jsonData['result']['itineraries'];
  for (final itineraryData in itineraryList) {
    final days = <DayPlan>[];
    for (final dayData in itineraryData['itinerary']) {
      print(dayData);
      final event = DayPlan.fromJson(dayData);
      days.add(event);
    }
    final itinerary =
        Itinerary(days, itineraryData['place'], itineraryData['itineraryName']);
    itineraries.add(itinerary);
  }

  return itineraries;
}

void main() async {
  var endpoint = Uri.https(
    'tripedia-genkit-hovwuqnpzq-uc.a.run.app',
    '/itineraryGenerator',
  );

  var response = await http.post(
    endpoint,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(
      {
        'data': {
          'request': "I want a vacation with beautiful views and good food."
        },
      },
    ),
  );

  List<Itinerary> allItineraries = parseItineraries(response.body);

  print(allItineraries);

  /*var decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
  var result = decodedBody['result'] as Map<String, dynamic>;
  var itineraries = result['itineraries'] as List<dynamic>;

  for (var itineraryHolder in itineraries) {
    //print(itineraryHolder);
    var thisItinerary = itineraryHolder as Map<String, dynamic>;
    var itineraryList = thisItinerary['itinerary'];

    /*int locId, locActivityId;
    List<String> locPlanForDay;*/

    print(itineraryList);
    print('\n');
  }*/

  /*List<dynamic> itineraries;

  {'result': {'itineraries': itineraries}} =
      jsonDecode(response.body) as Map<String, Map<String, List<dynamic>>>;

  //print(decodedBody['result'].keys);*/

  //print(itineraries);
}
