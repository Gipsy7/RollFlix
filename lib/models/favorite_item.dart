import 'package:flutter/widgets.dart';

import 'movie.dart';
import 'tv_show.dart';
import 'package:rollflix/l10n/app_localizations.dart';

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

  /// Retorna o ano de lançamento (não-localizado — curto)
  String get year {
    try {
      return releaseDate.split('-')[0];
    } catch (e) {
      return '-';
    }
  }

  /// Retorna o ano de lançamento de forma localizada (curta). Usa BuildContext
  /// para obter strings como 'N/A' a partir das localizações.
  String yearDescription(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    try {
      final y = releaseDate.split('-')[0];
      if (y.isEmpty) return loc.notAvailableShort;
      return y;
    } catch (e) {
      return loc.notAvailableShort;
    }
  }

  /// Retorna uma descrição curta (localizada) — precisa do BuildContext
  String typeDescription(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (isTVShow) {
      if (numberOfSeasons != null) {
        // Usa chave de pluralização simples já presente no arb (season / seasons)
        final seasonsLabel = numberOfSeasons == 1 ? loc.season : loc.seasons;
        return '$numberOfSeasons $seasonsLabel';
      }
      return loc.series;
    } else {
      if (runtime != null && runtime! > 0) {
        // 'minutes' chave existe nas localizações
        return '$runtime ${loc.minutes}';
      }
      // usa a chave singular já presente nas localizações
      return loc.movieLabel;
    }
  }

  /// Converte FavoriteItem de volta para Movie
  Movie toMovie() {
    return Movie(
      id: int.parse(id),
      title: title,
      overview: overview ?? '',
      posterPath: posterPath ?? '',
      backdropPath: '',
      voteAverage: voteAverage,
      voteCount: 0,
      releaseDate: releaseDate,
      genreIds: [],
      genres: [],
      runtime: runtime ?? 0,
      originalTitle: originalTitle ?? title,
      adult: false,
      originalLanguage: '',
      popularity: voteAverage * 10, // Estimativa baseada na nota
      video: false,
      productionCompanies: [],
    );
  }

  /// Converte FavoriteItem de volta para TVShow
  TVShow toTVShow() {
    return TVShow(
      id: int.parse(id),
      name: title,
      firstAirDate: releaseDate,
      overview: overview ?? '',
      posterPath: posterPath ?? '',
      backdropPath: '',
      voteAverage: voteAverage,
      voteCount: 0,
      originCountry: [],
      originalLanguage: '',
      originalName: originalName ?? title,
      popularity: 0.0,
      adult: false,
      genreIds: [],
      genres: [],
      numberOfSeasons: numberOfSeasons ?? 0,
      numberOfEpisodes: numberOfEpisodes ?? 0,
    );
  }
}
