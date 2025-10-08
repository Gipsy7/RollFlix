import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeCacheService {
  // Cache em memória (válido durante a execução do app)
  static final Map<String, Recipe> _memoryCache = {};
  static final Map<String, List<Recipe>> _searchCache = {};
  static final Map<String, Map<String, Recipe>> _menuCache = {};
  
  // Tempo de expiração do cache (24 horas)
  static const Duration _cacheExpiration = Duration(hours: 24);
  
  // Chaves para SharedPreferences
  static const String _recipeCacheKey = 'recipe_cache_';
  static const String _searchCacheKey = 'search_cache_';
  static const String _menuCacheKey = 'menu_cache_';
  static const String _timestampSuffix = '_timestamp';

  // ========== CACHE DE RECEITA INDIVIDUAL ==========

  /// Salvar receita no cache (memória + persistente)
  static Future<void> cacheRecipe(Recipe recipe) async {
    // Cache em memória
    _memoryCache[recipe.id.toString()] = recipe;
    
    // Cache persistente
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_recipeCacheKey${recipe.id}';
      final timestampKey = '$key$_timestampSuffix';
      
      await prefs.setString(key, jsonEncode(recipe.toJson()));
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Erro ao salvar receita no cache: $e');
    }
  }

  /// Buscar receita no cache
  static Future<Recipe?> getCachedRecipe(int recipeId) async {
    final key = recipeId.toString();
    
    // 1. Verificar cache em memória
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key];
    }
    
    // 2. Verificar cache persistente
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_recipeCacheKey$recipeId';
      final timestampKey = '$cacheKey$_timestampSuffix';
      
      final timestamp = prefs.getInt(timestampKey);
      if (timestamp == null) return null;
      
      // Verificar se o cache expirou
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheExpiration) {
        // Cache expirado, remover
        await prefs.remove(cacheKey);
        await prefs.remove(timestampKey);
        return null;
      }
      
      final jsonString = prefs.getString(cacheKey);
      if (jsonString == null) return null;
      
      final recipe = Recipe.fromJson(jsonDecode(jsonString));
      
      // Adicionar ao cache em memória para próximas consultas
      _memoryCache[key] = recipe;
      
      return recipe;
    } catch (e) {
      print('Erro ao buscar receita no cache: $e');
      return null;
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
    } catch (e) {
      print('Erro ao salvar busca no cache: $e');
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
    } catch (e) {
      print('Erro ao buscar resultados no cache: $e');
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
    } catch (e) {
      print('Erro ao salvar menu no cache: $e');
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
    } catch (e) {
      print('Erro ao buscar menu no cache: $e');
      return null;
    }
  }

  // ========== LIMPEZA ==========

  /// Limpar cache em memória
  static void clearMemoryCache() {
    _memoryCache.clear();
    _searchCache.clear();
    _menuCache.clear();
  }

  /// Limpar todo o cache (memória + persistente)
  static Future<void> clearAllCache() async {
    // Limpar memória
    clearMemoryCache();
    
    // Limpar cache persistente
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (var key in keys) {
        if (key.startsWith(_recipeCacheKey) ||
            key.startsWith(_searchCacheKey) ||
            key.startsWith(_menuCacheKey)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Erro ao limpar cache: $e');
    }
  }

  /// Limpar cache expirado
  static Future<void> clearExpiredCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (var key in keys) {
        if (key.endsWith(_timestampSuffix)) {
          final timestamp = prefs.getInt(key);
          if (timestamp != null) {
            final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            if (DateTime.now().difference(cacheTime) > _cacheExpiration) {
              // Remover cache expirado
              final baseKey = key.replaceAll(_timestampSuffix, '');
              await prefs.remove(baseKey);
              await prefs.remove(key);
            }
          }
        }
      }
    } catch (e) {
      print('Erro ao limpar cache expirado: $e');
    }
  }

  // ========== ESTATÍSTICAS ==========

  /// Obter tamanho do cache em memória
  static Map<String, int> getCacheStats() {
    return {
      'recipes': _memoryCache.length,
      'searches': _searchCache.length,
      'menus': _menuCache.length,
    };
  }

  /// Verificar se há receitas em cache
  static bool get hasCache => _memoryCache.isNotEmpty || 
                               _searchCache.isNotEmpty || 
                               _menuCache.isNotEmpty;
}
