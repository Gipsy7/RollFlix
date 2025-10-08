import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';
import '../utils/app_logger.dart';

class RecipeCacheService {
  // Cache em memória (válido durante a execução do app)
  static final Map<String, Recipe> _memoryCache = {};
  static final Map<String, List<Recipe>> _searchCache = {};
  static final Map<String, Map<String, Recipe>> _menuCache = {};
  
  // Rastreamento de uso para LRU (Least Recently Used)
  static final Map<String, DateTime> _lastAccessTime = {};
  static final Set<int> _invalidRecipeIds = {}; // IDs que retornaram 404
  static bool _isInitialized = false;
  
  // Tempo de expiração do cache (24 horas)
  static const Duration _cacheExpiration = Duration(hours: 24);
  
  // Limites de cache
  static const int _maxMemoryCacheSize = 100; // Máximo de receitas em memória
  static const int _maxSearchCacheSize = 20; // Máximo de buscas em cache
  
  // Chaves para SharedPreferences
  static const String _recipeCacheKey = 'recipe_cache_';
  static const String _searchCacheKey = 'search_cache_';
  static const String _menuCacheKey = 'menu_cache_';
  static const String _timestampSuffix = '_timestamp';
  static const String _accessTimeSuffix = '_access';
  static const String _invalidIdsKey = 'invalid_recipe_ids';

  // ========== INICIALIZAÇÃO ==========

  /// Inicializar o serviço de cache (chamar no início do app)
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      AppLogger.debug('🔧 Inicializando RecipeCacheService...');
      
      // Carregar IDs inválidos de forma assíncrona
      _loadInvalidIds().then((_) {
        AppLogger.debug('  ✓ IDs inválidos carregados: ${_invalidRecipeIds.length}');
      });
      
      // Executar limpeza em background
      Future.delayed(Duration(seconds: 2), () {
        smartCleanup();
      });
      
