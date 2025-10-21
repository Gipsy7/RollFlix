import 'date_night_combo.dart';

class DateNightPreferences {
  final DietaryRestriction dietaryRestriction;
  final BudgetRange budgetRange;
  final PreparationTime preparationTime;
  final CookingSkillLevel skillLevel;
  final List<String> dislikedIngredients;
  final bool includeAlcohol;

  const DateNightPreferences({
    this.dietaryRestriction = DietaryRestriction.none,
    this.budgetRange = BudgetRange.medium,
    this.preparationTime = PreparationTime.medium,
    this.skillLevel = CookingSkillLevel.intermediate,
    this.dislikedIngredients = const [],
    this.includeAlcohol = true,
  });

  DateNightPreferences copyWith({
    DietaryRestriction? dietaryRestriction,
    BudgetRange? budgetRange,
    PreparationTime? preparationTime,
    CookingSkillLevel? skillLevel,
    List<String>? dislikedIngredients,
    bool? includeAlcohol,
  }) {
    return DateNightPreferences(
      dietaryRestriction: dietaryRestriction ?? this.dietaryRestriction,
      budgetRange: budgetRange ?? this.budgetRange,
      preparationTime: preparationTime ?? this.preparationTime,
      skillLevel: skillLevel ?? this.skillLevel,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      includeAlcohol: includeAlcohol ?? this.includeAlcohol,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dietaryRestriction': dietaryRestriction.toString(),
      'budgetRange': budgetRange.toString(),
      'preparationTime': preparationTime.toString(),
      'skillLevel': skillLevel.toString(),
      'dislikedIngredients': dislikedIngredients,
      'includeAlcohol': includeAlcohol,
    };
  }

  factory DateNightPreferences.fromJson(Map<String, dynamic> json) {
    return DateNightPreferences(
      dietaryRestriction: DietaryRestriction.values.firstWhere(
        (e) => e.toString() == json['dietaryRestriction'],
        orElse: () => DietaryRestriction.none,
      ),
      budgetRange: BudgetRange.values.firstWhere(
        (e) => e.toString() == json['budgetRange'],
        orElse: () => BudgetRange.medium,
      ),
      preparationTime: PreparationTime.values.firstWhere(
        (e) => e.toString() == json['preparationTime'],
        orElse: () => PreparationTime.medium,
      ),
      skillLevel: CookingSkillLevel.values.firstWhere(
        (e) => e.toString() == json['skillLevel'],
        orElse: () => CookingSkillLevel.intermediate,
      ),
      dislikedIngredients: List<String>.from(json['dislikedIngredients'] ?? []),
      includeAlcohol: json['includeAlcohol'] ?? true,
    );
  }
}

enum DietaryRestriction {
  none('Sem Restrições', '🍽️'),
  vegetarian('Vegetariano', '🥗'),
  vegan('Vegano', '🌱'),
  glutenFree('Sem Glúten', '🌾'),
  lactoseFree('Sem Lactose', '🥛'),
  lowCarb('Low Carb', '🥩'),
  keto('Keto', '🥑'),
  pescatarian('Pescetariano', '🐟');

  final String label;
  final String emoji;
  
  const DietaryRestriction(this.label, this.emoji);
}

enum BudgetRange {
  low('Econômico', 'R\$ 30-60', '💰'),
  medium('Moderado', 'R\$ 60-120', '💰💰'),
  high('Premium', 'R\$ 120-200', '💰💰💰'),
  luxury('Luxo', 'R\$ 200+', '💎');

  final String label;
  final String range;
  final String icon;
  
  const BudgetRange(this.label, this.range, this.icon);
}

enum PreparationTime {
  quick('Rápido', '15-30 min', '⚡'),
  medium('Médio', '30-60 min', '⏱️'),
  long('Elaborado', '60-90 min', '⏰'),
  extended('Gourmet', '90+ min', '👨‍🍳');

  final String label;
  final String duration;
  final String icon;
  
  const PreparationTime(this.label, this.duration, this.icon);
}

enum CookingSkillLevel {
  beginner('Iniciante', 'Receitas simples e diretas', '⭐'),
  intermediate('Intermediário', 'Alguma experiência necessária', '⭐⭐'),
  advanced('Avançado', 'Técnicas mais complexas', '⭐⭐⭐'),
  expert('Expert', 'Alta gastronomia', '⭐⭐⭐⭐');

  final String label;
  final String description;
  final String stars;
  
  const CookingSkillLevel(this.label, this.description, this.stars);
}

class DateNightSchedule {
  final String time;
  final String activity;
  final String icon;
  final int durationMinutes;
  final String tips;

  const DateNightSchedule({
    required this.time,
    required this.activity,
    required this.icon,
    required this.durationMinutes,
    required this.tips,
  });
}

class ConversationStarter {
  final String category;
  final List<String> questions;
  final String icon;

  ConversationStarter({
    required this.category,
    required this.questions,
    required this.icon,
  });
}

class DateNightGame {
  final String name;
  final String description;
  final List<String> rules;
  final String difficulty;
  final int players;
  final int durationMinutes;

  DateNightGame({
    required this.name,
    required this.description,
    required this.rules,
    required this.difficulty,
    required this.players,
    required this.durationMinutes,
  });
}

class SavedDateNight {
  final String id;
  final DateNightCombo combo;
  final DateTime savedAt;
  final DateTime? executedAt;
  final int? rating;
  final String? notes;
  final List<String> photos;

  const SavedDateNight({
    required this.id,
    required this.combo,
    required this.savedAt,
    this.executedAt,
    this.rating,
    this.notes,
    this.photos = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'savedAt': savedAt.toIso8601String(),
      'executedAt': executedAt?.toIso8601String(),
      'rating': rating,
      'notes': notes,
      'photos': photos,
    };
  }

  factory SavedDateNight.fromJson(Map<String, dynamic> json, DateNightCombo combo) {
    return SavedDateNight(
      id: json['id'],
      combo: combo,
      savedAt: DateTime.parse(json['savedAt']),
      executedAt: json['executedAt'] != null 
          ? DateTime.parse(json['executedAt']) 
          : null,
      rating: json['rating'],
      notes: json['notes'],
      photos: List<String>.from(json['photos'] ?? []),
    );
  }
}
