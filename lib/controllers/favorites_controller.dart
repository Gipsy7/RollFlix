import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_item.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../services/user_data_service.dart';
import '../services/auth_service.dart';

/// Controller para gerenciar lista de favoritos
/// Singleton pattern para garantir instância única
class FavoritesController extends ChangeNotifier {
  static final FavoritesController _instance = FavoritesController._internal();
  static FavoritesController get instance => _instance;
  
  factory FavoritesController() => _instance;
  
  FavoritesController._internal() {
    _loadFavorites();
  }

  static const String _favoritesKey = 'rollflix_favorites';
  final List<FavoriteItem> _favorites = [];
  final List<FavoriteItem> _recentlyAdded = [];
  final List<FavoriteItem> _recentlyRemoved = [];
  bool _isLoading = false;

  List<FavoriteItem> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  int get count => _favorites.length;
  bool get hasFavorites => _favorites.isNotEmpty;

  /// Obtém e limpa lista de itens recentemente adicionados
  List<FavoriteItem> getAndClearRecentlyAdded() {
    final items = List<FavoriteItem>.from(_recentlyAdded);
    _recentlyAdded.clear();
    return items;
  }

  /// Obtém e limpa lista de itens recentemente removidos
  List<FavoriteItem> getAndClearRecentlyRemoved() {
    final items = List<FavoriteItem>.from(_recentlyRemoved);
    _recentlyRemoved.clear();
    return items;
  }

