package com.blockit.app.channel

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import com.blockit.app.util.PrefsHelper

class SessionEventChannel(
    private val context: Context
) : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private var handler: Handler? = null
    private var runnable: Runnable? = null
    private var isListening = false

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events
        handler = Handler(Looper.getMainLooper())
        isListening = true
        startTicking()
    }

    override fun onCancel(arguments: Any?) {
        isListening = false
        eventSink = null
        handler?.removeCallbacks(runnable ?: return)
        handler = null
    }

    private fun startTicking() {
        runnable = object : Runnable {
            override fun run() {
                if (!isListening) return
                
                val active = PrefsHelper.isSessionActive(context)
                val endTime = PrefsHelper.getSessionEndTime(context)
                val remaining = (endTime - System.currentTimeMillis()).coerceAtLeast(0)

                eventSink?.success(mapOf(
                    "active" to active,
                    "remainingMs" to remaining,
                    "remainingSeconds" to (remaining / 1000),
                    "endTime" to endTime,
                    "difficulty" to PrefsHelper.getDifficulty(context),
                    "parachutes" to PrefsHelper.getParachutes(context)
                ))

                if (active && remaining > 0) {
                    handler?.postDelayed(this, 1000)
                }
            }
        }
        handler?.post(runnable!!)
    }

    companion object {
        private const val CHANNEL_NAME = "com.blockit.app/session_events"

        fun register(messenger: io.flutter.plugin.common.BinaryMessenger) {
            val channel = EventChannel(messenger, CHANNEL_NAME)
            // Context will be set when handler is created
            channel.setStreamHandler(
                SessionEventChannel(
                    android.app.Application().applicationContext 
                )
            )
        }
    }
}
