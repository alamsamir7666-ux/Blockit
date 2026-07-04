import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/session_provider.dart';
import 'widgets/duration_selector.dart';
import 'widgets/difficulty_slider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _selectedMinutes = 30;
  int _difficulty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => Navigator.pushNamed(context, '/stats'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state is SessionRunning) {
            Navigator.pushNamed(context, '/blocking');
          }
          if (state is SessionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Start a Focus Session',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose how long you want to stay focused',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 40),
                  DurationSelector(
                    selectedMinutes: _selectedMinutes,
                    onChanged: (minutes) {
                      setState(() => _selectedMinutes = minutes);
                    },
                  ),
                  const SizedBox(height: 40),
                  DifficultySlider(
                    difficulty: _difficulty,
                    onChanged: (value) {
                      setState(() => _difficulty = value);
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is SessionRunning
                          ? null
                          : () {
                              context.read<SessionBloc>().add(
                                    StartSessionEvent(
                                      durationMinutes: _selectedMinutes,
                                      difficulty: _difficulty,
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: AppColors.surfaceLight,
                      ),
                      child: Text(
                        state is SessionRunning
                            ? 'Session in Progress...'
                            : AppStrings.startSession,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
