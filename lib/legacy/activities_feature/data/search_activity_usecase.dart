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

import 'package:tripedia/legacy/activities_feature/models/activity.dart';
import 'package:tripedia/legacy/activities_feature/data/legacy_activity_repository.dart';
import 'package:tripedia/legacy/activities_feature/data/legacy_activity_repository_local.dart';
import '../../common/utils/result.dart';

/// Search Activity Usecase
class SearchActivityUsecase {
  SearchActivityUsecase({
    required ActivityRepositoryLocal repository,
  }) : _repository = repository;

  final LegacyActivityRepository _repository;

  /// Perform search over possible destinations
  /// All search filter options are optional
  Future<Result<List<LegacyActivity>>> search({String? location}) async {
    bool filter(LegacyActivity activity) {
      /*debugPrint(
          '${location!.toLowerCase().replaceAll(' ', '-')} vs ${activity.locationName} vs ${activity.destination}');*/
      return (location == null ||
          activity.destination == location.toLowerCase().replaceAll(' ', '-'));
    }

    final result = await _repository.getActivities();
    //debugPrint(result);
    return switch (result) {
      Ok() => Result.ok(result.value.where(filter).toList()),
      Error() => result,
    };
  }
}
