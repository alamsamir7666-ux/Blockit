import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final bool isActive;
  final DateTime? startTime;
  final DateTime? endTime;
  final int difficulty;
  final int remainingSeconds;
  final int parachutesRemaining;

  const Session({
    this.isActive = false,
    this.startTime,
    this.endTime,
    this.difficulty = 1,
    this.remainingSeconds = 0,
    this.parachutesRemaining = 3,
  });

  Session copyWith({
    bool? isActive,
    DateTime? startTime,
    DateTime? endTime,
    int? difficulty,
    int? remainingSeconds,
    int? parachutesRemaining,
  }) {
    return Session(
      isActive: isActive ?? this.isActive,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      difficulty: difficulty ?? this.difficulty,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      parachutesRemaining: parachutesRemaining ?? this.parachutesRemaining,
    );
  }

  Duration get remainingDuration => Duration(seconds: remainingSeconds);

  String get formattedRemaining {
    final hours = remainingSeconds ~/ 3600;
    final minutes = (remainingSeconds % 3600) ~/ 60;
    final seconds = remainingSeconds % 60;
    if (hours > 0) return '${hours}h ${minutes}m ${seconds}s';
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }

  @override
  List<Object?> get props => [
        isActive,
        startTime,
        endTime,
        difficulty,
        remainingSeconds,
        parachutesRemaining,
      ];
}
