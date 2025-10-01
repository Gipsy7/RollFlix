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
  int _movieCount = 0; // Contador de filmes sorteados

  // Getters
  String? get selectedGenre => _selectedGenre;
  Movie? get selectedMovie => _selectedMovie;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMovie => _selectedMovie != null;
  bool get canRollMovie => _selectedGenre != null && !_isLoading;
  int get movieCount => _movieCount;

  /// Seleciona um gênero e limpa o filme atual apenas se for um gênero diferente
  void selectGenre(String? genre) {
    if (_selectedGenre != genre) {
      debugPrint('Mudando gênero de "$_selectedGenre" para "$genre"');
      _selectedGenre = genre;
      _selectedMovie = null; // Só limpa o filme quando o gênero realmente muda
      _movieCount = 0; // Reseta contador ao mudar de gênero
      _errorMessage = null;
      notifyListeners();
    } else {
      debugPrint('Gênero "$genre" já estava selecionado, mantendo filme atual');
    }
  }

  /// Busca um filme aleatório do gênero selecionado
  Future<void> rollMovie() async {
    if (_selectedGenre == null || _isLoading) return;

    debugPrint('Rolando filme do gênero: $_selectedGenre (Filme atual: ${_selectedMovie?.title ?? "nenhum"})');
    _setLoading(true);
    _errorMessage = null;

    try {
      // Passa o ID do filme atual para ser excluído da seleção
      final currentMovieId = _selectedMovie?.id;
      final newMovie = await _repository.getRandomMovieByGenre(
        _selectedGenre!, 
        excludeMovieId: currentMovieId
      );
      
      _selectedMovie = newMovie;
      _movieCount++; // Incrementa contador de filmes sorteados
      debugPrint('Filme final selecionado: ${_selectedMovie!.title} (Gênero: $_selectedGenre) - Total sorteados: $_movieCount');
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