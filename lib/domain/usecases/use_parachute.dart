import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/session_repository.dart';

class UseParachute {
  final SessionRepository repository;

  UseParachute(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      await repository.useParachute();
      return const Right(null);
    } catch (e) {
      return Left(SessionFailure(e.toString()));
    }
  }
}
