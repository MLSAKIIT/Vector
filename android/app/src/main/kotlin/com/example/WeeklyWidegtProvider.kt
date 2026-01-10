package com.example.vector

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class WeeklyWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {

            val widgetData = HomeWidgetPlugin.getData(context)

            val steps = widgetData.getString("steps", "0")
            val rank = widgetData.getString("rank", "0")
            val distance = widgetData.getString("distance", "0")

            val views = RemoteViews(context.packageName, R.layout.home_widget)

            views.setTextViewText(R.id.steps, "Steps: $steps")
            views.setTextViewText(R.id.rank, "Rank: #$rank")
            views.setTextViewText(R.id.distance, "Distance: $distance km")

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
