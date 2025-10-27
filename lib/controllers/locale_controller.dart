import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_preferences_controller.dart';

/// Simple singleton controller to manage app Locale and persist user choice.
class LocaleController extends ValueNotifier<Locale?> {
  LocaleController._internal() : super(null);

  static final LocaleController instance = LocaleController._internal();

  static const _kLocaleKey = 'app_locale';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLocaleKey);
    if (code != null && code.isNotEmpty) {
      value = Locale(code);
      debugPrint('🌍 LocaleController: init loaded locale: $value');
    } else {
      value = const Locale('pt'); // Default to Portuguese
      debugPrint('🌍 LocaleController: init set default locale: $value');
    }
  }

  Future<void> setLocale(String? languageCode) async {
    if (languageCode == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, languageCode);
    value = Locale(languageCode);
    debugPrint('🌍 LocaleController: setLocale called with $languageCode, new locale: $value');

    // Salva também no Firebase se usuário estiver logado
    try {
      await UserPreferencesController.instance.saveAppSettings(localeCode: languageCode);
    } catch (e) {
      debugPrint('❌ Erro ao salvar locale no Firebase: $e');
    }
  }

  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLocaleKey);
    value = const Locale('pt'); // Reset to default
    debugPrint('🌍 LocaleController: clearLocale, reset to default: $value');
  }

  Locale? get locale => value ?? const Locale('pt');
}
