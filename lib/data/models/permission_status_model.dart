import '../../domain/entities/permission_status.dart';

class PermissionStatusModel extends PermissionStatus {
  const PermissionStatusModel({
    super.overlay,
    super.usageStats,
    super.accessibilityService,
    super.deviceAdmin,
  });

  factory PermissionStatusModel.fromNativeMap(Map<String, dynamic> map) {
    return PermissionStatusModel(
      overlay: map['overlay'] as bool? ?? false,
      usageStats: map['usageStats'] as bool? ?? false,
      accessibilityService: map['accessibilityService'] as bool? ?? false,
      deviceAdmin: map['deviceAdmin'] as bool? ?? false,
    );
  }

  factory PermissionStatusModel.fromEntity(PermissionStatus status) {
    return PermissionStatusModel(
      overlay: status.overlay,
      usageStats: status.usageStats,
      accessibilityService: status.accessibilityService,
      deviceAdmin: status.deviceAdmin,
    );
  }
}
