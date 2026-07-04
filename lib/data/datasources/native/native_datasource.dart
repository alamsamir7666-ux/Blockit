import '../../../core/platform/session_channel.dart';
import '../../../core/platform/permission_channel.dart';
import '../../../core/platform/native_event_channel.dart';

class NativeDatasource {
  final SessionChannel sessionChannel;
  final PermissionChannel permissionChannel;
  final NativeEventChannel eventChannel;

  NativeDatasource({
    required this.sessionChannel,
    required this.permissionChannel,
    required this.eventChannel,
  });

  Future<Map<String, dynamic>> startSession({
    required int durationMinutes,
    required int difficulty,
  }) async {
    return sessionChannel.startSession(
      durationMinutes: durationMinutes,
      difficulty: difficulty,
    );
  }

  Future<Map<String, dynamic>> endSession() async {
    return sessionChannel.endSession();
  }

  Future<Map<String, dynamic>> useParachute() async {
    return sessionChannel.useParachute();
  }

  Future<Map<String, dynamic>> getSessionState() async {
    return sessionChannel.getSessionState();
  }

  Stream<Map<String, dynamic>> get sessionStream => eventChannel.sessionStream;

  Future<Map<String, dynamic>> checkAllPermissions() async {
    return permissionChannel.checkAllPermissions();
  }

  Future<void> requestOverlayPermission() async {
    await permissionChannel.requestOverlayPermission();
  }

  Future<void> requestUsageStatsPermission() async {
    await permissionChannel.requestUsageStatsPermission();
  }

  Future<void> requestAccessibilityService() async {
    await permissionChannel.requestAccessibilityService();
  }

  Future<void> requestDeviceAdmin() async {
    await permissionChannel.requestDeviceAdmin();
  }
}
