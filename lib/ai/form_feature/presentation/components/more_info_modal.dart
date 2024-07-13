import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tripedia/common/utilties.dart';

class KidsSwitch extends StatelessWidget {
  const KidsSwitch({this.value = false, required this.onChanged, super.key});

  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.child_friendly,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: const Text('Are the kids coming?'),
      trailing: Switch(
        activeTrackColor: Theme.of(context).colorScheme.primary,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class TravelDateTextField extends StatefulWidget {
  const TravelDateTextField({required this.onChanged, super.key});

  final Function(String) onChanged;

  @override
  State<TravelDateTextField> createState() => _TravelDateTextFieldState();
}

class _TravelDateTextFieldState extends State<TravelDateTextField> {
  TextEditingController userInputtedDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Icon(
          color: Theme.of(context).colorScheme.secondary,
          Icons.calendar_month,
        ),
      ),
      const SizedBox.square(dimension: 8),
      Expanded(
        child: TextField(
          controller: userInputtedDate,
          onChanged: widget.onChanged,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            label: const Text('When would you like to travel?'),
            hintText:
                '${datesWithSlash.format(DateTime.now())}, July 2025, next year...',
          ),
        ),
      ),
      const SizedBox.square(dimension: 16),
    ]);
  }
}

class BudgetSlider extends StatelessWidget {
  const BudgetSlider({required this.value, required this.onChanged, super.key});

  final double value;
  final Function(double) onChanged;

  String getLabel(double value) {
    return "\$" * value.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Icon(Icons.wallet,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            const Text(
              'What\'s your budget?',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ]),
          Row(children: [
            const Text('\$'),
            Expanded(
              child: Slider(
                label: getLabel(value),
                value: value,
                min: 1,
                max: 5,
                onChanged: onChanged,
                divisions: 4,
              ),
            ),
            const Text('\$\$\$\$\$'),
          ]),
        ],
      ),
    );
  }
}

class MoreInfoSheet extends StatefulWidget {
  const MoreInfoSheet({required this.details, super.key});

  final Map<String, Object?> details;

  @override
  State<MoreInfoSheet> createState() => _MoreInfoSheetState();
}

class _MoreInfoSheetState extends State<MoreInfoSheet> {
  bool hasKids = false;
  double budget = 1;
  String date = '';

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Just a few more details, please!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              if (widget.details['kids'] == false)
                Column(children: [
                  KidsSwitch(
                    value: hasKids,
                    onChanged: (val) {
                      setState(() {
                        hasKids = !hasKids;
                      });
                    },
                  ).animate().fadeIn(),
                  const Divider(),
                ]),
              const SizedBox.square(
                dimension: 8,
              ),
              if (widget.details['date'] == false)
                Column(children: [
                  TravelDateTextField(onChanged: (userInputtedDate) {
                    setState(() {
                      date = userInputtedDate;
                    });
                  }).animate().fadeIn(),
                  const SizedBox.square(
                    dimension: 16,
                  ),
                  const Divider(),
                ]),
              if (widget.details['cost'] == false)
                BudgetSlider(
                  value: budget,
                  onChanged: (val) {
                    setState(() {
                      budget = val;
                    });
                  },
                ).animate().fadeIn(),
              const SizedBox.square(
                dimension: 8,
              ),
              Row(children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, {
                        if (widget.details['kids'] == false) 'kids': hasKids,
                        if (widget.details['date'] == false) 'date': date,
                        if (widget.details['cost'] == false) 'cost': budget,
                      });
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}
