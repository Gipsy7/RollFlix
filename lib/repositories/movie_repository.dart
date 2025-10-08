import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/roll_preferences.dart';
import '../services/movie_service.dart';

/// Repository pattern para gerenciamento de dados de filmes
/// Implementa cache em memória para melhor performance
class MovieRepository extends ChangeNotifier {
  static final MovieRepository _instance = MovieRepository._internal();
  factory MovieRepository() => _instance;
  MovieRepository._internal();

  // Cache em memória
  final Map<String, List<Movie>> _movieCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiration = Duration(minutes: 15);
  
  // Histórico de filmes sorteados por gênero para evitar repetições
  final Map<String, List<int>> _recentlyDrawnMovies = {};
  static const int _maxHistorySize = 10; // Mantém os últimos 10 filmes sorteados por gênero

  /// Obtém filmes por gênero com cache
  Future<List<Movie>> getMoviesByGenre(String genre, {RollPreferences? preferences}) async {
    final cacheKey = genre.toLowerCase();
    
    // Se há preferências com filtros, não usa cache (busca direto da API)
    if (preferences != null && preferences.hasFilters) {
      debugPrint('Buscando filmes com filtros - ignorando cache');
      return await _fetchMoviesFromAPI(genre, preferences);
    }
    
    // Verifica se existe cache válido
    if (_movieCache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null && 
          DateTime.now().difference(timestamp) < _cacheExpiration) {
        debugPrint('Cache hit for genre: $genre');
        return _movieCache[cacheKey]!;
      }
    }

    // Busca dados da API sem filtros e atualiza cache
    debugPrint('Cache miss for genre: $genre - fetching from API');
    final movies = await _fetchMoviesFromAPI(genre, null);
    
    // Atualiza o cache apenas para buscas sem filtro
    _movieCache[cacheKey] = movies;
    _cacheTimestamps[cacheKey] = DateTime.now();
    
