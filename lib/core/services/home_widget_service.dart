import 'package:home_widget/home_widget.dart';

/// Service to manage the streak home screen widget
class HomeWidgetService {
  static const String appGroupId = 'group.com.example.vector';
  static const String androidWidgetName = 'StreakWidgetProvider';
  static const String iOSWidgetName = 'StreakWidget';

  /// Initialize the home widget
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  /// Update the streak widget with current data
  static Future<void> updateStreakWidget({
    required int streakCount,
    String? currentDate,
  }) async {
    // Save data to be read by the native widget
    await HomeWidget.saveWidgetData<int>('streak_count', streakCount);
    
    if (currentDate != null) {
      await HomeWidget.saveWidgetData<String>('current_date', currentDate);
    }

    // Request widget update
    await HomeWidget.updateWidget(
      androidName: androidWidgetName,
      iOSName: iOSWidgetName,
    );
  }

  /// Get the current date formatted for the widget
  static String getFormattedDate() {
    final now = DateTime.now();
    final day = now.day.toString();
    final months = [
      'jan', 'feb', 'mar', 'apr', 'may', 'jun',
      'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
    ];
    final month = months[now.month - 1];
    return '$day\n$month';
  }
}
