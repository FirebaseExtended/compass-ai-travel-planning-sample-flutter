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

import '../../../common/utils/result.dart';
import '../model/destination.dart';
import '../../data/destination_repository.dart';

/// Search Destinations Usecase
class SearchDestinationUsecase {
  SearchDestinationUsecase({
    required DestinationRepository repository,
  }) : _repository = repository;

  final DestinationRepository _repository;

  /// Perform search over possible destinations
  /// All search filter options are optional
  Future<Result<List<Destination>>> search({String? continent}) async {
    bool filter(Destination destination) {
      return (continent == null || destination.continent == continent);
    }

    final result = await _repository.getDestinations();
    return switch (result) {
      Ok() => Result.ok(result.value.where(filter).toList()),
      Error() => result,
    };
  }
}
