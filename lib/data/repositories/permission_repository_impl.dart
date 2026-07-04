import '../../domain/entities/permission_status.dart';
import '../../domain/repositories/permission_repository.dart';
import '../datasources/native/native_datasource.dart';
import '../models/permission_status_model.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final NativeDatasource nativeDatasource;

  PermissionRepositoryImpl({required this.nativeDatasource});

  @override
  Future<PermissionStatus> checkAllPermissions() async {
    final map = await nativeDatasource.checkAllPermissions();
    return PermissionStatusModel.fromNativeMap(map);
  }

  @override
  Future<void> requestOverlayPermission() async {
    await nativeDatasource.requestOverlayPermission();
  }

  @override
  Future<void> requestUsageStatsPermission() async {
    await nativeDatasource.requestUsageStatsPermission();
  }

  @override
  Future<void> requestAccessibilityService() async {
    await nativeDatasource.requestAccessibilityService();
  }

  @override
  Future<void> requestDeviceAdmin() async {
    await nativeDatasource.requestDeviceAdmin();
  }

  @override
  Future<bool> hasOverlayPermission() async {
    final status = await checkAllPermissions();
    return status.overlay;
  }

  @override
  Future<bool> hasUsageStatsPermission() async {
    final status = await checkAllPermissions();
    return status.usageStats;
  }

  @override
  Future<bool> hasAccessibilityService() async {
    final status = await checkAllPermissions();
    return status.accessibilityService;
  }

  @override
  Future<bool> hasDeviceAdmin() async {
    final status = await checkAllPermissions();
    return status.deviceAdmin;
  }
}
