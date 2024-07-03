import '../../../common/utils/result.dart';
import '../../business/model/destination.dart';
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
