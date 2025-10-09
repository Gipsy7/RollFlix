import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/movie.dart';
import '../models/cast.dart';
import '../models/watch_providers.dart';
import '../models/movie_videos.dart';
import '../models/soundtrack.dart';
import '../services/movie_service.dart';
import '../theme/app_theme.dart';
import '../utils/app_logger.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/watched_controller.dart';
import '../controllers/user_preferences_controller.dart';
import 'actor_details_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  Movie? detailedMovie;
  MovieCredits? credits;
  WatchProviders? watchProviders;
  MovieVideos? movieVideos;
  SoundtrackInfo? soundtrackInfo;
  bool isLoading = true;
  late final FavoritesController _favoritesController;
  late final WatchedController _watchedController;

  @override
  void initState() {
    super.initState();
    _favoritesController = FavoritesController.instance;
    _watchedController = WatchedController.instance;
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    try {
      final results = await Future.wait([
        MovieService.getMovieDetails(widget.movie.id),
        MovieService.getMovieCredits(widget.movie.id),
        MovieService.getWatchProviders(widget.movie.id),
        MovieService.getMovieVideos(widget.movie.id),
      ]);

      setState(() {
        detailedMovie = results[0] as Movie;
        credits = results[1] as MovieCredits;
        watchProviders = results[2] as WatchProviders?;
        movieVideos = results[3] as MovieVideos?;
        soundtrackInfo = MovieService.getSoundtrackInfo(results[0] as Movie);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        detailedMovie = widget.movie;
        soundtrackInfo = MovieService.getSoundtrackInfo(widget.movie);
        isLoading = false;
      });
    }
  }

  Future<void> _openProvider(WatchProvider provider) async {
    final movie = detailedMovie ?? widget.movie;
    final url = provider.getProviderUrl(movie.title, movie.id);
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao abrir o link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openTrailer() async {
    final trailer = movieVideos?.officialTrailer;
    if (trailer != null && trailer.youtubeUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(trailer.youtubeUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Não foi possível abrir o trailer'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao abrir o trailer'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trailer não disponível'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _launchSoundtrackUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao abrir o link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToActorDetails(CastMember actor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActorDetailsScreen(
          actorId: actor.id,
          actorName: actor.name,
        ),
      ),
    );
  }

  void _shareMovie() {
    final movie = detailedMovie ?? widget.movie;
    final year = movie.releaseDate.isNotEmpty 
        ? movie.releaseDate.split('-')[0] 
        : '';
    final rating = movie.voteAverage > 0 
        ? '⭐ ${movie.voteAverage.toStringAsFixed(1)}/10' 
        : '';
    
    String shareText = '🎬 ${movie.title}';
    if (year.isNotEmpty) {
      shareText += ' ($year)';
    }
    shareText += '\n\n';
    
    if (rating.isNotEmpty) {
      shareText += '$rating\n\n';
    }
    
    if (movie.overview.isNotEmpty) {
      shareText += '📖 ${movie.overview}\n\n';
    }
    
    if (movie.genres.isNotEmpty) {
      final genres = movie.genres.map((g) => g.name).join(', ');
      shareText += '🎭 Gêneros: $genres\n\n';
    }
    
    shareText += '🍿 Descubra mais filmes incríveis no RollFlix!';
    
    SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: movie.title,
      ),
    );
  }

  void _navigateToDirectorDetails(CrewMember director) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActorDetailsScreen(
          actorId: director.id,
          actorName: director.name,
          isDirector: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = detailedMovie ?? widget.movie;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            foregroundColor: AppColors.textPrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Compartilhar filme',
                onPressed: _shareMovie,
              ),
              // Botão de Assistido
              ListenableBuilder(
                listenable: _watchedController,
                builder: (context, _) {
                  final isWatched = _watchedController.isMovieWatched(widget.movie);
                  return IconButton(
                    icon: Icon(
                      isWatched ? Icons.check_circle : Icons.check_circle_outline,
                      color: isWatched ? Colors.green : AppColors.textPrimary,
                    ),
                    tooltip: isWatched ? 'Marcar como não assistido' : 'Marcar como assistido',
                    onPressed: () async {
                      // Verifica se há recursos disponíveis para assistidos
                      final userPrefsController = UserPreferencesController.instance;
                      if (!userPrefsController.canUseResource(ResourceType.watched)) {
                        final cooldown = userPrefsController.getResourceCooldown(ResourceType.watched);
                        if (cooldown != null) {
                          final hours = cooldown.inHours;
                          final minutes = cooldown.inMinutes.remainder(60);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sem recursos para assistidos! Recarrega em ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}h'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sem recursos para assistidos disponíveis!'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        return;
                      }

                      // Consome recurso de assistido
                      final consumed = await userPrefsController.consumeResource(ResourceType.watched);
                      if (!consumed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao consumir recurso de assistido'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      _watchedController.toggleMovieWatched(widget.movie);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isWatched
                                ? 'Removido de assistidos'
                                : 'Marcado como assistido',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),
              // Botão de Favorito
              ListenableBuilder(
                listenable: _favoritesController,
                builder: (context, _) {
                  final isFavorite = _favoritesController.isMovieFavorite(widget.movie);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : AppColors.textPrimary,
                    ),
                    tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                    onPressed: () async {
                      // Verifica se há recursos disponíveis para favoritos
                      final userPrefsController = UserPreferencesController.instance;
                      if (!userPrefsController.canUseResource(ResourceType.favorite)) {
                        final cooldown = userPrefsController.getResourceCooldown(ResourceType.favorite);
                        if (cooldown != null) {
                          final hours = cooldown.inHours;
                          final minutes = cooldown.inMinutes.remainder(60);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sem recursos para favoritos! Recarrega em ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}h'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sem recursos para favoritos disponíveis!'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        return;
                      }

                      // Consome recurso de favorito
                      final consumed = await userPrefsController.consumeResource(ResourceType.favorite);
                      if (!consumed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao consumir recurso de favorito'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      _favoritesController.toggleMovieFavorite(widget.movie);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? 'Removido dos favoritos'
                                : 'Adicionado aos favoritos',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 500),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    shadows: const [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  child: Text(movie.title),
                ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.fullBackdropUrl.isNotEmpty)
                    Image.network(
                      movie.fullBackdropUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surfaceDark,
                          child: Icon(
                            Icons.movie,
                            size: 100,
                            color: AppColors.textMuted,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: AppColors.surfaceDark,
                      child: Icon(
                        Icons.movie,
                        size: 100,
                        color: AppColors.textMuted,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações básicas
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (movie.fullPosterUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            movie.fullPosterUrl,
                            width: 120,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 120,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceDark,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.movie,
                                  size: 60,
                                  color: AppColors.textMuted,
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (movie.year.isNotEmpty)
                              Text(
                                movie.year,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '/10',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (movie.formattedRuntime != 'Duração não disponível')
                              Text(
                                movie.formattedRuntime,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            if (movie.genres.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: movie.genres.map((genre) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Text(
                                      genre.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botão do Trailer
                  if (movieVideos?.hasTrailer == true)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: ElevatedButton.icon(
                        onPressed: _openTrailer,
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const Text(
                          'Assistir Trailer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  
                  // Sinopse
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    child: const Text('Sinopse'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview.isNotEmpty ? movie.overview : 'Sinopse não disponível.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Diretor
                  if (credits?.directors.isNotEmpty == true) ...[
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      child: const Text('Direção'),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: credits!.directors.map((director) {
                        return GestureDetector(
                          onTap: () => _navigateToDirectorDetails(director),
                          child: Chip(
                            avatar: Icon(
                              Icons.movie_filter,
                              size: 16,
                              color: AppColors.backgroundDark, // Preto no fundo dourado
                            ),
                            label: Text(
                              director.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.backgroundDark, // Preto no fundo dourado
                              ),
                            ),
                            backgroundColor: AppColors.primary, // Fundo dourado
                            side: BorderSide(
                              color: AppColors.primaryDark,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Elenco principal
                  if (credits?.cast.isNotEmpty == true) ...[
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      child: const Text('Elenco Principal'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (credits!.cast.length > 10) ? 10 : credits!.cast.length,
                        itemBuilder: (context, index) {
                          final actor = credits!.cast[index];
                          return GestureDetector(
                            onTap: () => _navigateToActorDetails(actor),
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: actor.fullProfileUrl.isNotEmpty
                                        ? Image.network(
                                            actor.fullProfileUrl,
                                            width: 80,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 80,
                                                height: 120,
                                                color: AppColors.surfaceDark,
                                                child: Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: AppColors.textMuted,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            width: 80,
                                            height: 120,
                                            color: AppColors.surfaceDark,
                                            child: Icon(
                                              Icons.person,
                                              size: 40,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    actor.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    actor.character,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textTertiary,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Vídeos/Trailers adicionais
                  if (movieVideos != null && movieVideos!.results.length > 1) ...[
                    Text(
                      'Vídeos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movieVideos!.results.where((video) => 
                            video.isYouTube && (video.isTrailer || video.isTeaser)).length,
                        itemBuilder: (context, index) {
                          final videos = movieVideos!.results.where((video) => 
                              video.isYouTube && (video.isTrailer || video.isTeaser)).toList();
                          final video = videos[index];
                          
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  final uri = Uri.parse(video.youtubeUrl);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                } catch (e) {
                                  // Erro ao abrir vídeo - não mostramos SnackBar para evitar problemas de contexto
                                  AppLogger.debug('Erro ao abrir vídeo: $e');
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          video.youtubeThumbnailUrl,
                                          width: 160,
                                          height: 90,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 160,
                                              height: 90,
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.play_circle_fill,
                                                size: 40,
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                        ),
                                        const Positioned.fill(
                                          child: Center(
                                            child: Icon(
                                              Icons.play_circle_fill,
                                              size: 40,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Expanded(
                                    child: Text(
                                      video.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Onde assistir
                  if (watchProviders?.hasProviders == true) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.surfaceDark,
                            AppColors.surfaceVariantDark,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha:0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha:0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha:0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: AppColors.backgroundDark,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 500),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                child: const Text('Onde Assistir'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                    
                    if (watchProviders!.flatrate.isNotEmpty) ...[
                      Text(
                        'Streaming (Incluído na assinatura):',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary, // Dourado
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: watchProviders!.flatrate.map((provider) {
                          return GestureDetector(
                            onTap: () => _openProvider(provider),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withValues(alpha:0.9),
                                    AppColors.primaryLight.withValues(alpha:0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryDark,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha:0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (provider.fullLogoUrl.isNotEmpty)
                                    Image.network(
                                      provider.fullLogoUrl,
                                      width: 20,
                                      height: 20,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.tv, 
                                          size: 16, 
                                          color: AppColors.backgroundDark, // Preto no fundo dourado
                                        );
                                      },
                                    )
                                  else
                                    Icon(
                                      Icons.tv, 
                                      size: 16, 
                                      color: AppColors.backgroundDark, // Preto no fundo dourado
                                    ),
                                  const SizedBox(width: 6),
                                  Text(
                                    provider.providerName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.backgroundDark, // Preto no fundo dourado
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.open_in_new, 
                                    size: 12, 
                                    color: AppColors.backgroundDark, // Preto no fundo dourado
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (watchProviders!.rent.isNotEmpty) ...[
                      Text(
                        'Aluguel:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary, // Dourado
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: watchProviders!.rent.map((provider) {
                          return GestureDetector(
                            onTap: () => _openProvider(provider),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceDark,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.secondary,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondary.withValues(alpha:0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (provider.fullLogoUrl.isNotEmpty)
                                    Image.network(
                                      provider.fullLogoUrl,
                                      width: 20,
                                      height: 20,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.movie, 
                                          size: 16, 
                                          color: AppColors.secondary, // Vermelho no fundo escuro
                                        );
                                      },
                                    )
                                  else
                                    Icon(
                                      Icons.movie, 
                                      size: 16, 
                                      color: AppColors.secondary, // Vermelho no fundo escuro
                                    ),
                                  const SizedBox(width: 6),
                                  Text(
                                    provider.providerName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary, // Branco no fundo escuro
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.open_in_new, 
                                    size: 12, 
                                    color: AppColors.secondary, // Vermelho no fundo escuro
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (watchProviders!.buy.isNotEmpty) ...[
                      Text(
                        'Compra:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary, // Dourado
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: watchProviders!.buy.map((provider) {
                          return GestureDetector(
                            onTap: () => _openProvider(provider),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.surfaceVariantDark,
                                    AppColors.surfaceDark,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.accentDark,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentDark.withValues(alpha:0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (provider.fullLogoUrl.isNotEmpty)
                                    Image.network(
                                      provider.fullLogoUrl,
                                      width: 20,
                                      height: 20,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.shopping_cart, 
                                          size: 16, 
                                          color: AppColors.primary, // Dourado no fundo escuro
                                        );
                                      },
                                    )
                                  else
                                    Icon(
                                      Icons.shopping_cart, 
                                      size: 16, 
                                      color: AppColors.primary, // Dourado no fundo escuro
                                    ),
                                  const SizedBox(width: 6),
                                  Text(
                                    provider.providerName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary, // Branco no fundo escuro
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.open_in_new, 
                                    size: 12, 
                                    color: AppColors.primary, // Dourado no fundo escuro
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.surfaceDark,
                            AppColors.surfaceVariantDark,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha:0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha:0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariantDark,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.textMuted,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.tv_off,
                                  color: AppColors.textMuted,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Onde Assistir',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundDark.withValues(alpha:0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.textMuted.withValues(alpha:0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.textTertiary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Informações de streaming não disponíveis no momento.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textTertiary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Seção Trilha Sonora
                  if (soundtrackInfo != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Trilha Sonora',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Música Tema em Destaque
                    if (soundtrackInfo!.themeSongTitle != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha:0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.music_note, color: AppColors.primary, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  'Música Tema',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              soundtrackInfo!.themeSongTitle!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (soundtrackInfo!.themeSongArtist != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'por ${soundtrackInfo!.themeSongArtist}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // Botão Spotify da música tema
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final url = soundtrackInfo!.themeSongSpotifyUrl ?? 
                                                soundtrackInfo!.themeSongSearchSpotifyUrl;
                                      if (url != null) {
                                        _launchSoundtrackUrl(url);
                                      }
                                    },
                                    icon: const Icon(Icons.music_note, color: Colors.white),
                                    label: const Text('Spotify', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade600,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Botão YouTube da música tema
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final url = soundtrackInfo!.themeSongYoutubeUrl ?? 
                                                soundtrackInfo!.themeSongSearchYoutubeUrl;
                                      if (url != null) {
                                        _launchSoundtrackUrl(url);
                                      }
                                    },
                                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                                    label: const Text('YouTube', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade600,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Playlists Completas
                    const Text(
                      'Playlist Completa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Botão Spotify Playlist
                        Expanded(
                          child: Card(
                            elevation: 2,
                            child: InkWell(
                              onTap: () {
                                final url = soundtrackInfo!.spotifyPlaylistUrl ?? 
                                          soundtrackInfo!.spotifySearchUrl;
                                _launchSoundtrackUrl(url);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.library_music,
                                      size: 32,
                                      color: Colors.green.shade600,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Spotify',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Playlist no Spotify',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Botão YouTube Playlist
                        Expanded(
                          child: Card(
                            elevation: 2,
                            child: InkWell(
                              onTap: () {
                                final url = soundtrackInfo!.youtubePlaylistUrl ?? 
                                          soundtrackInfo!.youtubeSearchUrl;
                                _launchSoundtrackUrl(url);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.playlist_play,
                                      size: 32,
                                      color: Colors.red.shade600,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'YouTube',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Playlist no YouTube',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}