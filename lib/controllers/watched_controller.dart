import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/watched_item.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../services/user_data_service.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

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

  /// Carrega assistidos do armazenamento (Firebase se logado, senão SharedPreferences)
  Future<void> _loadWatchedItems() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Se usuário está logado, carrega do Firebase
      if (AuthService.isUserLoggedIn()) {
        // Use local cache fast, then prefer cloud when available
        final prefs = await SharedPreferences.getInstance();
        final localJson = prefs.getString(_watchedKey);
        if (localJson != null) {
          try {
            final List<dynamic> decoded = jsonDecode(localJson);
            _watchedItems.clear();
            _watchedItems.addAll(
              decoded.map((json) => WatchedItem.fromJson(json)).toList(),
            );
            debugPrint('⚡ Assistidos carregados do cache local (preliminar): ${_watchedItems.length}');
            notifyListeners();
          } catch (_) {}
        }

        final cloudWatched = await UserDataService.loadWatched();
        if (cloudWatched != null) {
          _watchedItems.clear();
          _watchedItems.addAll(cloudWatched);
          debugPrint('✅ Assistidos carregados do Firebase e aplicados (uid=${AuthService.currentUser?.uid}): ${_watchedItems.length}');
          await _saveWatchedItems();
        } else {
          debugPrint('ℹ️ Nenhum dado de assistidos no Firebase (document/field ausente) - mantendo cache local');
        }
      } else {
        // Senão, carrega do SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final watchedJson = prefs.getString(_watchedKey);

        if (watchedJson != null) {
          final List<dynamic> decoded = jsonDecode(watchedJson);
          _watchedItems.clear();
          _watchedItems.addAll(
            decoded.map((json) => WatchedItem.fromJson(json)).toList(),
          );
          debugPrint('✅ ${_watchedItems.length} assistidos carregados do local');
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar assistidos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Salva assistidos (Firebase se logado, SharedPreferences sempre)
  Future<void> _saveWatchedItems({bool allowEmpty = false}) async {
    try {
      // Sempre salva local (backup)
      final prefs = await SharedPreferences.getInstance();
      final watchedJson = jsonEncode(
        _watchedItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_watchedKey, watchedJson);
      
      // Se usuário está logado, também salva no Firebase
      if (AuthService.isUserLoggedIn()) {
        if (!SessionService.initialCloudSyncCompleted) {
          debugPrint('⏳ Sincronização inicial não concluída - adiando gravação no Firebase para assistidos');
        } else {
          try {
            await UserDataService.saveWatched(_watchedItems, allowEmpty: allowEmpty);
            debugPrint('✅ Assistidos salvos (local + Firebase): ${_watchedItems.length}');
          } catch (e) {
            debugPrint('⚠️ Erro ao salvar no Firebase, mas dados locais estão seguros: $e');
            // Não lança erro - dados locais estão salvos
          }
        }
      } else {
        debugPrint('✅ Assistidos salvos (apenas local): ${_watchedItems.length}');
      }
    } catch (e) {
      debugPrint('❌ Erro crítico ao salvar assistidos localmente: $e');
      // Mesmo em erro crítico, tenta manter consistência
      rethrow;
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
    // Allow empty writes when removing items so cloud reflects the change
    await _saveWatchedItems(allowEmpty: true);
    debugPrint('🗑️ Filme removido dos assistidos: ${movie.title}');
  }

  /// Remove uma série dos assistidos
  Future<void> removeTVShow(TVShow show) async {
    _watchedItems.removeWhere(
      (item) => item.id == show.id.toString() && item.isTVShow,
    );
    notifyListeners();
    await _saveWatchedItems(allowEmpty: true);
    debugPrint('🗑️ Série removida dos assistidos: ${show.name}');
  }

  /// Remove um assistido por ID
  Future<void> removeWatchedItem(String id) async {
    _watchedItems.removeWhere((item) => item.id == id);
    notifyListeners();
    await _saveWatchedItems(allowEmpty: true);
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
    // Explicit clear: allow writing empty list to cloud
    await _saveWatchedItems(allowEmpty: true);
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

  /// Sincroniza após login (mescla dados locais com Firebase)
  Future<void> syncAfterLogin() async {
    try {
      debugPrint('🔄 Sincronizando assistidos após login...');
      
      // Carrega dados locais atuais
      final prefs = await SharedPreferences.getInstance();
      final localJson = prefs.getString(_watchedKey);
      final List<WatchedItem> localWatched = [];
      
      if (localJson != null) {
        try {
          final List<dynamic> decoded = jsonDecode(localJson);
          localWatched.addAll(
            decoded.map((json) => WatchedItem.fromJson(json)).toList(),
          );
        } catch (e) {
          debugPrint('⚠️ Erro ao decodificar assistidos locais, ignorando: $e');
        }
      }
      
      // Carrega dados do Firebase (prioridade) — null indica doc/field ausente
      List<WatchedItem>? cloudWatched;
      try {
        cloudWatched = await UserDataService.loadWatched();
      } catch (e) {
        debugPrint('⚠️ Erro ao carregar assistidos do Firebase, usando apenas dados locais: $e');
        cloudWatched = null;
      }

      if (cloudWatched != null) {
        // Cloud authoritative data (may be empty) — prefer it
        _watchedItems.clear();
        _watchedItems.addAll(cloudWatched);
        debugPrint('✅ Assistidos substituídos pelos dados da nuvem (count=${_watchedItems.length})');
        await _saveWatchedItems();
      } else {
        // No cloud data present — keep local and push to cloud to create doc
        debugPrint('ℹ️ Nenhum dado de assistidos no Firebase (document/field ausente) - preservando cache local e subindo para nuvem');
        await _saveWatchedItems();
        if (AuthService.isUserLoggedIn()) {
          if (!SessionService.initialCloudSyncCompleted) {
            debugPrint('⏳ Sincronização inicial não concluída - adiando criação de documento de assistidos na nuvem');
          } else {
            try {
              await UserDataService.saveWatched(_watchedItems);
              debugPrint('✅ Assistidos locais enviados para o Firebase (criação de documento)');
            } catch (e) {
              debugPrint('⚠️ Erro ao criar assistidos no Firebase após sync: $e');
            }
          }
        }
      }
      
      notifyListeners();
      debugPrint('✅ Assistidos sincronizados: ${_watchedItems.length} itens');
    } catch (e) {
      debugPrint('❌ Erro crítico na sincronização de assistidos: $e');
      // Em caso de erro crítico, pelo menos carrega dados locais
      await _loadWatchedItems();
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

  final cloudWatched = await UserDataService.loadWatched();
  final localCount = _watchedItems.length;
  final cloudCount = cloudWatched?.length ?? 0;

      debugPrint('🔍 Verificando integridade: local=$localCount, cloud=$cloudCount');

      // Verifica se há diferenças significativas
      if ((localCount - cloudCount).abs() > 5) { // Diferença de mais de 5 itens
        debugPrint('⚠️ Diferença significativa detectada, forçando re-sync');
        await syncAfterLogin();
        return false; // Indica que foi necessário re-sync
      }

      // Verifica se todos os itens locais existem na nuvem
      final localIds = _watchedItems.map((w) => w.id).toSet();
      final cloudIds = cloudWatched != null ? cloudWatched.map((w) => w.id).toSet() : <String>{};
      final missingInCloud = localIds.difference(cloudIds);

      if (missingInCloud.isNotEmpty) {
        debugPrint('⚠️ ${missingInCloud.length} itens locais não encontrados na nuvem, sincronizando');
        if (!SessionService.initialCloudSyncCompleted) {
          debugPrint('⏳ Sincronização inicial não concluída - adiando envio de assistidos ausentes para a nuvem');
        } else {
          await UserDataService.saveWatched(_watchedItems);
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
