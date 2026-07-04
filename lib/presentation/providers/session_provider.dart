import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/start_session.dart';
import '../../domain/usecases/end_session.dart';
import '../../domain/usecases/use_parachute.dart';

// Events
abstract class SessionEvent {}

class StartSessionEvent extends SessionEvent {
  final int durationMinutes;
  final int difficulty;
  StartSessionEvent({required this.durationMinutes, required this.difficulty});
}

class EndSessionEvent extends SessionEvent {}
class UseParachuteEvent extends SessionEvent {}
class UpdateSessionFromNative extends SessionEvent {
  final Session session;
  UpdateSessionFromNative(this.session);
}
class ResetSession extends SessionEvent {}

// States
abstract class SessionState {}

class SessionInitial extends SessionState {}
class SessionIdle extends SessionState {
  final Session session;
  SessionIdle(this.session);
}

class SessionRunning extends SessionState {
  final Session session;
  SessionRunning(this.session);
}

class SessionEnded extends SessionState {
  final Session session;
  SessionEnded(this.session);
}

class SessionError extends SessionState {
  final String message;
  SessionError(this.message);
}

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final StartSession startSession;
  final EndSession endSession;
  final UseParachute useParachute;
  final Stream<Session> sessionStream;
  StreamSubscription<Session>? _subscription;

  SessionBloc({
    required this.startSession,
    required this.endSession,
    required this.useParachute,
    required this.sessionStream,
  }) : super(SessionInitial()) {
    _listenToNativeStream();

    on<StartSessionEvent>((event, emit) async {
      final result = await startSession(
        durationMinutes: event.durationMinutes,
        difficulty: event.difficulty,
      );
      result.fold(
        (failure) => emit(SessionError(failure.message)),
        (_) => emit(SessionRunning(Session(
          isActive: true,
          difficulty: event.difficulty,
          remainingSeconds: event.durationMinutes * 60,
        ))),
      );
    });

    on<EndSessionEvent>((event, emit) async {
      final result = await endSession();
      result.fold(
        (failure) => emit(SessionError(failure.message)),
        (_) => emit(SessionEnded(const Session())),
      );
    });

    on<UseParachuteEvent>((event, emit) async {
      final result = await useParachute();
      result.fold(
        (failure) => emit(SessionError(failure.message)),
        (_) => emit(SessionEnded(const Session())),
      );
    });

    on<UpdateSessionFromNative>((event, emit) {
      final session = event.session;
      if (session.isActive && session.remainingSeconds > 0) {
        emit(SessionRunning(session));
      } else if (!session.isActive) {
        emit(SessionIdle(session));
      }
    });

    on<ResetSession>((event, emit) {
      emit(SessionIdle(const Session()));
    });
  }

  void _listenToNativeStream() {
    _subscription = sessionStream.listen((session) {
      add(UpdateSessionFromNative(session));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
