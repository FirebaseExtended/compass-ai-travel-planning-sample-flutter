import 'package:flutter/material.dart';
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
                image: NetworkImage(widget.activity.imageUrl),
              ),
              color: Colors.green, // b
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.timeOfDay,
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(widget.activity.name),
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
                    onPressed: () {},
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
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
