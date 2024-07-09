import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/screens/legacy/activities/activity.dart';

class ActivityTile extends StatefulWidget {
  const ActivityTile({required this.activity, super.key});

  final LegacyActivity activity;

  @override
  State<ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    var duration = widget.activity.duration;

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
                    TextButton(
                      style: ButtonStyle(
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
                              return Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                          widget.activity.imageUrl),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 8),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 16, 8, 0),
                                            child: Text(
                                              widget.activity.name,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 16),
                                            child: Text(
                                              widget.activity.description,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton.icon(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                icon: const Icon(Icons.close),
                                                label: Text(
                                                  'Close',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  iconColor:
                                                      WidgetStatePropertyAll(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      child: const Text(
                        'Learn more',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
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
