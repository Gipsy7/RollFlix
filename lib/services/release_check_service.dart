import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/favorite_item.dart';
import '../constants/app_constants.dart';
import 'notification_service.dart';

/// Serviço para verificar lançamentos de filmes e séries favoritas
class ReleaseCheckService {
  static final ReleaseCheckService _instance = ReleaseCheckService._internal();
  static ReleaseCheckService get instance => _instance;

  ReleaseCheckService._internal();

  static const String _apiKey = AppConstants.tmdbApiKey;
  static const String _baseUrl = AppConstants.tmdbBaseUrl;

  DateTime? _lastCheckTime;
  static const Duration minCheckInterval = Duration(hours: 6);

  /// Verifica lançamentos de filmes favoritos
  Future<void> checkMovieReleases(List<FavoriteItem> favorites) async {
    try {
      final notificationService = NotificationService.instance;
      final lastCheck = await notificationService.getLastReleaseCheck();
      final now = DateTime.now();

      // Filtrar apenas filmes favoritos
      final favoriteMovies = favorites.where((fav) => !fav.isTVShow).toList();

      for (final favorite in favoriteMovies) {
        try {
          // Verificar se o filme já foi lançado
          final releaseDate = DateTime.parse(favorite.releaseDate);

          // Se o filme foi lançado hoje
          if (_isToday(releaseDate)) {
            await notificationService.notifyMovieRelease(
              favorite.id,
              favorite.title,
              releaseDate,
            );
            debugPrint('🎬 Notificação enviada: ${favorite.title} foi lançado hoje!');
          }
          // Se o filme será lançado amanhã e ainda não foi notificado
          else if (_isTomorrow(releaseDate) &&
                   (lastCheck == null || releaseDate.isAfter(lastCheck))) {
            await notificationService.scheduleMovieReleaseNotification(
              favorite.id,
              favorite.title,
              releaseDate,
            );
            debugPrint('📅 Notificação agendada: ${favorite.title} será lançado amanhã!');
          }
        } catch (e) {
          debugPrint('Erro ao verificar lançamento do filme ${favorite.title}: $e');
        }
      }

      // Atualizar última verificação
      await notificationService.setLastReleaseCheck(now);
      debugPrint('✅ Verificação de lançamentos de filmes concluída');

    } catch (e) {
      debugPrint('❌ Erro ao verificar lançamentos de filmes: $e');
    }
  }

  /// Verifica novos episódios de séries favoritas
  Future<void> checkTVShowEpisodes(List<FavoriteItem> favorites) async {
    try {
      final notificationService = NotificationService.instance;

      // Filtrar apenas séries favoritas
      final favoriteShows = favorites.where((fav) => fav.isTVShow).toList();

      for (final favorite in favoriteShows) {
        try {
          // Buscar informações atualizadas da série
          final updatedShow = await _fetchTVShowDetails(favorite.id);

          if (updatedShow != null) {
            // Verificar se há novos episódios
            final lastEpisode = await _getLatestEpisode(updatedShow);

            if (lastEpisode != null) {
              final episodeDate = DateTime.parse(lastEpisode['air_date']);
              final episodeInfo = _formatEpisodeInfo(lastEpisode);

              // Se o episódio foi lançado hoje
              if (_isToday(episodeDate)) {
                await notificationService.notifyTVShowEpisode(
                  favorite.id,
                  favorite.title,
                  episodeInfo,
                  episodeDate,
                );
                debugPrint('📺 Notificação enviada: Novo episódio de ${favorite.title} - $episodeInfo');
              }
            }
          }
        } catch (e) {
          debugPrint('Erro ao verificar episódios da série ${favorite.title}: $e');
        }
      }

      debugPrint('✅ Verificação de novos episódios concluída');

    } catch (e) {
      debugPrint('❌ Erro ao verificar novos episódios: $e');
    }
  }

  /// Busca detalhes atualizados de uma série
  Future<Map<String, dynamic>?> _fetchTVShowDetails(String showId) async {
    try {
      final url = Uri.parse('$_baseUrl/tv/$showId?api_key=$_apiKey&language=pt-BR');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint('Erro ao buscar detalhes da série $showId: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Erro ao buscar detalhes da série $showId: $e');
      return null;
    }
  }