  /// Carrega favoritos do armazenamento (Firebase se logado, senão SharedPreferences)
  Future<void> _loadFavorites() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Se usuário está logado, carrega do Firebase
      if (AuthService.isUserLoggedIn()) {
        final cloudFavorites = await UserDataService.loadFavorites();
        _favorites.clear();
        _favorites.addAll(cloudFavorites);
        debugPrint('✅ ${_favorites.length} favoritos carregados do Firebase');
      } else {
        // Senão, carrega do SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final favoritesJson = prefs.getString(_favoritesKey);

        if (favoritesJson != null) {
          final List<dynamic> decoded = jsonDecode(favoritesJson);
          _favorites.clear();
          _favorites.addAll(
            decoded.map((json) => FavoriteItem.fromJson(json)).toList(),
          );
          debugPrint('✅ ${_favorites.length} favoritos carregados do local');
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar favoritos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Salva favoritos (Firebase se logado, SharedPreferences sempre)
  Future<void> _saveFavorites() async {
    try {
      // Sempre salva local (backup)
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = jsonEncode(
        _favorites.map((fav) => fav.toJson()).toList(),
      );
      await prefs.setString(_favoritesKey, favoritesJson);
      
      // Se usuário está logado, também salva no Firebase
      if (AuthService.isUserLoggedIn()) {
        await UserDataService.saveFavorites(_favorites);
        debugPrint('✅ Favoritos salvos (local + Firebase): ${_favorites.length}');
      } else {
        debugPrint('✅ Favoritos salvos (apenas local): ${_favorites.length}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao salvar favoritos: $e');
    }
  }

  /// Verifica se um filme está nos favoritos
  bool isMovieFavorite(Movie movie) {
    return _favorites.any(
      (fav) => fav.id == movie.id.toString() && !fav.isTVShow,
    );
  }

  /// Verifica se uma série está nos favoritos
  bool isTVShowFavorite(TVShow show) {
    return _favorites.any(
      (fav) => fav.id == show.id.toString() && fav.isTVShow,
    );
  }

  /// Adiciona um filme aos favoritos
  Future<void> addMovie(Movie movie) async {
    if (isMovieFavorite(movie)) {
      debugPrint('⚠️ Filme já está nos favoritos: ${movie.title}');
      return;
    }

    final favoriteItem = FavoriteItem.fromMovie(movie);
    _favorites.insert(0, favoriteItem); // Adiciona no início
    _recentlyAdded.add(favoriteItem); // Rastreia item adicionado
    notifyListeners();
    await _saveFavorites();
    debugPrint('⭐ Filme adicionado aos favoritos: ${movie.title}');
  }

  /// Adiciona uma série aos favoritos
  Future<void> addTVShow(TVShow show) async {
    if (isTVShowFavorite(show)) {
      debugPrint('⚠️ Série já está nos favoritos: ${show.name}');
      return;
    }

    final favoriteItem = FavoriteItem.fromTVShow(show);
    _favorites.insert(0, favoriteItem); // Adiciona no início
    _recentlyAdded.add(favoriteItem); // Rastreia item adicionado
    notifyListeners();
    await _saveFavorites();
    debugPrint('⭐ Série adicionada aos favoritos: ${show.name}');
  }

  /// Remove um filme dos favoritos
  Future<void> removeMovie(Movie movie) async {
    final removed = _favorites.where(
      (fav) => fav.id == movie.id.toString() && !fav.isTVShow,
    ).toList();
    
    _favorites.removeWhere(
      (fav) => fav.id == movie.id.toString() && !fav.isTVShow,
    );
    
    _recentlyRemoved.addAll(removed); // Rastreia itens removidos
    notifyListeners();
    await _saveFavorites();
    debugPrint('🗑️ Filme removido dos favoritos: ${movie.title}');
  }

  /// Remove uma série dos favoritos
  Future<void> removeTVShow(TVShow show) async {
    final removed = _favorites.where(
      (fav) => fav.id == show.id.toString() && fav.isTVShow,
    ).toList();
    
    _favorites.removeWhere(
      (fav) => fav.id == show.id.toString() && fav.isTVShow,
    );
    
    _recentlyRemoved.addAll(removed); // Rastreia itens removidos
    notifyListeners();
    await _saveFavorites();
    debugPrint('🗑️ Série removida dos favoritos: ${show.name}');
  }

  /// Remove um favorito por ID
  Future<void> removeFavorite(String id) async {
    final removed = _favorites.where((fav) => fav.id == id).toList();
    _favorites.removeWhere((fav) => fav.id == id);
    _recentlyRemoved.addAll(removed); // Rastreia itens removidos
    notifyListeners();
    await _saveFavorites();
    debugPrint('🗑️ Favorito removido: $id');
  }

  /// Toggle favorito de um filme
  Future<void> toggleMovieFavorite(Movie movie) async {
    if (isMovieFavorite(movie)) {
      await removeMovie(movie);
    } else {
      await addMovie(movie);
    }
  }

  /// Toggle favorito de uma série
  Future<void> toggleTVShowFavorite(TVShow show) async {
    if (isTVShowFavorite(show)) {
      await removeTVShow(show);
    } else {
      await addTVShow(show);
    }
  }

  /// Limpa todos os favoritos
  Future<void> clearAll() async {
    _favorites.clear();
    notifyListeners();
    await _saveFavorites();
    debugPrint('🗑️ Todos os favoritos foram limpos');
  }

  /// Obtém favoritos filtrados por tipo
  List<FavoriteItem> getFavoritesByType({required bool isTVShow}) {
    return _favorites.where((fav) => fav.isTVShow == isTVShow).toList();
  }

  /// Obtém apenas filmes favoritos
  List<FavoriteItem> get favoriteMovies => getFavoritesByType(isTVShow: false);

  /// Obtém apenas séries favoritas
  List<FavoriteItem> get favoriteTVShows => getFavoritesByType(isTVShow: true);

  /// Recarrega favoritos
  Future<void> reload() async {
    await _loadFavorites();
  }

  /// Sincroniza após login (mescla dados locais com Firebase)
  Future<void> syncAfterLogin() async {
    try {
      debugPrint('🔄 Sincronizando favoritos após login...');
      
      // Carrega dados locais atuais
      final prefs = await SharedPreferences.getInstance();
      final localJson = prefs.getString(_favoritesKey);
      final List<FavoriteItem> localFavorites = [];
      
      if (localJson != null) {
        final List<dynamic> decoded = jsonDecode(localJson);
        localFavorites.addAll(
          decoded.map((json) => FavoriteItem.fromJson(json)).toList(),
        );
      }
      
      // Carrega dados do Firebase
      final cloudFavorites = await UserDataService.loadFavorites();
      
      // Mescla (remove duplicatas, mantém mais recentes)
      final Map<String, FavoriteItem> merged = {};
      
      for (final item in localFavorites) {
        merged[item.id] = item;
      }
      
      for (final item in cloudFavorites) {
        merged[item.id] = item; // Prioriza dados da nuvem
      }
      
      _favorites.clear();
      _favorites.addAll(merged.values.toList()
        ..sort((a, b) => b.addedAt.compareTo(a.addedAt)));
      
      // Salva dados mesclados
      await _saveFavorites();
      notifyListeners();
      
      debugPrint('✅ Favoritos sincronizados: ${_favorites.length} itens');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar favoritos: $e');
    }
  }
}
