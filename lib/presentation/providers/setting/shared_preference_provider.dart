import 'package:flutter/material.dart';
import 'package:restaurant_app/data/local/services/shared_preference_service.dart';

class SharedPreferenceProvider extends ChangeNotifier {
  final SharedPreferenceService _service;

  SharedPreferenceProvider(this._service);

  bool _themes = false;
  bool _notification = false;

  bool get themes => _themes;

  bool get notification => _notification;

  void toggleTheme(bool value) async {
    _themes = !value;
    await _service.setThemes(_themes);
    notifyListeners();
  }

  void toggleNotification(bool value) async {
    _notification = !value;
    await _service.setNotification(_notification);
    notifyListeners();
  }

  void getThemesAndNotificationValue() async {
    try {
      _themes = _service.themes;
      _notification = _service.notification;
    } catch (e) {
      throw Exception("Error");
    }
    notifyListeners();
  }
}
