import '../l10n/app_localizations.dart';

class DateNightCombo {
  final String movieTitle;
  final String movieYear;
  final String moviePosterPath;
  final String movieBackdropPath;
  final double movieRating;
  final String movieOverview;
  final int movieId;
  final List<String> movieGenres;
  final String movieRuntime;
  final String movieReleaseDate;
  final String movieOriginalLanguage;
  final List<String> movieProductionCompanies;
  final List<Map<String, dynamic>> movieWatchProviders;
  
  final String mainDish;
  final String drink;
  final String dessert;
  final List<String> snacks;
  final String atmosphere;
  final String preparationTime;
  final String difficulty;
  final List<String> ingredients;
  final String cookingTips;
  
  // Informações extras para o encontro
  final String theme;
  final List<String> playlistSuggestions;
  final String ambientLighting;
  final String estimatedCost;

  // IDs das receitas da API (opcionais)
  final int? mainCourseRecipeId;
  final int? dessertRecipeId;
  final int? appetizerRecipeId;
  final int? sideDishRecipeId;

  const DateNightCombo({
    required this.movieTitle,
    required this.movieYear,
    required this.moviePosterPath,
    this.movieBackdropPath = '',
    required this.movieRating,
    required this.movieOverview,
    required this.movieId,
    this.movieGenres = const [],
    this.movieRuntime = '',
    this.movieReleaseDate = '',
    this.movieOriginalLanguage = '',
    this.movieProductionCompanies = const [],
    this.movieWatchProviders = const [],
    required this.mainDish,
    required this.drink,
    required this.dessert,
    required this.snacks,
    required this.atmosphere,
    required this.preparationTime,
    required this.difficulty,
    required this.ingredients,
    required this.cookingTips,
    required this.theme,
    required this.playlistSuggestions,
    required this.ambientLighting,
    required this.estimatedCost,
    this.mainCourseRecipeId,
    this.dessertRecipeId,
    this.appetizerRecipeId,
    this.sideDishRecipeId,
  });

  // Método para converter um Movie em DateNightCombo
  factory DateNightCombo.fromMovie({
    required int movieId,
    required String title,
    required String year,
    required String posterPath,
    String backdropPath = '',
    required double rating,
    required String overview,
    List<String> genres = const [],
    String runtime = '',
    String releaseDate = '',
    String originalLanguage = '',
    List<String> productionCompanies = const [],
    List<Map<String, dynamic>> watchProviders = const [],
    required String mealType,
    AppLocalizations? localizations,
  }) {
    final mealData = DateNightService.getMealForMovieType(mealType, localizations);
    
    return DateNightCombo(
      movieId: movieId,
      movieTitle: title,
      movieYear: year,
      moviePosterPath: posterPath,
      movieBackdropPath: backdropPath,
      movieRating: rating,
      movieOverview: overview,
      movieGenres: genres,
      movieRuntime: runtime,
      movieReleaseDate: releaseDate,
      movieOriginalLanguage: originalLanguage,
      movieProductionCompanies: productionCompanies,
      movieWatchProviders: watchProviders,
      mainDish: mealData['mainDish']!,
      drink: mealData['drink']!,
      dessert: mealData['dessert']!,
      snacks: List<String>.from(mealData['snacks']!),
      atmosphere: mealData['atmosphere']!,
      preparationTime: mealData['preparationTime']!,
      difficulty: mealData['difficulty']!,
      ingredients: List<String>.from(mealData['ingredients']!),
      cookingTips: mealData['cookingTips']!,
      theme: mealData['theme']!,
      playlistSuggestions: List<String>.from(mealData['playlistSuggestions']!),
      ambientLighting: mealData['ambientLighting']!,
      estimatedCost: mealData['estimatedCost']!,
    );
  }
}

