package com.blockit.app.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.blockit.app.service.OverlayManager
import com.blockit.app.util.PrefsHelper

class ScreenOffReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_SCREEN_ON -> {
                // When screen turns on, check if session is active and re-show overlay
                if (PrefsHelper.isSessionActive(context)) {
                    OverlayManager.showBlockOverlay(context)
                }
            }
            Intent.ACTION_SCREEN_OFF -> {
                // Screen turned off — session continues in background
            }
            Intent.ACTION_USER_PRESENT -> {
                // Device unlocked — ensure overlay is shown
                if (PrefsHelper.isSessionActive(context)) {
                    android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                        OverlayManager.showBlockOverlay(context)
                    }, 300)
                }
            }
        }
    }
}
