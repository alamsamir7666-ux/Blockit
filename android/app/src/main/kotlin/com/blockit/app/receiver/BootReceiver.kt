package com.blockit.app.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.blockit.app.service.SessionForegroundService
import com.blockit.app.util.PrefsHelper

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            // Resume session if one was active before reboot
            if (PrefsHelper.isSessionActive(context)) {
                val endTime = PrefsHelper.getSessionEndTime(context)
                if (System.currentTimeMillis() < endTime) {
                    // Session still valid, restart foreground service
                    val serviceIntent = Intent(context, SessionForegroundService::class.java).apply {
                        action = "START_SESSION"
                        val remainingMinutes = (endTime - System.currentTimeMillis()) / (60 * 1000)
                        putExtra("duration_minutes", remainingMinutes + 1)
                        putExtra("difficulty", PrefsHelper.getDifficulty(context))
                    }
                    context.startForegroundService(serviceIntent)
                } else {
                    // Session expired during reboot
                    PrefsHelper.clearSession(context)
                }
            }
        }
    }
}
