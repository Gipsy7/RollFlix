class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Título não disponível',
      overview: json['overview'] ?? 'Descrição não disponível',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }

  String get fullPosterUrl {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return '';
  }

  String get year {
    if (releaseDate.isNotEmpty) {
      return releaseDate.split('-')[0];
    }
    return '';
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