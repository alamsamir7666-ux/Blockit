import 'package:flutter/services.dart';

class PermissionChannel {
  static const _channel = MethodChannel('com.blockit.app/permissions');

  Future<bool> checkOverlayPermission() async {
    return await _channel.invokeMethod('checkOverlayPermission');
  }

  Future<void> requestOverlayPermission() async {
    await _channel.invokeMethod('requestOverlayPermission');
  }

  Future<bool> checkUsageStatsPermission() async {
    return await _channel.invokeMethod('checkUsageStatsPermission');
  }

  Future<void> requestUsageStatsPermission() async {
    await _channel.invokeMethod('requestUsageStatsPermission');
  }

  Future<bool> checkAccessibilityService() async {
    return await _channel.invokeMethod('checkAccessibilityService');
  }

  Future<void> requestAccessibilityService() async {
    await _channel.invokeMethod('requestAccessibilityService');
  }

  Future<bool> checkDeviceAdmin() async {
    return await _channel.invokeMethod('checkDeviceAdmin');
  }

  Future<void> requestDeviceAdmin() async {
    await _channel.invokeMethod('requestDeviceAdmin');
  }

  Future<Map<String, dynamic>> checkAllPermissions() async {
    final result = await _channel.invokeMethod('checkAllPermissions');
    return Map<String, dynamic>.from(result);
  }
}
