import '../common/utils/result.dart';
import 'package:flutter/cupertino.dart';

import './search_activity_usecase.dart';
import 'activity.dart';

/// Results screen view model
/// Based on https://docs.flutter.dev/get-started/fwe/state-management#using-mvvm-for-your-applications-architecture
class ActivitiesViewModel extends ChangeNotifier {
  ActivitiesViewModel({
    required SearchActivityUsecase searchActivityUsecase,
  }) : _searchActivityUsecase = searchActivityUsecase {
    // Preload a search result
    search(location: 'Amalfi Coast');
  }

  final SearchActivityUsecase _searchActivityUsecase;

  // Setters are private
  List<LegacyActivity> _activities = [];
  bool _loading = false;
  String? _location;

  /// List of destinations, may be empty but never null
  List<LegacyActivity> get activities => _activities;

  /// Loading state
  bool get loading => _loading;

  /// Return a formatted String with all the filter options
  String get filters => _location ?? '';

  /// Perform search
  Future<void> search({String? location}) async {
    // Set loading state and notify the view
    _loading = true;
    _location = location;
    notifyListeners();

    // Call the search usecase and request data
    final result = await _searchActivityUsecase.search(location: location);
    //print(result); // Set loading state to false
    _loading = false;
    switch (result) {
      case Ok():
        {
          // If the result is Ok, update the list of destinations
          _activities = result.value;
        }
      case Error():
        {
          // TODO: Handle error
          // ignore: avoid_print
          print(result.error);
        }
    }

    // After finish loading results, notify the view
    notifyListeners();
  }
}
