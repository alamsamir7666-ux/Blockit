import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/permission_status.dart';
import '../../domain/usecases/check_permissions.dart';

// Events
abstract class PermissionEvent {}

class CheckAllPermissionsEvent extends PermissionEvent {}
class RequestOverlayPermissionEvent extends PermissionEvent {}
class RequestUsageStatsPermissionEvent extends PermissionEvent {}
class RequestAccessibilityServiceEvent extends PermissionEvent {}
class RequestDeviceAdminEvent extends PermissionEvent {}

// States
abstract class PermissionState {}

class PermissionInitial extends PermissionState {}
class PermissionLoading extends PermissionState {}
class PermissionsChecked extends PermissionState {
  final PermissionStatus status;
  PermissionsChecked(this.status);
}

class PermissionGranted extends PermissionState {
  final String permission;
  PermissionGranted(this.permission);
}

class PermissionError extends PermissionState {
  final String message;
  PermissionError(this.message);
}

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final CheckPermissions checkPermissions;

  PermissionBloc({required this.checkPermissions})
      : super(PermissionInitial()) {
    on<CheckAllPermissionsEvent>((event, emit) async {
      emit(PermissionLoading());
      final result = await checkPermissions();
      result.fold(
        (failure) => emit(PermissionError(failure.message)),
        (status) => emit(PermissionsChecked(status)),
      );
    });
  }
}
