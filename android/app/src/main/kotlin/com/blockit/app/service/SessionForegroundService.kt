package com.blockit.app.service

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import com.blockit.app.util.PrefsHelper

class SessionForegroundService : Service() {

    private var wakeLock: PowerManager.WakeLock? = null
    private var countdownThread: Thread? = null
    private var isRunning = false

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            "START_SESSION" -> {
                val durationMinutes = intent.getLongExtra("duration_minutes", 30)
                val difficulty = intent.getIntExtra("difficulty", 1)
                startSession(durationMinutes, difficulty)
            }
            "STOP_SESSION" -> {
                stopSession()
            }
            "UPDATE_PARACHUTE" -> {
                updateNotification()
            }
        }
        return START_STICKY
    }

    private fun startSession(durationMinutes: Long, difficulty: Int) {
        val endTime = System.currentTimeMillis() + (durationMinutes * 60 * 1000)
        
        PrefsHelper.setSessionActive(this, true)
        PrefsHelper.setSessionEndTime(this, endTime)
        PrefsHelper.setSessionStartTime(this, System.currentTimeMillis())
        PrefsHelper.setDifficulty(this, difficulty)

        acquireWakeLock()
        startForeground(NOTIFICATION_ID, buildNotification(endTime))
        startCountdown(endTime)
        isRunning = true
    }

    private fun stopSession() {
        isRunning = false
        countdownThread?.interrupt()
        releaseWakeLock()
        PrefsHelper.clearSession(this)
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun startCountdown(endTime: Long) {
        countdownThread = Thread {
            while (isRunning && System.currentTimeMillis() < endTime) {
                try {
                    Thread.sleep(1000)
                    updateNotification()
                } catch (e: InterruptedException) {
                    break
                }
            }
            if (isRunning && System.currentTimeMillis() >= endTime) {
                stopSession()
            }
        }
        countdownThread?.start()
    }

    private fun acquireWakeLock() {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "Blockit:SessionWakeLock"
        )
        wakeLock?.acquire(24 * 60 * 60 * 1000L)
    }

    private fun releaseWakeLock() {
        wakeLock?.let {
            if (it.isHeld) it.release()
        }
        wakeLock = null
    }

    private fun buildNotification(endTime: Long): Notification {
        val remaining = (endTime - System.currentTimeMillis()) / 1000
        val minutes = remaining / 60
        val seconds = remaining % 60
        
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Focus Session Active")
            .setContentText("Time remaining: ${minutes}m ${seconds}s")
            .setSmallIcon(android.R.drawable.ic_lock_lock)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()
    }

    private fun updateNotification() {
        val endTime = PrefsHelper.getSessionEndTime(this)
        if (endTime > 0) {
            val notification = buildNotification(endTime)
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.notify(NOTIFICATION_ID, notification)
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Focus Session",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Shows active focus session status"
                setShowBadge(false)
            }
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        releaseWakeLock()
        super.onDestroy()
    }

    companion object {
        const val CHANNEL_ID = "blockit_session_channel"
        const val NOTIFICATION_ID = 1001
    }
}
