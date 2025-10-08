import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../data/static_recipes_data.dart';
import 'recipe_cache_service.dart';

class RecipeService {
  // API Key da Spoonacular (use sua própria key)
  // Obtenha gratuitamente em: https://spoonacular.com/food-api
  static const String _apiKey = 'd82daaa2179b49cba610fa5223795596';
  static const String _baseUrl = 'https://api.spoonacular.com/recipes';

  // Buscar receitas por tipo
  static Future<List<Recipe>> searchRecipes({
    required String type, // main course, dessert, appetizer, side dish
    int number = 10,
    String? cuisine,
    String? diet,
  }) async {
    // 1. Verificar cache primeiro
    final cachedResults = await RecipeCacheService.getCachedSearchResults(type, cuisine, diet);
    if (cachedResults != null && cachedResults.isNotEmpty) {
      print('✓ Receitas carregadas do cache para $type: ${cachedResults.length} receitas');
      // Embaralhar as receitas do cache para variar a seleção
      final shuffled = List<Recipe>.from(cachedResults)..shuffle(Random());
      print('  Embaralhadas: ${shuffled.take(3).map((r) => r.title).join(", ")}...');
      return shuffled.take(number).toList();
    }

    // 2. Buscar da API se não estiver em cache
    try {
      final queryParams = {
        'apiKey': _apiKey,
        'type': type,
        'number': number.toString(),
        'addRecipeInformation': 'true',
        'fillIngredients': 'true',
        if (cuisine != null) 'cuisine': cuisine,
        if (diet != null) 'diet': diet,
      };

      final uri = Uri.parse('$_baseUrl/complexSearch').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        final recipes = results.map((recipe) => Recipe.fromJson(recipe)).toList();
        
        print('✓ Receitas recebidas da API para $type: ${recipes.length} receitas');
        
        // 3. Salvar no cache para uso futuro
        await RecipeCacheService.cacheSearchResults(type, cuisine, diet, recipes);
        print('✓ Receitas salvas no cache para $type');
        
        return recipes;
      } else {
        throw Exception('Erro ao buscar receitas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar receitas: $e');
      return _getFallbackRecipes(type);
    }
  }

