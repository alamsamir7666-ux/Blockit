import '../platform/permission_channel.dart';

class PermissionChecker {
  final PermissionChannel _channel;

  PermissionChecker(this._channel);

  Future<bool> canStartSession() async {
    final overlay = await _channel.checkOverlayPermission();
    final accessibility = await _channel.checkAccessibilityService();
    return overlay && accessibility;
  }

  Future<List<String>> getMissingPermissions() async {
    final missing = <String>[];
    if (!await _channel.checkOverlayPermission()) {
      missing.add('overlay');
    }
    if (!await _channel.checkUsageStatsPermission()) {
      missing.add('usage_stats');
    }
    if (!await _channel.checkAccessibilityService()) {
      missing.add('accessibility');
    }
    if (!await _channel.checkDeviceAdmin()) {
      missing.add('device_admin');
    }
    return missing;
  }
}