      _isInitialized = true;
      AppLogger.debug('✅ RecipeCacheService inicializado');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Erro ao inicializar RecipeCacheService: $e', stackTrace: stackTrace);
    }
  }

  // ========== CACHE DE RECEITA INDIVIDUAL ==========

  /// Salvar receita no cache (memória + persistente)
  static Future<void> cacheRecipe(Recipe recipe) async {
    try {
      final key = recipe.id.toString();
      
      // Cache em memória
      _memoryCache[key] = recipe;
      
      // Atualizar tempo de acesso (apenas em memória para performance)
      _lastAccessTime[key] = DateTime.now();
      
      // Limpar cache se exceder limite SIGNIFICATIVAMENTE (evita chamadas frequentes)
      if (_memoryCache.length > _maxMemoryCacheSize + 20) {
        _cleanupMemoryCacheSync(); // Limpeza síncrona rápida
      }
      
      // Cache persistente (assíncrono, não bloqueia)
      _saveToPersistentCache(recipe);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Erro ao salvar receita no cache: $e', stackTrace: stackTrace);
    }
  }

  /// Salvar no cache persistente (método privado async)
  static Future<void> _saveToPersistentCache(Recipe recipe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_recipeCacheKey${recipe.id}';
      final timestampKey = '$key$_timestampSuffix';
      
      await prefs.setString(key, jsonEncode(recipe.toJson()));
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e, stackTrace) {
      AppLogger.error('⚠ Erro ao salvar no cache persistente: $e', stackTrace: stackTrace);
    }
  }

  /// Limpeza síncrona rápida do cache em memória
  static void _cleanupMemoryCacheSync() {
    if (_memoryCache.length <= _maxMemoryCacheSize) return;
    
    try {
      // Ordenar por tempo de acesso
      final sortedEntries = _lastAccessTime.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      // Remover 30% das mais antigas
      final toRemove = (_memoryCache.length * 0.3).toInt();
      
      for (var i = 0; i < toRemove && i < sortedEntries.length; i++) {
        final key = sortedEntries[i].key;
        _memoryCache.remove(key);
        _lastAccessTime.remove(key);
      }
      
      AppLogger.debug('🧹 Limpeza rápida: $toRemove receitas removidas');
    } catch (e, stackTrace) {
      AppLogger.error('⚠ Erro na limpeza rápida: $e', stackTrace: stackTrace);
    }
  }

  /// Buscar receita no cache
  static Future<Recipe?> getCachedRecipe(int recipeId) async {
    try {
      final key = recipeId.toString();
      
      // 0. Verificação síncrona de IDs inválidos (muito mais rápido)
      if (_invalidRecipeIds.contains(recipeId)) {
        return null; // Não precisa logar toda vez
      }
      
      // 1. Verificar cache em memória
      if (_memoryCache.containsKey(key)) {
        _lastAccessTime[key] = DateTime.now(); // Atualização síncrona
        return _memoryCache[key];
      }
      
      // 2. Verificar cache persistente
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_recipeCacheKey$recipeId';
      final timestampKey = '$cacheKey$_timestampSuffix';
      
      final timestamp = prefs.getInt(timestampKey);
      if (timestamp == null) return null;
      
      // Verificar se o cache expirou
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheExpiration) {
        // Remover em background
        _removeExpiredFromPersistent(recipeId);
        return null;
      }
      
      final jsonString = prefs.getString(cacheKey);
      if (jsonString == null) return null;
      
      final recipe = Recipe.fromJson(jsonDecode(jsonString));
      
      // Adicionar ao cache em memória
      _memoryCache[key] = recipe;
      _lastAccessTime[key] = DateTime.now();
      
      return recipe;
    } catch (e, stackTrace) {
      AppLogger.error('⚠ Erro ao buscar receita #$recipeId no cache: $e', stackTrace: stackTrace);
      return null;
    }
  }

  /// Remover item expirado do cache persistente (background)
  static Future<void> _removeExpiredFromPersistent(int recipeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_recipeCacheKey$recipeId';
      final timestampKey = '$cacheKey$_timestampSuffix';
      final accessKey = '$cacheKey$_accessTimeSuffix';
      
      await prefs.remove(cacheKey);
      await prefs.remove(timestampKey);
      await prefs.remove(accessKey);
    } catch (e) {
      // Silencioso - não é crítico
    }
  }

  /// Remover receita específica do cache
  static Future<void> removeRecipe(int recipeId) async {
    final key = recipeId.toString();
    
    // Marcar como inválida
    _invalidRecipeIds.add(recipeId);
    await _saveInvalidIds();
    
    // Remover do cache em memória
    _memoryCache.remove(key);
    _lastAccessTime.remove(key);
    
    // Remover do cache persistente
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_recipeCacheKey$recipeId';
      final timestampKey = '$cacheKey$_timestampSuffix';
      final accessKey = '$cacheKey$_accessTimeSuffix';
      
      await prefs.remove(cacheKey);
      await prefs.remove(timestampKey);
      await prefs.remove(accessKey);
      
      AppLogger.debug('✓ Receita #$recipeId removida do cache');
    } catch (e, stackTrace) {
      AppLogger.error('⚠ Erro ao remover receita do cache: $e', stackTrace: stackTrace);
    }
  }

  /// Verificar se receita é conhecida como inválida (síncrono para performance)
  static bool isInvalidRecipe(int recipeId) {
    return _invalidRecipeIds.contains(recipeId);
  }

  /// Salvar lista de IDs inválidos
  static Future<void> _saveInvalidIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = _invalidRecipeIds.toList();
      await prefs.setString(_invalidIdsKey, jsonEncode(ids));
    } catch (e, stackTrace) {
      AppLogger.error('⚠ Erro ao salvar IDs inválidos: $e', stackTrace: stackTrace);
    }
  }

  /// Carregar lista de IDs inválidos
  static Future<void> _loadInvalidIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idsJson = prefs.getString(_invalidIdsKey);
      if (idsJson != null) {
        final ids = List<int>.from(jsonDecode(idsJson));
        _invalidRecipeIds.addAll(ids);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao carregar IDs inválidos: $e', stackTrace: stackTrace);
    }
  }

  // ========== CACHE DE BUSCA ==========

  /// Gerar chave de busca
  static String _getSearchCacheKey(String type, String? cuisine, String? diet) {
    return '${type}_${cuisine ?? 'any'}_${diet ?? 'any'}';
  }

  /// Salvar resultados de busca no cache
  static Future<void> cacheSearchResults(
    String type,
    String? cuisine,
    String? diet,
    List<Recipe> recipes,
  ) async {
    final cacheKey = _getSearchCacheKey(type, cuisine, diet);
    
    // Cache em memória
    _searchCache[cacheKey] = recipes;
    
    // Salvar cada receita individualmente
    for (var recipe in recipes) {
      await cacheRecipe(recipe);
    }
    
    // Cache persistente da lista de IDs
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_searchCacheKey$cacheKey';
      final timestampKey = '$key$_timestampSuffix';
      
      final recipeIds = recipes.map((r) => r.id).toList();
      await prefs.setString(key, jsonEncode(recipeIds));
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao salvar busca no cache: $e', stackTrace: stackTrace);
    }
  }

  /// Buscar resultados de busca no cache
  static Future<List<Recipe>?> getCachedSearchResults(
    String type,
    String? cuisine,
    String? diet,
  ) async {
    final cacheKey = _getSearchCacheKey(type, cuisine, diet);
    
    // 1. Verificar cache em memória
    if (_searchCache.containsKey(cacheKey)) {
      // Retornar uma CÓPIA da lista para não modificar o cache original
      return List<Recipe>.from(_searchCache[cacheKey]!);
    }
    
    // 2. Verificar cache persistente
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_searchCacheKey$cacheKey';
      final timestampKey = '$key$_timestampSuffix';
      
      final timestamp = prefs.getInt(timestampKey);
      if (timestamp == null) return null;
      
      // Verificar se o cache expirou
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheExpiration) {
        await prefs.remove(key);
        await prefs.remove(timestampKey);
        return null;
      }
      
      final idsJson = prefs.getString(key);
      if (idsJson == null) return null;
      
      final recipeIds = List<int>.from(jsonDecode(idsJson));
      
      // Buscar cada receita do cache
      List<Recipe> recipes = [];
      for (var id in recipeIds) {
        final recipe = await getCachedRecipe(id);
        if (recipe != null) {
          recipes.add(recipe);
        }
      }
      
      // Se conseguiu todas as receitas, salvar no cache de memória e retornar cópia
      if (recipes.length == recipeIds.length) {
        _searchCache[cacheKey] = recipes;
        // Retornar uma CÓPIA para não modificar o cache original
        return List<Recipe>.from(recipes);
      }
      
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao buscar resultados no cache: $e', stackTrace: stackTrace);
      return null;
    }
  }

  // ========== CACHE DE MENU COMPLETO ==========

  /// Gerar chave de menu
  static String _getMenuCacheKey(String? cuisine, String? diet) {
    return '${cuisine ?? 'any'}_${diet ?? 'any'}';
  }

  /// Salvar menu completo no cache
  static Future<void> cacheMenu(
    String? cuisine,
    String? diet,
    Map<String, Recipe> menu,
  ) async {
    final cacheKey = _getMenuCacheKey(cuisine, diet);
    
    // Cache em memória
    _menuCache[cacheKey] = menu;
    
    // Salvar cada receita
    for (var recipe in menu.values) {
      await cacheRecipe(recipe);
    }
    
    // Cache persistente dos IDs do menu
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_menuCacheKey$cacheKey';
      final timestampKey = '$key$_timestampSuffix';
      
      final menuIds = {
        'mainCourse': menu['mainCourse']?.id,
        'dessert': menu['dessert']?.id,
        'appetizer': menu['appetizer']?.id,
        'sideDish': menu['sideDish']?.id,
      };
      
      await prefs.setString(key, jsonEncode(menuIds));
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao salvar menu no cache: $e', stackTrace: stackTrace);
    }
  }

  /// Buscar menu completo no cache
  static Future<Map<String, Recipe>?> getCachedMenu(
    String? cuisine,
    String? diet,
  ) async {
    final cacheKey = _getMenuCacheKey(cuisine, diet);
    
    // 1. Verificar cache em memória
    if (_menuCache.containsKey(cacheKey)) {
      return _menuCache[cacheKey];
    }
    
    // 2. Verificar cache persistente
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_menuCacheKey$cacheKey';
      final timestampKey = '$key$_timestampSuffix';
      
      final timestamp = prefs.getInt(timestampKey);
      if (timestamp == null) return null;
      
      // Verificar se o cache expirou
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheExpiration) {
        await prefs.remove(key);
        await prefs.remove(timestampKey);
        return null;
      }
      
      final menuJson = prefs.getString(key);
      if (menuJson == null) return null;
      
      final menuIds = Map<String, dynamic>.from(jsonDecode(menuJson));
      
      // Buscar cada receita do cache
      Map<String, Recipe> menu = {};
      
      for (var entry in menuIds.entries) {
        if (entry.value != null) {
          final recipe = await getCachedRecipe(entry.value as int);
          if (recipe != null) {
            menu[entry.key] = recipe;
          }
        }
      }
      
      // Se conseguiu todas as receitas, retornar
      if (menu.length == 4) {
        _menuCache[cacheKey] = menu;
        return menu;
      }
      
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao buscar menu no cache: $e', stackTrace: stackTrace);
      return null;
    }
  }

  // ========== LIMPEZA ==========

  /// Limpar cache em memória
  static void clearMemoryCache() {
    _memoryCache.clear();
    _searchCache.clear();
    _menuCache.clear();
    _lastAccessTime.clear();
    _invalidRecipeIds.clear();
  }

  /// Limpar todo o cache (memória + persistente)
  static Future<void> clearAllCache() async {
    AppLogger.debug('🧹 Limpando todo o cache...');
    
    // Limpar memória
    clearMemoryCache();
    
    // Limpar cache persistente
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      int removedCount = 0;
      
      for (var key in keys) {
        if (key.startsWith(_recipeCacheKey) ||
            key.startsWith(_searchCacheKey) ||
            key.startsWith(_menuCacheKey) ||
            key == _invalidIdsKey) {
          await prefs.remove(key);
          removedCount++;
        }
      }
      
      AppLogger.debug('✅ Cache limpo: $removedCount itens removidos');
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao limpar cache: $e', stackTrace: stackTrace);
    }
  }

  /// Limpar cache expirado
  static Future<void> clearExpiredCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      int removedCount = 0;
      
      for (var key in keys) {
        if (key.endsWith(_timestampSuffix)) {
          final timestamp = prefs.getInt(key);
          if (timestamp != null) {
            final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            if (DateTime.now().difference(cacheTime) > _cacheExpiration) {
              // Remover cache expirado
              final baseKey = key.replaceAll(_timestampSuffix, '');
              final accessKey = '$baseKey$_accessTimeSuffix';
              await prefs.remove(baseKey);
              await prefs.remove(key);
              await prefs.remove(accessKey);
              removedCount++;
            }
          }
        }
      }
      
      if (removedCount > 0) {
        AppLogger.debug('🧹 Limpeza automática: $removedCount itens expirados removidos');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao limpar cache expirado: $e', stackTrace: stackTrace);
    }
  }

  /// Limpar receitas menos usadas (LRU - Least Recently Used)
  static Future<void> cleanLeastRecentlyUsed() async {
    if (_memoryCache.length <= _maxMemoryCacheSize) {
      return; // Cache dentro do limite
    }
    
    try {
      // Ordenar receitas por tempo de acesso (mais antigas primeiro)
      final sortedEntries = _lastAccessTime.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      // Calcular quantas remover (manter apenas maxMemoryCacheSize)
      final toRemove = _memoryCache.length - _maxMemoryCacheSize;
      int removedCount = 0;
      
      for (var i = 0; i < toRemove && i < sortedEntries.length; i++) {
        final recipeId = sortedEntries[i].key;
        _memoryCache.remove(recipeId);
        _lastAccessTime.remove(recipeId);
        removedCount++;
      }
      
      AppLogger.debug('🧹 Limpeza LRU: $removedCount receitas menos usadas removidas da memória');
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao limpar receitas menos usadas: $e', stackTrace: stackTrace);
    }
  }

  /// Limpar cache de buscas antigas
  static Future<void> cleanOldSearchCache() async {
    if (_searchCache.length <= _maxSearchCacheSize) {
      return; // Cache dentro do limite
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final searchCaches = <String, int>{}; // key -> timestamp
      
      // Coletar timestamps de buscas
      for (var key in keys) {
        if (key.startsWith(_searchCacheKey) && key.endsWith(_timestampSuffix)) {
          final timestamp = prefs.getInt(key);
          if (timestamp != null) {
            searchCaches[key] = timestamp;
          }
        }
      }
      
      // Ordenar por timestamp (mais antigas primeiro)
      final sortedCaches = searchCaches.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      // Remover as mais antigas até atingir o limite
      final toRemove = searchCaches.length - _maxSearchCacheSize;
      int removedCount = 0;
      
      for (var i = 0; i < toRemove && i < sortedCaches.length; i++) {
        final timestampKey = sortedCaches[i].key;
        final baseKey = timestampKey.replaceAll(_timestampSuffix, '');
        await prefs.remove(baseKey);
        await prefs.remove(timestampKey);
        removedCount++;
      }
      
      if (removedCount > 0) {
        AppLogger.debug('🧹 Limpeza de buscas: $removedCount buscas antigas removidas');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao limpar cache de buscas antigas: $e', stackTrace: stackTrace);
    }
  }

  /// Limpeza inteligente completa
  static Future<void> smartCleanup() async {
    AppLogger.debug('🧹 Iniciando limpeza inteligente do cache...');
    
    final startTime = DateTime.now();
    
    // 1. Limpar cache expirado
    await clearExpiredCache();
    
    // 2. Limpar receitas menos usadas se exceder limite
    await cleanLeastRecentlyUsed();
    
    // 3. Limpar buscas antigas se exceder limite
    await cleanOldSearchCache();
    
    // 4. Limpar cache de memória de buscas se exceder limite
    if (_searchCache.length > _maxSearchCacheSize) {
      final toRemove = _searchCache.length - _maxSearchCacheSize;
      final keys = _searchCache.keys.take(toRemove).toList();
      for (var key in keys) {
        _searchCache.remove(key);
      }
      AppLogger.debug('🧹 Removidas $toRemove buscas da memória');
    }
    
    final duration = DateTime.now().difference(startTime);
    final stats = getCacheStats();
    AppLogger.debug('✅ Limpeza concluída em ${duration.inMilliseconds}ms');
    AppLogger.debug('📊 Cache atual: ${stats['recipes']} receitas, ${stats['searches']} buscas, ${stats['menus']} menus');
  }

  // ========== ESTATÍSTICAS ==========

  /// Obter tamanho do cache em memória
  static Map<String, int> getCacheStats() {
    return {
      'recipes': _memoryCache.length,
      'searches': _searchCache.length,
      'menus': _menuCache.length,
      'invalidIds': _invalidRecipeIds.length,
    };
  }

  /// Obter estatísticas detalhadas
  static Future<Map<String, dynamic>> getDetailedStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      int persistentRecipes = 0;
      int persistentSearches = 0;
      int persistentMenus = 0;
      int expiredItems = 0;
      
      for (var key in keys) {
        if (key.startsWith(_recipeCacheKey) && !key.endsWith(_timestampSuffix) && !key.endsWith(_accessTimeSuffix)) {
          persistentRecipes++;
        } else if (key.startsWith(_searchCacheKey) && !key.endsWith(_timestampSuffix)) {
          persistentSearches++;
        } else if (key.startsWith(_menuCacheKey) && !key.endsWith(_timestampSuffix)) {
          persistentMenus++;
        }
        
        // Verificar expiração
        if (key.endsWith(_timestampSuffix)) {
          final timestamp = prefs.getInt(key);
          if (timestamp != null) {
            final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            if (DateTime.now().difference(cacheTime) > _cacheExpiration) {
              expiredItems++;
            }
          }
        }
      }
      
      return {
        'memory': {
          'recipes': _memoryCache.length,
          'searches': _searchCache.length,
          'menus': _menuCache.length,
          'lastAccessTimes': _lastAccessTime.length,
        },
        'persistent': {
          'recipes': persistentRecipes,
          'searches': persistentSearches,
          'menus': persistentMenus,
        },
        'invalidRecipeIds': _invalidRecipeIds.length,
        'expiredItems': expiredItems,
        'limits': {
          'maxMemoryCache': _maxMemoryCacheSize,
          'maxSearchCache': _maxSearchCacheSize,
        },
      };
    } catch (e, stackTrace) {
      AppLogger.error('Erro ao obter estatísticas detalhadas: $e', stackTrace: stackTrace);
      return {};
    }
  }

  /// Verificar se há receitas em cache
  static bool get hasCache => _memoryCache.isNotEmpty || 
                               _searchCache.isNotEmpty || 
                               _menuCache.isNotEmpty;
}
