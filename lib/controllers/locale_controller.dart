import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_preferences_controller.dart';
import 'app_mode_controller.dart';

/// Simple singleton controller to manage app Locale and persist user choice.
class LocaleController extends ValueNotifier<Locale?> {
  LocaleController._internal() : super(null);

  static final LocaleController instance = LocaleController._internal();

  static const _kLocaleKey = 'app_locale';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLocaleKey);
    if (code != null && code.isNotEmpty) {
      // If we have a saved code, ensure it's supported; otherwise fallback to English
      final supported = AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet();
      final chosen = supported.contains(code) ? code : 'en';
      value = Locale(chosen);
      debugPrint('🌍 LocaleController: init loaded locale from prefs: $value (raw=$code)');
      // Persist normalized choice
      await prefs.setString(_kLocaleKey, chosen);
    } else {
      // No saved preference: try device locale, fallback to English if unsupported
      final deviceLocale = PlatformDispatcher.instance.locale;
      final deviceCode = deviceLocale.languageCode;
      final supported = AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet();
      final chosen = supported.contains(deviceCode) ? deviceCode : 'en';
      value = Locale(chosen);
      await prefs.setString(_kLocaleKey, chosen);
      debugPrint('🌍 LocaleController: init set locale from device: $value (device=$deviceLocale)');
    }
  }

  /// Set the app locale. By default this will persist locally and also
  /// attempt to save to the user's Firebase document. When loading settings
  /// from the cloud you should call with `saveToCloud: false` to avoid
  /// overwriting other app settings during sync.
  Future<void> setLocale(String? languageCode, {bool saveToCloud = true}) async {
    if (languageCode == null) return;
    final prefs = await SharedPreferences.getInstance();
    // Normalize to supported locales; fallback to English
    final supported = AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet();
    final chosen = supported.contains(languageCode) ? languageCode : 'en';
    await prefs.setString(_kLocaleKey, chosen);
    value = Locale(chosen);
    debugPrint('🌍 LocaleController: setLocale called with $languageCode, new locale: $value (saveToCloud=$saveToCloud)');

    if (!saveToCloud) return;

    // Salva também no Firebase se usuário estiver logado
    try {
      // Passa o estado atual do AppModeController para evitar sobrescrever
      // o modo/genre com valores padrão ao gravar apenas a localidade.
      await UserPreferencesController.instance.saveAppSettings(
        localeCode: languageCode,
        isSeriesMode: AppModeController.instance.isSeriesMode,
        selectedGenre: AppModeController.instance.selectedGenre,
      );
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
