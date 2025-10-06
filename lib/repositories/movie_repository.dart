import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
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
  Future<List<Movie>> getMoviesByGenre(String genre) async {
    final cacheKey = genre.toLowerCase();
    
    // Verifica se existe cache válido
    if (_movieCache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null && 
          DateTime.now().difference(timestamp) < _cacheExpiration) {
        debugPrint('Cache hit for genre: $genre');
        return _movieCache[cacheKey]!;
      }
    }

    // Busca dados da API
    debugPrint('Cache miss for genre: $genre - fetching from API');
    try {
      // Busca uma lista completa de filmes do gênero
      final movies = await MovieService.getMoviesByGenre(genre);
      
      if (movies.isEmpty) {
        throw Exception('Nenhum filme encontrado para o gênero $genre');
      }
      
      debugPrint('Fetched ${movies.length} movies for genre: $genre');
      
      // Atualiza o cache
      _movieCache[cacheKey] = movies;
      _cacheTimestamps[cacheKey] = DateTime.now();
      
      return movies;
    } catch (e) {
      debugPrint('Error fetching movies for genre $genre: $e');
      rethrow;
    }
  }

  /// Obtém um filme aleatório do cache ou API, evitando repetições recentes
  Future<Movie> getRandomMovieByGenre(String genre, {int? excludeMovieId}) async {
    debugPrint('Buscando filme aleatório do gênero: $genre (Excluindo: $excludeMovieId)');
    final movies = await getMoviesByGenre(genre);
    if (movies.isEmpty) {
      throw Exception('Nenhum filme encontrado para o gênero $genre');
    }
    
    debugPrint('Encontrados ${movies.length} filmes do gênero $genre');
    
    // Obtém o histórico de filmes recentes deste gênero
    final cacheKey = genre.toLowerCase();
    final recentMovieIds = _recentlyDrawnMovies[cacheKey] ?? [];
    
    // Filtra filmes que não estão no histórico recente
    List<Movie> availableMovies = movies.where((movie) {
      // Exclui o filme atual se especificado
      if (excludeMovieId != null && movie.id == excludeMovieId) {
        return false;
      }
      // Exclui filmes do histórico recente
      return !recentMovieIds.contains(movie.id);
    }).toList();
    
    debugPrint('Histórico recente tem ${recentMovieIds.length} filmes, ${availableMovies.length} filmes disponíveis após filtro');
    
    // Se não sobrou nenhum filme após exclusão, limpa o histórico e usa toda a lista
    // (exceto o filme atual se especificado)
    if (availableMovies.isEmpty) {
      debugPrint('Histórico resetado - todos os filmes já foram sorteados');
      _recentlyDrawnMovies[cacheKey] = [];
      availableMovies = movies.where((movie) => 
        excludeMovieId == null || movie.id != excludeMovieId
      ).toList();
    }
    
    // Se ainda não há filmes disponíveis, usa a lista completa
    if (availableMovies.isEmpty) {
      availableMovies = movies;
      debugPrint('Usando lista completa pois não há filmes disponíveis');
    }
    
    // Seleciona um filme aleatório
    final random = Random();
    final selectedMovie = availableMovies[random.nextInt(availableMovies.length)];
    
    // Adiciona ao histórico
    _recentlyDrawnMovies[cacheKey] = _recentlyDrawnMovies[cacheKey] ?? [];
    _recentlyDrawnMovies[cacheKey]!.add(selectedMovie.id);
    
    // Mantém apenas os últimos N filmes no histórico
    if (_recentlyDrawnMovies[cacheKey]!.length > _maxHistorySize) {
      _recentlyDrawnMovies[cacheKey] = 
        _recentlyDrawnMovies[cacheKey]!.skip(_recentlyDrawnMovies[cacheKey]!.length - _maxHistorySize).toList();
    }
    
    debugPrint('Filme sorteado: ${selectedMovie.title} (ID: ${selectedMovie.id})');
    debugPrint('Histórico atualizado: ${_recentlyDrawnMovies[cacheKey]!.length} filmes');
    return selectedMovie;
  }

  /// Limpa o cache e histórico
  void clearCache() {
    _movieCache.clear();
    _cacheTimestamps.clear();
    _recentlyDrawnMovies.clear();
    debugPrint('Movie cache and history cleared');
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