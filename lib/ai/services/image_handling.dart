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
import 'package:image/image.dart' as imgpkg;

var imageResourceEndpoint = 'uploadimgtrip-hovwuqnpzq-uc.a.run.app';
var imageMimeTypeResourceEndpoint = 'us-central1-yt-rag.cloudfunctions.net';

class UserSelectedImage {
  String path;
  Uint8List bytes;

  UserSelectedImage(this.path, this.bytes);
}

class ImageClient {
  static Future<Uint8List?> resizeAndCompressImage(Uint8List imageBytes) async {
    imgpkg.Image? img = await compute(imgpkg.decodeImage, imageBytes);

    if (img == null) {
      return null;
    }

    imgpkg.Image smallImg = imgpkg.copyResize(img, width: 250);
    Uint8List smallBytes = imgpkg.encodeJpg(smallImg, quality: 10);

    return smallBytes;
  }

  static Future<List<String>> base64EncodeImages(
      List<UserSelectedImage> images) async {
    debugPrint('Resizing, compressing, and encoding images');
    try {
      List<String> base64Encodedimages = [];

      for (var image in images) {
        var imgBytes = await resizeAndCompressImage(image.bytes);

        if (imgBytes != null) {
          base64Encodedimages
              .add('data:image/jpeg;base64,${base64Encode(imgBytes)}');
        }
      }

      return base64Encodedimages;
    } catch (e) {
      throw ('Unable to upload images');
    }
  }
}
