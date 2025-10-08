import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/watched_item.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';

/// Controller para gerenciar lista de assistidos
/// Singleton pattern para garantir instância única
class WatchedController extends ChangeNotifier {
  static final WatchedController _instance = WatchedController._internal();
  static WatchedController get instance => _instance;
  
  factory WatchedController() => _instance;
  
  WatchedController._internal() {
    _loadWatchedItems();
  }

  static const String _watchedKey = 'rollflix_watched';
  final List<WatchedItem> _watchedItems = [];
  bool _isLoading = false;

  List<WatchedItem> get watchedItems => List.unmodifiable(_watchedItems);
  bool get isLoading => _isLoading;
  int get count => _watchedItems.length;
  bool get hasWatchedItems => _watchedItems.isNotEmpty;

  /// Carrega assistidos do armazenamento local
  Future<void> _loadWatchedItems() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final watchedJson = prefs.getString(_watchedKey);

      if (watchedJson != null) {
        final List<dynamic> decoded = jsonDecode(watchedJson);
        _watchedItems.clear();
        _watchedItems.addAll(
          decoded.map((json) => WatchedItem.fromJson(json)).toList(),
        );
        debugPrint('✅ ${_watchedItems.length} itens assistidos carregados');
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar assistidos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Salva assistidos no armazenamento local
  Future<void> _saveWatchedItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final watchedJson = jsonEncode(
        _watchedItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_watchedKey, watchedJson);
      debugPrint('✅ Assistidos salvos: ${_watchedItems.length}');
    } catch (e) {
      debugPrint('❌ Erro ao salvar assistidos: $e');
    }
  }

  /// Verifica se um filme foi assistido
  bool isMovieWatched(Movie movie) {
    return _watchedItems.any(
      (item) => item.id == movie.id.toString() && !item.isTVShow,
    );
  }

  /// Verifica se uma série foi assistida
  bool isTVShowWatched(TVShow show) {
    return _watchedItems.any(
      (item) => item.id == show.id.toString() && item.isTVShow,
    );
  }

  /// Adiciona um filme aos assistidos
  Future<void> addMovie(Movie movie) async {
    if (isMovieWatched(movie)) {
      debugPrint('⚠️ Filme já está nos assistidos: ${movie.title}');
      return;
    }

    final watchedItem = WatchedItem.fromMovie(movie);
    _watchedItems.insert(0, watchedItem); // Adiciona no início
    notifyListeners();
    await _saveWatchedItems();
    debugPrint('👁️ Filme adicionado aos assistidos: ${movie.title}');
  }

  /// Adiciona uma série aos assistidos
  Future<void> addTVShow(TVShow show) async {
    if (isTVShowWatched(show)) {
      debugPrint('⚠️ Série já está nos assistidos: ${show.name}');
      return;
    }

    final watchedItem = WatchedItem.fromTVShow(show);
    _watchedItems.insert(0, watchedItem); // Adiciona no início
    notifyListeners();
    await _saveWatchedItems();
    debugPrint('👁️ Série adicionada aos assistidos: ${show.name}');
  }

  /// Remove um filme dos assistidos
  Future<void> removeMovie(Movie movie) async {
    _watchedItems.removeWhere(
      (item) => item.id == movie.id.toString() && !item.isTVShow,
    );
    notifyListeners();
    await _saveWatchedItems();
    debugPrint('🗑️ Filme removido dos assistidos: ${movie.title}');
  }

  /// Remove uma série dos assistidos
  Future<void> removeTVShow(TVShow show) async {
    _watchedItems.removeWhere(
      (item) => item.id == show.id.toString() && item.isTVShow,
    );
    notifyListeners();
    await _saveWatchedItems();
    debugPrint('🗑️ Série removida dos assistidos: ${show.name}');
  }

  /// Remove um assistido por ID
  Future<void> removeWatchedItem(String id) async {
    _watchedItems.removeWhere((item) => item.id == id);
    notifyListeners();
    await _saveWatchedItems();
    debugPrint('🗑️ Assistido removido: $id');
  }

  /// Toggle assistido de um filme
  Future<void> toggleMovieWatched(Movie movie) async {
    if (isMovieWatched(movie)) {
      await removeMovie(movie);
    } else {
      await addMovie(movie);
    }
  }

  /// Toggle assistido de uma série
  Future<void> toggleTVShowWatched(TVShow show) async {
    if (isTVShowWatched(show)) {
      await removeTVShow(show);
    } else {
      await addTVShow(show);
    }
  }

  /// Limpa todos os assistidos
  Future<void> clearAll() async {
    _watchedItems.clear();
    notifyListeners();
    await _saveWatchedItems();
    debugPrint('🗑️ Todos os assistidos foram removidos');
  }

  /// Recarrega a lista de assistidos
  Future<void> reload() async {
    await _loadWatchedItems();
  }

  /// Retorna apenas filmes assistidos
  List<WatchedItem> get movies {
    return _watchedItems.where((item) => !item.isTVShow).toList();
  }

  /// Retorna apenas séries assistidas
  List<WatchedItem> get tvShows {
    return _watchedItems.where((item) => item.isTVShow).toList();
  }

  /// Retorna estatísticas
  Map<String, int> get stats {
    return {
      'total': _watchedItems.length,
      'movies': movies.length,
      'tvShows': tvShows.length,
    };
  }
}
