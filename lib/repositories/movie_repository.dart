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
      // Por enquanto, usa o método existente que retorna um filme
      // Em uma implementação real, buscaria uma lista
      final movie = await MovieService.getRandomMovieByGenre(genre);
      final movies = [movie]; // Simula uma lista
      
      // Atualiza o cache
      _movieCache[cacheKey] = movies;
      _cacheTimestamps[cacheKey] = DateTime.now();
      
      return movies;
    } catch (e) {
      debugPrint('Error fetching movies for genre $genre: $e');
      rethrow;
    }
  }

  /// Obtém um filme aleatório do cache ou API
  Future<Movie> getRandomMovieByGenre(String genre) async {
    final movies = await getMoviesByGenre(genre);
    if (movies.isEmpty) {
      throw Exception('Nenhum filme encontrado para o gênero $genre');
    }
    
    // Em uma implementação real, retornaria um filme aleatório da lista
    return movies.first;
  }

  /// Limpa o cache
  void clearCache() {
    _movieCache.clear();
    _cacheTimestamps.clear();
    debugPrint('Movie cache cleared');
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