import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/permission_status.dart';
import '../repositories/permission_repository.dart';

class CheckPermissions {
  final PermissionRepository repository;

  CheckPermissions(this.repository);

  Future<Either<Failure, PermissionStatus>> call() async {
    try {
      final status = await repository.checkAllPermissions();
      return Right(status);
    } catch (e) {
      return Left(PermissionFailure(e.toString()));
    }
  }
}
