import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const _key = 'kavach_locale';
  static const _chosenKey = 'kavach_locale_chosen';

  Locale _locale = const Locale('en');
  bool _ready = false;
  bool _hasChosenLanguage = false;

  Locale get locale => _locale;
  bool get ready => _ready;
  bool get hasChosenLanguage => _hasChosenLanguage;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'en';
    _locale = Locale(code);
    _hasChosenLanguage = prefs.getBool(_chosenKey) ?? false;
    _ready = true;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale, {bool markChosen = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final changed = _locale != locale;
    if (changed) {
      _locale = locale;
      await prefs.setString(_key, locale.languageCode);
    }
    if (markChosen && !_hasChosenLanguage) {
      _hasChosenLanguage = true;
      await prefs.setBool(_chosenKey, true);
    } else if (markChosen) {
      await prefs.setBool(_chosenKey, true);
      _hasChosenLanguage = true;
    }
    if (changed || markChosen) notifyListeners();
  }

  /// Confirm selection on the onboarding screen.
  Future<void> chooseLanguage(Locale locale) async {
    await setLocale(locale, markChosen: true);
  }

  String displayName(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return 'हिन्दी';
      case 'gu':
        return 'ગુજરાતી';
      default:
        return 'English';
    }
  }
}
