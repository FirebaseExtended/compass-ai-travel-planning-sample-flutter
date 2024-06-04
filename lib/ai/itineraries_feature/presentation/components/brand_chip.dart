import 'package:flutter/material.dart';

class BrandChip extends StatelessWidget {
  const BrandChip({
    required this.title,
    this.icon,
    super.key,
  });

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Chip(
            //color: const WidgetStatePropertyAll(Colors.transparent),
            backgroundColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.8),
            shape: const StadiumBorder(side: BorderSide.none),
            avatar: (icon != null)
                ? Icon(icon,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)
                : null,
            label: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
