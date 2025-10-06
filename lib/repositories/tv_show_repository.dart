import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/tv_show.dart';
import '../services/movie_service.dart';

/// Repository pattern para gerenciamento de dados de séries TV
/// Implementa cache em memória e histórico para evitar repetições
class TVShowRepository extends ChangeNotifier {
  static final TVShowRepository _instance = TVShowRepository._internal();
  factory TVShowRepository() => _instance;
  TVShowRepository._internal();

  // Cache em memória
  final Map<String, List<TVShow>> _tvShowCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiration = Duration(minutes: 15);
  
  // Histórico de séries sorteadas por gênero para evitar repetições
  final Map<String, List<int>> _recentlyDrawnShows = {};
  static const int _maxHistorySize = 10; // Mantém as últimas 10 séries sorteadas por gênero

  /// Obtém séries por gênero com cache
  Future<List<TVShow>> getTVShowsByGenre(String genre) async {
    final cacheKey = genre.toLowerCase();
    
    // Verifica se existe cache válido
    if (_tvShowCache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null && 
          DateTime.now().difference(timestamp) < _cacheExpiration) {
        debugPrint('Cache hit for TV genre: $genre');
        return _tvShowCache[cacheKey]!;
      }
    }

    // Busca dados da API
    debugPrint('Cache miss for TV genre: $genre - fetching from API');
    try {
      // Busca uma lista completa de séries do gênero
      final tvShows = await MovieService.getTVShowsByGenre(genre);
      
      if (tvShows.isEmpty) {
        throw Exception('Nenhuma série encontrada para o gênero $genre');
      }
      
      debugPrint('Fetched ${tvShows.length} TV shows for genre: $genre');
      
      // Atualiza o cache
      _tvShowCache[cacheKey] = tvShows;
      _cacheTimestamps[cacheKey] = DateTime.now();
      
      return tvShows;
    } catch (e) {
      debugPrint('Error fetching TV shows for genre $genre: $e');
      rethrow;
    }
  }

  /// Obtém uma série aleatória do cache ou API, evitando repetições recentes
  Future<TVShow> getRandomTVShowByGenre(String genre, {int? excludeShowId}) async {
    debugPrint('Buscando série aleatória do gênero: $genre (Excluindo: $excludeShowId)');
    final tvShows = await getTVShowsByGenre(genre);
    if (tvShows.isEmpty) {
      throw Exception('Nenhuma série encontrada para o gênero $genre');
    }
    
    debugPrint('Encontradas ${tvShows.length} séries do gênero $genre');
    
    // Obtém o histórico de séries recentes deste gênero
    final cacheKey = genre.toLowerCase();
    final recentShowIds = _recentlyDrawnShows[cacheKey] ?? [];
    
    // Filtra séries que não estão no histórico recente
    List<TVShow> availableShows = tvShows.where((show) {
      // Exclui a série atual se especificado
      if (excludeShowId != null && show.id == excludeShowId) {
        return false;
      }
      // Exclui séries do histórico recente
      return !recentShowIds.contains(show.id);
    }).toList();
    
    debugPrint('Histórico recente tem ${recentShowIds.length} séries, ${availableShows.length} séries disponíveis após filtro');
    
    // Se não sobrou nenhuma série após exclusão, limpa o histórico e usa toda a lista
    // (exceto a série atual se especificado)
    if (availableShows.isEmpty) {
      debugPrint('Histórico resetado - todas as séries já foram sorteadas');
      _recentlyDrawnShows[cacheKey] = [];
      availableShows = tvShows.where((show) => 
        excludeShowId == null || show.id != excludeShowId
      ).toList();
    }
    
    // Se ainda não há séries disponíveis, usa a lista completa
    if (availableShows.isEmpty) {
      availableShows = tvShows;
      debugPrint('Usando lista completa pois não há séries disponíveis');
    }
    
    // Seleciona uma série aleatória
    final random = Random();
    final selectedShow = availableShows[random.nextInt(availableShows.length)];
    
    // Adiciona ao histórico
    _recentlyDrawnShows[cacheKey] = _recentlyDrawnShows[cacheKey] ?? [];
    _recentlyDrawnShows[cacheKey]!.add(selectedShow.id);
    
    // Mantém apenas as últimas N séries no histórico
    if (_recentlyDrawnShows[cacheKey]!.length > _maxHistorySize) {
      _recentlyDrawnShows[cacheKey] = 
        _recentlyDrawnShows[cacheKey]!.skip(_recentlyDrawnShows[cacheKey]!.length - _maxHistorySize).toList();
    }
    
    debugPrint('Série sorteada: ${selectedShow.name} (ID: ${selectedShow.id})');
    debugPrint('Histórico atualizado: ${_recentlyDrawnShows[cacheKey]!.length} séries');
    return selectedShow;
  }

  /// Limpa o cache e histórico
  void clearCache() {
    _tvShowCache.clear();
    _cacheTimestamps.clear();
    _recentlyDrawnShows.clear();
    debugPrint('TV show cache and history cleared');
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
      _tvShowCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      debugPrint('Cleaned ${expiredKeys.length} expired TV cache entries');
    }
  }

  /// Pré-carrega séries para gêneros populares
  Future<void> preloadPopularGenres() async {
    const popularGenres = ['Drama', 'Comédia', 'Ação & Aventura', 'Crime'];
    
    for (final genre in popularGenres) {
      try {
        await getTVShowsByGenre(genre);
        // Adiciona delay para não sobrecarregar a API
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        debugPrint('Failed to preload TV genre $genre: $e');
      }
    }
  }

  /// Obtém estatísticas do cache
  Map<String, dynamic> getCacheStats() {
    return {
      'cached_genres': _tvShowCache.length,
      'total_shows': _tvShowCache.values.fold<int>(0, (sum, list) => sum + list.length),
      'cache_size_mb': _calculateCacheSize(),
      'history_entries': _recentlyDrawnShows.length,
      'total_history_items': _recentlyDrawnShows.values.fold<int>(0, (sum, list) => sum + list.length),
    };
  }

  double _calculateCacheSize() {
    // Estimativa simples do tamanho do cache
    int totalSize = 0;
    for (final shows in _tvShowCache.values) {
      totalSize += shows.length * 1024; // Estimativa de 1KB por série
    }
    return totalSize / (1024 * 1024); // Converte para MB
  }
}
