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
      /*print(
          '${location!.toLowerCase().replaceAll(' ', '-')} vs ${activity.locationName} vs ${activity.destination}');*/
      return (location == null ||
          activity.destination == location.toLowerCase().replaceAll(' ', '-'));
    }

    final result = await _repository.getActivities();
    //print(result);
    return switch (result) {
      Ok() => Result.ok(result.value.where(filter).toList()),
      Error() => result,
    };
  }
}
