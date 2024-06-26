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
    return InputDatePickerFormField(
      fieldLabelText: 'When would you like to travel?',
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
          Slider(
            label: getLabel(value),
            value: value,
            min: 1,
            max: 5,
            onChanged: onChanged,
            divisions: 4,
          )
        ],
      ),
    );
  }
}
