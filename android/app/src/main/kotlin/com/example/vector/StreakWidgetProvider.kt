package com.example.vector

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class StreakWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"
        
        internal fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            try {
                val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                val views = RemoteViews(context.packageName, R.layout.streak_widget)

                // Get streak count from shared preferences (default 40)
                val streakCount = prefs.getInt("streak_count", 40)
                val currentDate = prefs.getString("current_date", "10\njan") ?: "10\njan"

                // Update the title
                views.setTextViewText(R.id.streak_title, "$streakCount days streak!")
                views.setTextViewText(R.id.date_text, currentDate)

                // Update widget
                appWidgetManager.updateAppWidget(appWidgetId, views)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
