import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final SharedPreferences _preferences;

  SharedPreferenceService(this._preferences);

  static const String _keyNotification = "NOTIFICATION";
  static const String _keyThemes = "THEMES";

  Future<void> setThemes(bool value) async {
    try {
      await _preferences.setBool(_keyThemes, value);
    } catch(e) {
      throw Exception("Error");
    }
  }

  Future<void> setNotification(bool value) async {
    try {
      await _preferences.setBool(_keyNotification, value);
    } catch (e) {
      throw Exception("Error");
    }
  }

  bool get themes => _preferences.getBool(_keyThemes) ?? false;
  bool get notification => _preferences.getBool(_keyNotification) ?? false;
}
