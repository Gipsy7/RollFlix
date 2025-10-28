import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../services/prefs_service.dart';
import '../models/favorite_item.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../services/user_data_service.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

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
        // Use local cache as a fast fallback, but prefer cloud when available.
  final prefs = PrefsService.prefs;
  final localJson = prefs.getString(_favoritesKey);
        if (localJson != null) {
          try {
            final List<dynamic> decoded = jsonDecode(localJson);
            _favorites.clear();
            _favorites.addAll(
              decoded.map((json) => FavoriteItem.fromJson(json)).toList(),
            );
            debugPrint('⚡ Favoritos carregados do cache local (preliminar): ${_favorites.length}');
            notifyListeners();
          } catch (_) {}
        }

        final cloudFavorites = await UserDataService.loadFavorites();
        if (cloudFavorites != null) {
          // Cloud has explicit data (could be empty list) — prefer it.
          _favorites.clear();
          _favorites.addAll(cloudFavorites);
          debugPrint('✅ Favoritos carregados do Firebase e aplicados (uid=${AuthService.currentUser?.uid}): ${_favorites.length}');
          // Update local cache to reflect authoritative cloud data
          await _saveFavorites();
        } else {
          debugPrint('ℹ️ Nenhum dado de favoritos no Firebase (document/field ausente) - mantendo cache local');
        }
      } else {
  // Senão, carrega do PrefsService cached SharedPreferences
  final prefs = PrefsService.prefs;
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
  Future<void> _saveFavorites({bool allowEmpty = false}) async {
    try {
      // Sempre salva local (backup)
      final prefs = PrefsService.prefs;
      final favoritesJson = jsonEncode(
        _favorites.map((fav) => fav.toJson()).toList(),
      );
      await prefs.setString(_favoritesKey, favoritesJson);
      
      // Se usuário está logado, também salva no Firebase — mas só após
      // a sincronização inicial com a nuvem para evitar sobrescritas.
      if (AuthService.isUserLoggedIn()) {
        if (!SessionService.initialCloudSyncCompleted) {
          debugPrint('⏳ Sincronização inicial não concluída - adiando gravação no Firebase para favoritos');
        } else {
          try {
            await UserDataService.saveFavorites(_favorites, allowEmpty: allowEmpty);
            debugPrint('✅ Favoritos salvos (local + Firebase): ${_favorites.length}');
          } catch (e) {
            debugPrint('⚠️ Erro ao salvar no Firebase, mas dados locais estão seguros: $e');
            // Não lança erro - dados locais estão salvos
          }
        }
      } else {
        debugPrint('✅ Favoritos salvos (apenas local): ${_favorites.length}');
      }
    } catch (e) {
      debugPrint('❌ Erro crítico ao salvar favoritos localmente: $e');
      // Mesmo em erro crítico, tenta manter consistência
      rethrow;
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
    // Allow empty writes so removing the last favorite propagates to cloud
    await _saveFavorites(allowEmpty: true);
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
    await _saveFavorites(allowEmpty: true);
    debugPrint('🗑️ Série removida dos favoritos: ${show.name}');
  }

  /// Remove um favorito por ID
  Future<void> removeFavorite(String id) async {
    final removed = _favorites.where((fav) => fav.id == id).toList();
    _favorites.removeWhere((fav) => fav.id == id);
    _recentlyRemoved.addAll(removed); // Rastreia itens removidos
    notifyListeners();
    await _saveFavorites(allowEmpty: true);
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
    // Explicit clear: allow writing empty list to cloud
    await _saveFavorites(allowEmpty: true);
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
  final prefs = PrefsService.prefs;
  final localJson = prefs.getString(_favoritesKey);
      final List<FavoriteItem> localFavorites = [];
      
      if (localJson != null) {
        try {
          final List<dynamic> decoded = jsonDecode(localJson);
          localFavorites.addAll(
            decoded.map((json) => FavoriteItem.fromJson(json)).toList(),
          );
        } catch (e) {
          debugPrint('⚠️ Erro ao decodificar favoritos locais, ignorando: $e');
        }
      }
      
      // Carrega dados do Firebase (prioridade) — null indica doc/field ausente
      List<FavoriteItem>? cloudFavorites;
      try {
        cloudFavorites = await UserDataService.loadFavorites();
      } catch (e) {
        debugPrint('⚠️ Erro ao carregar favoritos do Firebase, usando apenas dados locais: $e');
        cloudFavorites = null;
      }

      if (cloudFavorites != null) {
        // Cloud has authoritative data (may be empty) — prefer it.
        _favorites.clear();
        _favorites.addAll(cloudFavorites);
        debugPrint('✅ Favoritos substituídos pelos dados da nuvem (count=${_favorites.length})');
        // Persist authoritative cloud content locally
        await _saveFavorites();
      } else {
        // No cloud data present — keep local and push to cloud to create doc
        debugPrint('ℹ️ Nenhum dado de favoritos no Firebase (document/field ausente) - preservando cache local e subindo para nuvem');
        await _saveFavorites();
        if (AuthService.isUserLoggedIn()) {
          if (!SessionService.initialCloudSyncCompleted) {
            debugPrint('⏳ Sincronização inicial não concluída - adiando criação de documento de favoritos na nuvem');
          } else {
            try {
              await UserDataService.saveFavorites(_favorites);
              debugPrint('✅ Favoritos locais enviados para o Firebase (criação de documento)');
            } catch (e) {
              debugPrint('⚠️ Erro ao criar favoritos no Firebase após sync: $e');
            }
          }
        }
      }
      
      notifyListeners();
      debugPrint('✅ Favoritos sincronizados: ${_favorites.length} itens');
    } catch (e) {
      debugPrint('❌ Erro crítico na sincronização de favoritos: $e');
      // Em caso de erro crítico, pelo menos carrega dados locais
      await _loadFavorites();
      notifyListeners();
    }
  }

  /// Verifica integridade dos dados entre local e Firebase
  Future<bool> verifyDataIntegrity() async {
    try {
      if (!AuthService.isUserLoggedIn()) {
        debugPrint('ℹ️ Usuário não logado - pulando verificação de integridade');
        return true;
      }

      final cloudFavorites = await UserDataService.loadFavorites();
      final localCount = _favorites.length;
      final cloudCount = cloudFavorites?.length ?? 0;

      debugPrint('🔍 Verificando integridade: local=$localCount, cloud=$cloudCount');

      // Verifica se há diferenças significativas
      if ((localCount - cloudCount).abs() > 5) { // Diferença de mais de 5 itens
        debugPrint('⚠️ Diferença significativa detectada, forçando re-sync');
        await syncAfterLogin();
        return false; // Indica que foi necessário re-sync
      }

      // Verifica se todos os itens locais existem na nuvem
      final localIds = _favorites.map((f) => f.id).toSet();
      final cloudIds = cloudFavorites != null ? cloudFavorites.map((f) => f.id).toSet() : <String>{};
      final missingInCloud = localIds.difference(cloudIds);

      if (missingInCloud.isNotEmpty) {
        debugPrint('⚠️ ${missingInCloud.length} itens locais não encontrados na nuvem, sincronizando');
        if (!SessionService.initialCloudSyncCompleted) {
          debugPrint('⏳ Sincronização inicial não concluída - adiando envio de favoritos ausentes para a nuvem');
        } else {
          await UserDataService.saveFavorites(_favorites);
        }
      }

      debugPrint('✅ Integridade dos dados verificada');
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao verificar integridade dos dados: $e');
      return false;
    }
  }
}
