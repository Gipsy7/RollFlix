import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/date_night_preferences.dart';

class PreferencesService {
  static const String _preferencesKey = 'date_night_preferences';

  /// Salvar preferências
  static Future<void> savePreferences(DateNightPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(preferences.toJson());
      await prefs.setString(_preferencesKey, jsonString);
      print('✓ Preferências salvas com sucesso');
    } catch (e) {
      print('Erro ao salvar preferências: $e');
    }
  }

  /// Carregar preferências
  static Future<DateNightPreferences> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_preferencesKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        print('✓ Preferências carregadas do cache');
        return DateNightPreferences.fromJson(json);
      }
    } catch (e) {
      print('Erro ao carregar preferências: $e');
    }
    
    // Retornar preferências padrão
    print('✓ Usando preferências padrão');
    return const DateNightPreferences();
  }

  /// Limpar preferências
  static Future<void> clearPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_preferencesKey);
      print('✓ Preferências limpas');
    } catch (e) {
      print('Erro ao limpar preferências: $e');
    }
  }
}
