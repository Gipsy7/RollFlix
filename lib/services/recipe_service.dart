import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

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
        return results.map((recipe) => Recipe.fromJson(recipe)).toList();
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
        return Recipe.fromJson(data);
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
  }) async {
    try {
      // Buscar em paralelo
      final results = await Future.wait([
        searchRecipes(type: 'main course', number: 1, cuisine: cuisine, diet: diet),
        searchRecipes(type: 'dessert', number: 1, cuisine: cuisine),
        searchRecipes(type: 'appetizer', number: 1, cuisine: cuisine, diet: diet),
        searchRecipes(type: 'side dish', number: 1, cuisine: cuisine, diet: diet),
      ]);

      return {
        'mainCourse': results[0].isNotEmpty ? results[0][0] : _getFallbackRecipes('main course')[0],
        'dessert': results[1].isNotEmpty ? results[1][0] : _getFallbackRecipes('dessert')[0],
        'appetizer': results[2].isNotEmpty ? results[2][0] : _getFallbackRecipes('appetizer')[0],
        'sideDish': results[3].isNotEmpty ? results[3][0] : _getFallbackRecipes('side dish')[0],
      };
    } catch (e) {
      print('Erro ao gerar menu: $e');
      // Retornar menu fallback
      return {
        'mainCourse': _getFallbackRecipes('main course')[0],
        'dessert': _getFallbackRecipes('dessert')[0],
        'appetizer': _getFallbackRecipes('appetizer')[0],
        'sideDish': _getFallbackRecipes('side dish')[0],
      };
    }
  }

  // Receitas de fallback (quando a API falha ou não está configurada)
  static List<Recipe> _getFallbackRecipes(String type) {
    switch (type.toLowerCase()) {
      case 'main course':
        return [
          Recipe(
            id: 1,
            title: 'Filé Mignon ao Molho Madeira',
            image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500',
            readyInMinutes: 45,
            servings: 2,
            sourceUrl: '',
            summary: 'Filé mignon suculento com delicioso molho madeira.',
            pricePerServing: 2500.0,
            vegetarian: false,
            glutenFree: true,
          ),
        ];
      case 'dessert':
        return [
          Recipe(
            id: 2,
            title: 'Mousse de Chocolate Belga',
            image: 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=500',
            readyInMinutes: 20,
            servings: 2,
            sourceUrl: '',
            summary: 'Mousse cremoso de chocolate belga.',
            pricePerServing: 800.0,
            vegetarian: true,
          ),
        ];
      case 'appetizer':
        return [
          Recipe(
            id: 3,
            title: 'Bruschetta Caprese',
            image: 'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=500',
            readyInMinutes: 15,
            servings: 2,
            sourceUrl: '',
            summary: 'Bruschetta italiana com tomate, manjericão e mozzarella.',
            pricePerServing: 600.0,
            vegetarian: true,
          ),
        ];
      case 'side dish':
        return [
          Recipe(
            id: 4,
            title: 'Batatas ao Alecrim',
            image: 'https://images.unsplash.com/photo-1518013431117-eb1465fa5752?w=500',
            readyInMinutes: 30,
            servings: 2,
            sourceUrl: '',
            summary: 'Batatas assadas crocantes com alecrim fresco.',
            pricePerServing: 400.0,
            vegetarian: true,
            vegan: true,
          ),
        ];
      default:
        return [];
    }
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
