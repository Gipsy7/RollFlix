import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/favorite_item.dart';
import '../models/watched_item.dart';
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
  
  // ==================== FAVORITOS ====================
  
  /// Salva lista de favoritos no Firestore
  static Future<void> saveFavorites(List<FavoriteItem> favorites) async {
    try {
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
    } catch (e) {
      debugPrint('❌ Erro ao salvar favoritos no Firebase: $e');
      rethrow;
    }
  }
  
  /// Carrega lista de favoritos do Firestore
  static Future<List<FavoriteItem>> loadFavorites() async {
    try {
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
    } catch (e) {
      debugPrint('❌ Erro ao carregar favoritos do Firebase: $e');
      return [];
    }
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
    try {
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
    } catch (e) {
      debugPrint('❌ Erro ao salvar assistidos no Firebase: $e');
      rethrow;
    }
  }
  
  /// Carrega lista de assistidos do Firestore
  static Future<List<WatchedItem>> loadWatched() async {
    try {
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
    } catch (e) {
      debugPrint('❌ Erro ao carregar assistidos do Firebase: $e');
      return [];
    }
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
      
      debugPrint('🗑️ Dados do usuário limpos no Firebase');
    } catch (e) {
      debugPrint('❌ Erro ao limpar dados do usuário: $e');
    }
  }
}