  /// Obtém o último episódio lançado de uma série
  Future<Map<String, dynamic>?> _getLatestEpisode(Map<String, dynamic> showData) async {
    try {
      final seasons = showData['seasons'] as List<dynamic>?;

      if (seasons == null || seasons.isEmpty) return null;

      // Pegar a temporada mais recente (excluindo especiais)
      final regularSeasons = seasons.where((season) =>
        season['season_number'] != 0 &&
        season['air_date'] != null &&
        season['air_date'].toString().isNotEmpty
      ).toList();

      if (regularSeasons.isEmpty) return null;

      regularSeasons.sort((a, b) =>
        DateTime.parse(b['air_date']).compareTo(DateTime.parse(a['air_date']))
      );

      final latestSeason = regularSeasons.first;
      final seasonNumber = latestSeason['season_number'];

      // Buscar episódios da temporada mais recente
      final episodes = await _fetchSeasonEpisodes(showData['id'].toString(), seasonNumber);

      if (episodes == null || episodes.isEmpty) return null;

      // Pegar o episódio mais recente
      episodes.sort((a, b) =>
        DateTime.parse(b['air_date'] ?? '1900-01-01')
            .compareTo(DateTime.parse(a['air_date'] ?? '1900-01-01'))
      );

      return episodes.first;
    } catch (e) {
      debugPrint('Erro ao obter último episódio: $e');
      return null;
    }
  }

  /// Busca episódios de uma temporada específica
  Future<List<Map<String, dynamic>>?> _fetchSeasonEpisodes(String showId, int seasonNumber) async {
    try {
      final url = Uri.parse('$_baseUrl/tv/$showId/season/$seasonNumber?api_key=$_apiKey&language=pt-BR');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final episodes = data['episodes'] as List<dynamic>?;
        return episodes?.cast<Map<String, dynamic>>();
      } else {
        debugPrint('Erro ao buscar episódios da temporada $seasonNumber: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Erro ao buscar episódios da temporada $seasonNumber: $e');
      return null;
    }
  }

  /// Formata informações do episódio
  String _formatEpisodeInfo(Map<String, dynamic> episode) {
    final seasonNumber = episode['season_number'] ?? 0;
    final episodeNumber = episode['episode_number'] ?? 0;
    final episodeName = episode['name'] ?? 'Episódio sem nome';

    return 'S${seasonNumber.toString().padLeft(2, '0')}E${episodeNumber.toString().padLeft(2, '0')} - $episodeName';
  }

  /// Verifica se uma data é hoje
  bool _isToday(DateTime date) {
    final now = DateTime.now().toUtc();
    final dateUtc = date.toUtc();
    
    return dateUtc.year == now.year &&
           dateUtc.month == now.month &&
           dateUtc.day == now.day;
  }

  /// Verifica se uma data é amanhã
  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().toUtc().add(const Duration(days: 1));
    final dateUtc = date.toUtc();
    
    return dateUtc.year == tomorrow.year &&
           dateUtc.month == tomorrow.month &&
           dateUtc.day == tomorrow.day;
  }

  /// Executa verificação completa de lançamentos
  Future<void> checkAllReleases(List<FavoriteItem> favorites) async {
    // Verificar se já verificou recentemente (rate limiting)
    if (_lastCheckTime != null) {
      final timeSinceLastCheck = DateTime.now().difference(_lastCheckTime!);
      if (timeSinceLastCheck < minCheckInterval) {
        debugPrint('⏭️ Verificação muito recente, pulando (última: $_lastCheckTime)');
        return;
      }
    }

    debugPrint('🔍 Iniciando verificação de lançamentos...');
    _lastCheckTime = DateTime.now();

    await Future.wait([
      checkMovieReleases(favorites),
      checkTVShowEpisodes(favorites),
    ]);

    debugPrint('✅ Verificação completa de lançamentos finalizada');
  }

  /// Agenda verificações periódicas (deve ser chamado periodicamente)
  Future<void> schedulePeriodicChecks(List<FavoriteItem> favorites) async {
    // Esta função pode ser chamada por um WorkManager ou similar
    // Por enquanto, apenas executa a verificação
    await checkAllReleases(favorites);
  }
}