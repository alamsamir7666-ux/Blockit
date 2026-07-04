package com.blockit.app.channel

import android.app.AppOpsManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Process
import android.provider.Settings
import android.net.Uri
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.blockit.app.admin.BlockitDeviceAdminReceiver

class PermissionMethodChannel(
    private val context: Context,
    channel: MethodChannel
) : MethodChannel.MethodCallHandler {

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkOverlayPermission" -> {
                result.success(checkOverlayPermission())
            }
            "requestOverlayPermission" -> {
                requestOverlayPermission(result)
            }
            "checkUsageStatsPermission" -> {
                result.success(checkUsageStatsPermission())
            }
            "requestUsageStatsPermission" -> {
                requestUsageStatsPermission(result)
            }
            "checkAccessibilityService" -> {
                result.success(checkAccessibilityService())
            }
            "requestAccessibilityService" -> {
                requestAccessibilityService(result)
            }
            "checkDeviceAdmin" -> {
                result.success(checkDeviceAdmin())
            }
            "requestDeviceAdmin" -> {
                requestDeviceAdmin(result)
            }
            "checkAllPermissions" -> {
                checkAllPermissions(result)
            }
            else -> result.notImplemented()
        }
    }

    private fun checkOverlayPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(context)
        } else {
            true
        }
    }

    private fun requestOverlayPermission(result: MethodChannel.Result) {
        try {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:${context.packageName}")
            )
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("OVERLAY_REQUEST_FAILED", e.message, null)
        }
    }

    private fun checkUsageStatsPermission(): Boolean {
        return try {
            val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName
            )
            mode == AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            false
        }
    }

    private fun requestUsageStatsPermission(result: MethodChannel.Result) {
        try {
            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("USAGE_STATS_REQUEST_FAILED", e.message, null)
        }
    }

    private fun checkAccessibilityService(): Boolean {
        val serviceName = "${context.packageName}/.service.BlockAccessibilityService"
        val enabledServices = Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false
        return enabledServices.contains(serviceName)
    }

    private fun requestAccessibilityService(result: MethodChannel.Result) {
        try {
            val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("ACCESSIBILITY_REQUEST_FAILED", e.message, null)
        }
    }

    private fun checkDeviceAdmin(): Boolean {
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponent = ComponentName(context, BlockitDeviceAdminReceiver::class.java)
        return dpm.isAdminActive(adminComponent)
    }

    private fun requestDeviceAdmin(result: MethodChannel.Result) {
        try {
            val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
                putExtra(
                    DevicePolicyManager.EXTRA_DEVICE_ADMIN,
                    ComponentName(context, BlockitDeviceAdminReceiver::class.java)
                )
                putExtra(
                    DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                    "Blockit needs Device Admin to lock your screen during focus sessions, preventing easy escape from the blocking screen."
                )
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("DEVICE_ADMIN_REQUEST_FAILED", e.message, null)
        }
    }

    private fun checkAllPermissions(result: MethodChannel.Result) {
        result.success(mapOf(
            "overlay" to checkOverlayPermission(),
            "usageStats" to checkUsageStatsPermission(),
            "accessibilityService" to checkAccessibilityService(),
            "deviceAdmin" to checkDeviceAdmin()
        ))
    }

    companion object {
        private const val CHANNEL_NAME = "com.blockit.app/permissions"

        fun register(messenger: io.flutter.plugin.common.BinaryMessenger, context: Context) {
            val channel = MethodChannel(messenger, CHANNEL_NAME)
            PermissionMethodChannel(context, channel)
        }
    }
}
