import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/data/local/services/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService) {
    _loadNotificationId();
  }

  int _notificationId = 0;
  bool? _permission = false;

  bool? get permission => _permission;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  Future<void> _loadNotificationId() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationId = prefs.getInt('notification_id') ?? 0;
  }

  Future<void> _saveNotificationId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_id', _notificationId);
  }

  Future<void> scheduleDailyElevenAMNotification() async {
    _notificationId += 1;
    await _saveNotificationId();
    flutterNotificationService.scheduleDailyElevenAMNotification(
      id: _notificationId,
    );
  }

  Future<void> cancelNotification() async {
    await flutterNotificationService.cancelNotification(_notificationId);
  }
}
