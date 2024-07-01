import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripedia/screens/legacy/activities/activity_list_tile.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              style: ButtonStyle(
                side: WidgetStatePropertyAll(
                  BorderSide(color: Colors.grey[300]!),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onPressed: () => context.go('/'),
              icon: const Icon(
                Icons.home_outlined,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: ListView(
          children: [
            Text('Daytime'),
            ActivityTile(),
            ActivityTile(),
            ActivityTile(),
            Text('Evening'),
            ActivityTile(),
            ActivityTile(),
            ActivityTile(),
          ],
        ),
      ),
    );
  }
}
