import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';
import '../models/cast.dart';
import '../models/watch_providers.dart';
import '../models/movie_videos.dart';
import '../services/movie_service.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        detailedMovie = widget.movie;
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

  @override
  Widget build(BuildContext context) {
    final movie = detailedMovie ?? widget.movie;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
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
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.movie,
                        size: 100,
                        color: Colors.grey,
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
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.movie,
                                  size: 60,
                                  color: Colors.grey,
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
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  '/10',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
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
                                  color: Colors.grey.shade600,
                                ),
                              ),
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
                  const Text(
                    'Sinopse',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview.isNotEmpty ? movie.overview : 'Sinopse não disponível.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Diretor
                  if (credits?.directors.isNotEmpty == true) ...[
                    const Text(
                      'Direção',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      credits!.directors.map((d) => d.name).join(', '),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Elenco principal
                  if (credits?.cast.isNotEmpty == true) ...[
                    const Text(
                      'Elenco Principal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (credits!.cast.length > 10) ? 10 : credits!.cast.length,
                        itemBuilder: (context, index) {
                          final actor = credits!.cast[index];
                          return Container(
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
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.person,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 80,
                                          height: 120,
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  actor.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  actor.character,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Vídeos/Trailers adicionais
                  if (movieVideos != null && movieVideos!.results.length > 1) ...[
                    const Text(
                      'Vídeos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
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
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Erro ao abrir vídeo'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
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
                    const Text(
                      'Onde Assistir',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    if (watchProviders!.flatrate.isNotEmpty) ...[
                      const Text(
                        'Streaming (Incluído na assinatura):',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.green),
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
                                        return const Icon(Icons.tv, size: 16);
                                      },
                                    )
                                  else
                                    const Icon(Icons.tv, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    provider.providerName,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.open_in_new, size: 12),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (watchProviders!.rent.isNotEmpty) ...[
                      const Text(
                        'Aluguel:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange),
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
                                        return const Icon(Icons.movie, size: 16);
                                      },
                                    )
                                  else
                                    const Icon(Icons.movie, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    provider.providerName,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.open_in_new, size: 12),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (watchProviders!.buy.isNotEmpty) ...[
                      const Text(
                        'Compra:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue),
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
                                        return const Icon(Icons.shopping_cart, size: 16);
                                      },
                                    )
                                  else
                                    const Icon(Icons.shopping_cart, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    provider.providerName,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.open_in_new, size: 12),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ] else ...[
                    const Text(
                      'Onde Assistir',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Informações de streaming não disponíveis no momento.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
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