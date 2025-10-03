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
  }) {
    final mealData = DateNightService.getMealForMovieType(mealType);
    
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
      'playlistSuggestions': ['Jazz suave', 'Bossa nova', 'Clássicos românticos'],
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
    }
  };

  static Map<String, dynamic> getMealForMovieType(String movieType) {
    return _mealCombinations[movieType] ?? _mealCombinations['romance_classic']!;
  }

  static List<String> getAvailableDateTypes() {
    return [
      'Romance Clássico',
      'Comédia Romântica', 
      'Drama Romântico',
      'Musical Romântico',
      'Romance Aventureiro'
    ];
  }

  static String getMovieTypeKey(String dateType) {
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
      default:
        return 'romance_classic';
    }
  }
}