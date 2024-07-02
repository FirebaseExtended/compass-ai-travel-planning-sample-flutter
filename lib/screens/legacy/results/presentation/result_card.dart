import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/screens/legacy/activities/activity.dart';

import '../../common/themes/text_styles.dart';
import '../../common/widgets/tag_chip.dart';
import '../../results/business/model/destination.dart';
import 'package:flutter/material.dart';

import '../../activities/activities_viewmodel.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.destination,
  });

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context
              .read<ActivitiesViewModel>()
              .search(location: destination.name);
          context.push('/legacy/activities');
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          // TODO: Improve image loading and caching
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                destination.imageUrl,
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
        ));
  }
}
