import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/stats_entry.dart';

class GetStats {
  Future<Either<Failure, List<StatsEntry>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Will be implemented with Hive datasource
      return const Right([]);
    } catch (e) {
      return Left(StatsFailure(e.toString()));
    }
  }
}
