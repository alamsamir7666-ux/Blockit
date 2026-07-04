import 'package:get_it/get_it.dart';
import 'core/platform/session_channel.dart';
import 'core/platform/permission_channel.dart';
import 'core/platform/native_event_channel.dart';
import 'data/datasources/native/native_datasource.dart';
import 'data/repositories/session_repository_impl.dart';
import 'data/repositories/permission_repository_impl.dart';
import 'domain/repositories/session_repository.dart';
import 'domain/repositories/permission_repository.dart';
import 'domain/usecases/start_session.dart';
import 'domain/usecases/end_session.dart';
import 'domain/usecases/use_parachute.dart';
import 'domain/usecases/check_permissions.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Platform Channels
  sl.registerLazySingleton<SessionChannel>(() => SessionChannel());
  sl.registerLazySingleton<PermissionChannel>(() => PermissionChannel());
  sl.registerLazySingleton<NativeEventChannel>(() => NativeEventChannel());

  // Data Sources
  sl.registerLazySingleton<NativeDatasource>(
    () => NativeDatasource(
      sessionChannel: sl(),
      permissionChannel: sl(),
      eventChannel: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(nativeDatasource: sl()),
  );
  sl.registerLazySingleton<PermissionRepository>(
    () => PermissionRepositoryImpl(nativeDatasource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton<StartSession>(
    () => StartSession(sl()),
  );
  sl.registerLazySingleton<EndSession>(
    () => EndSession(sl()),
  );
  sl.registerLazySingleton<UseParachute>(
    () => UseParachute(sl()),
  );
  sl.registerLazySingleton<CheckPermissions>(
    () => CheckPermissions(sl()),
  );
}
