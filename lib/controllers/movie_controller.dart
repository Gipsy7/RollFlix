import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

/// Controller responsável pelo gerenciamento de estado dos filmes
/// Separação da lógica de negócio da UI para melhor testabilidade
class MovieController extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();
  
  String? _selectedGenre;
  Movie? _selectedMovie;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get selectedGenre => _selectedGenre;
  Movie? get selectedMovie => _selectedMovie;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMovie => _selectedMovie != null;
  bool get canRollMovie => _selectedGenre != null && !_isLoading;

  /// Seleciona um gênero e limpa o filme atual
  void selectGenre(String? genre) {
    if (_selectedGenre != genre) {
      _selectedGenre = genre;
      _selectedMovie = null;
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Busca um filme aleatório do gênero selecionado
  Future<void> rollMovie() async {
    if (_selectedGenre == null || _isLoading) return;

    _setLoading(true);
    _errorMessage = null;

    try {
      final movie = await _repository.getRandomMovieByGenre(_selectedGenre!);
      _selectedMovie = movie;
    } catch (e) {
      _errorMessage = 'Erro ao buscar filme: ${e.toString()}';
      _selectedMovie = null;
      debugPrint('Error in rollMovie: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Limpa o estado atual
  void clearState() {
    _selectedGenre = null;
    _selectedMovie = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Limpa apenas o erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Pré-carrega dados para melhor performance
  Future<void> preloadData() async {
    try {
      await _repository.preloadPopularGenres();
      debugPrint('Popular genres preloaded successfully');
    } catch (e) {
      debugPrint('Error preloading data: $e');
    }
  }

  /// Limpa cache do repository
  void clearCache() {
    _repository.clearCache();
  }

  /// Obtém estatísticas do cache
  Map<String, dynamic> getCacheStats() {
    return _repository.getCacheStats();
  }

  /// Método privado para controlar loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    // Limpa cache expirado antes de descartar
    _repository.cleanExpiredCache();
    super.dispose();
  }
}