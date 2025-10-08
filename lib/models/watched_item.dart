import 'movie.dart';
import 'tv_show.dart';

/// Modelo unificado para itens assistidos (filmes e séries)
class WatchedItem {
  final String id;
  final String title;
  final String? posterPath;
  final String? overview;
  final double voteAverage;
  final String releaseDate;
  final bool isTVShow;
  final DateTime watchedAt;
  
  // Campos específicos de filme
  final String? originalTitle;
  final int? runtime;
  
  // Campos específicos de série
  final String? originalName;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;

  WatchedItem({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.isTVShow,
    required this.watchedAt,
    this.originalTitle,
    this.runtime,
    this.originalName,
    this.numberOfSeasons,
    this.numberOfEpisodes,
  });

  /// Cria um WatchedItem a partir de um Movie
  factory WatchedItem.fromMovie(Movie movie) {
    return WatchedItem(
      id: movie.id.toString(),
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      isTVShow: false,
      watchedAt: DateTime.now(),
      originalTitle: movie.originalTitle,
      runtime: movie.runtime,
    );
  }

  /// Cria um WatchedItem a partir de uma TVShow
  factory WatchedItem.fromTVShow(TVShow show) {
    return WatchedItem(
      id: show.id.toString(),
      title: show.name,
      posterPath: show.posterPath,
      overview: show.overview,
      voteAverage: show.voteAverage,
      releaseDate: show.firstAirDate,
      isTVShow: true,
      watchedAt: DateTime.now(),
      originalName: show.originalName,
      numberOfSeasons: show.numberOfSeasons,
      numberOfEpisodes: show.numberOfEpisodes,
    );
  }

  /// Converte para JSON para persistência
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
      'isTVShow': isTVShow,
      'watchedAt': watchedAt.toIso8601String(),
      'originalTitle': originalTitle,
      'runtime': runtime,
      'originalName': originalName,
      'numberOfSeasons': numberOfSeasons,
      'numberOfEpisodes': numberOfEpisodes,
    };
  }

  /// Cria a partir de JSON
  factory WatchedItem.fromJson(Map<String, dynamic> json) {
    return WatchedItem(
      id: json['id'] as String,
      title: json['title'] as String,
      posterPath: json['posterPath'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['voteAverage'] as num).toDouble(),
      releaseDate: json['releaseDate'] as String,
      isTVShow: json['isTVShow'] as bool,
      watchedAt: DateTime.parse(json['watchedAt'] as String),
      originalTitle: json['originalTitle'] as String?,
      runtime: json['runtime'] as int?,
      originalName: json['originalName'] as String?,
      numberOfSeasons: json['numberOfSeasons'] as int?,
      numberOfEpisodes: json['numberOfEpisodes'] as int?,
    );
  }

  /// Converte para Movie (se for filme)
  Movie toMovie() {
    return Movie(
      id: int.parse(id),
      title: title,
      posterPath: posterPath ?? '',
      backdropPath: '',
      overview: overview ?? '',
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      originalTitle: originalTitle ?? title,
      adult: false,
      genreIds: [],
      popularity: 0,
      voteCount: 0,
      runtime: runtime ?? 0,
      originalLanguage: '',
      video: false,
      productionCompanies: [],
      genres: [],
    );
  }

  /// Converte para TVShow (se for série)
  TVShow toTVShow() {
    return TVShow(
      id: int.parse(id),
      name: title,
      posterPath: posterPath ?? '',
      backdropPath: '',
      overview: overview ?? '',
      voteAverage: voteAverage,
      firstAirDate: releaseDate,
      originalName: originalName ?? title,
      adult: false,
      genreIds: [],
      popularity: 0,
      voteCount: 0,
      numberOfSeasons: numberOfSeasons ?? 0,
      numberOfEpisodes: numberOfEpisodes ?? 0,
      originCountry: [],
      originalLanguage: '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isTVShow == other.isTVShow;

  @override
  int get hashCode => id.hashCode ^ isTVShow.hashCode;
}
