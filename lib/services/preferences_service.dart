import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/date_night_preferences.dart';
import '../utils/app_logger.dart';

class PreferencesService {
  static const String _preferencesKey = 'date_night_preferences';

  /// Salvar preferências
  static Future<void> savePreferences(DateNightPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(preferences.toJson());
      await prefs.setString(_preferencesKey, jsonString);
      AppLogger.debug('✓ Preferências salvas com sucesso');
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao salvar preferências: $e', stackTrace: stackTrace);
    }
  }

  /// Carregar preferências
  static Future<DateNightPreferences> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_preferencesKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        AppLogger.debug('✓ Preferências carregadas do cache');
        return DateNightPreferences.fromJson(json);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao carregar preferências: $e', stackTrace: stackTrace);
    }
    
    // Retornar preferências padrão
    AppLogger.debug('✓ Usando preferências padrão');
    return const DateNightPreferences();
  }

  /// Limpar preferências
  static Future<void> clearPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_preferencesKey);
      AppLogger.debug('✓ Preferências limpas');
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao limpar preferências: $e', stackTrace: stackTrace);
    }
  }
}
