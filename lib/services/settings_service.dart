import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String darkModeKey = 'settings_dark_mode';
  static const String languageKey = 'settings_language';
  static const String notificationsKey = 'settings_notifications';

  bool _isDarkMode = false;
  String _language = 'Português';
  bool _notificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(darkModeKey) ?? false;
    _language = prefs.getString(languageKey) ?? 'Português';
    _notificationsEnabled = prefs.getBool(notificationsKey) ?? true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkModeKey, value);
    _isDarkMode = value;
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, value);
    _language = value;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationsKey, value);
    _notificationsEnabled = value;
    notifyListeners();
  }
}
