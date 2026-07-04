import '../entities/permission_status.dart';

abstract class PermissionRepository {
  Future<PermissionStatus> checkAllPermissions();
  Future<void> requestOverlayPermission();
  Future<void> requestUsageStatsPermission();
  Future<void> requestAccessibilityService();
  Future<void> requestDeviceAdmin();
  Future<bool> hasOverlayPermission();
  Future<bool> hasUsageStatsPermission();
  Future<bool> hasAccessibilityService();
  Future<bool> hasDeviceAdmin();
}
