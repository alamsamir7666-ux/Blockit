class PermissionConstants {
  static const overlay = 'SYSTEM_ALERT_WINDOW';
  static const usageStats = 'PACKAGE_USAGE_STATS';
  static const accessibility = 'BIND_ACCESSIBILITY_SERVICE';
  static const deviceAdmin = 'BIND_DEVICE_ADMIN';
  static const foregroundService = 'FOREGROUND_SERVICE';
  static const bootCompleted = 'RECEIVE_BOOT_COMPLETED';
  static const wakeLock = 'WAKE_LOCK';

  static const allPermissions = [
    overlay,
    usageStats,
    accessibility,
    deviceAdmin,
    foregroundService,
    bootCompleted,
    wakeLock,
  ];

  static Map<String, String> get permissionDescriptions => {
    overlay: 'Draw over other apps to show focus screen',
    usageStats: 'Track app usage for statistics',
    accessibility: 'Detect app switches to maintain focus',
    deviceAdmin: 'Lock screen to prevent easy escape',
    foregroundService: 'Keep focus session running in background',
    bootCompleted: 'Resume session after device restart',
    wakeLock: 'Keep device awake during sessions',
  };
}
