import 'package:flutter/material.dart';
import 'dart:typed_data';

class Thumbnail extends StatelessWidget {
  const Thumbnail({required this.image, this.title, super.key});

  final ImageProvider image;
  final String? title;

  @override
  Widget build(BuildContext context) {
    String? imageTitle = title;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: imageTitle != null
              ? Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    textAlign: TextAlign.center,
                    imageTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
