import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Itinerary {
  List<Event> events = [];
  String place = '';
  String name = '';

  Itinerary(events, place, name);
}

class Event {
  int activityId;
  int dayNum;
  List<String> planForDay;

  Event(
      {required this.activityId,
      required this.dayNum,
      required this.planForDay});

  static Event fromJson(Map<String, dynamic> jsonMap) {
    int localActivityId, localDayNum;
    List<dynamic> localPlan;

    {
      'day': localDayNum,
      'activityId': localActivityId,
      'planForDay': localPlan,
    } = jsonMap;

    /*dayNum = localDayNum;
    activityId = localActivityId;
    planForDay = localPlan;*/

    return Event(
      activityId: localActivityId,
      dayNum: localDayNum,
      planForDay: List<String>.from(localPlan),
    );
  }
}

List<Itinerary> parseItineraries(String jsonStr) {
  final jsonData = jsonDecode(jsonStr);
  final itineraries = <Itinerary>[];

  final itineraryList = jsonData['result']['itineraries'];
  for (final itineraryData in itineraryList) {
    final events = <Event>[];
    for (final eventData in itineraryData['itinerary']) {
      print(eventData);
      final event = Event.fromJson(eventData);
      events.add(event);
    }
    final itinerary = Itinerary(
        events, itineraryData['place'], itineraryData['itineraryName']);
    itineraries.add(itinerary);
  }

  return itineraries;
}

void main() async {
  var endpoint = Uri.https(
    'genkit-express-hovwuqnpzq-uc.a.run.app',
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
