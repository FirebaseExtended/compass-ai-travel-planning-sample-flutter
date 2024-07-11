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

import 'package:flutter/material.dart';

class Thumbnail extends StatelessWidget {
  const Thumbnail({
    required this.image,
    this.title,
    this.faded = false,
    super.key,
    required this.width,
    required this.height,
  });

  final ImageProvider image;
  final String? title;
  final bool faded;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    String? imageTitle = title;
    final smallText = Theme.of(context).textTheme.titleMedium;
    final largeText = Theme.of(context).textTheme.titleLarge;
    bool isLarge = width > 250;
    TextStyle? textStyle = isLarge ? largeText : smallText;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: width.toDouble(),
        height: height.toDouble(),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
            opacity: faded ? 0.5 : 1.0,
          ),
        ),
        child: Center(
          child: imageTitle != null
              ? Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    textAlign: TextAlign.center,
                    imageTitle,
                    style: TextStyle(
                      height: textStyle?.height,
                      color: Colors.white,
                      fontSize: textStyle?.fontSize,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
