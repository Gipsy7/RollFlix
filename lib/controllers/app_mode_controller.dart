import 'package:flutter/foundation.dart';

/// Controller global para gerenciar o modo da aplicação (Filme/Série)
/// Singleton pattern para garantir instância única
class AppModeController extends ChangeNotifier {
  static final AppModeController _instance = AppModeController._internal();
  static AppModeController get instance => _instance;
  
  factory AppModeController() => _instance;
  
  AppModeController._internal();

  bool _isSeriesMode = false;

  bool get isSeriesMode => _isSeriesMode;

  void toggleMode() {
    _isSeriesMode = !_isSeriesMode;
    notifyListeners();
    debugPrint('Modo alterado para: ${_isSeriesMode ? "Séries" : "Filmes"}');
  }

  void setSeriesMode(bool value) {
    if (_isSeriesMode != value) {
      _isSeriesMode = value;
      notifyListeners();
      debugPrint('Modo definido para: ${_isSeriesMode ? "Séries" : "Filmes"}');
    }
  }

  void setToMovieMode() => setSeriesMode(false);
  void setToSeriesMode() => setSeriesMode(true);
}
