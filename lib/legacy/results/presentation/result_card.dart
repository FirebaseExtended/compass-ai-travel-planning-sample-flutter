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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/legacy/activities_feature/models/activity.dart';
import 'package:tripedia/legacy/activities_feature/presentation/activities_screen.dart';

import '../../common/themes/text_styles.dart';
import '../../common/widgets/tag_chip.dart';
import '../business/model/destination.dart';
import 'package:flutter/material.dart';

import '../../activities_feature/view_models/activities_viewmodel.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.destination,
    this.isSmall = true,
  });

  final Destination destination;
  final bool isSmall;

  Widget _buildSmall(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      // TODO: Improve image loading and caching
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: CachedNetworkImageProvider(
              destination.imageUrl,
            ),
            fit: BoxFit.fitHeight,
          ),
          Positioned(
            bottom: 12.0,
            left: 12.0,
            right: 12.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name.toUpperCase(),
                  style: TextStyles.cardTitleStyle,
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children:
                      destination.tags.map((e) => TagChip(tag: e)).toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLarge(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      // TODO: Improve image loading and caching
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: CachedNetworkImageProvider(
              destination.imageUrl,
            ),
            fit: BoxFit.fitHeight,
          ),
          Positioned(
            bottom: 32.0,
            left: 16.0,
            right: 24.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name.toUpperCase(),
                  style: TextStyles.cardTitleStyle.copyWith(fontSize: 32),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: destination.tags
                      .map((e) => TagChip(
                            tag: e,
                            isSmall: false,
                          ))
                      .toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.read<TravelPlan>().destination = destination;
          context
              .read<ActivitiesViewModel>()
              .search(location: destination.name);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ActivitiesScreen(),
            ),
          );
        },
        child: isSmall ? _buildSmall(context) : _buildLarge(context));
  }
}
