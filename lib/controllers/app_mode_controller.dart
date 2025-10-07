import 'package:flutter/foundation.dart';

/// Controller global para gerenciar o modo da aplicação (Filme/Série)
/// Singleton pattern para garantir instância única
class AppModeController extends ChangeNotifier {
  static final AppModeController _instance = AppModeController._internal();
  static AppModeController get instance => _instance;
  
  factory AppModeController() => _instance;
  
  AppModeController._internal();

  bool _isSeriesMode = false;
  String? _selectedGenre;

  bool get isSeriesMode => _isSeriesMode;
  String? get selectedGenre => _selectedGenre;

  void toggleMode() {
    _isSeriesMode = !_isSeriesMode;
    _selectedGenre = null; // Limpa gênero ao trocar de modo
    notifyListeners();
    debugPrint('Modo alterado para: ${_isSeriesMode ? "Séries" : "Filmes"}');
  }

  void setSeriesMode(bool value) {
    if (_isSeriesMode != value) {
      _isSeriesMode = value;
      _selectedGenre = null; // Limpa gênero ao trocar de modo
      notifyListeners();
      debugPrint('Modo definido para: ${_isSeriesMode ? "Séries" : "Filmes"}');
    }
  }

  void setToMovieMode() => setSeriesMode(false);
  void setToSeriesMode() => setSeriesMode(true);
  
  void selectGenre(String genre) {
    if (_selectedGenre != genre) {
      _selectedGenre = genre;
      notifyListeners();
      debugPrint('Gênero selecionado: $genre');
    }
  }
  
  void clearGenre() {
    if (_selectedGenre != null) {
      _selectedGenre = null;
      notifyListeners();
    }
  }
}
