import '../../common/utils/result.dart';
import '../../results/business/model/destination.dart';

/// Data source with all possible destinations
abstract class DestinationRepository {
  /// Get complete list of destinations
  Future<Result<List<Destination>>> getDestinations();
}
