import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/ai/styles.dart';
import 'package:tripedia/legacy/results/presentation/results_screen.dart';

import '../../activities_feature/models/activity.dart';
import '../../results/presentation/results_viewmodel.dart';
import '../../../../../common/services/navigation.dart';
import '../models/travel_query.dart';

import './components/components.dart';

class LegacyFormScreen extends StatefulWidget {
  const LegacyFormScreen({super.key});

  @override
  State<LegacyFormScreen> createState() => _LegacyFormScreenState();
}

class _LegacyFormScreenState extends State<LegacyFormScreen> {
  int numPeople = 1;
  String? selectedLocation;
  DateTimeRange? tripDateRange;

  void decreaseNumPeople() {
    setState(() {
      numPeople -= 1;
    });
  }

  void increaseNumPeople() {
    setState(() {
      numPeople += 1;
    });
  }

  void selectLocation(String location) {
    setState(() {
      selectedLocation = location;
    });
  }

  void setQueryAndGoToResults() {
    var location = selectedLocation;
    var date = tripDateRange;

    if (location == null || date == null) return;
    // TODO: Show alert asking for location and date

    context.read<TravelPlan>().setQuery(
          TravelQuery(location: location, dates: date, numPeople: numPeople),
        );

    context.read<ResultsViewModel>().search(continent: location);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResultsScreen(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
              onPressed: () => goToSplashScreen(context),
              icon: const Icon(
                Icons.home_outlined,
              ),
            )),
      ],
    );
  }

  Widget _buildMobileScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
      child: Column(
        children: [
          Expanded(
            child: Column(children: [
              SizedBox(
                height: 120,
                child: LocationPicker(
                  height: 120,
                  width: 120,
                  selected: selectedLocation,
                  onSelect: selectLocation,
                ),
              ),
              const SizedBox.square(
                dimension: 24,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: TravelDatePicker(
                  tripDateRange: tripDateRange,
                  onDateTimeRangeSelected: (tripDates) => setState(() {
                    tripDateRange = tripDates;
                  }),
                ),
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: NumberOfTravelersPicker(
                  numPeople: numPeople,
                  onDecreaseNumPeople: decreaseNumPeople,
                  onIncreaseNumPeople: increaseNumPeople,
                ),
              ),
            ]),
          ),
          SearchButton(onPressed: setQueryAndGoToResults),
        ],
      ),
    );
  }

  Widget _buildWideScreen(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              SizedBox(
                  width: constraints.maxWidth * 0.48,
                  child: LocationPickerGrid(
                    width: 400,
                    height: 200,
                    selected: selectedLocation,
                    onSelect: selectLocation,
                  )),
              SizedBox.square(
                dimension: (constraints.maxWidth > 724) ? 24 : 16,
              ),
              Column(children: [
                Container(
                  width: constraints.maxWidth * 0.43,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: TravelDatePicker(
                    tripDateRange: tripDateRange,
                    onDateTimeRangeSelected: (tripDates) => setState(() {
                      tripDateRange = tripDates;
                    }),
                  ),
                ),
                const SizedBox.square(
                  dimension: 16,
                ),
                Container(
                  width: constraints.maxWidth * 0.43,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: NumberOfTravelersPicker(
                    numPeople: numPeople,
                    onDecreaseNumPeople: decreaseNumPeople,
                    onIncreaseNumPeople: increaseNumPeople,
                  ),
                ),
              ]),
            ],
          )),
          SearchButton(onPressed: setQueryAndGoToResults),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isPortrait = constraints.maxHeight > constraints.maxWidth;

      return Scaffold(
        appBar: _buildAppBar(),
        body: (constraints.maxWidth <= Breakpoints.compact || isPortrait)
            ? _buildMobileScreen(context)
            : _buildWideScreen(context, constraints),
      );
    });
  }
}
