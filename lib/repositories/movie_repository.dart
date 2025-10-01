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

  /// Obtém um filme aleatório do cache ou API
  Future<Movie> getRandomMovieByGenre(String genre, {int? excludeMovieId}) async {
    debugPrint('Buscando filme aleatório do gênero: $genre (Excluindo: $excludeMovieId)');
    final movies = await getMoviesByGenre(genre);
    if (movies.isEmpty) {
      throw Exception('Nenhum filme encontrado para o gênero $genre');
    }
    
    debugPrint('Encontrados ${movies.length} filmes do gênero $genre');
    
    // Se há um filme a excluir e há mais de um filme, remove da lista
    List<Movie> availableMovies = movies;
    if (excludeMovieId != null && movies.length > 1) {
      availableMovies = movies.where((movie) => movie.id != excludeMovieId).toList();
      debugPrint('Após excluir filme atual: ${availableMovies.length} filmes disponíveis');
    }
    
    // Se não sobrou nenhum filme após exclusão, usa a lista original
    if (availableMovies.isEmpty) {
      availableMovies = movies;
      debugPrint('Usando lista original pois não sobrou nenhum filme');
    }
    
    // Retorna um filme verdadeiramente aleatório da lista
    final random = Random();
    final selectedMovie = availableMovies[random.nextInt(availableMovies.length)];
    
    debugPrint('Filme sorteado: ${selectedMovie.title}');
    return selectedMovie;
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