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

import 'dart:ui';

import '../themes/colors.dart';
import '../themes/text_styles.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tag, this.isSmall = true});

  final String tag;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.whiteTransparent,
          ),
          child: SizedBox(
            height: isSmall ? 20.0 : 32,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconFrom(tag),
                    color: Colors.white,
                    size: isSmall ? 10 : 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tag,
                    textAlign: TextAlign.center,
                    style: isSmall
                        ? TextStyles.chipTagStyle
                        : TextStyles.chipTagStyle.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData? _iconFrom(String tag) {
    return switch (tag) {
      'Adventure sports' => Icons.kayaking_outlined,
      'Beach' => Icons.beach_access_outlined,
      'City' => Icons.location_city_outlined,
      'Cultural experiences' => Icons.museum_outlined,
      'Foodie' || 'Food tours' => Icons.restaurant,
      'Hiking' => Icons.hiking,
      'Historic' => Icons.menu_book_outlined,
      'Island' || 'Coastal' || 'Lake' || 'River' => Icons.water,
      'Luxury' => Icons.attach_money_outlined,
      'Mountain' || 'Wildlife watching' => Icons.landscape_outlined,
      'Nightlife' => Icons.local_bar_outlined,
      'Off-the-beaten-path' => Icons.do_not_step_outlined,
      'Romantic' => Icons.favorite_border_outlined,
      'Rural' => Icons.agriculture_outlined,
      'Secluded' => Icons.church_outlined,
      'Sightseeing' => Icons.attractions_outlined,
      'Skiing' => Icons.downhill_skiing_outlined,
      'Wine tasting' => Icons.wine_bar_outlined,
      'Winter destination' => Icons.ac_unit,
      _ => Icons.label_outlined,
    };
  }
}

class DetailTagChip extends StatelessWidget {
  const DetailTagChip({
    super.key,
    required this.tag,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.whiteTransparent,
          ),
          child: SizedBox(
            height: 40.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconFrom(tag),
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tag,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData? _iconFrom(String tag) {
    return switch (tag) {
      'Adventure sports' => Icons.kayaking_outlined,
      'Beach' => Icons.beach_access_outlined,
      'City' => Icons.location_city_outlined,
      'Cultural experiences' => Icons.museum_outlined,
      'Foodie' || 'Food tours' => Icons.restaurant,
      'Hiking' => Icons.hiking,
      'Historic' => Icons.menu_book_outlined,
      'Island' || 'Coastal' || 'Lake' || 'River' => Icons.water,
      'Luxury' => Icons.attach_money_outlined,
      'Mountain' || 'Wildlife watching' => Icons.landscape_outlined,
      'Nightlife' => Icons.local_bar_outlined,
      'Off-the-beaten-path' => Icons.do_not_step_outlined,
      'Romantic' => Icons.favorite_border_outlined,
      'Rural' => Icons.agriculture_outlined,
      'Secluded' => Icons.church_outlined,
      'Sightseeing' => Icons.attractions_outlined,
      'Skiing' => Icons.downhill_skiing_outlined,
      'Wine tasting' => Icons.wine_bar_outlined,
      'Winter destination' => Icons.ac_unit,
      _ => Icons.label_outlined,
    };
  }
}
