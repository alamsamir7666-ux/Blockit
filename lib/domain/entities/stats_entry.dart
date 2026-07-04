import 'package:equatable/equatable.dart';

class StatsEntry extends Equatable {
  final DateTime date;
  final int totalMinutes;
  final int sessionsCompleted;
  final int sessionsAbandoned;
  final int parachutesUsed;

  const StatsEntry({
    required this.date,
    this.totalMinutes = 0,
    this.sessionsCompleted = 0,
    this.sessionsAbandoned = 0,
    this.parachutesUsed = 0,
  });

  StatsEntry copyWith({
    DateTime? date,
    int? totalMinutes,
    int? sessionsCompleted,
    int? sessionsAbandoned,
    int? parachutesUsed,
  }) {
    return StatsEntry(
      date: date ?? this.date,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      sessionsAbandoned: sessionsAbandoned ?? this.sessionsAbandoned,
      parachutesUsed: parachutesUsed ?? this.parachutesUsed,
    );
  }

  double get completionRate {
    final total = sessionsCompleted + sessionsAbandoned;
    if (total == 0) return 0.0;
    return sessionsCompleted / total;
  }

  @override
  List<Object?> get props => [
        date,
        totalMinutes,
        sessionsCompleted,
        sessionsAbandoned,
        parachutesUsed,
      ];
}
