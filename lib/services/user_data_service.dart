import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/favorite_item.dart';
import '../models/watched_item.dart';
import '../models/roll_preferences.dart';
import '../models/date_night_preferences.dart';
import '../controllers/user_preferences_controller.dart';
import 'auth_service.dart';

/// Serviço para gerenciar dados do usuário no Firestore
class UserDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Referência para a coleção de usuários
  static CollectionReference get _usersCollection => _firestore.collection('users');
  
  /// Obtém a referência do documento do usuário atual
  static DocumentReference? get _currentUserDoc {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return null;
    return _usersCollection.doc(uid);
  }

  /// Executa uma operação com retry automático em caso de falha
  static Future<T> _executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          debugPrint('❌ Operação falhou após $maxRetries tentativas: $e');
          rethrow;
        }
        debugPrint('⚠️ Tentativa $attempts falhou, tentando novamente em ${delay.inSeconds}s: $e');
        await Future.delayed(delay * attempts); // Backoff exponencial
      }
    }
    throw Exception('Operação falhou após $maxRetries tentativas');
  }
  
  // ==================== FAVORITOS ====================
  
  /// Salva lista de favoritos no Firestore
  static Future<void> saveFavorites(List<FavoriteItem> favorites) async {
    await _executeWithRetry(() async {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - favoritos não serão salvos no Firebase');
        return;
      }
      
      final favoritesJson = favorites.map((item) => item.toJson()).toList();
      
      await userDoc.set({
        'favorites': favoritesJson,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      debugPrint('✅ ${favorites.length} favoritos salvos no Firebase');
    });
  }
  
  /// Carrega lista de favoritos do Firestore
  static Future<List<FavoriteItem>> loadFavorites() async {
    return await _executeWithRetry(() async {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - retornando favoritos vazios');
        return [];
      }
      
      final snapshot = await userDoc.get();
      
      if (!snapshot.exists) {
        debugPrint('📄 Documento do usuário não existe - retornando favoritos vazios');
        return [];
      }
      
      final data = snapshot.data() as Map<String, dynamic>?;
      final favoritesList = data?['favorites'] as List<dynamic>?;
      
      if (favoritesList == null || favoritesList.isEmpty) {
        debugPrint('📋 Nenhum favorito encontrado no Firebase');
        return [];
      }
      
      final favorites = favoritesList
          .map((json) => FavoriteItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      debugPrint('✅ ${favorites.length} favoritos carregados do Firebase');
      return favorites;
    }, maxRetries: 2); // Menos retries para operações de leitura
  }
  
  /// Stream de favoritos em tempo real
  static Stream<List<FavoriteItem>> favoritesStream() {
    final userDoc = _currentUserDoc;
    if (userDoc == null) {
      return Stream.value([]);
    }
    
    return userDoc.snapshots().map((snapshot) {
      if (!snapshot.exists) return [];
      
      final data = snapshot.data() as Map<String, dynamic>?;
      final favoritesList = data?['favorites'] as List<dynamic>?;
      
      if (favoritesList == null || favoritesList.isEmpty) return [];
      
      return favoritesList
          .map((json) => FavoriteItem.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }
  
  // ==================== ASSISTIDOS ====================
  
  /// Salva lista de assistidos no Firestore
  static Future<void> saveWatched(List<WatchedItem> watched) async {
    await _executeWithRetry(() async {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - assistidos não serão salvos no Firebase');
        return;
      }
      
      final watchedJson = watched.map((item) => item.toJson()).toList();
      
      await userDoc.set({
        'watched': watchedJson,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      debugPrint('✅ ${watched.length} assistidos salvos no Firebase');
    });
  }
  
  /// Carrega lista de assistidos do Firestore
  static Future<List<WatchedItem>> loadWatched() async {
    return await _executeWithRetry(() async {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - retornando assistidos vazios');
        return [];
      }
      
      final snapshot = await userDoc.get();
      
      if (!snapshot.exists) {
        debugPrint('📄 Documento do usuário não existe - retornando assistidos vazios');
        return [];
      }
      
      final data = snapshot.data() as Map<String, dynamic>?;
      final watchedList = data?['watched'] as List<dynamic>?;
      
      if (watchedList == null || watchedList.isEmpty) {
        debugPrint('📋 Nenhum assistido encontrado no Firebase');
        return [];
      }
      
      final watched = watchedList
          .map((json) => WatchedItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      debugPrint('✅ ${watched.length} assistidos carregados do Firebase');
      return watched;
    }, maxRetries: 2); // Menos retries para operações de leitura
  }
  
  /// Stream de assistidos em tempo real
  static Stream<List<WatchedItem>> watchedStream() {
    final userDoc = _currentUserDoc;
    if (userDoc == null) {
      return Stream.value([]);
    }
    
    return userDoc.snapshots().map((snapshot) {
      if (!snapshot.exists) return [];
      
      final data = snapshot.data() as Map<String, dynamic>?;
      final watchedList = data?['watched'] as List<dynamic>?;
      
      if (watchedList == null || watchedList.isEmpty) return [];
      
      return watchedList
          .map((json) => WatchedItem.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }
  
  // ==================== SINCRONIZAÇÃO ====================
  
  /// Sincroniza dados locais com o Firebase após login
  static Future<void> syncAfterLogin({
    required List<FavoriteItem> localFavorites,
    required List<WatchedItem> localWatched,
  }) async {
    try {
      debugPrint('🔄 Iniciando sincronização após login...');
      
      // Carrega dados do Firebase
      final cloudFavorites = await loadFavorites();
      final cloudWatched = await loadWatched();
      
      // Mescla dados (prioriza dados da nuvem, adiciona dados locais que não existem)
      final mergedFavorites = _mergeFavorites(cloudFavorites, localFavorites);
      final mergedWatched = _mergeWatched(cloudWatched, localWatched);
      
      // Salva dados mesclados no Firebase
      await saveFavorites(mergedFavorites);
      await saveWatched(mergedWatched);
      
      debugPrint('✅ Sincronização concluída: ${mergedFavorites.length} favoritos, ${mergedWatched.length} assistidos');
    } catch (e) {
      debugPrint('❌ Erro na sincronização: $e');
      rethrow;
    }
  }
  
  /// Mescla listas de favoritos (remove duplicatas mantendo o mais recente)
  static List<FavoriteItem> _mergeFavorites(List<FavoriteItem> cloud, List<FavoriteItem> local) {
    final Map<String, FavoriteItem> merged = {};
    
    // Adiciona dados locais
    for (final item in local) {
      merged[item.id] = item;
    }
    
    // Adiciona/sobrescreve com dados da nuvem (mais recentes)
    for (final item in cloud) {
      merged[item.id] = item;
    }
    
    return merged.values.toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt)); // Mais recentes primeiro
  }
  
  /// Mescla listas de assistidos (remove duplicatas mantendo o mais recente)
  static List<WatchedItem> _mergeWatched(List<WatchedItem> cloud, List<WatchedItem> local) {
    final Map<String, WatchedItem> merged = {};
    
    // Adiciona dados locais
    for (final item in local) {
      merged[item.id] = item;
    }
    
    // Adiciona/sobrescreve com dados da nuvem (mais recentes)
    for (final item in cloud) {
      merged[item.id] = item;
    }
    
    return merged.values.toList()
      ..sort((a, b) => b.watchedAt.compareTo(a.watchedAt)); // Mais recentes primeiro
  }
  
  // ==================== PREFERÊNCIAS ====================

  /// Salva preferências de sorteio no Firestore
  static Future<void> saveRollPreferences(RollPreferences preferences) async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - roll preferences não serão salvas no Firebase');
        return;
      }

      await userDoc.set({
        'rollPreferences': preferences.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Roll preferences salvas no Firebase');
    } catch (e) {
      debugPrint('❌ Erro ao salvar roll preferences no Firebase: $e');
      rethrow;
    }
  }

  /// Carrega preferências de sorteio do Firestore
  static Future<RollPreferences?> loadRollPreferences() async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) return null;

      final doc = await userDoc.get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('rollPreferences')) return null;

      return RollPreferences.fromJson(data['rollPreferences']);
    } catch (e) {
      debugPrint('❌ Erro ao carregar roll preferences do Firebase: $e');
      return null;
    }
  }

  /// Salva preferências do date night no Firestore
  static Future<void> saveDateNightPreferences(DateNightPreferences preferences) async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - date night preferences não serão salvas no Firebase');
        return;
      }

      await userDoc.set({
        'dateNightPreferences': preferences.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Date night preferences salvas no Firebase');
    } catch (e) {
      debugPrint('❌ Erro ao salvar date night preferences no Firebase: $e');
      rethrow;
    }
  }

  /// Carrega preferências do date night do Firestore
  static Future<DateNightPreferences?> loadDateNightPreferences() async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) return null;

      final doc = await userDoc.get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('dateNightPreferences')) return null;

      return DateNightPreferences.fromJson(data['dateNightPreferences']);
    } catch (e) {
      debugPrint('❌ Erro ao carregar date night preferences do Firebase: $e');
      return null;
    }
  }

  /// Salva estatísticas de sorteios no Firestore
  static Future<void> saveRollStats(RollStats stats) async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - roll stats não serão salvas no Firebase');
        return;
      }

      await userDoc.set({
        'rollStats': stats.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Roll stats salvas no Firebase');
    } catch (e) {
      debugPrint('❌ Erro ao salvar roll stats no Firebase: $e');
      rethrow;
    }
  }

  /// Carrega estatísticas de sorteios do Firestore
  static Future<RollStats?> loadRollStats() async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) return null;

      final doc = await userDoc.get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('rollStats')) return null;

      return RollStats.fromJson(data['rollStats']);
    } catch (e) {
      debugPrint('❌ Erro ao carregar roll stats do Firebase: $e');
      return null;
    }
  }

  // ==================== USER RESOURCES ====================

  /// Salva recursos do usuário no Firestore
  static Future<void> saveUserResources(UserResources resources) async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - user resources não serão salvos no Firebase');
        return;
      }

      await userDoc.set({
        'userResources': resources.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ User resources salvos no Firebase');
    } catch (e) {
      debugPrint('❌ Erro ao salvar user resources no Firebase: $e');
      rethrow;
    }
  }

  /// Carrega recursos do usuário do Firestore
  static Future<UserResources?> loadUserResources() async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) return null;

      final doc = await userDoc.get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('userResources')) return null;

      return UserResources.fromJson(data['userResources']);
    } catch (e) {
      debugPrint('❌ Erro ao carregar user resources do Firebase: $e');
      return null;
    }
  }

  /// Limpa dados do usuário no Firebase (usado ao fazer logout)
  static Future<void> clearUserData() async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) return;
      
      // Não deleta o documento, apenas limpa as listas
      await userDoc.set({
        'favorites': [],
        'watched': [],
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      debugPrint('✅ Dados do usuário limpos no Firebase');
    } catch (e) {
      debugPrint('❌ Erro ao limpar dados do usuário no Firebase: $e');
      rethrow;
    }
  }

  /// Salva configurações do app (locale e modo) no Firestore
  static Future<void> saveAppSettings({
    required String? localeCode,
    required bool isSeriesMode,
    required String? selectedGenre,
  }) async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        debugPrint('⚠️ Usuário não logado - configurações do app não serão salvas no Firebase');
        return;
      }

      await userDoc.set({
        'appSettings': {
          'localeCode': localeCode,
          'isSeriesMode': isSeriesMode,
          'selectedGenre': selectedGenre,
        },
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Configurações do app salvas no Firebase');
      final uid = AuthService.currentUser?.uid;
      debugPrint('🔁 user_data_service.saveAppSettings -> uid=$uid, payload=${{
        'localeCode': localeCode,
        'isSeriesMode': isSeriesMode,
        'selectedGenre': selectedGenre,
      }}');
    } catch (e) {
      debugPrint('❌ Erro ao salvar configurações do app no Firebase: $e');
      rethrow;
    }
  }

  /// Carrega configurações do app do Firestore
  static Future<Map<String, dynamic>?> loadAppSettings() async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) return null;

      final doc = await userDoc.get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('appSettings')) return null;

      return data['appSettings'] as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Erro ao carregar configurações do app do Firebase: $e');
      return null;
    }
  }
}
