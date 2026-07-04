package com.blockit.app.util

import android.content.Context
import android.content.SharedPreferences

object PrefsHelper {
    private const val PREFS_NAME = "blockit_session_prefs"
    private const val KEY_SESSION_ACTIVE = "session_active"
    private const val KEY_SESSION_END_TIME = "session_end_time"
    private const val KEY_DIFFICULTY = "difficulty"
    private const val KEY_PARACHUTES = "parachutes"
    private const val KEY_SESSION_START_TIME = "session_start_time"

    private fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    fun setSessionActive(context: Context, active: Boolean) {
        getPrefs(context).edit().putBoolean(KEY_SESSION_ACTIVE, active).apply()
    }

    fun isSessionActive(context: Context): Boolean {
        return getPrefs(context).getBoolean(KEY_SESSION_ACTIVE, false)
    }

    fun setSessionEndTime(context: Context, endTime: Long) {
        getPrefs(context).edit().putLong(KEY_SESSION_END_TIME, endTime).apply()
    }

    fun getSessionEndTime(context: Context): Long {
        return getPrefs(context).getLong(KEY_SESSION_END_TIME, 0L)
    }

    fun setSessionStartTime(context: Context, startTime: Long) {
        getPrefs(context).edit().putLong(KEY_SESSION_START_TIME, startTime).apply()
    }

    fun getSessionStartTime(context: Context): Long {
        return getPrefs(context).getLong(KEY_SESSION_START_TIME, 0L)
    }

    fun setDifficulty(context: Context, difficulty: Int) {
        getPrefs(context).edit().putInt(KEY_DIFFICULTY, difficulty).apply()
    }

    fun getDifficulty(context: Context): Int {
        return getPrefs(context).getInt(KEY_DIFFICULTY, 1)
    }

    fun setParachutes(context: Context, count: Int) {
        getPrefs(context).edit().putInt(KEY_PARACHUTES, count).apply()
    }

    fun getParachutes(context: Context): Int {
        return getPrefs(context).getInt(KEY_PARACHUTES, 3)
    }

    fun decrementParachutes(context: Context): Int {
        val current = getParachutes(context)
        if (current > 0) {
            setParachutes(context, current - 1)
        }
        return getParachutes(context)
    }

    fun clearSession(context: Context) {
        getPrefs(context).edit().apply {
            remove(KEY_SESSION_ACTIVE)
            remove(KEY_SESSION_END_TIME)
            remove(KEY_SESSION_START_TIME)
            remove(KEY_DIFFICULTY)
        }.apply()
    }
}
