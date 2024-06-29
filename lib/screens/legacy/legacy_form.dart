import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LegacyFormScreen extends StatelessWidget {
  const LegacyFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.all(8),
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
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'When',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Add Dates',
                    ),
                  ],
                ),
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Who',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Number Input',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
