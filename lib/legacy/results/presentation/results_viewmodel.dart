// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import '../../common/utils/result.dart';
import '../business/model/destination.dart';
import '../business/usecases/search_destination_usecase.dart';
import 'package:flutter/cupertino.dart';

/// Results screen view model
/// Based on https://docs.flutter.dev/get-started/fwe/state-management#using-mvvm-for-your-applications-architecture
class ResultsViewModel extends ChangeNotifier {
  ResultsViewModel({
    required SearchDestinationUsecase searchDestinationUsecase,
  }) : _searchDestinationUsecase = searchDestinationUsecase {
    // Preload a search result
    search(continent: 'Europe');
  }

  final SearchDestinationUsecase _searchDestinationUsecase;

  // Setters are private
  List<Destination> _destinations = [];
  bool _loading = false;
  String? _continent;

  /// List of destinations, may be empty but never null
  List<Destination> get destinations => _destinations;

  /// Loading state
  bool get loading => _loading;

  /// Return a formatted String with all the filter options
  String get filters => _continent ?? '';

  /// Perform search
  Future<void> search({String? continent}) async {
    // Set loading state and notify the view
    _loading = true;
    _continent = continent;
    notifyListeners();

    // Call the search usecase and request data
    final result = await _searchDestinationUsecase.search(continent: continent);
    // Set loading state to false
    _loading = false;
    switch (result) {
      case Ok():
        {
          // If the result is Ok, update the list of destinations
          _destinations = result.value;
        }
      case Error():
        {
          // TODO: Handle error
          debugPrint(result.error.toString());
        }
    }

    // After finish loading results, notify the view
    notifyListeners();
  }
}
