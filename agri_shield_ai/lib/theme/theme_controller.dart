import 'package:flutter/material.dart';

/// Force premium dark experience for KAVACH AI.
class ThemeController extends ChangeNotifier {
  ThemeMode get mode => ThemeMode.dark;
  bool get isDark => true;

  void setMode(ThemeMode mode) {}
  void setLight() {}
  void setDark() {}
  void toggle() {}
}

final themeController = ThemeController();