  // Buscar detalhes completos de uma receita
  static Future<Recipe> getRecipeDetails(int recipeId) async {
    // 1. Verificar cache primeiro
    final cachedRecipe = await RecipeCacheService.getCachedRecipe(recipeId);
    if (cachedRecipe != null) {
      print('✓ Receita #$recipeId carregada do cache');
      return cachedRecipe;
    }

    // 2. Buscar da API se não estiver em cache
    try {
      final uri = Uri.parse('$_baseUrl/$recipeId/information').replace(
        queryParameters: {
          'apiKey': _apiKey,
          'includeNutrition': 'true',
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipe = Recipe.fromJson(data);
        
        // 3. Salvar no cache
        await RecipeCacheService.cacheRecipe(recipe);
        print('✓ Receita #$recipeId salva no cache');
        
        return recipe;
      } else {
        throw Exception('Erro ao buscar detalhes: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar detalhes da receita: $e');
      rethrow;
    }
  }

  // Buscar receitas aleatórias
  static Future<List<Recipe>> getRandomRecipes({
    int number = 3,
    String? tags,
  }) async {
    try {
      final queryParams = {
        'apiKey': _apiKey,
        'number': number.toString(),
        if (tags != null) 'tags': tags,
      };

      final uri = Uri.parse('$_baseUrl/random').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipes = data['recipes'] as List;
        return recipes.map((recipe) => Recipe.fromJson(recipe)).toList();
      } else {
        throw Exception('Erro ao buscar receitas aleatórias: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar receitas aleatórias: $e');
      return [];
    }
  }

  // Gerar menu completo para date night
  static Future<Map<String, Recipe>> generateDateNightMenu({
    String? cuisine,
    String? diet,
    String? dateType, // Tipo de Date Night para fallback apropriado
  }) async {
    // NÃO usar cache de menu completo - sempre gerar novo menu
    // para garantir variedade nas receitas
    
    // 2. Buscar da API (searchRecipes já usa cache internamente e randomiza)
    try {
      // Buscar MÚLTIPLAS receitas (10 de cada tipo) para popular o cache
      // Depois retornar apenas 1 aleatória de cada
      final results = await Future.wait([
        searchRecipes(type: 'main course', number: 10, cuisine: cuisine, diet: diet),
        searchRecipes(type: 'dessert', number: 10, cuisine: cuisine),
        searchRecipes(type: 'appetizer', number: 10, cuisine: cuisine, diet: diet),
        searchRecipes(type: 'side dish', number: 10, cuisine: cuisine, diet: diet),
      ]);

      // Pegar a primeira receita de cada lista JÁ randomizada
      final menu = {
        'mainCourse': results[0].isNotEmpty ? results[0][0] : _getFallbackRecipes('main course', dateType: dateType)[0],
        'dessert': results[1].isNotEmpty ? results[1][0] : _getFallbackRecipes('dessert', dateType: dateType)[0],
        'appetizer': results[2].isNotEmpty ? results[2][0] : _getFallbackRecipes('appetizer', dateType: dateType)[0],
        'sideDish': results[3].isNotEmpty ? results[3][0] : _getFallbackRecipes('side dish', dateType: dateType)[0],
      };

      // Log para debug
      print('✓ Menu gerado com receitas aleatórias:');
      print('  - Main Course: ${(menu['mainCourse'] as Recipe).title}');
      print('  - Dessert: ${(menu['dessert'] as Recipe).title}');
      print('  - Appetizer: ${(menu['appetizer'] as Recipe).title}');
      print('  - Side Dish: ${(menu['sideDish'] as Recipe).title}');

      return menu;
    } catch (e) {
      print('Erro ao gerar menu: $e');
      // Retornar menu fallback usando receitas estáticas apropriadas
      if (dateType != null) {
        final staticMenu = StaticRecipesData.getRandomMenuForDateType(dateType);
        print('✓ Usando menu estático para $dateType');
        return staticMenu;
      }
      
      // Fallback genérico
      return {
        'mainCourse': _getFallbackRecipes('main course', dateType: dateType)[0],
        'dessert': _getFallbackRecipes('dessert', dateType: dateType)[0],
        'appetizer': _getFallbackRecipes('appetizer', dateType: dateType)[0],
        'sideDish': _getFallbackRecipes('side dish', dateType: dateType)[0],
      };
    }
  }

  // Receitas de fallback (quando a API falha ou não está configurada)
  // Usa banco de dados estático com receitas reais por tipo de Date Night
  static List<Recipe> _getFallbackRecipes(String type, {String? dateType}) {
    final random = Random();
    
    // Se temos o tipo de Date Night, usar receitas específicas
    if (dateType != null) {
      switch (type.toLowerCase()) {
        case 'main course':
          final recipes = StaticRecipesData.getMainCoursesForDateType(dateType);
          // Retornar uma receita aleatória da lista
          final index = random.nextInt(recipes.length);
          return [recipes[index]];
        case 'dessert':
          final recipes = StaticRecipesData.getDessertsForDateType(dateType);
          final index = random.nextInt(recipes.length);
          return [recipes[index]];
        case 'appetizer':
          // Para petiscos, usar pratos principais como alternativa
          final recipes = StaticRecipesData.getMainCoursesForDateType(dateType);
          final index = random.nextInt(recipes.length);
          return [recipes[index]];
        case 'side dish':
          // Para acompanhamentos, usar pratos principais como alternativa
          final recipes = StaticRecipesData.getMainCoursesForDateType(dateType);
          final index = random.nextInt(recipes.length);
          return [recipes[index]];
        default:
          return [];
      }
    }
    
    // Fallback padrão se não tiver tipo de Date Night (usar Romance Clássico)
    return _getFallbackRecipes(type, dateType: 'Romance Clássico');
  }

  // Mapear tipo de encontro para tipo de cozinha
  static String? getDateTypeCuisine(String dateType) {
    switch (dateType) {
      case 'Romance Clássico':
        return 'italian,french';
      case 'Comédia Romântica':
        return 'american,mexican';
      case 'Drama Romântico':
        return 'french,mediterranean';
      case 'Musical Romântico':
        return 'latin american,spanish';
      case 'Romance Aventureiro':
        return 'thai,japanese';
      case 'Suspense Romântico':
        return 'italian,middle eastern';
      default:
        return null;
    }
  }
}
