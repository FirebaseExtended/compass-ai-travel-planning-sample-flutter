import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:mime/mime.dart';

import 'package:http/http.dart' as http;

var imageResourceEndpoint = 'uploadimgtrip-hovwuqnpzq-uc.a.run.app';
var imageMimeTypeResourceEndpoint = 'us-central1-yt-rag.cloudfunctions.net';

class ImageClient {
  static tempUrls(String path) async {
    var endpoint = Uri.https(
      imageMimeTypeResourceEndpoint,
      '/UploadImgTrip',
    );

    String? mimeType = lookupMimeType(path);

    if (mimeType == null) return;

    var response = await http.get(endpoint, headers: {'mime': mimeType});

    var jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

    String uploadUrl, downloadUrl;

    {
      'uploadLocation': uploadUrl as String,
      'downloadLocation': downloadUrl as String,
    } = jsonMap;

    return (uploadUrl, downloadUrl);
  }

  /*static Future<String> uploadImage(File imageFile) async {
    String uploadUrl, downloadUrl;
    (uploadUrl, downloadUrl) = await ImageClient.tempUrls;

    await http.put(
      Uri.parse(uploadUrl),
      headers: {'Content-Type': 'application/octet-stream'},
      body: await imageFile.readAsBytes(),
    );

    return downloadUrl;
  }*/

  static Future<String> uploadImageBytes(
      String path, Uint8List imageBytes) async {
    String uploadUrl, downloadUrl;
    (uploadUrl, downloadUrl) = await ImageClient.tempUrls(path);

    await http.put(
      Uri.parse(uploadUrl),
      headers: {'Content-Type': lookupMimeType(path)!},
      body: imageBytes,
    );

    return downloadUrl;
  }

  /*static Future<List<String>> uploadImages(List<File> images) async {
    List<Future<String>> imagesFutures = List.generate(
      images.length,
      (idx) => uploadImage(images[idx]),
    );

    var imagesDownloadUrls = await Future.wait(imagesFutures);

    return imagesDownloadUrls;
  }*/

  static Future<List<String>> uploadImagesBytes(
      Map<String, Uint8List> images) async {
    try {
      var paths = images.keys.toList();
      List<Future<String>> imagesFutures = List.generate(
        images.length,
        (idx) => uploadImageBytes(paths[idx], images[paths[idx]]!),
      );

      var imagesDownloadUrls = await Future.wait(imagesFutures);

      print('Uploaded all images!\n$imagesDownloadUrls');

      return imagesDownloadUrls;
    } catch (e) {
      throw ('Unable to upload images');
    }
  }
}

void main() async {
  //var imageFile = File('assets/images/la-jolla.jpeg');

  //var downloadUrl = await ImageClient.uploadImage(imageFile);

  //print('Uploaded! Check it out:\n$downloadUrl');

  /*var images = [
    File('assets/images/la-jolla.jpeg').readAsBytes(),
    File('assets/images/coronado-island.jpeg').readAsBytes(),
    File('assets/images/louvre.png').readAsBytes(),
    File('assets/images/paris.png').readAsBytes(),
  ];

  var imageBytes = await Future.wait(images);

  var downloadUrls = await ImageClient.uploadImagesBytes(imageBytes);

  print(downloadUrls);*/
}
