import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:compass/config.dart';
import 'package:http/http.dart' as http;

class QueryClient {
  static Future<Map<String, bool>> hasRequiredInfo(String query) async {
    debugPrint('Checking refinements for trip description');
    var endpoint = Uri.https(
        // TODO(@nohe427): Use env vars to set this. ==> see config.dart
        backendEndpoint,
        '/textRefinement');

    var jsonBody = jsonEncode({'data': query});

    try {
      var response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      Map<String, dynamic> hasRequiredData = jsonDecode(response.body);
      Map<String, dynamic> result =
          hasRequiredData['result'] as Map<String, dynamic>;

      bool cost, kids, date;
      {
        'cost': cost as bool,
        'kids': kids as bool,
        'date': date as bool,
      } = result;

      return {'cost': cost, 'kids': kids, 'date': date};
    } catch (e) {
      debugPrint(e.toString());
      throw ("Error validating required info.");
    }
  }

  static String generateRefinements(Map<String, dynamic> refinedDetails) {
    Map<String, String> refinementPrompts = {
      'kids': 'Is it family friendly?',
      'cost': 'How much are you willing to spend (1 is low 5 is high):',
      'date': 'Start date:',
    };
    String refinementSpec = '\nRefinements:\n';

    for (var key in refinedDetails.keys) {
      refinementSpec += '${refinementPrompts[key]} ${refinedDetails[key]}\n';
    }

    return refinementSpec;
  }
}
