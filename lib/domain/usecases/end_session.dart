import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/session_repository.dart';

class EndSession {
  final SessionRepository repository;

  EndSession(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      await repository.endSession();
      return const Right(null);
    } catch (e) {
      return Left(SessionFailure(e.toString()));
    }
  }
}
