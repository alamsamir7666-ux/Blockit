import '../../domain/entities/stats_entry.dart';

class StatsRepositoryImpl {
  Future<List<StatsEntry>> getStatsForRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Will be implemented with Hive local storage
    return [];
  }

  Future<void> saveSessionComplete({
    required DateTime startTime,
    required DateTime endTime,
    required int difficulty,
  }) async {
    // Will be implemented with Hive
  }

  Future<void> saveSessionAbandoned({
    required DateTime startTime,
    required DateTime endTime,
    required bool usedParachute,
  }) async {
    // Will be implemented with Hive
  }
}
