import 'package:flutter/foundation.dart';
import '../models/tv_show.dart';
import '../repositories/tv_show_repository.dart';

/// Controller responsável pelo gerenciamento de estado das séries TV
/// Singleton pattern para garantir instância única em toda a aplicação
class TVShowController extends ChangeNotifier {
  // Singleton pattern
  static final TVShowController _instance = TVShowController._internal();
  static TVShowController get instance => _instance;
  
  factory TVShowController() => _instance;
  
  TVShowController._internal();
  
  final TVShowRepository _repository = TVShowRepository();
  
  String? _selectedGenre;
  TVShow? _selectedShow;
  bool _isLoading = false;
  String? _errorMessage;
  int _showCount = 0; // Contador de séries sorteadas

  // Getters
  String? get selectedGenre => _selectedGenre;
  TVShow? get selectedShow => _selectedShow;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasShow => _selectedShow != null;
  bool get canRollShow => _selectedGenre != null && !_isLoading;
  int get showCount => _showCount;

  /// Seleciona um gênero e limpa a série atual apenas se for um gênero diferente
  void selectGenre(String? genre) {
    if (_selectedGenre != genre) {
      debugPrint('Mudando gênero de "$_selectedGenre" para "$genre"');
      _selectedGenre = genre;
      _selectedShow = null; // Só limpa a série quando o gênero realmente muda
      _showCount = 0; // Reseta contador ao mudar de gênero
      _errorMessage = null;
      notifyListeners();
    } else {
      debugPrint('Gênero "$genre" já estava selecionado, mantendo série atual');
    }
  }

  /// Busca uma série aleatória do gênero selecionado
  Future<void> rollShow() async {
    if (_selectedGenre == null || _isLoading) return;

    debugPrint('Rolando série do gênero: $_selectedGenre (Série atual: ${_selectedShow?.name ?? "nenhuma"})');
    _setLoading(true);
    _errorMessage = null;

    try {
      // Passa o ID da série atual para ser excluída da seleção
      final currentShowId = _selectedShow?.id;
      final newShow = await _repository.getRandomTVShowByGenre(
        _selectedGenre!, 
        excludeShowId: currentShowId
      );
      
      _selectedShow = newShow;
      _showCount++; // Incrementa contador de séries sorteadas
      debugPrint('Série final selecionada: ${_selectedShow!.name} (Gênero: $_selectedGenre) - Total sorteadas: $_showCount');
    } catch (e) {
      _errorMessage = 'Erro ao buscar série: ${e.toString()}';
      _selectedShow = null;
      debugPrint('Error in rollShow: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Limpa o estado atual
  void clearState() {
    _selectedGenre = null;
    _selectedShow = null;
    _errorMessage = null;
    _isLoading = false;
    _showCount = 0;
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
      debugPrint('Popular TV genres preloaded successfully');
    } catch (e) {
      debugPrint('Error preloading TV data: $e');
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
