class Recipe {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final String sourceUrl;
  
  // Detalhes completos (carregados sob demanda)
  final String? summary;
  final List<Ingredient>? extendedIngredients;
  final List<RecipeStep>? analyzedInstructions;
  final NutritionInfo? nutrition;
  final bool? vegetarian;
  final bool? vegan;
  final bool? glutenFree;
  final bool? dairyFree;
  final double? pricePerServing;
  final List<String>? dishTypes;
  final List<String>? cuisines;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
    this.summary,
    this.extendedIngredients,
    this.analyzedInstructions,
    this.nutrition,
    this.vegetarian,
    this.vegan,
    this.glutenFree,
    this.dairyFree,
    this.pricePerServing,
    this.dishTypes,
    this.cuisines,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 30,
      servings: json['servings'] ?? 2,
      sourceUrl: json['sourceUrl'] ?? '',
      summary: json['summary'],
      extendedIngredients: json['extendedIngredients'] != null
          ? (json['extendedIngredients'] as List)
              .map((i) => Ingredient.fromJson(i))
              .toList()
          : null,
      analyzedInstructions: json['analyzedInstructions'] != null &&
              (json['analyzedInstructions'] as List).isNotEmpty
          ? (json['analyzedInstructions'][0]['steps'] as List)
              .map((s) => RecipeStep.fromJson(s))
              .toList()
          : null,
      nutrition: json['nutrition'] != null
          ? NutritionInfo.fromJson(json['nutrition'])
          : null,
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      glutenFree: json['glutenFree'],
      dairyFree: json['dairyFree'],
      pricePerServing: json['pricePerServing']?.toDouble(),
      dishTypes: json['dishTypes'] != null
          ? List<String>.from(json['dishTypes'])
          : null,
      cuisines:
          json['cuisines'] != null ? List<String>.from(json['cuisines']) : null,
    );
  }

  String get formattedPrice {
    if (pricePerServing == null) return 'R\$ -';
    final priceInReais = (pricePerServing! / 100) * 5; // Conversão aproximada
    return 'R\$ ${priceInReais.toStringAsFixed(2)} por porção';
  }

  String get formattedTime {
    if (readyInMinutes < 60) {
      return '$readyInMinutes minutos';
    }
    final hours = readyInMinutes ~/ 60;
    final minutes = readyInMinutes % 60;
    return minutes > 0 ? '${hours}h ${minutes}min' : '${hours}h';
  }

  List<String> get dietaryTags {
    final tags = <String>[];
    if (vegetarian == true) tags.add('Vegetariano');
    if (vegan == true) tags.add('Vegano');
    if (glutenFree == true) tags.add('Sem Glúten');
    if (dairyFree == true) tags.add('Sem Lactose');
    return tags;
  }
}

class Ingredient {
  final int id;
  final String name;
  final String original;
  final double amount;
  final String unit;
  final String? image;

  Ingredient({
    required this.id,
    required this.name,
    required this.original,
    required this.amount,
    required this.unit,
    this.image,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['nameClean'] ?? '',
      original: json['original'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      image: json['image'],
    );
  }

  String get imageUrl =>
      image != null ? 'https://spoonacular.com/cdn/ingredients_100x100/$image' : '';
}

class RecipeStep {
  final int number;
  final String step;
  final List<Ingredient> ingredients;
  final List<Equipment> equipment;

  RecipeStep({
    required this.number,
    required this.step,
    required this.ingredients,
    required this.equipment,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      number: json['number'] ?? 0,
      step: json['step'] ?? '',
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((i) => Ingredient.fromJson(i))
              .toList()
          : [],
      equipment: json['equipment'] != null
          ? (json['equipment'] as List).map((e) => Equipment.fromJson(e)).toList()
          : [],
    );
  }
}

class Equipment {
  final int id;
  final String name;
  final String? image;

  Equipment({
    required this.id,
    required this.name,
    this.image,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
    );
  }
}

class NutritionInfo {
  final List<Nutrient> nutrients;
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbs;

  NutritionInfo({
    required this.nutrients,
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    final nutrients = json['nutrients'] != null
        ? (json['nutrients'] as List).map((n) => Nutrient.fromJson(n)).toList()
        : <Nutrient>[];

    double? findNutrient(String name) {
      try {
        return nutrients
            .firstWhere((n) => n.name.toLowerCase() == name.toLowerCase())
            .amount;
      } catch (e) {
        return null;
      }
    }

    return NutritionInfo(
      nutrients: nutrients,
      calories: findNutrient('Calories'),
      protein: findNutrient('Protein'),
      fat: findNutrient('Fat'),
      carbs: findNutrient('Carbohydrates'),
    );
  }
}

class Nutrient {
  final String name;
  final double amount;
  final String unit;

  Nutrient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }

  String get formatted => '${amount.toStringAsFixed(1)}$unit';
}
