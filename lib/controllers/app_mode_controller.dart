import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_preferences_controller.dart';

/// Controller global para gerenciar o modo da aplicação (Filme/Série)
/// Singleton pattern para garantir instância única
class AppModeController extends ChangeNotifier {
  static final AppModeController _instance = AppModeController._internal();
  static AppModeController get instance => _instance;
  
  factory AppModeController() => _instance;
  
  AppModeController._internal() {
    _loadPreferences();
  }

  // Chaves para SharedPreferences
  static const String _isSeriesModeKey = 'app_is_series_mode';
  static const String _selectedGenreKey = 'app_selected_genre';

  bool _isSeriesMode = false;
  String? _selectedGenre;

  bool get isSeriesMode => _isSeriesMode;
  String? get selectedGenre => _selectedGenre;

  void toggleMode() {
    _isSeriesMode = !_isSeriesMode;
    _selectedGenre = null; // Limpa gênero ao trocar de modo
    notifyListeners();
    _savePreferences();
    debugPrint('Modo alterado para: ${_isSeriesMode ? "Séries" : "Filmes"}');
  }

  void setSeriesMode(bool value) {
    if (_isSeriesMode != value) {
      _isSeriesMode = value;
      _selectedGenre = null; // Limpa gênero ao trocar de modo
      notifyListeners();
      _savePreferences();
      debugPrint('Modo definido para: ${_isSeriesMode ? "Séries" : "Filmes"}');
    }
  }

  void setToMovieMode() => setSeriesMode(false);
  void setToSeriesMode() => setSeriesMode(true);
  
  void selectGenre(String genre) {
    if (_selectedGenre != genre) {
      _selectedGenre = genre;
      notifyListeners();
      _savePreferences();
      debugPrint('Gênero selecionado: $genre');
    }
  }
  
  void clearGenre() {
    if (_selectedGenre != null) {
      _selectedGenre = null;
      notifyListeners();
      _savePreferences();
    }
  }

  /// Carrega preferências do SharedPreferences
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSeriesMode = prefs.getBool(_isSeriesModeKey) ?? false;
      _selectedGenre = prefs.getString(_selectedGenreKey);
      debugPrint('📱 AppModeController: loaded isSeriesMode=$_isSeriesMode, selectedGenre=$_selectedGenre');
    } catch (e) {
      debugPrint('❌ Erro ao carregar app mode preferences: $e');
    }
  }

  /// Salva preferências no SharedPreferences e Firebase
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isSeriesModeKey, _isSeriesMode);
      if (_selectedGenre != null) {
        await prefs.setString(_selectedGenreKey, _selectedGenre!);
      } else {
        await prefs.remove(_selectedGenreKey);
      }

      // Salva também no Firebase se usuário estiver logado
      await UserPreferencesController.instance.saveAppSettings(
        isSeriesMode: _isSeriesMode,
        selectedGenre: _selectedGenre,
      );

      debugPrint('✅ App mode preferences salvas');
    } catch (e) {
      debugPrint('❌ Erro ao salvar app mode preferences: $e');
    }
  }
}
