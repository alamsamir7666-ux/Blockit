import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/theme/app_theme.dart';
import 'domain/repositories/session_repository.dart';
import 'domain/repositories/permission_repository.dart';
import 'domain/usecases/start_session.dart';
import 'domain/usecases/end_session.dart';
import 'domain/usecases/use_parachute.dart';
import 'domain/usecases/check_permissions.dart';
import 'presentation/providers/session_provider.dart';
import 'presentation/providers/permission_provider.dart';
import 'presentation/providers/stats_provider.dart';
import 'presentation/screens/onboarding/sign_in_screen.dart';
import 'presentation/screens/onboarding/permission_flow_screen.dart';
import 'presentation/screens/onboarding/ready_screen.dart';
import 'presentation/screens/home/timer_screen.dart';
import 'presentation/screens/session/blocking_screen.dart';
import 'presentation/screens/stats/stats_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';

class BlockitApp extends StatelessWidget {
  const BlockitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sl = GetIt.instance;
    final sessionRepo = sl<SessionRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionBloc>(
          create: (_) => SessionBloc(
            startSession: sl<StartSession>(),
            endSession: sl<EndSession>(),
            useParachute: sl<UseParachute>(),
            sessionStream: sessionRepo.sessionStream,
          ),
        ),
        BlocProvider<PermissionBloc>(
          create: (_) => PermissionBloc(
            checkPermissions: sl<CheckPermissions>(),
          ),
        ),
        BlocProvider<StatsBloc>(
          create: (_) => StatsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Blockit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        initialRoute: '/',
        routes: {
          '/': (context) => const SignInScreen(),
          '/permissions': (context) => const PermissionFlowScreen(),
          '/ready': (context) => const ReadyScreen(),
          '/home': (context) => const TimerScreen(),
          '/blocking': (context) => const BlockingScreen(),
          '/stats': (context) => const StatsScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
