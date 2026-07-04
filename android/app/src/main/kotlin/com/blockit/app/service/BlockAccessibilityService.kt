package com.blockit.app.service

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.view.accessibility.AccessibilityEvent
import com.blockit.app.util.PrefsHelper

class BlockAccessibilityService : AccessibilityService() {

    override fun onServiceConnected() {
        super.onServiceConnected()
        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
                        AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS or
                    AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS
            notificationTimeout = 100
        }
        serviceInfo = info
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (!PrefsHelper.isSessionActive(this)) return

        when (event?.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                handleWindowChange(event)
            }
        }
    }

    private fun handleWindowChange(event: AccessibilityEvent) {
        val packageName = event.packageName?.toString() ?: return
        
        // Allow phone/dialer app through
        if (packageName == "com.android.dialer" || 
            packageName == "com.android.phone" ||
            packageName == "com.google.android.dialer" ||
            packageName == "com.android.incallui") {
            return
        }
        
        // Allow our own app through
        if (packageName == "com.blockit.app") return

        // Any other app - show blocking overlay
        OverlayManager.showBlockOverlay(this)
    }

    override fun onInterrupt() {
        // Required override
    }
}
