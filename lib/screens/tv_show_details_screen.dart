import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/tv_show.dart';
import '../models/cast.dart';
import '../models/watch_providers.dart';
import '../models/movie_videos.dart';
import '../services/movie_service.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 300,
      pinned: true,
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
                    Colors.black.withOpacity(0.7),
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
                          color: Colors.purple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.purple.withOpacity(0.5),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Onde assistir no Brasil',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (watchProviders!.flatrate.isNotEmpty) ...[
            Text(
              'Streaming:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            _buildProvidersList(watchProviders!.flatrate),
            const SizedBox(height: 16),
          ],
          if (watchProviders!.rent.isNotEmpty) ...[
            Text(
              'Aluguel:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            _buildProvidersList(watchProviders!.rent),
            const SizedBox(height: 16),
          ],
          if (watchProviders!.buy.isNotEmpty) ...[
            Text(
              'Compra:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            _buildProvidersList(watchProviders!.buy),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProvidersList(List<WatchProvider> providers) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: providers.map((provider) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://image.tmdb.org/t/p/w92${provider.logoPath}',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 40,
                height: 40,
                color: Colors.grey[800],
                child: Text(
                  provider.providerName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        );
      }).toList(),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActorDetailsScreen(
                actorId: actor.id,
                actorName: actor.name,
              ),
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