// Classe auxiliar para gerenciar os dados do Date Night
class DateNightService {
  static const Map<String, Map<String, dynamic>> _mealCombinations = {
    'romance_classic': {
      'mainDish': 'Risotto de camarão',
      'drink': 'Vinho rosé',
      'dessert': 'Morangos com chocolate',
      'snacks': ['Queijos especiais', 'Uvas', 'Nozes'],
      'atmosphere': 'Luzes baixas e velas aromáticas',
      'preparationTime': '45 minutos',
      'difficulty': 'Intermediário',
      'ingredients': [
        'Arroz arbóreo',
        'Camarões frescos',
        'Vinho branco',
        'Caldo de peixe',
        'Queijo parmesão',
        'Morangos',
        'Chocolate 70%'
      ],
      'cookingTips': 'Mexa o risotto constantemente para ficar cremoso',
      'theme': 'Romance Clássico',
      'playlistSuggestions': ['Jazz suave', 'Blues clássico', 'Ritmos soul'],
      'ambientLighting': 'Velas e luzes LED quentes',
      'estimatedCost': 'R\$ 80-120'
    },
    'romantic_comedy': {
      'mainDish': 'Pizza margherita caseira',
      'drink': 'Prosecco',
      'dessert': 'Brownie com sorvete',
      'snacks': ['Pipoca gourmet', 'Azeitonas', 'Pães de alho'],
      'atmosphere': 'Ambiente descontraído e divertido',
      'preparationTime': '30 minutos',
      'difficulty': 'Fácil',
      'ingredients': [
        'Massa de pizza pronta',
        'Molho de tomate',
        'Mussarela de búfala',
        'Manjericão fresco',
        'Mix para brownie',
        'Sorvete de baunilha'
      ],
      'cookingTips': 'Use ingredientes frescos para um sabor autêntico',
      'theme': 'Diversão Romântica',
      'playlistSuggestions': ['Pop romântico', 'Indie folk', 'Sucessos dos anos 80'],
      'ambientLighting': 'Luzes coloridas e ambiente alegre',
      'estimatedCost': 'R\$ 40-60'
    },
    'drama_romantic': {
      'mainDish': 'Salmão grelhado com aspargos',
      'drink': 'Vinho tinto suave',
      'dessert': 'Tiramisù',
      'snacks': ['Tábua de frios', 'Azeitonas especiais', 'Pães artesanais'],
      'atmosphere': 'Sofisticado e intimista',
      'preparationTime': '50 minutos',
      'difficulty': 'Intermediário',
      'ingredients': [
        'Filé de salmão',
        'Aspargos frescos',
        'Limão siciliano',
        'Azeite extra virgem',
        'Ingredientes para tiramisù',
        'Café expresso'
      ],
      'cookingTips': 'Não cozinhe demais o salmão para manter a textura',
      'theme': 'Elegância Romântica',
      'playlistSuggestions': ['Música clássica', 'Jazz contemporâneo', 'Instrumental'],
      'ambientLighting': 'Iluminação suave e ambiente requintado',
      'estimatedCost': 'R\$ 100-150'
    },
    'musical_romance': {
      'mainDish': 'Paella valenciana',
      'drink': 'Sangria',
      'dessert': 'Crème brûlée',
      'snacks': ['Tapas variadas', 'Azeitonas', 'Pimentões assados'],
      'atmosphere': 'Vibrante e musical',
      'preparationTime': '60 minutos',
      'difficulty': 'Avançado',
      'ingredients': [
        'Arroz bomba',
        'Frutos do mar',
        'Frango',
        'Açafrão',
        'Pimentões',
        'Vinho tinto',
        'Frutas para sangria'
      ],
      'cookingTips': 'Use panela paellera tradicional se possível',
      'theme': 'Paixão Espanhola',
      'playlistSuggestions': ['Música espanhola', 'Latin jazz', 'Trilhas de musicais'],
      'ambientLighting': 'Luzes quentes e atmosfera festiva',
      'estimatedCost': 'R\$ 90-130'
    },
    'adventure_romance': {
      'mainDish': 'Churrasco gourmet',
      'drink': 'Caipirinha de frutas vermelhas',
      'dessert': 'Pavlova de frutas',
      'snacks': ['Espetinhos de queijo', 'Chips de batata doce', 'Guacamole'],
      'atmosphere': 'Aventureiro e descontraído',
      'preparationTime': '40 minutos',
      'difficulty': 'Fácil',
      'ingredients': [
        'Carne nobre para churrasco',
        'Temperos especiais',
        'Cachaça',
        'Frutas vermelhas',
        'Merengue pronto',
        'Frutas da estação'
      ],
      'cookingTips': 'Deixe a carne marinando por algumas horas',
      'theme': 'Romance Aventureiro',
      'playlistSuggestions': ['Rock suave', 'Country romântico', 'Pop internacional'],
      'ambientLighting': 'Ambiente ao ar livre ou luzes naturais',
      'estimatedCost': 'R\$ 70-100'
    },
    'thriller_romance': {
      'mainDish': 'Risotto de cogumelos selvagens',
      'drink': 'Vinho tinto encorpado',
      'dessert': 'Torta de chocolate amargo',
      'snacks': ['Queijos maturados', 'Pães rústicos', 'Azeitonas pretas'],
      'atmosphere': 'Misterioso e intenso',
      'preparationTime': '55 minutos',
      'difficulty': 'Intermediário',
      'ingredients': [
        'Arroz arbóreo',
        'Cogumelos selvagens',
        'Vinho tinto',
        'Caldo de legumes',
        'Queijo parmesão',
        'Chocolate 85%',
        'Creme de leite'
      ],
      'cookingTips': 'Use cogumelos frescos para melhor sabor',
      'theme': 'Suspense Romântico',
      'playlistSuggestions': ['Jazz misterioso', 'Ambient sombrio', 'Clássico intenso'],
      'ambientLighting': 'Luzes baixas e atmosfera dramática',
      'estimatedCost': 'R\$ 85-125'
    }
  };

