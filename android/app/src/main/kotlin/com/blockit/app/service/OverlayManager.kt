package com.blockit.app.service

import android.app.ActivityManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.view.Gravity
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.blockit.app.admin.BlockitDeviceAdminReceiver
import com.blockit.app.util.PrefsHelper

object OverlayManager {

    private var overlayView: View? = null
    private var windowManager: WindowManager? = null

    fun showBlockOverlay(context: Context) {
        if (!PrefsHelper.isSessionActive(context)) return
        
        // Remove existing overlay first
        removeOverlay()

        windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

        val layout = FrameLayout(context).apply {
            setBackgroundColor(0xFF121212.toInt())
            isFocusable = true
            isFocusableInTouchMode = true
            isClickable = true

            // Capture back button
            setOnKeyListener { _, keyCode, event ->
                if (keyCode == KeyEvent.KEYCODE_BACK && event.action == KeyEvent.ACTION_UP) {
                    // Instead of closing, lock the screen
                    lockScreen(context)
                    return@setOnKeyListener true
                }
                false
            }
        }

        // Block screen UI
        val blockText = TextView(context).apply {
            text = "🔒 Focus Session Active\n\nStay focused. Your session is in progress."
            textSize = 20f
            textAlignment = View.TEXT_ALIGNMENT_CENTER
            setTextColor(0xFFFFFFFF.toInt())
            gravity = Gravity.CENTER
            setPadding(40, 0, 40, 0)
        }

        layout.addView(blockText, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        ))

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_FULLSCREEN or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.CENTER
        }

        windowManager?.addView(layout, params)
        overlayView = layout
    }

    fun removeOverlay() {
        overlayView?.let {
            try {
                windowManager?.removeView(it)
            } catch (e: Exception) {
                // View might already be removed
            }
        }
        overlayView = null
    }

    fun isOverlayShowing(): Boolean {
        return overlayView != null
    }

    private fun lockScreen(context: Context) {
        val devicePolicyManager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponent = ComponentName(context, BlockitDeviceAdminReceiver::class.java)
        
        if (devicePolicyManager.isAdminActive(adminComponent)) {
            devicePolicyManager.lockNow()
        } else {
            // If device admin not active, just turn screen off via power manager
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                // Can't force sleep, but we keep overlay up
            }
        }
    }
}
