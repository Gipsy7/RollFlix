class TVShow {
  final int id;
  final String name;
  final String firstAirDate;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final double popularity;
  final bool adult;
  final List<int> genreIds;
  
  // Campos específicos de séries
  final List<int> episodeRunTime;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final bool inProduction;

  const TVShow({
    required this.id,
    required this.name,
    required this.firstAirDate,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.popularity,
    required this.adult,
    required this.genreIds,
    this.episodeRunTime = const [],
    this.numberOfEpisodes = 0,
    this.numberOfSeasons = 0,
    this.inProduction = false,
  });

  // Getters para compatibilidade com Movie
  String get title => name;
  String get releaseDate => firstAirDate;
  String get year => firstAirDate.isNotEmpty 
      ? firstAirDate.split('-').first 
      : '';

  String get fullPosterUrl => posterPath.isNotEmpty 
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : '';

  String get fullBackdropUrl => backdropPath.isNotEmpty 
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : '';

  factory TVShow.fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Título não disponível',
      firstAirDate: json['first_air_date'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      adult: json['adult'] ?? false,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      episodeRunTime: List<int>.from(json['episode_run_time'] ?? []),
      numberOfEpisodes: json['number_of_episodes'] ?? 0,
      numberOfSeasons: json['number_of_seasons'] ?? 0,
      inProduction: json['in_production'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_air_date': firstAirDate,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'origin_country': originCountry,
      'original_language': originalLanguage,
      'original_name': originalName,
      'popularity': popularity,
      'adult': adult,
      'genre_ids': genreIds,
      'episode_run_time': episodeRunTime,
      'number_of_episodes': numberOfEpisodes,
      'number_of_seasons': numberOfSeasons,
      'in_production': inProduction,
    };
  }
}

class TVShowsResponse {
  final int page;
  final List<TVShow> results;
  final int totalPages;
  final int totalResults;

  const TVShowsResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TVShowsResponse.fromJson(Map<String, dynamic> json) {
    return TVShowsResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List<dynamic>? ?? [])
          .map((item) => TVShow.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
    );
  }
}