import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:developer';

import 'package:http/http.dart' as http;

var imageResourceEndpoint = 'uploadimgtrip-hovwuqnpzq-uc.a.run.app';
var imageMimeTypeResourceEndpoint = 'us-central1-yt-rag.cloudfunctions.net';

class UserSelectedImage {
  String path;
  Uint8List bytes;

  UserSelectedImage(this.path, this.bytes);
}

class ImageClient {
  static String? getMimeType(UserSelectedImage image) {
    List<int> header = [];

    image.bytes.forEach((element) {
      if (element == 0) return;
      header.add(element);
    });

    String? mimeType = lookupMimeType(image.path, headerBytes: header);

    return mimeType;
  }

  static tempUrls(String mimeType) async {
    var endpoint = Uri.https(
      imageResourceEndpoint,
      '/UploadImgTrip',
    );

    if (mimeType != 'image/png' && mimeType != 'image/jpeg') return;

    try {
      var response = await http.get(endpoint, headers: {
        'mime': mimeType,
      });

      var jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

      String uploadUrl, downloadUrl;

      {
        'uploadLocation': uploadUrl as String,
        'downloadLocation': downloadUrl as String,
      } = jsonMap;

      return (uploadUrl, downloadUrl);
    } catch (e) {
      print(e);
      throw ('couldn\'t get image processing urls');
    }
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

  static Future<String> uploadImageBytes(UserSelectedImage image) async {
    String uploadUrl, downloadUrl;
    var mimeType = getMimeType(image);

    if (!['image/jpeg', 'image/png'].contains(mimeType) || mimeType == null) {
      throw ("Sorry we don't support that file type.");
    }

    (uploadUrl, downloadUrl) = await ImageClient.tempUrls(mimeType);

    await http.put(
      Uri.parse(uploadUrl),
      headers: {
        'Content-Type': mimeType,
      },
      body: image.bytes,
    );

    print(downloadUrl);

    return downloadUrl;
  }

  static Future<List<String>> uploadImagesBytes(
      List<UserSelectedImage> images) async {
    try {
      List<Future<String>> imagesFutures = List.generate(
        images.length,
        (idx) => uploadImageBytes(images[idx]),
      );

      var imagesDownloadUrls = await Future.wait(imagesFutures);

      print('Uploaded all images!\n$imagesDownloadUrls');

      return imagesDownloadUrls;
    } catch (e) {
      throw ('Unable to upload images');
    }
  }

  static List<String> base64EncodeImages(List<UserSelectedImage> images) {
    try {
      List<String> base64Encodedimages = List.generate(
        images.length,
        (idx) => 'data:image/jpeg;base64,${base64Encode(images[idx].bytes)}',
      );

      for (var image in base64Encodedimages) {
        debugPrint(image);
      }

      return base64Encodedimages;
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
