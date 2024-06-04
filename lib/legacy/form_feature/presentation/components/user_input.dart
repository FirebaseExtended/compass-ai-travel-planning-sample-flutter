import 'package:flutter/material.dart';
import '../../../../common/utilties.dart';

class NumberOfTravelersPicker extends StatelessWidget {
  const NumberOfTravelersPicker(
      {required this.numPeople,
      required this.onDecreaseNumPeople,
      required this.onIncreaseNumPeople,
      super.key});

  final int numPeople;
  final VoidCallback onDecreaseNumPeople, onIncreaseNumPeople;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Who',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        QuantityInput(
          value: numPeople,
          onDecrease: onDecreaseNumPeople,
          onIncrease: onIncreaseNumPeople,
          min: 1,
        ),
      ],
    );
  }
}

class TravelDatePicker extends StatelessWidget {
  const TravelDatePicker(
      {required this.tripDateRange,
      required this.onDateTimeRangeSelected,
      super.key});

  final DateTimeRange? tripDateRange;
  final void Function(DateTimeRange) onDateTimeRangeSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'When',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextButton(
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            ),
          ),
          onPressed: () async {
            DateTimeRange? tripDates = await showDialog(
              context: context,
              builder: (context) {
                return Theme(
                  data: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.black,
                      dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
                    ),
                  ),
                  child: DateRangePickerDialog(
                    initialDateRange: tripDateRange,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.parse('2028-01-01'),
                  ),
                );
              },
            );

            if (tripDates == null) return;

            onDateTimeRangeSelected(tripDates);
          },
          child: tripDateRange != null
              ? Text(
                  '${shortenedDate(tripDateRange!.start.toString())} – ${shortenedDate(tripDateRange!.end.toString().toString())}')
              : const Text('Add Dates'),
        ),
      ],
    );
  }
}

class QuantityInput extends StatelessWidget {
  const QuantityInput({
    required this.value,
    required this.onIncrease,
    required this.onDecrease,
    this.min,
    this.max,
    super.key,
  });

  final VoidCallback onDecrease, onIncrease;
  final int value;
  final int? min, max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            int? minValue = min;
            if (minValue != null && value <= minValue) return;

            onDecrease();
          },
          icon: const Icon(
            Icons.remove_circle_outline,
          ),
        ),
        Text(value.toString()),
        IconButton(
          onPressed: onIncrease,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextButton(
          style: ButtonStyle(
            shadowColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer),
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
            backgroundColor: const WidgetStatePropertyAll(
              Colors.black,
            ),
          ),
          onPressed: onPressed,
          child: const Text(
            'Search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    ]);
  }
}
