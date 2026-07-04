import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/permission_provider.dart';

class PermissionFlowScreen extends StatefulWidget {
  const PermissionFlowScreen({super.key});

  @override
  State<PermissionFlowScreen> createState() => _PermissionFlowScreenState();
}

class _PermissionFlowScreenState extends State<PermissionFlowScreen> {
  int _currentStep = 0;

  final List<_PermissionStep> _steps = [
    _PermissionStep(
      icon: Icons.layers_outlined,
      title: AppStrings.overlayPermission,
      description: AppStrings.overlayDesc,
      permissionType: 'overlay',
    ),
    _PermissionStep(
      icon: Icons.visibility_outlined,
      title: AppStrings.usageStatsPermission,
      description: AppStrings.usageStatsDesc,
      permissionType: 'usageStats',
    ),
    _PermissionStep(
      icon: Icons.accessibility_new_outlined,
      title: AppStrings.accessibilityPermission,
      description: AppStrings.accessibilityDesc,
      permissionType: 'accessibility',
    ),
    _PermissionStep(
      icon: Icons.admin_panel_settings_outlined,
      title: AppStrings.deviceAdminPermission,
      description: AppStrings.deviceAdminDesc,
      permissionType: 'deviceAdmin',
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<PermissionBloc>().add(CheckAllPermissionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.permissionRequired,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Step ${_currentStep + 1} of ${_steps.length}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                borderRadius: BorderRadius.circular(4),
                minHeight: 4,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: _buildCurrentStep(),
              ),
              const SizedBox(height: 20),
              _buildNavigationButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    final step = _steps[_currentStep];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            step.icon,
            size: 56,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          step.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          step.description,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _grantPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Grant Permission',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_currentStep < _steps.length - 1)
          TextButton(
            onPressed: () {
              setState(() {
                if (_currentStep < _steps.length - 1) _currentStep++;
              });
            },
            child: const Text(
              'Skip for now',
              style: TextStyle(color: AppColors.textMuted),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Continue to App',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  void _grantPermission() {
    final step = _steps[_currentStep];
    switch (step.permissionType) {
      case 'overlay':
        context.read<PermissionBloc>().add(RequestOverlayPermissionEvent());
        break;
      case 'usageStats':
        context.read<PermissionBloc>().add(RequestUsageStatsPermissionEvent());
        break;
      case 'accessibility':
        context.read<PermissionBloc>().add(RequestAccessibilityServiceEvent());
        break;
      case 'deviceAdmin':
        context.read<PermissionBloc>().add(RequestDeviceAdminEvent());
        break;
    }
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }
}

class _PermissionStep {
  final IconData icon;
  final String title;
  final String description;
  final String permissionType;

  const _PermissionStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.permissionType,
  });
}
