import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/tv_show.dart';
import '../models/cast.dart';
import '../models/watch_providers.dart';
import '../models/movie_videos.dart';
import '../models/soundtrack.dart';
import '../services/movie_service.dart';
import '../utils/page_transitions.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/watched_controller.dart';
import '../controllers/user_preferences_controller.dart';
import 'actor_details_screen.dart';

class TVShowDetailsScreen extends StatefulWidget {
  final TVShow tvShow;

  const TVShowDetailsScreen({super.key, required this.tvShow});

  @override
  State<TVShowDetailsScreen> createState() => _TVShowDetailsScreenState();
}

class _TVShowDetailsScreenState extends State<TVShowDetailsScreen> {
  TVShow? detailedTVShow;
  MovieCredits? credits;
  WatchProviders? watchProviders;
  MovieVideos? tvShowVideos;
  SoundtrackInfo? soundtrackInfo;
  bool isLoading = true;
  late final FavoritesController _favoritesController;
  late final WatchedController _watchedController;

  @override
  void initState() {
    super.initState();
    _favoritesController = FavoritesController.instance;
    _watchedController = WatchedController.instance;
    _loadTVShowDetails();
  }

  Future<void> _loadTVShowDetails() async {
    try {
      final results = await Future.wait([
        MovieService.getTVShowDetails(widget.tvShow.id),
        MovieService.getTVShowCredits(widget.tvShow.id),
        MovieService.getTVShowWatchProviders(widget.tvShow.id),
        MovieService.getTVShowVideos(widget.tvShow.id),
      ]);

      setState(() {
        detailedTVShow = results[0] as TVShow;
        credits = results[1] as MovieCredits;
        watchProviders = results[2] as WatchProviders?;
        tvShowVideos = results[3] as MovieVideos?;
        soundtrackInfo = MovieService.getTVShowSoundtrackInfo(results[0] as TVShow);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        ),
      );
    }

    if (detailedTVShow == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            'Erro ao carregar detalhes da série',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTVShowInfo(),
                if (detailedTVShow!.overview.isNotEmpty) _buildOverview(),
                if (credits?.cast.isNotEmpty == true) _buildCastSection(),
                if (credits?.crew.isNotEmpty == true) _buildCrewSection(),
                if (watchProviders != null) _buildWatchProvidersSection(),
                if (tvShowVideos?.results.isNotEmpty == true) _buildVideosSection(),
                if (soundtrackInfo != null) _buildSoundtrackSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareTVShow() {
    final tvShow = detailedTVShow ?? widget.tvShow;
    final year = tvShow.firstAirDate.isNotEmpty 
        ? tvShow.firstAirDate.split('-')[0] 
        : '';
    final rating = tvShow.voteAverage > 0 
        ? '⭐ ${tvShow.voteAverage.toStringAsFixed(1)}/10' 
        : '';
    
    String shareText = '📺 ${tvShow.name}';
    if (year.isNotEmpty) {
      shareText += ' ($year)';
    }
    shareText += '\n\n';
    
    if (rating.isNotEmpty) {
      shareText += '$rating\n\n';
    }
    
    if (tvShow.numberOfSeasons > 0) {
      shareText += '📺 ${tvShow.numberOfSeasons} temporada${tvShow.numberOfSeasons > 1 ? 's' : ''}';
      if (tvShow.numberOfEpisodes > 0) {
        shareText += ' • ${tvShow.numberOfEpisodes} episódios';
      }
      shareText += '\n\n';
    }
    
    if (tvShow.overview.isNotEmpty) {
      shareText += '📖 ${tvShow.overview}\n\n';
    }
    
    if (tvShow.genres.isNotEmpty) {
      final genres = tvShow.genres.map((g) => g.name).join(', ');
      shareText += '🎭 Gêneros: $genres\n\n';
    }
    
    shareText += '🍿 Descubra mais séries incríveis no RollFlix!';
    
    SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: tvShow.name,
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 300,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: 'Compartilhar série',
          onPressed: _shareTVShow,
        ),
        // Botão de Assistido
        ListenableBuilder(
          listenable: _watchedController,
          builder: (context, _) {
            final isWatched = _watchedController.isTVShowWatched(widget.tvShow);
            return IconButton(
              icon: Icon(
                isWatched ? Icons.check_circle : Icons.check_circle_outline,
                color: isWatched ? Colors.green : Colors.white,
              ),
              tooltip: isWatched ? 'Marcar como não assistido' : 'Marcar como assistido',
              onPressed: () async {
                // Se está desmarcando, não consome recurso
                if (isWatched) {
                  _watchedController.toggleTVShowWatched(widget.tvShow);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removido de assistidos'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                
                // Se está marcando, tenta usar recurso
                final userPrefsController = UserPreferencesController.instance;
                final consumed = await userPrefsController.tryUseResourceWithAd(
                  ResourceType.watched,
                  context,
                );
                
                if (!consumed) {
                  // Usuário cancelou ou anúncio não disponível
                  return;
                }

                _watchedController.toggleTVShowWatched(widget.tvShow);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Marcado como assistido'),
                    duration: Duration(seconds: 2),
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
            final isFavorite = _favoritesController.isTVShowFavorite(widget.tvShow);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
              tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
              onPressed: () async {
                // Se está desmarcando, não consome recurso
                if (isFavorite) {
                  _favoritesController.toggleTVShowFavorite(widget.tvShow);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removido dos favoritos'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                
                // Se está marcando, tenta usar recurso
                final userPrefsController = UserPreferencesController.instance;
                final consumed = await userPrefsController.tryUseResourceWithAd(
                  ResourceType.favorite,
                  context,
                );
                
                if (!consumed) {
                  // Usuário cancelou ou anúncio não disponível
                  return;
                }

                _favoritesController.toggleTVShowFavorite(widget.tvShow);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Adicionado aos favoritos'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (detailedTVShow!.backdropPath.isNotEmpty)
              Image.network(
                'https://image.tmdb.org/t/p/w780${detailedTVShow!.backdropPath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: const Icon(
                      Icons.tv,
                      size: 64,
                      color: Colors.white54,
                    ),
                  );
                },
              )
            else
              Container(
                color: Colors.grey[900],
                child: const Icon(
                  Icons.tv,
                  size: 64,
                  color: Colors.white54,
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
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildTVShowInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: detailedTVShow!.posterPath.isNotEmpty
                ? Image.network(
                    'https://image.tmdb.org/t/p/w300${detailedTVShow!.posterPath}',
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 180,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.tv,
                          size: 40,
                          color: Colors.white54,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 120,
                    height: 180,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.tv,
                      size: 40,
                      color: Colors.white54,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detailedTVShow!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (detailedTVShow!.firstAirDate.isNotEmpty)
                  Text(
                    'Primeira exibição: ${_formatDate(detailedTVShow!.firstAirDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                if (detailedTVShow!.numberOfSeasons > 0)
                  Text(
                    '${detailedTVShow!.numberOfSeasons} temporada${detailedTVShow!.numberOfSeasons > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                if (detailedTVShow!.numberOfEpisodes > 0)
                  Text(
                    '${detailedTVShow!.numberOfEpisodes} episódio${detailedTVShow!.numberOfEpisodes > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                if (detailedTVShow!.voteAverage > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        detailedTVShow!.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '/10',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                if (detailedTVShow!.genres.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: detailedTVShow!.genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha:0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.purple.withValues(alpha:0.5),
                          ),
                        ),
                        child: Text(
                          genre.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
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
    );
  }

  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sinopse',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detailedTVShow!.overview,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Elenco',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: credits!.cast.length > 10 ? 10 : credits!.cast.length,
            itemBuilder: (context, index) {
              final actor = credits!.cast[index];
              return _buildActorCard(actor);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCrewSection() {
    final directors = credits!.crew.where((member) => member.job == 'Director').toList();
    final writers = credits!.crew.where((member) => 
      member.job == 'Writer' || 
      member.job == 'Screenplay' || 
      member.job == 'Story'
    ).toList();
    
    if (directors.isEmpty && writers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Equipe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (directors.isNotEmpty) ...[
            Text(
              'Direção: ${directors.map((d) => d.name).join(', ')}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (writers.isNotEmpty) ...[
            Text(
              'Roteiro: ${writers.map((w) => w.name).join(', ')}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[300],
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWatchProvidersSection() {
    if (watchProviders == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[900]!,
            Colors.grey[850]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withValues(alpha:0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha:0.1),
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
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.purple.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha:0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Onde Assistir',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: watchProviders!.flatrate.map((provider) {
                return GestureDetector(
                  onTap: () {
                    // TODO: Implementar abertura do provedor
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withValues(alpha:0.9),
                          Colors.purple.shade300.withValues(alpha:0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha:0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.logoPath.isNotEmpty)
                          Image.network(
                            'https://image.tmdb.org/t/p/w92${provider.logoPath}',
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.tv,
                                size: 16,
                                color: Colors.white,
                              );
                            },
                          )
                        else
                          const Icon(
                            Icons.tv,
                            size: 16,
                            color: Colors.white,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          provider.providerName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.open_in_new,
                          size: 12,
                          color: Colors.white,
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
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: watchProviders!.rent.map((provider) {
                return GestureDetector(
                  onTap: () {
                    // TODO: Implementar abertura do provedor
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.shade300,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.shade300.withValues(alpha:0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.logoPath.isNotEmpty)
                          Image.network(
                            'https://image.tmdb.org/t/p/w92${provider.logoPath}',
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.tv,
                                size: 16,
                                color: Colors.purple.shade300,
                              );
                            },
                          )
                        else
                          Icon(
                            Icons.tv,
                            size: 16,
                            color: Colors.purple.shade300,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          provider.providerName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.open_in_new,
                          size: 12,
                          color: Colors.purple.shade300,
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
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: watchProviders!.buy.map((provider) {
                return GestureDetector(
                  onTap: () {
                    // TODO: Implementar abertura do provedor
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[850]!,
                          Colors.grey[800]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.shade400,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.shade400.withValues(alpha:0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.logoPath.isNotEmpty)
                          Image.network(
                            'https://image.tmdb.org/t/p/w92${provider.logoPath}',
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.tv,
                                size: 16,
                                color: Colors.purple.shade400,
                              );
                            },
                          )
                        else
                          Icon(
                            Icons.tv,
                            size: 16,
                            color: Colors.purple.shade400,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          provider.providerName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.open_in_new,
                          size: 12,
                          color: Colors.purple.shade400,
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
    );
  }

  Widget _buildVideosSection() {
    final trailers = tvShowVideos!.results.where((video) => 
      video.type == 'Trailer' && video.site == 'YouTube'
    ).toList();

    if (trailers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Trailers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trailers.length,
            itemBuilder: (context, index) {
              final video = trailers[index];
              return _buildVideoCard(video);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildActorCard(CastMember actor) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushDetails(
            ActorDetailsScreen(
              actorId: actor.id,
              actorName: actor.name,
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: actor.profilePath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w185${actor.profilePath}',
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 120,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white54,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 100,
                      height: 120,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white54,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              actor.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (actor.character.isNotEmpty)
              Text(
                actor.character,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(MovieVideo video) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _launchYouTube(video.key),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.play_circle_fill,
                  size: 40,
                  color: Colors.purple,
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  video.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchYouTube(String videoKey) async {
    final url = 'https://www.youtube.com/watch?v=$videoKey';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _launchSoundtrackUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Widget _buildSoundtrackSection() {
    if (soundtrackInfo == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trilha Sonora',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Música Tema em Destaque
          if (soundtrackInfo!.themeSongTitle != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withValues(alpha:0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.music_note, color: Colors.purple, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Música Tema',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    soundtrackInfo!.themeSongTitle!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (soundtrackInfo!.themeSongArtist != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'por ${soundtrackInfo!.themeSongArtist}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
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
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Botão Spotify Playlist
              Expanded(
                child: Card(
                  color: Colors.grey[900],
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
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Playlist no Spotify',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Botão YouTube Playlist
              Expanded(
                child: Card(
                  color: Colors.grey[900],
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
                            Icons.play_circle_filled,
                            size: 32,
                            color: Colors.red.shade600,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'YouTube',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Playlist no YouTube',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return date;
    } catch (e) {
      return date;
    }
  }
}