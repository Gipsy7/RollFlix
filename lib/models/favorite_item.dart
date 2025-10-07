import 'movie.dart';
import 'tv_show.dart';

/// Modelo unificado para itens favoritos (filmes e séries)
class FavoriteItem {
  final String id;
  final String title;
  final String? posterPath;
  final String? overview;
  final double voteAverage;
  final String releaseDate;
  final bool isTVShow;
  final DateTime addedAt;
  
  // Campos específicos de filme
  final String? originalTitle;
  final int? runtime;
  
  // Campos específicos de série
  final String? originalName;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;

  FavoriteItem({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.isTVShow,
    required this.addedAt,
    this.originalTitle,
    this.runtime,
    this.originalName,
    this.numberOfSeasons,
    this.numberOfEpisodes,
  });

  /// Cria um FavoriteItem a partir de um Movie
  factory FavoriteItem.fromMovie(Movie movie) {
    return FavoriteItem(
      id: movie.id.toString(),
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      isTVShow: false,
      addedAt: DateTime.now(),
      originalTitle: movie.originalTitle,
      runtime: movie.runtime,
    );
  }

  /// Cria um FavoriteItem a partir de uma TVShow
  factory FavoriteItem.fromTVShow(TVShow show) {
    return FavoriteItem(
      id: show.id.toString(),
      title: show.name,
      posterPath: show.posterPath,
      overview: show.overview,
      voteAverage: show.voteAverage,
      releaseDate: show.firstAirDate,
      isTVShow: true,
      addedAt: DateTime.now(),
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
      'addedAt': addedAt.toIso8601String(),
      'originalTitle': originalTitle,
      'runtime': runtime,
      'originalName': originalName,
      'numberOfSeasons': numberOfSeasons,
      'numberOfEpisodes': numberOfEpisodes,
    };
  }

  /// Cria a partir de JSON
  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      title: json['title'] as String,
      posterPath: json['posterPath'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['voteAverage'] as num).toDouble(),
      releaseDate: json['releaseDate'] as String,
      isTVShow: json['isTVShow'] as bool,
      addedAt: DateTime.parse(json['addedAt'] as String),
      originalTitle: json['originalTitle'] as String?,
      runtime: json['runtime'] as int?,
      originalName: json['originalName'] as String?,
      numberOfSeasons: json['numberOfSeasons'] as int?,
      numberOfEpisodes: json['numberOfEpisodes'] as int?,
    );
  }

  /// Retorna o ano de lançamento
  String get year {
    try {
      return releaseDate.split('-')[0];
    } catch (e) {
      return 'N/A';
    }
  }

  /// Retorna uma descrição curta
  String get typeDescription {
    if (isTVShow) {
      if (numberOfSeasons != null) {
        return '$numberOfSeasons temporada${numberOfSeasons! > 1 ? 's' : ''}';
      }
      return 'Série';
    } else {
      if (runtime != null && runtime! > 0) {
        return '$runtime min';
      }
      return 'Filme';
    }
  }
}
