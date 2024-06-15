import 'dart:convert';

import 'package:http/http.dart' as http;

var imageResourceEndpoint = 'uploadimgtrip-hovwuqnpzq-uc.a.run.app';

class ImageClient {
  static get tempUrls async {
    var endpoint = Uri.https(imageResourceEndpoint);
    var response = await http.get(
      endpoint,
    );

    var jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

    String uploadUrl, downloadUrl;

    {
      'uploadLocation': uploadUrl as String,
      'downloadLocation': downloadUrl as String,
    } = jsonMap;

    return (uploadUrl, downloadUrl);
  }
}

void main() async {
  String uploadUrl, downloadUrl;
  (uploadUrl, downloadUrl) = ImageClient.tempUrls;

  //print(itineraries);
}
