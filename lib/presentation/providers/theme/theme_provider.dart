import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  set toggleTheme(value) {
    _isDark = !value;
    notifyListeners();
  }
}
