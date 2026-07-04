import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/session_repository.dart';

class StartSession {
  final SessionRepository repository;

  StartSession(this.repository);

  Future<Either<Failure, void>> call({
    required int durationMinutes,
    required int difficulty,
  }) async {
    try {
      await repository.startSession(
        durationMinutes: durationMinutes,
        difficulty: difficulty,
      );
      return const Right(null);
    } catch (e) {
      return Left(SessionFailure(e.toString()));
    }
  }
}
