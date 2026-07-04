import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/stats_entry.dart';

class HiveSessionDatasource {
  static const _boxName = 'stats_box';
  static const _statsKey = 'daily_stats';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  List<StatsEntry> getStats() {
    final raw = _box.get(_statsKey);
    if (raw == null) return [];
    // Parse from stored format
    return [];
  }

  Future<void> saveStats(List<StatsEntry> stats) async {
    // Convert to storable format and save
    await _box.put(_statsKey, stats);
  }

  Future<void> clearStats() async {
    await _box.delete(_statsKey);
  }
}
