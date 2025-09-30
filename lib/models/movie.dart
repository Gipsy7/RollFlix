class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<int> genreIds;
  final int runtime;
  final String originalLanguage;
  final String originalTitle;
  final bool adult;
  final double popularity;
  final bool video;
  final List<String> productionCompanies;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    this.runtime = 0,
    this.originalLanguage = '',
    this.originalTitle = '',
    this.adult = false,
    this.popularity = 0.0,
    this.video = false,
    this.productionCompanies = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Título não disponível',
      overview: json['overview'] ?? 'Descrição não disponível',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      runtime: json['runtime'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      adult: json['adult'] ?? false,
      popularity: (json['popularity'] ?? 0).toDouble(),
      video: json['video'] ?? false,
      productionCompanies: json['production_companies'] != null
          ? (json['production_companies'] as List)
              .map((company) => company['name']?.toString() ?? '')
              .where((name) => name.isNotEmpty)
              .toList()
          : [],
    );
  }

  String get fullPosterUrl {
    return posterPath.isNotEmpty 
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : '';
  }

  String get fullBackdropUrl {
    return backdropPath.isNotEmpty 
        ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
        : '';
  }

  String get year {
    if (releaseDate.isNotEmpty) {
      return releaseDate.split('-')[0];
    }
    return '';
  }

  String get formattedRuntime {
    if (runtime > 0) {
      final hours = runtime ~/ 60;
      final minutes = runtime % 60;
      if (hours > 0) {
        return '${hours}h ${minutes}min';
      } else {
        return '${minutes}min';
      }
    }
    return 'Duração não disponível';
  }

  String get formattedReleaseDate {
    if (releaseDate.isEmpty) return 'Data não disponível';
    try {
      final date = DateTime.parse(releaseDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Data inválida';
    }
  }

  bool get hasValidPoster => posterPath.isNotEmpty;
  bool get hasValidBackdrop => backdropPath.isNotEmpty;
  bool get hasValidRating => voteAverage > 0;
  bool get hasValidOverview => overview.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, year: $year, rating: $voteAverage)';
  }
}

class MoviesResponse {
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  MoviesResponse({
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) {
    return MoviesResponse(
      results: (json['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}