  static Map<String, dynamic> getMealForMovieType(String movieType, [AppLocalizations? localizations]) {
    if (localizations == null) {
      // Fallback to hardcoded Portuguese for backward compatibility
      return Map<String, dynamic>.from(_mealCombinations[movieType] ?? _mealCombinations['romance_classic']!);
    }
    
    // Localized version
    final baseData = Map<String, dynamic>.from(_mealCombinations[movieType] ?? _mealCombinations['romance_classic']!);
    
    // Apply localizations to all fields
    final localizedData = Map<String, dynamic>.from(baseData);
    
    // Localize main dish
    switch (baseData['mainDish']) {
      case 'Risotto de camarão':
        localizedData['mainDish'] = localizations.shrimpRisotto;
        break;
      case 'Pizza margherita caseira':
        localizedData['mainDish'] = localizations.homemadeMargheritaPizza;
        break;
      case 'Salmão grelhado com aspargos':
        localizedData['mainDish'] = localizations.grilledSalmonWithAsparagus;
        break;
      case 'Paella valenciana':
        localizedData['mainDish'] = localizations.valencianPaella;
        break;
      case 'Churrasco gourmet':
        localizedData['mainDish'] = localizations.gourmetBarbecue;
        break;
      case 'Risotto de cogumelos selvagens':
        localizedData['mainDish'] = localizations.wildMushroomRisotto;
        break;
    }
    
    // Localize drink
    switch (baseData['drink']) {
      case 'Vinho rosé':
        localizedData['drink'] = localizations.roseWine;
        break;
      case 'Prosecco':
        localizedData['drink'] = localizations.prosecco;
        break;
      case 'Vinho tinto suave':
        localizedData['drink'] = localizations.softRedWine;
        break;
      case 'Sangria':
        localizedData['drink'] = localizations.sangria;
        break;
      case 'Caipirinha de frutas vermelhas':
        localizedData['drink'] = localizations.redBerryCaipirinha;
        break;
      case 'Vinho tinto encorpado':
        localizedData['drink'] = localizations.fullBodiedRedWine;
        break;
    }
    
    // Localize dessert
    switch (baseData['dessert']) {
      case 'Morangos com chocolate':
        localizedData['dessert'] = localizations.strawberriesWithChocolate;
        break;
      case 'Brownie com sorvete':
        localizedData['dessert'] = localizations.brownieWithIceCream;
        break;
      case 'Tiramisù':
        localizedData['dessert'] = localizations.tiramisu;
        break;
      case 'Crème brûlée':
        localizedData['dessert'] = localizations.cremeBrulee;
        break;
      case 'Pavlova de frutas':
        localizedData['dessert'] = localizations.fruitPavlova;
        break;
      case 'Torta de chocolate amargo':
        localizedData['dessert'] = localizations.darkChocolateCake;
        break;
    }
    
    // Localize snacks
    localizedData['snacks'] = (baseData['snacks'] as List<String>).map((snack) {
      switch (snack) {
        case 'Queijos especiais':
          return localizations.specialCheeses;
        case 'Uvas':
          return localizations.grapes;
        case 'Nozes':
          return localizations.nuts;
        case 'Pipoca gourmet':
          return localizations.gourmetPopcorn;
        case 'Azeitonas':
          return localizations.olives;
        case 'Pães de alho':
          return localizations.garlicBread;
        case 'Tábua de frios':
          return localizations.cheeseBoard;
        case 'Pães artesanais':
          return localizations.artisanBreads;
        case 'Tapas variadas':
          return localizations.varietyTapas;
        case 'Pimentões assados':
          return localizations.roastedPeppers;
        case 'Espetinhos de queijo':
          return localizations.cheeseSkewers;
        case 'Chips de batata doce':
          return localizations.sweetPotatoChips;
        case 'Guacamole':
          return localizations.guacamole;
        case 'Queijos maturados':
          return localizations.agedCheeses;
        case 'Pães rústicos':
          return localizations.rusticBreads;
        case 'Azeitonas pretas':
          return localizations.blackOlives;
        default:
          return snack;
      }
    }).toList();
    
    // Localize atmosphere
    switch (baseData['atmosphere']) {
      case 'Luzes baixas e velas aromáticas':
        localizedData['atmosphere'] = localizations.lowLightsAromaticCandles;
        break;
      case 'Ambiente descontraído e divertido':
        localizedData['atmosphere'] = localizations.relaxedFunAtmosphere;
        break;
      case 'Sofisticado e intimista':
        localizedData['atmosphere'] = localizations.sophisticatedIntimate;
        break;
      case 'Vibrante e musical':
        localizedData['atmosphere'] = localizations.vibrantMusical;
        break;
      case 'Aventureiro e descontraído':
        localizedData['atmosphere'] = localizations.adventurousRelaxed;
        break;
      case 'Misterioso e intenso':
        localizedData['atmosphere'] = localizations.mysteriousIntense;
        break;
    }
    
    // Localize preparation time
    switch (baseData['preparationTime']) {
      case '45 minutos':
        localizedData['preparationTime'] = localizations.fortyFiveMinutes;
        break;
      case '30 minutos':
        localizedData['preparationTime'] = localizations.thirtyMinutes;
        break;
      case '50 minutos':
        localizedData['preparationTime'] = localizations.fiftyMinutes;
        break;
      case '60 minutos':
        localizedData['preparationTime'] = localizations.sixtyMinutes;
        break;
      case '40 minutos':
        localizedData['preparationTime'] = localizations.fortyMinutes;
        break;
      case '55 minutos':
        localizedData['preparationTime'] = localizations.fiftyFiveMinutes;
        break;
    }
    
    // Localize difficulty
    switch (baseData['difficulty']) {
      case 'Intermediário':
        localizedData['difficulty'] = localizations.intermediate;
        break;
      case 'Fácil':
        localizedData['difficulty'] = localizations.easy;
        break;
      case 'Avançado':
        localizedData['difficulty'] = localizations.advanced;
        break;
    }
    
    // Localize ingredients
    localizedData['ingredients'] = (baseData['ingredients'] as List<String>).map((ingredient) {
      switch (ingredient) {
        case 'Arroz arbóreo':
          return localizations.arborioRice;
        case 'Camarões frescos':
          return localizations.freshShrimp;
        case 'Vinho branco':
          return localizations.whiteWine;
        case 'Caldo de peixe':
          return localizations.fishBroth;
        case 'Queijo parmesão':
          return localizations.parmesanCheese;
        case 'Morangos':
          return localizations.strawberries;
        case 'Chocolate 70%':
          return localizations.seventyPercentChocolate;
        case 'Massa de pizza pronta':
          return localizations.pizzaDough;
        case 'Molho de tomate':
          return localizations.tomatoSauce;
        case 'Mussarela de búfala':
          return localizations.buffaloMozzarella;
        case 'Manjericão fresco':
          return localizations.freshBasil;
        case 'Mix para brownie':
          return localizations.brownieMix;
        case 'Sorvete de baunilha':
          return localizations.vanillaIceCream;
        case 'Filé de salmão':
          return localizations.salmonFillet;
        case 'Aspargos frescos':
          return localizations.freshAsparagus;
        case 'Limão siciliano':
          return localizations.sicilianLemon;
        case 'Azeite extra virgem':
          return localizations.extraVirginOliveOil;
        case 'Ingredientes para tiramisù':
          return localizations.tiramisuIngredients;
        case 'Café expresso':
          return localizations.espressoCoffee;
        case 'Arroz bomba':
          return localizations.bombaRice;
        case 'Frutos do mar':
          return localizations.seafood;
        case 'Frango':
          return localizations.chicken;
        case 'Açafrão':
          return localizations.saffron;
        case 'Pimentões':
          return localizations.peppers;
        case 'Vinho tinto':
          return localizations.redWine;
        case 'Frutas para sangria':
          return localizations.fruitsForSangria;
        case 'Carne nobre para churrasco':
          return localizations.nobleMeatForBarbecue;
        case 'Temperos especiais':
          return localizations.specialSeasonings;
        case 'Cachaça':
          return localizations.cachaca;
        case 'Frutas vermelhas':
          return localizations.redBerries;
        case 'Merengue pronto':
          return localizations.readyMeringue;
        case 'Frutas da estação':
          return localizations.seasonalFruits;
        case 'Cogumelos selvagens':
          return localizations.wildMushrooms;
        case 'Caldo de legumes':
          return localizations.vegetableBroth;
        case 'Chocolate 85%':
          return localizations.eightyFivePercentChocolate;
        case 'Creme de leite':
          return localizations.heavyCream;
        default:
          return ingredient;
      }
    }).toList();
    
    // Localize cooking tips
    switch (baseData['cookingTips']) {
      case 'Mexa o risotto constantemente para ficar cremoso':
        localizedData['cookingTips'] = localizations.stirRisottoConstantly;
        break;
      case 'Use ingredientes frescos para um sabor autêntico':
        localizedData['cookingTips'] = localizations.useFreshIngredients;
        break;
      case 'Não cozinhe demais o salmão para manter a textura':
        localizedData['cookingTips'] = localizations.dontOvercookSalmon;
        break;
      case 'Use panela paellera tradicional se possível':
        localizedData['cookingTips'] = localizations.useTraditionalPaellaPan;
        break;
      case 'Deixe a carne marinando por algumas horas':
        localizedData['cookingTips'] = localizations.marinateMeatForHours;
        break;
      case 'Use cogumelos frescos para melhor sabor':
        localizedData['cookingTips'] = localizations.useFreshMushrooms;
        break;
    }
    
    // Localize theme
    switch (baseData['theme']) {
      case 'Romance Clássico':
        localizedData['theme'] = localizations.classicRomanceTheme;
        break;
      case 'Diversão Romântica':
        localizedData['theme'] = localizations.romanticFunTheme;
        break;
      case 'Elegância Romântica':
        localizedData['theme'] = localizations.elegantRomanceTheme;
        break;
      case 'Paixão Espanhola':
        localizedData['theme'] = localizations.spanishPassionTheme;
        break;
      case 'Romance Aventureiro':
        localizedData['theme'] = localizations.adventureRomanceTheme;
        break;
      case 'Suspense Romântico':
        localizedData['theme'] = localizations.thrillerRomanceTheme;
        break;
    }
    
    // Localize ambient lighting
    switch (baseData['ambientLighting']) {
      case 'Velas e luzes LED quentes':
        localizedData['ambientLighting'] = localizations.candlesWarmLED;
        break;
      case 'Luzes coloridas e ambiente alegre':
        localizedData['ambientLighting'] = localizations.colorfulLightsCheerful;
        break;
      case 'Iluminação suave e ambiente requintado':
        localizedData['ambientLighting'] = localizations.softLightingElegant;
        break;
      case 'Luzes quentes e atmosfera festiva':
        localizedData['ambientLighting'] = localizations.warmLightsFestive;
        break;
      case 'Ambiente ao ar livre ou luzes naturais':
        localizedData['ambientLighting'] = localizations.outdoorNaturalLight;
        break;
      case 'Luzes baixas e atmosfera dramática':
        localizedData['ambientLighting'] = localizations.lowLightsDramatic;
        break;
    }
    
    // Localize estimated cost
    switch (baseData['estimatedCost']) {
      case 'R\$ 80-120':
        localizedData['estimatedCost'] = localizations.cost80120;
        break;
      case 'R\$ 40-60':
        localizedData['estimatedCost'] = localizations.cost4060;
        break;
      case 'R\$ 100-150':
        localizedData['estimatedCost'] = localizations.cost100150;
        break;
      case 'R\$ 90-130':
        localizedData['estimatedCost'] = localizations.cost90130;
        break;
      case 'R\$ 70-100':
        localizedData['estimatedCost'] = localizations.cost70100;
        break;
      case 'R\$ 85-125':
        localizedData['estimatedCost'] = localizations.cost85125;
        break;
    }
    
    // Apply localizations to playlist suggestions (already implemented)
    final playlistSuggestions = localizedData['playlistSuggestions'] as List<String>;
    localizedData['playlistSuggestions'] = playlistSuggestions.map((suggestion) {
      switch (suggestion) {
        case 'Jazz suave':
          return localizations.jazzSmooth;
        case 'Blues clássico':
          return localizations.bluesClassic;
        case 'Ritmos soul':
          return localizations.soulfulRhythms;
        case 'Pop romântico':
          return localizations.romanticPop;
        case 'Indie folk':
          return localizations.indieFolk;
        case 'Sucessos dos anos 80':
          return localizations.eightiesHits;
        case 'Música clássica':
          return localizations.classicalMusic;
        case 'Jazz contemporâneo':
          return localizations.contemporaryJazz;
        case 'Instrumental':
          return localizations.instrumental;
        case 'Música espanhola':
          return localizations.spanishMusic;
        case 'Latin jazz':
          return localizations.latinJazz;
        case 'Trilhas de musicais':
          return localizations.musicalSoundtracks;
        case 'Rock suave':
          return localizations.softRock;
        case 'Country romântico':
          return localizations.romanticCountry;
        case 'Pop internacional':
          return localizations.internationalPop;
        case 'Jazz misterioso':
          return localizations.mysteryJazz;
        case 'Ambient sombrio':
          return localizations.darkAmbient;
        case 'Clássico intenso':
          return localizations.intenseClassical;
        default:
          return suggestion;
      }
    }).toList();
    
    return localizedData;
  }

