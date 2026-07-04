import '../entities/session.dart';

abstract class SessionRepository {
  Future<Session> getSessionState();
  Future<void> startSession({
    required int durationMinutes,
    required int difficulty,
  });
  Future<void> endSession();
  Future<void> useParachute();
  Future<int> getRemainingTime();
  Stream<Session> get sessionStream;
}
