import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:palette_generator/palette_generator.dart';
import '../models/movie.dart';
import '../models/cast.dart';
import '../models/watch_providers.dart';
import '../models/movie_videos.dart';
import '../models/soundtrack.dart';
import '../services/movie_service.dart';
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
  
  // Adaptive colors
  Color primaryColor = const Color(0xFF6366F1);
  Color backgroundColor = Colors.white;
  Color surfaceColor = const Color(0xFFF8FAFC);
  Color onSurfaceColor = const Color(0xFF1E293B);
  Color secondaryColor = const Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
    _extractColorsFromImage();
  }

  Future<void> _extractColorsFromImage() async {
    final movie = widget.movie;
    if (movie.fullPosterUrl.isNotEmpty) {
      try {
        final paletteGenerator = await PaletteGenerator.fromImageProvider(
          NetworkImage(movie.fullPosterUrl),
          maximumColorCount: 20,
        );

        if (mounted) {
          setState(() {
            final dominantColor = paletteGenerator.dominantColor?.color ?? const Color(0xFF6366F1);
            final vibrantColor = paletteGenerator.vibrantColor?.color ?? const Color(0xFF8B5CF6);
            
            primaryColor = dominantColor;
            secondaryColor = vibrantColor;
            
            // Calculate contrasting colors for text
            final luminance = dominantColor.computeLuminance();
            onSurfaceColor = luminance > 0.5 ? const Color(0xFF1E293B) : Colors.white;
            
            // Create a lighter version for surface
            surfaceColor = Color.lerp(dominantColor, Colors.white, 0.85) ?? const Color(0xFFF8FAFC);
            backgroundColor = Color.lerp(dominantColor, Colors.white, 0.95) ?? Colors.white;
          });
        }
      } catch (e) {
        // Keep default colors if extraction fails
      }
    }
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
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: primaryColor,
            foregroundColor: onSurfaceColor,
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 500),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: onSurfaceColor,
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
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    child: const Text('Sinopse'),
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
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
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
                            avatar: const Icon(
                              Icons.movie_filter,
                              size: 16,
                              color: Colors.purple,
                            ),
                            label: Text(
                              director.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: Colors.purple.shade50,
                            side: BorderSide(
                              color: Colors.purple.shade200,
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
                        color: primaryColor,
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
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      child: const Text('Onde Assistir'),
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

                  // Seção Trilha Sonora
                  if (soundtrackInfo != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Trilha Sonora',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Música Tema em Destaque
                    if (soundtrackInfo!.themeSongTitle != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade100, Colors.blue.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.music_note, color: Colors.purple.shade700, size: 24),
                                const SizedBox(width: 8),
                                const Text(
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