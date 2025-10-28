import 'package:shared_preferences/shared_preferences.dart';

/// Small wrapper that caches a SharedPreferences instance to avoid calling
/// SharedPreferences.getInstance() all over the app. Call [init] once during
/// app startup (before controllers run) to ensure synchronous access.
class PrefsService {
  static SharedPreferences? _prefs;

  /// Initialize and cache the SharedPreferences instance.
  static Future<void> init() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
  }

  /// Access cached instance (may be null if init() wasn't called).
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('PrefsService not initialized. Call PrefsService.init() in main before using prefs.');
    }
    return _prefs!;
  }

  // Convenience helpers
  static String? getString(String key) => prefs.getString(key);
  static Future<bool> setString(String key, String value) => prefs.setString(key, value);
  static bool? getBool(String key) => prefs.getBool(key);
  static Future<bool> setBool(String key, bool value) => prefs.setBool(key, value);
  static Future<bool> remove(String key) => prefs.remove(key);
}
