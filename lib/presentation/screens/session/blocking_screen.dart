import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/session.dart';
import '../../providers/session_provider.dart';

class BlockingScreen extends StatelessWidget {
  const BlockingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            if (state is SessionRunning) {
              return _buildBlockingUI(context, state.session);
            }
            if (state is SessionEnded || state is SessionIdle) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/home');
              });
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBlockingUI(BuildContext context, Session session) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Focus Session Active',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Stay focused. Your phone is locked.',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            _buildCountdownTimer(session),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, color: AppColors.textMuted, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Difficulty: ${_difficultyText(session.difficulty)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
            if (session.parachutesRemaining > 0)
              _buildParachuteButton(context, session),
            const SizedBox(height: 16),
            Text(
              'Press back button to turn off screen',
              style: TextStyle(
                color: AppColors.textMuted.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(Session session) {
    return TweenAnimationBuilder<Duration>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: Duration.zero, end: session.remainingDuration),
      builder: (context, Duration value, child) {
        final hours = value.inHours;
        final minutes = value.inMinutes.remainder(60);
        final seconds = value.inSeconds.remainder(60);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeBox(hours.toString().padLeft(2, '0'), 'hrs'),
            const Text(':', style: TextStyle(fontSize: 40, color: AppColors.textPrimary)),
            _buildTimeBox(minutes.toString().padLeft(2, '0'), 'min'),
            const Text(':', style: TextStyle(fontSize: 40, color: AppColors.textPrimary)),
            _buildTimeBox(seconds.toString().padLeft(2, '0'), 'sec'),
          ],
        );
      },
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Column(
      children: [
        Container(
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildParachuteButton(BuildContext context, Session session) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _showParachuteDialog(context),
        icon: const Text('🪂', style: TextStyle(fontSize: 20)),
        label: Text(
          'Use Parachute (${session.parachutesRemaining} left)',
          style: const TextStyle(fontSize: 16),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.warning,
          side: BorderSide(color: AppColors.warning.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _showParachuteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Use Parachute?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This will end your session early. Parachutes are limited.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SessionBloc>().add(UseParachuteEvent());
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              'Use Parachute',
              style: TextStyle(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }

  String _difficultyText(int difficulty) {
    switch (difficulty) {
      case 1: return 'Easy';
      case 2: return 'Medium';
      case 3: return 'Hard';
      default: return 'Unknown';
    }
  }
}
