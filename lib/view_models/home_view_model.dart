import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class HomeViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

Future<void> updateHomeWidget({
  required int steps,
  required int rank,
  required int distance,
}) async {
  await HomeWidget.saveWidgetData('steps', steps.toString());
  await HomeWidget.saveWidgetData('rank', rank.toString());
  await HomeWidget.saveWidgetData('distance', distance.toString());

  await HomeWidget.updateWidget(androidName: 'WeeklyWidgetProvider');
}
