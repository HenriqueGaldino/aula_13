import 'package:shared_preferences/shared_preferences.dart';

class MigrationService {
  static const String dataVersionKey = 'data_version';
  static const int currentVersion = 2;

  static Future<void> migrateIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getInt(dataVersionKey) ?? 1;

    if (savedVersion < 2) {
      await _migrateFromV1ToV2(prefs);
      await prefs.setInt(dataVersionKey, currentVersion);
    }
  }

  static Future<void> _migrateFromV1ToV2(SharedPreferences prefs) async {
    final oldDarkMode = prefs.getBool('dark_mode');
    final oldLanguage = prefs.getString('language');
    final oldNotifications = prefs.getBool('notifications');

    if (oldDarkMode != null) {
      await prefs.setBool('settings_dark_mode', oldDarkMode);
      await prefs.remove('dark_mode');
    }

    if (oldLanguage != null) {
      await prefs.setString('settings_language', oldLanguage);
      await prefs.remove('language');
    }

    if (oldNotifications != null) {
      await prefs.setBool('settings_notifications', oldNotifications);
      await prefs.remove('notifications');
    }
  }
}