    return movies;
  }
  
  /// Busca filmes da API com filtros opcionais
  Future<List<Movie>> _fetchMoviesFromAPI(String genre, RollPreferences? preferences) async {
    try {
      final movies = await MovieService.getMoviesByGenre(
        genre,
        minYear: preferences?.minYear,
        maxYear: preferences?.maxYear,
      );
      
      if (movies.isEmpty) {
        throw Exception('Nenhum filme encontrado para o gênero $genre');
      }
      
      debugPrint('Fetched ${movies.length} movies for genre: $genre');
      return movies;
    } catch (e) {
      debugPrint('Error fetching movies for genre $genre: $e');
      rethrow;
    }
  }

  /// Obtém um filme aleatório do cache ou API, evitando repetições recentes
  Future<Movie> getRandomMovieByGenre(
    String genre, {
    int? excludeMovieId,
    RollPreferences? preferences,
  }) async {
    debugPrint('=== INICIANDO BUSCA DE FILME ===');
    debugPrint('Buscando filme aleatório do gênero: $genre (Excluindo: $excludeMovieId)');
    debugPrint('Preferências recebidas: ${preferences?.toJson()}');
    if (preferences != null) {
      debugPrint('  - Ano mín/máx: ${preferences.minYear} / ${preferences.maxYear}');
      debugPrint('  - Classificação: ${preferences.ageRating}');
      debugPrint('  - Ordenação: ${preferences.sortBy}');
    }
    
    final movies = await getMoviesByGenre(genre, preferences: preferences);
    if (movies.isEmpty) {
      throw Exception('Nenhum filme encontrado para o gênero $genre');
    }
    
    debugPrint('Encontrados ${movies.length} filmes do gênero $genre');
    
    // Obtém o histórico de filmes recentes deste gênero
    final cacheKey = genre.toLowerCase();
    final recentMovieIds = _recentlyDrawnMovies[cacheKey] ?? [];
    
    // Filtra filmes que não estão no histórico recente e aplica preferências
    List<Movie> availableMovies = movies.where((movie) {
      // Exclui o filme atual se especificado
      if (excludeMovieId != null && movie.id == excludeMovieId) {
        return false;
      }
      // Exclui filmes do histórico recente
      if (recentMovieIds.contains(movie.id)) {
        return false;
      }
      
      // Aplica filtros de preferências
      if (preferences != null) {
        // Filtro de ano mínimo e máximo
        if ((preferences.minYear != null || preferences.maxYear != null) && movie.year.isNotEmpty) {
          try {
            final movieYear = int.parse(movie.year);
            if (preferences.minYear != null && movieYear < preferences.minYear!) {
              return false;
            }
            if (preferences.maxYear != null && movieYear > preferences.maxYear!) {
              return false;
            }
          } catch (e) {
            // Se não conseguir parsear o ano, ignora esse filtro
            debugPrint('Erro ao parsear ano do filme: ${movie.year}');
          }
        }
        
        // Filtro de classificação indicativa usando o campo 'adult'
        // Filmes com adult=true são considerados NC-17/18+
        if (preferences.ageRating != null) {
          if (preferences.ageRating == 'G' || preferences.ageRating == 'PG' || preferences.ageRating == 'PG-13') {
            // Se busca classificações mais baixas, exclui filmes adultos
            if (movie.adult) {
              return false;
            }
          }
          // Para R e NC-17, permite qualquer filme
        }
      }
      
      return true;
    }).toList();
    
    debugPrint('Histórico recente tem ${recentMovieIds.length} filmes, ${availableMovies.length} filmes disponíveis após filtros');
    
    // Se não sobrou nenhum filme após exclusão, limpa o histórico e usa toda a lista
    // (exceto o filme atual se especificado)
    if (availableMovies.isEmpty) {
      debugPrint('Histórico resetado - todos os filmes já foram sorteados ou não atendem aos filtros');
      _recentlyDrawnMovies[cacheKey] = [];
      
      // Tenta novamente sem histórico mas mantendo os filtros de preferências
      availableMovies = movies.where((movie) {
        if (excludeMovieId != null && movie.id == excludeMovieId) {
          return false;
        }
        
        // Reaplica filtros de preferências
        if (preferences != null) {
          if ((preferences.minYear != null || preferences.maxYear != null) && movie.year.isNotEmpty) {
            try {
              final movieYear = int.parse(movie.year);
              if (preferences.minYear != null && movieYear < preferences.minYear!) {
                return false;
              }
              if (preferences.maxYear != null && movieYear > preferences.maxYear!) {
                return false;
              }
            } catch (e) {
              // Ignora erro de parsing
            }
          }
          
          if (preferences.ageRating != null) {
            if (preferences.ageRating == 'G' || preferences.ageRating == 'PG' || preferences.ageRating == 'PG-13') {
              if (movie.adult) {
                return false;
              }
            }
          }
        }
        
        return true;
      }).toList();
    }
    
    // Se ainda não há filmes disponíveis após aplicar filtros, lança erro
    if (availableMovies.isEmpty) {
      debugPrint('❌ Nenhum filme do gênero "$genre" atende aos filtros de preferência');
      throw Exception(
        'Nenhum filme encontrado com os filtros aplicados.\n'
        'Tente reduzir a nota mínima ou escolher outro gênero.'
      );
    }
    
    debugPrint('✅ ${availableMovies.length} filmes atendem aos filtros de preferência');
    
    // Aplica ordenação se especificada
    if (preferences?.sortBy != null && preferences!.sortBy != 'random') {
      if (preferences.sortBy == 'rating') {
        availableMovies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        // Pega os top 10 e sorteia entre eles para manter aleatoriedade
        if (availableMovies.length > 10) {
          availableMovies = availableMovies.take(10).toList();
        }
      } else if (preferences.sortBy == 'popularity') {
        availableMovies.sort((a, b) => b.popularity.compareTo(a.popularity));
        // Pega os top 10 e sorteia entre eles para manter aleatoriedade
        if (availableMovies.length > 10) {
          availableMovies = availableMovies.take(10).toList();
        }
      }
    }
    
    // Seleciona um filme aleatório
    final random = Random();
    final selectedMovie = availableMovies[random.nextInt(availableMovies.length)];
    
    debugPrint('🎬 Filme sorteado: ${selectedMovie.title}');
    debugPrint('   📊 Nota: ${selectedMovie.voteAverage} / Ano: ${selectedMovie.year} / Adult: ${selectedMovie.adult}');
    
    // Adiciona ao histórico
    _recentlyDrawnMovies[cacheKey] = _recentlyDrawnMovies[cacheKey] ?? [];
    _recentlyDrawnMovies[cacheKey]!.add(selectedMovie.id);
    
    // Mantém apenas os últimos N filmes no histórico
    if (_recentlyDrawnMovies[cacheKey]!.length > _maxHistorySize) {
      _recentlyDrawnMovies[cacheKey] = 
        _recentlyDrawnMovies[cacheKey]!.skip(_recentlyDrawnMovies[cacheKey]!.length - _maxHistorySize).toList();
    }
    
    debugPrint('Filme sorteado: ${selectedMovie.title} (ID: ${selectedMovie.id}, Rating: ${selectedMovie.voteAverage})');
    debugPrint('Histórico atualizado: ${_recentlyDrawnMovies[cacheKey]!.length} filmes');
    return selectedMovie;
  }

  /// Limpa o cache e histórico
  void clearCache() {
    debugPrint('🗑️ Limpando cache de filmes e histórico');
    _movieCache.clear();
    _cacheTimestamps.clear();
    _recentlyDrawnMovies.clear();
  }
  
  /// Limpa o cache de um gênero específico
  void clearGenreCache(String genre) {
    final cacheKey = genre.toLowerCase();
    debugPrint('🗑️ Limpando cache do gênero: $genre');
    _movieCache.remove(cacheKey);
    _cacheTimestamps.remove(cacheKey);
  }

  /// Limpa cache expirado
  void cleanExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) >= _cacheExpiration) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      _movieCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      debugPrint('Cleaned ${expiredKeys.length} expired cache entries');
    }
  }

  /// Pré-carrega filmes para gêneros populares
  Future<void> preloadPopularGenres() async {
    const popularGenres = ['Ação', 'Comédia', 'Drama', 'Aventura'];
    
    for (final genre in popularGenres) {
      try {
        await getMoviesByGenre(genre);
        // Adiciona delay para não sobrecarregar a API
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        debugPrint('Failed to preload genre $genre: $e');
      }
    }
  }

  /// Obtém estatísticas do cache
  Map<String, dynamic> getCacheStats() {
    return {
      'cached_genres': _movieCache.length,
      'total_movies': _movieCache.values.fold<int>(0, (sum, list) => sum + list.length),
      'cache_size_mb': _calculateCacheSize(),
      'history_entries': _recentlyDrawnMovies.length,
      'total_history_items': _recentlyDrawnMovies.values.fold<int>(0, (sum, list) => sum + list.length),
    };
  }

  double _calculateCacheSize() {
    // Estimativa simples do tamanho do cache
    int totalSize = 0;
    for (final movies in _movieCache.values) {
      totalSize += movies.length * 1024; // Estimativa de 1KB por filme
    }
    return totalSize / (1024 * 1024); // Converte para MB
  }
}