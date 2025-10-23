import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';

/// Helper class for localized genre names
class LocalizedGenres {
  const LocalizedGenres._();

  static String getGenreName(BuildContext context, String genreKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (genreKey) {
      case 'Novidades':
        return localizations.genreNovidades;
      case 'Ação':
        return localizations.genreAcao;
      case 'Aventura':
        return localizations.genreAventura;
      case 'Animação':
        return localizations.genreAnimacao;
      case 'Comédia':
        return localizations.genreComedia;
      case 'Crime':
        return localizations.genreCrime;
      case 'Documentário':
        return localizations.genreDocumentario;
      case 'Drama':
        return localizations.genreDrama;
      case 'Família':
        return localizations.genreFamilia;
      case 'Fantasia':
        return localizations.genreFantasia;
      case 'História':
        return localizations.genreHistoria;
      case 'Terror':
        return localizations.genreTerror;
      case 'Música':
        return localizations.genreMusica;
      case 'Mistério':
        return localizations.genreMisterio;
      case 'Romance':
        return localizations.genreRomance;
      case 'Ficção Científica':
        return localizations.genreFiccaoCientifica;
      case 'Suspense':
        return localizations.genreSuspense;
      case 'Guerra':
        return localizations.genreGuerra;
      case 'Western':
        return localizations.genreWestern;
      case 'Favoritos':
        return localizations.genreFavoritos;
      case 'Assistidos':
        return localizations.genreAssistidos;
      default:
        return genreKey;
    }
  }

  static String getTVGenreName(BuildContext context, String genreKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (genreKey) {
      case 'Novidades':
        return localizations.tvGenreNovidades;
      case 'Ação & Aventura':
        return localizations.tvGenreAcaoAventura;
      case 'Animação':
        return localizations.tvGenreAnimacao;
      case 'Comédia':
        return localizations.tvGenreComedia;
      case 'Crime':
        return localizations.tvGenreCrime;
      case 'Documentário':
        return localizations.tvGenreDocumentario;
      case 'Drama':
        return localizations.tvGenreDrama;
      case 'Família':
        return localizations.tvGenreFamilia;
      case 'Infantil':
        return localizations.tvGenreInfantil;
      case 'Mistério':
        return localizations.tvGenreMisterio;
      case 'Novela':
        return localizations.tvGenreNovela;
      case 'Ficção Científica & Fantasia':
        return localizations.tvGenreFiccaoCientificaFantasia;
      case 'Talk Show':
        return localizations.tvGenreTalkShow;
      case 'Guerra & Política':
        return localizations.tvGenreGuerraPolitica;
      case 'Western':
        return localizations.tvGenreWestern;
      case 'Reality':
        return localizations.tvGenreReality;
      case 'Favoritos':
        return localizations.tvGenreFavoritos;
      case 'Assistidos':
        return localizations.tvGenreAssistidos;
      default:
        return genreKey;
    }
  }

  static List<String> getLocalizedGenres(BuildContext context) {
    return [
      'Novidades',
      'Ação',
      'Aventura',
      'Animação',
      'Comédia',
      'Crime',
      'Documentário',
      'Drama',
      'Família',
      'Fantasia',
      'História',
      'Terror',
      'Música',
      'Mistério',
      'Romance',
      'Ficção Científica',
      'Suspense',
      'Guerra',
      'Western',
      'Favoritos',
      'Assistidos',
    ].map((genre) => getGenreName(context, genre)).toList();
  }

  static List<String> getLocalizedTVGenres(BuildContext context) {
    return [
      'Novidades',
      'Ação & Aventura',
      'Animação',
      'Comédia',
      'Crime',
      'Documentário',
      'Drama',
      'Família',
      'Infantil',
      'Mistério',
      'Novela',
      'Ficção Científica & Fantasia',
      'Talk Show',
      'Guerra & Política',
      'Western',
      'Reality',
      'Favoritos',
      'Assistidos',
    ].map((genre) => getTVGenreName(context, genre)).toList();
  }
}