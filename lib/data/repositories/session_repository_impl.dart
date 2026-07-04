import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/native/native_datasource.dart';
import '../models/session_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  final NativeDatasource nativeDatasource;

  SessionRepositoryImpl({required this.nativeDatasource});

  @override
  Future<Session> getSessionState() async {
    final map = await nativeDatasource.getSessionState();
    return SessionModel.fromNativeMap(map);
  }

  @override
  Future<void> startSession({
    required int durationMinutes,
    required int difficulty,
  }) async {
    await nativeDatasource.startSession(
      durationMinutes: durationMinutes,
      difficulty: difficulty,
    );
  }

  @override
  Future<void> endSession() async {
    await nativeDatasource.endSession();
  }

  @override
  Future<void> useParachute() async {
    await nativeDatasource.useParachute();
  }

  @override
  Future<int> getRemainingTime() async {
    final state = await getSessionState();
    return state.remainingSeconds;
  }

  @override
  Stream<Session> get sessionStream {
    return nativeDatasource.sessionStream.map((map) {
      return SessionModel.fromNativeMap(map);
    });
  }
}
