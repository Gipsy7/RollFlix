import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeServiceFirebase {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Random _random = Random();
  
  // Cache local das receitas para evitar múltiplas consultas
  static Map<String, List<Recipe>> _cachedRecipes = {};
  static DateTime? _lastFetchTime;
  static const _cacheExpiration = Duration(hours: 1);

  // Limpar cache manualmente se necessário
  static void clearCache() {
    _cachedRecipes.clear();
    _lastFetchTime = null;
    print('🗑️ Cache limpo');
  }

  // Buscar receitas por categoria
  static Future<List<Recipe>> searchRecipes({
    required String type,
    int number = 10,
    String? cuisine,
    String? diet,
  }) async {
    print('🍽️ Buscando receitas Firebase para: $type');
    
    // Verificar cache
    if (_cachedRecipes.containsKey(type) && _lastFetchTime != null) {
      final timeSinceLastFetch = DateTime.now().difference(_lastFetchTime!);
      if (timeSinceLastFetch < _cacheExpiration) {
        print('📦 Usando cache para $type');
        final cached = _cachedRecipes[type]!;
        final shuffled = List<Recipe>.from(cached)..shuffle(_random);
        return shuffled.take(number).toList();
      }
    }

    try {
      // Buscar do Firebase
      final snapshot = await _firestore
          .collection('recipes')
          .where('category', isEqualTo: type)
          .get();

      if (snapshot.docs.isEmpty) {
        print('⚠️ Nenhuma receita encontrada para $type no Firebase');
        return [];
      }

      // Converter documentos para objetos Recipe
      final recipes = snapshot.docs
          .map((doc) => Recipe.fromFirestore(doc.data(), doc.id))
          .toList();

      // Atualizar cache
      _cachedRecipes[type] = recipes;
      _lastFetchTime = DateTime.now();

      print('✅ ${recipes.length} receitas carregadas do Firebase para $type');

      // Embaralhar e retornar quantidade solicitada
      final shuffled = List<Recipe>.from(recipes)..shuffle(_random);
      return shuffled.take(number).toList();
    } catch (e) {
      print('❌ Erro ao buscar receitas do Firebase: $e');
      return [];
    }
  }

  // Buscar detalhes de uma receita específica
  static Future<Recipe> getRecipeDetails(int recipeId) async {
    print('📖 Buscando detalhes da receita $recipeId no Firebase');

    try {
      final doc = await _firestore
          .collection('recipes')
          .doc(recipeId.toString())
          .get();

      if (!doc.exists) {
        print('⚠️ Receita $recipeId não encontrada no Firebase');
        return _getPlaceholderRecipe();
      }

      final recipe = Recipe.fromFirestore(doc.data()!, doc.id);
      print('✅ Receita carregada: ${recipe.title}');
      return recipe;
    } catch (e) {
      print('❌ Erro ao buscar receita $recipeId: $e');
      return _getPlaceholderRecipe();
    }
  }

  // Buscar detalhes com retry automático
  static Future<Recipe> getRecipeDetailsWithRetry({
    required int recipeId,
    String? recipeType,
    int maxRetries = 3,
  }) async {
    print('🔄 Buscando receita $recipeId com retry (max: $maxRetries)');

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final recipe = await getRecipeDetails(recipeId);
        
        // Se conseguiu buscar (mesmo que seja placeholder), retorna
        if (recipe.id != 0) {
          return recipe;
        }

        // Se é placeholder e ainda tem tentativas, tenta novamente
        if (attempt < maxRetries) {
          print('⚠️ Tentativa $attempt falhou, tentando novamente...');
          await Future.delayed(Duration(seconds: attempt)); // Backoff exponencial
          continue;
        }

        return recipe; // Última tentativa, retorna placeholder
      } catch (e) {
        print('❌ Erro na tentativa $attempt: $e');
        
        if (attempt == maxRetries) {
          return _getPlaceholderRecipe();
        }
        
        await Future.delayed(Duration(seconds: attempt));
      }
    }

    return _getPlaceholderRecipe();
  }

  // Gerar menu completo para date night
  static Future<Map<String, Recipe>> generateDateNightMenu({
    String? cuisine,
    String? diet,
    String? dateType,
  }) async {
    print('🍽️ Gerando menu completo do Firebase...');

    try {
      // Buscar receitas de todas as categorias em paralelo
      final results = await Future.wait([
        searchRecipes(type: 'main course', number: 1),
        searchRecipes(type: 'dessert', number: 1),
        searchRecipes(type: 'appetizer', number: 1),
        searchRecipes(type: 'side dish', number: 1),
      ]);

      final mainCourses = results[0];
      final desserts = results[1];
      final appetizers = results[2];
      final sideDishes = results[3];

      // Verificar se conseguiu receitas de todas as categorias
      if (mainCourses.isEmpty || desserts.isEmpty || 
          appetizers.isEmpty || sideDishes.isEmpty) {
        print('⚠️ Algumas categorias não têm receitas disponíveis');
      }

      final menu = {
        'mainCourse': mainCourses.isNotEmpty ? mainCourses.first : _getPlaceholderRecipe(),
        'dessert': desserts.isNotEmpty ? desserts.first : _getPlaceholderRecipe(),
        'appetizer': appetizers.isNotEmpty ? appetizers.first : _getPlaceholderRecipe(),
        'sideDish': sideDishes.isNotEmpty ? sideDishes.first : _getPlaceholderRecipe(),
      };

      print('✅ Menu gerado com sucesso!');
      return menu;
    } catch (e) {
      print('❌ Erro ao gerar menu: $e');
      
      // Retornar menu com placeholders em caso de erro
      return {
        'mainCourse': _getPlaceholderRecipe(),
        'dessert': _getPlaceholderRecipe(),
        'appetizer': _getPlaceholderRecipe(),
        'sideDish': _getPlaceholderRecipe(),
      };
    }
  }

  // Receita placeholder para quando não houver dados
  static Recipe _getPlaceholderRecipe() {
    return Recipe(
      id: 0,
      title: 'Receita Indisponível',
      image: 'https://via.placeholder.com/300x200/CCCCCC/FFFFFF?text=Indisponivel',
      sourceUrl: '',
      readyInMinutes: 0,
      servings: 2,
      summary: 'Esta receita está temporariamente indisponível.',
      extendedIngredients: [],
      analyzedInstructions: [],
    );
  }

  // Compatibilidade com API antiga
  static String getDietFromRestriction(String restriction) {
    return restriction;
  }

  static String? getDateTypeCuisine(String dateType) {
    return null;
  }
}
