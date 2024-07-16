import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:compass/legacy/activities_feature/models/activity.dart';

import '../../common/themes/text_styles.dart';

class ActivityTile extends StatefulWidget {
  const ActivityTile({required this.activity, super.key});

  final LegacyActivity activity;

  @override
  State<ActivityTile> createState() => _ActivityTileState();
}

Widget _buildLearnMoreDialogSmall(
    BuildContext context, LegacyActivity activity) {
  return Dialog(child: Builder(builder: (context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    var duration = activity.duration;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: SizedBox(
            width: width,
            height: 0.5 * height,
            child: Image(
                image: CachedNetworkImageProvider(activity.imageUrl),
                fit: BoxFit.cover)),
      ),
      const SizedBox(
        width: 16,
      ),
      Column(children: [
        const SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              activity.name,
              style: const TextStyle(
                fontSize: 18,
              ),
            )),
        Text(
          '$duration ${duration <= 1 ? 'hour' : 'hours'}',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: SizedBox(
              //width: width *0.67,
              child: Text(activity.description)),
        ),
      ])
    ]);
  }));
}

Widget _buildLearnMoreDialogMid(BuildContext context, LegacyActivity activity) {
  return Dialog(
    child: Builder(builder: (context) {
      var width = MediaQuery.sizeOf(context).width;
      var height = MediaQuery.sizeOf(context).height;
      var duration = activity.duration;

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: SizedBox(
              width: width,
              height: 0.6 * height,
              child: Image(
                  image: CachedNetworkImageProvider(activity.imageUrl),
                  fit: BoxFit.cover)),
        ),
        Text(
          '$duration ${duration <= 1 ? 'hour' : 'hours'}',
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 16),
          child: SizedBox(
              //height: 300,
              child: Text(activity.description)),
        ),
      ]);
    }),
  );
}

// This is for tablet
Widget _buildLearnMoreDialogLarge(
    BuildContext context, LegacyActivity activity) {
  return Dialog(child: Builder(builder: (context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    var duration = activity.duration;

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        child: SizedBox(
            width: 0.48 * width,
            height: height,
            child: Image(
                image: CachedNetworkImageProvider(activity.imageUrl),
                fit: BoxFit.cover)),
      ),
      const SizedBox(
        width: 16,
      ),
      Column(children: [
        const SizedBox(height: 16),
        Text(
          activity.name,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          '$duration ${duration <= 1 ? 'hour' : 'hours'}',
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
              width: width * 0.4,
              //height: 300,
              child: Text(activity.description)),
        ),
      ])
    ]);
  }));
}

Widget buildLearnMoreButton(
    BuildContext context, Color color, LegacyActivity activity) {
  var width = MediaQuery.sizeOf(context).width;

  return TextButton(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(color),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: Colors.grey[300]!),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    onPressed: () {
      showDialog(
          context: context,
          builder: (context) {
            return OrientationBuilder(builder: (context, orientation) {
              debugPrint(orientation.toString());
              if (width < 600) {
                if (orientation == Orientation.portrait) {
                  return _buildLearnMoreDialogSmall(context, activity);
                } else {
                  return _buildLearnMoreDialogMid(context, activity);
                }
              } else if (width > 600 && width < 800) {
                return _buildLearnMoreDialogMid(context, activity);
              } else {
                if (orientation == Orientation.landscape) {
                  return _buildLearnMoreDialogLarge(context, activity);
                } else {
                  return _buildLearnMoreDialogMid(context, activity);
                }
              }
            });
          });
    },
    child: const Text(
      'Learn more',
      style: TextStyle(
        fontSize: 12,
      ),
    ),
  );
}

class _ActivityTileState extends State<ActivityTile> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    var duration = widget.activity.duration;
    checked = context.read<TravelPlan>().activities.contains(widget.activity);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(widget.activity.imageUrl),
              ), // b
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.activity.name),
                  Row(children: [
                    buildLearnMoreButton(
                        context, Colors.transparent, widget.activity),
                    const SizedBox.square(
                      dimension: 24,
                    ),
                    Text(
                      '$duration ${duration <= 1 ? 'hour' : 'hours'}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: Colors.grey[600]!, width: 1),
            value: checked,
            onChanged: (val) {
              context.read<TravelPlan>().toggleActivity(widget.activity);
              setState(() {
                checked = !checked;
              });
            },
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatefulWidget {
  const ActivityCard({required this.activity, super.key});

  final LegacyActivity activity;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool checked = false;

  Widget _buildCheck(BuildContext context) {
    checked = context.read<TravelPlan>().activities.contains(widget.activity);
    var colorScheme = Theme.of(context).colorScheme;
    if (checked) {
      return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(24)),
          child: Icon(
            Icons.check,
            color: colorScheme.onSurface,
          ));
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    var duration = widget.activity.duration;
    //var width = MediaQuery.sizeOf(context).width;
    var colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
        onTap: () {
          context.read<TravelPlan>().toggleActivity(widget.activity);
          setState(() {
            checked = !checked;
          });
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            // TODO: Improve image loading and caching
            child: SizedBox(
                width: 400,
                height: 400,
                child: Stack(fit: StackFit.expand, children: [
                  Image(
                      image:
                          CachedNetworkImageProvider(widget.activity.imageUrl),
                      fit: BoxFit.fitHeight),
                  Positioned(right: 24, top: 24, child: _buildCheck(context)),
                  Positioned(
                      bottom: 32.0,
                      left: 16.0,
                      right: 24.0,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.activity.name,
                              style: TextStyles.cardTitleStyle
                                  .copyWith(fontSize: 24),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$duration ${duration <= 1 ? 'hour' : 'hours'}',
                                  style: TextStyles.cardTitleStyle
                                      .copyWith(fontSize: 18),
                                ),
                                buildLearnMoreButton(
                                    context,
                                    colorScheme.surfaceContainer,
                                    widget.activity)
                              ],
                            )
                          ])),
                ]))));
  }
}

class ActivityDetailTile extends StatelessWidget {
  const ActivityDetailTile({required this.activity, super.key});

  final LegacyActivity activity;

  @override
  Widget build(BuildContext context) {
    var duration = activity.duration;

    return ExpansionTile(
      tilePadding: const EdgeInsets.all(0),
      childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      maintainState: true,
      minTileHeight: 100,
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(activity.imageUrl),
          ), // b
        ),
      ),
      title: Text(activity.name),
      subtitle: Text(
        '$duration ${duration <= 1 ? 'hour' : 'hours'}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      children: [
        Text(
          activity.description,
        ),
      ],
    );
  }
}
