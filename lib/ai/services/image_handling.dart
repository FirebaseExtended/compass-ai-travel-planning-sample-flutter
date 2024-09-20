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
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

var imageResourceEndpoint = 'uploadimgtrip-hovwuqnpzq-uc.a.run.app';
var imageMimeTypeResourceEndpoint = 'us-central1-yt-rag.cloudfunctions.net';

class UserSelectedImage {
  String path;
  Uint8List bytes;

  UserSelectedImage(this.path, this.bytes);
}

class ImageClient {
  static Future<Uint8List?> resizeAndCompressImage(Uint8List imageBytes) async {
    try {
      ui.Image img = await decodeImageFromList(imageBytes);

      var record = ui.PictureRecorder();
      var imgCanvas = Canvas(record);

      double targetWidth = 300;
      var percentageScale = targetWidth / img.width.toDouble();
      var targetHeight = img.height * percentageScale;

      imgCanvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        Rect.fromLTWH(0, 0, targetWidth, targetHeight),
        Paint(),
      );

      var picture = record.endRecording();

      ui.Image resizedImage = await picture.toImage(
        targetWidth.toInt(),
        targetHeight.toInt(),
      );

      picture.dispose();

      var resizedImageByteData = await resizedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      resizedImage.dispose();

      if (resizedImageByteData == null) return null;

      var resizedImageBytes = resizedImageByteData.buffer.asUint8List();

      var compressedBytes = await FlutterImageCompress.compressWithList(
        resizedImageBytes,
        minWidth: targetWidth.floor(),
        minHeight: targetHeight.floor(),
        quality: 50,
      );

      return compressedBytes;
    } catch (e) {
      debugPrint(e.toString());
      throw ('Unable to resize and compress images');
    }
  }

  static Future<List<String>?> base64EncodeImages(
      List<UserSelectedImage> images) async {
    debugPrint('Resizing, compressing, and encoding images');
    try {
      List<String> base64Encodedimages = [];

      for (var image in images) {
        var imgBytes = await resizeAndCompressImage(image.bytes);

        if (imgBytes != null) {
          String base64image =
              'data:image/jpeg;base64,${base64Encode(imgBytes)}';
          base64Encodedimages.add(base64image);
        }
      }

      return base64Encodedimages.isEmpty ? null : base64Encodedimages;
    } catch (e) {
      throw ('Unable to upload images');
    }
  }
}
