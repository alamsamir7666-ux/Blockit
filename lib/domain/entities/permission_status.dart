import 'package:equatable/equatable.dart';

class PermissionStatus extends Equatable {
  final bool overlay;
  final bool usageStats;
  final bool accessibilityService;
  final bool deviceAdmin;

  const PermissionStatus({
    this.overlay = false,
    this.usageStats = false,
    this.accessibilityService = false,
    this.deviceAdmin = false,
  });

  bool get allGranted =>
      overlay && usageStats && accessibilityService && deviceAdmin;

  List<String> get missingPermissions {
    final missing = <String>[];
    if (!overlay) missing.add('Overlay');
    if (!usageStats) missing.add('Usage Stats');
    if (!accessibilityService) missing.add('Accessibility');
    if (!deviceAdmin) missing.add('Device Admin');
    return missing;
  }

  @override
  List<Object?> get props => [
        overlay,
        usageStats,
        accessibilityService,
        deviceAdmin,
      ];
}
