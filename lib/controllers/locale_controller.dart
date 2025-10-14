import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple singleton controller to manage app Locale and persist user choice.
class LocaleController extends ChangeNotifier {
  LocaleController._internal();

  static final LocaleController instance = LocaleController._internal();

  Locale? _locale;

  Locale? get locale => _locale ?? const Locale('pt'); // Default to Portuguese if not set

  static const _kLocaleKey = 'app_locale';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLocaleKey);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(String? languageCode) async {
    if (languageCode == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLocaleKey);
    _locale = null;
    notifyListeners();
  }
}