  static List<String> getAvailableDateTypes(AppLocalizations? localizations) {
    if (localizations == null) {
      return [
        'Romance Clássico',
        'Comédia Romântica', 
        'Drama Romântico',
        'Musical Romântico',
        'Romance Aventureiro',
        'Suspense Romântico'
      ];
    }
    
    return [
      localizations.classicRomance,
      localizations.romanticComedy,
      localizations.romanticDrama,
      localizations.musicalRomance,
      localizations.adventureRomance,
      localizations.thrillerRomance,
    ];
  }

  static String getMovieTypeKey(String dateType, AppLocalizations? localizations) {
    // First try to match with localized strings
    if (localizations != null) {
      if (dateType == localizations.classicRomance) return 'romance_classic';
      if (dateType == localizations.romanticComedy) return 'romantic_comedy';
      if (dateType == localizations.romanticDrama) return 'drama_romantic';
      if (dateType == localizations.musicalRomance) return 'musical_romance';
      if (dateType == localizations.adventureRomance) return 'adventure_romance';
      if (dateType == localizations.thrillerRomance) return 'thriller_romance';
    }
    
    // Fallback to Portuguese hardcoded strings for backward compatibility
    switch (dateType) {
      case 'Romance Clássico':
        return 'romance_classic';
      case 'Comédia Romântica':
        return 'romantic_comedy';
      case 'Drama Romântico':
        return 'drama_romantic';
      case 'Musical Romântico':
        return 'musical_romance';
      case 'Romance Aventureiro':
        return 'adventure_romance';
      case 'Suspense Romântico':
        return 'thriller_romance';
      default:
        return 'romance_classic';
    }
  }
}