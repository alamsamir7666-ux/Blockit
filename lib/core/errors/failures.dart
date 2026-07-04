import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class SessionFailure extends Failure {
  const SessionFailure(String message) : super(message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(String message) : super(message);
}

class StatsFailure extends Failure {
  const StatsFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}
