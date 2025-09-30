import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'utils/app_utils.dart';
import 'services/movie_service.dart';
import 'models/movie.dart';
import 'screens/movie_details_screen.dart';
import 'widgets/genre_wheel.dart';
import 'widgets/cinema_animations.dart';

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
    final isMobile = ResponsiveUtils.isMobile(context);
    
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
                    padding: EdgeInsets.all(isMobile ? AppConstants.spacingL : AppConstants.spacingXL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            // Projector Animation
                            const ProjectorAnimation(size: 60),
                            const SizedBox(width: AppConstants.spacingL),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppConstants.appName,
                                    style: AppTextStyles.cinemaTitle.copyWith(
                                      fontSize: isMobile ? 28 : 36,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.spacingXS),
                                  Text(
                                    'Cinema Clássico - Descubra Seu Próximo Filme',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Popcorn Animation
                            const PopcornAnimation(size: 50),
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
              padding: EdgeInsets.all(isMobile ? AppConstants.spacingL : AppConstants.spacingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Genre Selection - Film Strip Style
                  FilmStripDecoration(
                    height: isMobile ? 450 : 500,
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? AppConstants.spacingL : AppConstants.spacingXL),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 20,
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
                                padding: const EdgeInsets.all(AppConstants.spacingS),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                ),
                                child: Icon(
                                  Icons.casino,
                                  color: AppColors.backgroundDark,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingM),
                              Text(
                                'Gire a Roleta dos Gêneros',
                                style: (isMobile 
                                  ? AppTextStyles.headlineSmall
                                  : AppTextStyles.headlineMedium).copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.spacingL),
                          // Roleta de Gêneros
                          Expanded(
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
                  ),
                  
                  const SizedBox(height: AppConstants.spacingXL),
                  
                  // Cinema Ticket Button
                  SizedBox(
                    height: isMobile ? 66 : 74,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(AppConstants.spacingL),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: selectedGenre != null ? _sortearFilme : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.backgroundDark,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.spacingL),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.backgroundDark),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.local_movies, size: 28),
                                  const SizedBox(width: AppConstants.spacingM),
                                  Text(
                                    '🎬 Sortear Filme',
                                    style: (isMobile 
                                      ? AppTextStyles.labelLarge
                                      : AppTextStyles.headlineMedium).copyWith(
                                        color: AppColors.backgroundDark,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.0,
                                      ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingXL),
                  
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
          child: CurtainAnimation(
            isOpen: true,
            child: AnimatedContainer(
              duration: AppConstants.slowAnimation,
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isMobile ? AppConstants.spacingL : AppConstants.spacingXL),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.surfaceDark, AppColors.surfaceVariantDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.backgroundDark.withOpacity(0.8),
                    blurRadius: 40,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(movie: selectedMovie!),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppConstants.spacingL),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Poster with Film Frame
                    Container(
                      width: isMobile ? 100 : 120,
                      height: isMobile ? 150 : 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        border: Border.all(
                          color: AppColors.filmStrip,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radiusL - 4),
                        child: selectedMovie!.fullPosterUrl.isNotEmpty
                            ? Image.network(
                                selectedMovie!.fullPosterUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.surfaceVariantDark,
                                    child: Icon(
                                      Icons.local_movies,
                                      size: 48,
                                      color: AppColors.primary,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: AppColors.surfaceVariantDark,
                                child: Icon(
                                  Icons.local_movies,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(width: AppConstants.spacingL),
                    
                    // Movie Info with Cinema Style
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppConstants.spacingS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingS, 
                              vertical: AppConstants.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(AppConstants.spacingS),
                            ),
                            child: Text(
                              '🎟️ Filme Sorteado',
                              style: (isMobile ? AppTextStyles.labelSmall : AppTextStyles.labelMedium).copyWith(
                                color: AppColors.backgroundDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: AppConstants.spacingM),
                          
                          AnimatedDefaultTextStyle(
                            duration: AppConstants.slowAnimation,
                            style: (isMobile 
                              ? AppTextStyles.headlineMedium 
                              : AppTextStyles.headlineLarge).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                    color: AppColors.backgroundDark.withOpacity(0.5),
                                  ),
                                ],
                            ),
                            child: Text(
                              selectedMovie!.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          if (selectedMovie!.year.isNotEmpty) ...[
                            const SizedBox(height: AppConstants.spacingS),
                            AnimatedDefaultTextStyle(
                              duration: AppConstants.slowAnimation,
                              style: (isMobile 
                                ? AppTextStyles.bodyMedium 
                                : AppTextStyles.bodyLarge).copyWith(
                                  color: AppColors.textSecondary,
                              ),
                              child: Text('📅 ${selectedMovie!.year}'),
                            ),
                          ],
                          
                          const SizedBox(height: AppConstants.spacingM),
                          
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spacingS, 
                                  vertical: AppConstants.spacingXS,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppConstants.spacingS),
                                  border: Border.all(
                                    color: AppColors.accent,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: AppColors.accent,
                                      size: 16,
                                    ),
                                    const SizedBox(width: AppConstants.spacingXS),
                                    Text(
                                      selectedMovie!.voteAverage.toStringAsFixed(1),
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: AppConstants.spacingL),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingM, 
                              vertical: AppConstants.spacingS,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.8)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.play_circle_outline,
                                  color: AppColors.textPrimary,
                                  size: 16,
                                ),
                                const SizedBox(width: AppConstants.spacingXS),
                                Text(
                                  'Ver Detalhes',
                                  style: (isMobile ? AppTextStyles.labelMedium : AppTextStyles.labelLarge).copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
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
            ),
          ),
        );
      },
    );
  }
}
