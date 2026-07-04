import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/stats_entry.dart';

// Events
abstract class StatsEvent {}

class LoadStatsEvent extends StatsEvent {
  final DateTime startDate;
  final DateTime endDate;
  LoadStatsEvent({required this.startDate, required this.endDate});
}

// States
abstract class StatsState {}

class StatsInitial extends StatsState {}
class StatsLoading extends StatsState {}
class StatsLoaded extends StatsState {
  final List<StatsEntry> entries;
  final int totalMinutes;
  final int totalSessions;
  final double completionRate;

  StatsLoaded({
    required this.entries,
    required this.totalMinutes,
    required this.totalSessions,
    required this.completionRate,
  });
}

class StatsError extends StatsState {
  final String message;
  StatsError(this.message);
}

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsInitial()) {
    on<LoadStatsEvent>((event, emit) async {
      emit(StatsLoading());
      // Will be connected to Hive datasource
      emit(StatsLoaded(
        entries: [],
        totalMinutes: 0,
        totalSessions: 0,
        completionRate: 0.0,
      ));
    });
  }
}
