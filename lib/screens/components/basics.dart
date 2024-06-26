import 'package:flutter/material.dart';

class CompassSwitch extends StatelessWidget {
  CompassSwitch({this.value = false, required this.onChanged, super.key});

  bool value;
  Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.child_friendly),
      title: const Text('Are the kids coming?'),
      trailing: Switch(
        activeTrackColor: Theme.of(context).colorScheme.primary,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class CompassDateInput extends StatelessWidget {
  const CompassDateInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.calendar_month),
      const SizedBox.square(dimension: 8),
      Expanded(
          child: InputDatePickerFormField(
        fieldLabelText: 'When would you like to travel?',
        firstDate: DateTime.now(),
        lastDate: DateTime.now(),
      ))
    ]);
  }
}

class CompassSlider extends StatelessWidget {
  CompassSlider({required this.value, required this.onChanged, super.key});

  double value;
  Function(double) onChanged;

  String getLabel(double value) {
    return "\$" * value.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Icon(
                Icons.wallet,
              ),
            ),
            Text(
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
            const Text('\$\$\$\$'),
          ]),
        ],
      ),
    );
  }
}

class MoreInfoSheet extends StatefulWidget {
  const MoreInfoSheet({super.key});

  @override
  State<MoreInfoSheet> createState() => _MoreInfoSheetState();
}

class _MoreInfoSheetState extends State<MoreInfoSheet> {
  bool switchEnabled = false;
  double sliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
          child: Column(
            children: [
              Text(
                'Just a few more details, please!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox.square(
                dimension: 8,
              ),
              CompassSwitch(
                value: switchEnabled,
                onChanged: (val) {
                  setState(() {
                    switchEnabled = !switchEnabled;
                  });
                },
              ),
              Divider(),
              const SizedBox.square(
                dimension: 16,
              ),
              const CompassDateInput(),
              const SizedBox.square(
                dimension: 16,
              ),
              Divider(),
              CompassSlider(
                value: sliderValue,
                onChanged: (val) {
                  setState(() {
                    sliderValue = val;
                  });
                },
              ),
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
                        'hasKids': false,
                        'date': '11/07/2025',
                        'budget': '\$\$\$\$',
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
