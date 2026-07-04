package com.blockit.app.channel

import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.blockit.app.service.SessionForegroundService
import com.blockit.app.service.OverlayManager
import com.blockit.app.util.PrefsHelper

class SessionMethodChannel(
    private val context: Context,
    channel: MethodChannel
) : MethodChannel.MethodCallHandler {

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startSession" -> {
                val durationMinutes = (call.argument<Number>("duration")?.toLong() ?: 30)
                val difficulty = (call.argument<Number>("difficulty")?.toInt() ?: 1)
                startSession(durationMinutes, difficulty, result)
            }
            "endSession" -> {
                endSession(result)
            }
            "useParachute" -> {
                useParachute(result)
            }
            "getSessionState" -> {
                getSessionState(result)
            }
            "getRemainingTime" -> {
                getRemainingTime(result)
            }
            "getParachutes" -> {
                getParachutes(result)
            }
            else -> result.notImplemented()
        }
    }

    private fun startSession(durationMinutes: Long, difficulty: Int, result: MethodChannel.Result) {
        try {
            val intent = Intent(context, SessionForegroundService::class.java).apply {
                action = "START_SESSION"
                putExtra("duration_minutes", durationMinutes)
                putExtra("difficulty", difficulty)
            }
            context.startForegroundService(intent)
            result.success(mapOf(
                "active" to true,
                "endTime" to PrefsHelper.getSessionEndTime(context),
                "difficulty" to difficulty
            ))
        } catch (e: Exception) {
            result.error("START_FAILED", e.message, null)
        }
    }

    private fun endSession(result: MethodChannel.Result) {
        OverlayManager.removeOverlay()
        val intent = Intent(context, SessionForegroundService::class.java).apply {
            action = "STOP_SESSION"
        }
        context.startService(intent)
        PrefsHelper.clearSession(context)
        result.success(mapOf("active" to false))
    }

    private fun useParachute(result: MethodChannel.Result) {
        val remaining = PrefsHelper.decrementParachutes(context)
        if (remaining >= 0) {
            endSession(result)
        } else {
            result.error("NO_PARACHUTES", "No parachutes remaining", null)
        }
    }

    private fun getSessionState(result: MethodChannel.Result) {
        val active = PrefsHelper.isSessionActive(context)
        val endTime = PrefsHelper.getSessionEndTime(context)
        val startTime = PrefsHelper.getSessionStartTime(context)
        val difficulty = PrefsHelper.getDifficulty(context)

        result.success(mapOf(
            "active" to active,
            "endTime" to endTime,
            "startTime" to startTime,
            "difficulty" to difficulty,
            "remainingMs" to (endTime - System.currentTimeMillis()).coerceAtLeast(0)
        ))
    }

    private fun getRemainingTime(result: MethodChannel.Result) {
        val endTime = PrefsHelper.getSessionEndTime(context)
        val remaining = (endTime - System.currentTimeMillis()).coerceAtLeast(0)
        result.success(remaining)
    }

    private fun getParachutes(result: MethodChannel.Result) {
        result.success(PrefsHelper.getParachutes(context))
    }

    companion object {
        private const val CHANNEL_NAME = "com.blockit.app/session"

        fun register(messenger: io.flutter.plugin.common.BinaryMessenger, context: Context) {
            val channel = MethodChannel(messenger, CHANNEL_NAME)
            SessionMethodChannel(context, channel)
        }
    }
}
