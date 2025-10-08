import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/tv_show.dart';
import '../models/roll_preferences.dart';
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
  Future<List<TVShow>> getTVShowsByGenre(String genre, {RollPreferences? preferences}) async {
    final cacheKey = genre.toLowerCase();
    
    // Se há preferências com filtros, não usa cache (busca direto da API)
    if (preferences != null && preferences.hasFilters) {
      debugPrint('Buscando séries com filtros - ignorando cache');
      return await _fetchTVShowsFromAPI(genre, preferences);
    }
    
    // Verifica se existe cache válido
    if (_tvShowCache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null && 
          DateTime.now().difference(timestamp) < _cacheExpiration) {
        debugPrint('Cache hit for TV genre: $genre');
        return _tvShowCache[cacheKey]!;
      }
    }

    // Busca dados da API sem filtros e atualiza cache
    debugPrint('Cache miss for TV genre: $genre - fetching from API');
    final tvShows = await _fetchTVShowsFromAPI(genre, null);
    
    // Atualiza o cache apenas para buscas sem filtro
    _tvShowCache[cacheKey] = tvShows;
    _cacheTimestamps[cacheKey] = DateTime.now();
    
    return tvShows;
  }
  
  /// Busca séries da API com filtros opcionais
  Future<List<TVShow>> _fetchTVShowsFromAPI(String genre, RollPreferences? preferences) async {
    try {
      final tvShows = await MovieService.getTVShowsByGenre(
        genre,
        minYear: preferences?.minYear,
        maxYear: preferences?.maxYear,
      );
      
      if (tvShows.isEmpty) {
        throw Exception('Nenhuma série encontrada para o gênero $genre');
      }
      
      debugPrint('Fetched ${tvShows.length} TV shows for genre: $genre');
      return tvShows;
    } catch (e) {
      debugPrint('Error fetching TV shows for genre $genre: $e');
      rethrow;
    }
  }

  /// Obtém uma série aleatória do cache ou API, evitando repetições recentes
  Future<TVShow> getRandomTVShowByGenre(
    String genre, {
    int? excludeShowId,
    RollPreferences? preferences,
  }) async {
    debugPrint('Buscando série aleatória do gênero: $genre (Excluindo: $excludeShowId)');
    debugPrint('Preferências: ${preferences?.toJson()}');
    
    final tvShows = await getTVShowsByGenre(genre, preferences: preferences);
    if (tvShows.isEmpty) {
      throw Exception('Nenhuma série encontrada para o gênero $genre');
    }
    
    debugPrint('Encontradas ${tvShows.length} séries do gênero $genre');
    
    // Obtém o histórico de séries recentes deste gênero
    final cacheKey = genre.toLowerCase();
    final recentShowIds = _recentlyDrawnShows[cacheKey] ?? [];
    
    // Filtra séries que não estão no histórico recente e aplica preferências
    List<TVShow> availableShows = tvShows.where((show) {
      if (excludeShowId != null && show.id == excludeShowId) return false;
      if (recentShowIds.contains(show.id)) return false;
      
      return _applyPreferenceFilters(show, preferences);
    }).toList();
    
    debugPrint('${availableShows.length} séries disponíveis após filtros');
    
    // Se não sobrou nenhuma série, tenta sem histórico
    if (availableShows.isEmpty) {
      debugPrint('Histórico resetado');
      _recentlyDrawnShows[cacheKey] = [];
      availableShows = tvShows.where((show) {
        if (excludeShowId != null && show.id == excludeShowId) return false;
        return _applyPreferenceFilters(show, preferences);
      }).toList();
    }
    
    // Se ainda vazio após aplicar filtros, lança erro
    if (availableShows.isEmpty) {
      debugPrint('❌ Nenhuma série do gênero "$genre" atende aos filtros de preferência');
      throw Exception(
        'Nenhuma série encontrada com os filtros aplicados.\n'
        'Tente reduzir a nota mínima ou escolher outro gênero.'
      );
    }
    
    debugPrint('✅ ${availableShows.length} séries atendem aos filtros de preferência');
    
    // Aplica ordenação
    if (preferences?.sortBy != null && preferences!.sortBy != 'random') {
      if (preferences.sortBy == 'rating') {
        availableShows.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        if (availableShows.length > 10) availableShows = availableShows.take(10).toList();
      } else if (preferences.sortBy == 'popularity') {
        availableShows.sort((a, b) => b.popularity.compareTo(a.popularity));
        if (availableShows.length > 10) availableShows = availableShows.take(10).toList();
      }
    }
    
    // Seleciona aleatoriamente
    final random = Random();
    final selectedShow = availableShows[random.nextInt(availableShows.length)];
    
    debugPrint('📺 Série sorteada: ${selectedShow.name}');
    debugPrint('   📊 Nota: ${selectedShow.voteAverage} / Ano: ${selectedShow.firstAirDate.split('-').first} / Adult: ${selectedShow.adult}');
    
    // Atualiza histórico
    _recentlyDrawnShows[cacheKey] = _recentlyDrawnShows[cacheKey] ?? [];
    _recentlyDrawnShows[cacheKey]!.add(selectedShow.id);
    if (_recentlyDrawnShows[cacheKey]!.length > _maxHistorySize) {
      _recentlyDrawnShows[cacheKey] = 
        _recentlyDrawnShows[cacheKey]!.skip(_recentlyDrawnShows[cacheKey]!.length - _maxHistorySize).toList();
    }
    
    debugPrint('Série sorteada: ${selectedShow.name} (Rating: ${selectedShow.voteAverage})');
    return selectedShow;
  }
  
  /// Aplica filtros de preferências a uma série
  bool _applyPreferenceFilters(TVShow show, RollPreferences? preferences) {
    if (preferences == null) return true;
    
    // Filtro de ano (extrai do firstAirDate)
    if ((preferences.minYear != null || preferences.maxYear != null) && show.firstAirDate.isNotEmpty) {
      try {
        final year = int.parse(show.firstAirDate.split('-')[0]);
        if (preferences.minYear != null && year < preferences.minYear!) return false;
        if (preferences.maxYear != null && year > preferences.maxYear!) return false;
      } catch (e) {
        debugPrint('Erro ao parsear ano: ${show.firstAirDate}');
      }
    }
    
    // Classificação indicativa
    if (preferences.ageRating != null) {
      if (preferences.ageRating == 'G' || preferences.ageRating == 'PG' || preferences.ageRating == 'PG-13') {
        if (show.adult) return false;
      }
    }
    
    return true;
  }

  /// Limpa o cache e histórico
  void clearCache() {
    debugPrint('🗑️ Limpando cache de séries e histórico');
    _tvShowCache.clear();
    _cacheTimestamps.clear();
    _recentlyDrawnShows.clear();
  }
  
  /// Limpa o cache de um gênero específico
  void clearGenreCache(String genre) {
    final cacheKey = genre.toLowerCase();
    debugPrint('🗑️ Limpando cache do gênero (séries): $genre');
    _tvShowCache.remove(cacheKey);
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
