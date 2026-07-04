package com.blockit.app.admin

import android.app.admin.DeviceAdminReceiver
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.Toast

class BlockitDeviceAdminReceiver : DeviceAdminReceiver() {

    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        Toast.makeText(context, "Blockit Device Admin enabled. You can now use lock screen features.", Toast.LENGTH_LONG).show()
    }

    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Toast.makeText(context, "Blockit Device Admin disabled. Lock screen features will not work.", Toast.LENGTH_LONG).show()
    }

    override fun onPasswordChanged(context: Context, intent: Intent, userHandle: android.os.UserHandle) {
        super.onPasswordChanged(context, intent, userHandle)
    }

    companion object {
        fun isDeviceAdminActive(context: Context): Boolean {
            val devicePolicyManager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
            val adminComponent = ComponentName(context, BlockitDeviceAdminReceiver::class.java)
            return devicePolicyManager.isAdminActive(adminComponent)
        }
    }
}
