import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'utils/app_utils.dart' as AppUtils;
import 'services/movie_service.dart';
import 'models/movie.dart';
import 'screens/movie_details_screen.dart';
import 'widgets/genre_wheel.dart';
import 'widgets/common_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkCinemaTheme,
      home: const MovieSorterApp(),
    );
  }
}

class MovieSorterApp extends StatefulWidget {
  const MovieSorterApp({super.key});

  @override
  State<MovieSorterApp> createState() => _MovieSorterAppState();
}

class _MovieSorterAppState extends State<MovieSorterApp> with TickerProviderStateMixin {
  String? selectedGenre;
  Movie? selectedMovie;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> genres = AppConstants.movieGenres;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.slowAnimation,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _sortearFilme() async {
    if (selectedGenre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um gênero primeiro!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      selectedMovie = null;
    });

    try {
      final movie = await MovieService.getRandomMovieByGenre(selectedGenre!);
      
      setState(() {
        selectedMovie = movie;
        isLoading = false;
      });

      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar filme: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppUtils.ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Modern Cinema App Bar
          SliverAppBar(
            expandedHeight: isMobile ? 200 : 250,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.cinemaGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 20 : 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            // RollFlix Logo
                            Container(
                              width: isMobile ? 60 : 70,
                              height: isMobile ? 60 : 70,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.glassGradient,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SvgPicture.asset(
                                  'assets/images/rollflix_logo.svg',
                                  fit: BoxFit.contain,
                                  // ignore: deprecated_member_use
                                  color: null, // Preserve original colors
                                  placeholderBuilder: (context) {
                                    // Fallback para ícone se a imagem não for encontrada
                                    return Icon(
                                      Icons.movie_filter,
                                      color: AppColors.backgroundDark,
                                      size: 32,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppConstants.appName,
                                    style: AppTextStyles.headlineLarge.copyWith(
                                      fontSize: isMobile ? 28 : 36,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      shadows: [
                                        Shadow(
                                          color: AppColors.backgroundDark.withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Roll and Chill',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textPrimary.withOpacity(0.9),
                                      fontWeight: FontWeight.w400,
                                      shadows: [
                                        Shadow(
                                          color: AppColors.backgroundDark.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Genre Selection Card
                  AppCard(
                    padding: EdgeInsets.all(isMobile ? 24 : 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.casino,
                                color: AppColors.backgroundDark, // Preto no fundo dourado
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Escolha um Gênero',
                              style: (isMobile 
                                ? AppTextStyles.headlineSmall
                                : AppTextStyles.headlineMedium).copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Genre Wheel Container - Invisível
                        Container(
                          height: isMobile ? 400 : 450,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: GenreWheel(
                            genres: genres,
                            selectedGenre: selectedGenre,
                            onGenreSelected: (genre) {
                              setState(() {
                                selectedGenre = genre;
                                selectedMovie = null;
                              });
                            },
                            onRandomSpin: () {
                              // Opcional: adicionar efeitos visuais durante o giro
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Modern Action Button
                  AppButton(
                    onPressed: selectedGenre != null ? _sortearFilme : null,
                    text: isLoading ? 'Rolando...' : 'Rolar Filme',
                    isLoading: isLoading,
                    icon: isLoading ? null : Icons.local_movies,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Movie Result
                  if (selectedMovie != null) _buildMovieCard(context, isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, bool isMobile) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: AppCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(movie: selectedMovie!),
                ),
              );
            },
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster with Modern Frame
                Container(
                  width: isMobile ? 100 : 120,
                  height: isMobile ? 150 : 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: AppColors.glassGradient,
                    border: Border.all(
                      color: AppColors.interactive.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.interactive.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: selectedMovie!.posterPath.isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500${selectedMovie!.posterPath}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: const BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                ),
                                child: Icon(
                                  Icons.movie,
                                  color: AppColors.backgroundDark, // Preto no fundo dourado
                                  size: 48,
                                ),
                              );
                            },
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: AppColors.primaryGradient,
                            ),
                            child: Icon(
                              Icons.movie,
                              color: AppColors.backgroundDark, // Preto no fundo dourado
                              size: 48,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Movie Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with modern styling
                      Text(
                        selectedMovie!.title,
                        style: (isMobile 
                            ? AppTextStyles.headlineSmall
                            : AppTextStyles.headlineMedium).copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Release Date with Icon
                      if (selectedMovie!.releaseDate.isNotEmpty) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundDark,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: AppColors.primary, // Amarelo no fundo preto
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppUtils.DateUtils.formatReleaseDate(selectedMovie!.releaseDate),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      // Rating with Stars
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.primary, // Sempre amarelo
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${selectedMovie!.voteAverage.toStringAsFixed(1)}/10',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Overview
                      if (selectedMovie!.overview.isNotEmpty) ...[
                        Text(
                          selectedMovie!.overview,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          maxLines: isMobile ? 3 : 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Action Hint
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 16,
                              color: AppColors.primary, // Amarelo no fundo preto
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Toque para mais detalhes',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary, // Amarelo no fundo preto
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
