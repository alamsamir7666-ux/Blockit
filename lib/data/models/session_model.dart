import '../../domain/entities/session.dart';

class SessionModel extends Session {
  const SessionModel({
    super.isActive,
    super.startTime,
    super.endTime,
    super.difficulty,
    super.remainingSeconds,
    super.parachutesRemaining,
  });

  factory SessionModel.fromNativeMap(Map<String, dynamic> map) {
    return SessionModel(
      isActive: map['active'] as bool? ?? false,
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int)
          : null,
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int)
          : null,
      difficulty: map['difficulty'] as int? ?? 1,
      remainingSeconds: ((map['remainingMs'] as int?) ?? 0) ~/ 1000,
      parachutesRemaining: map['parachutes'] as int? ?? 3,
    );
  }

  factory SessionModel.fromEntity(Session session) {
    return SessionModel(
      isActive: session.isActive,
      startTime: session.startTime,
      endTime: session.endTime,
      difficulty: session.difficulty,
      remainingSeconds: session.remainingSeconds,
      parachutesRemaining: session.parachutesRemaining,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'startTime': startTime?.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'difficulty': difficulty,
      'remainingSeconds': remainingSeconds,
      'parachutesRemaining': parachutesRemaining,
    };
  }
}
