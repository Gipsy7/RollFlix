import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'utils/app_utils.dart';
import 'services/movie_service.dart';
import 'models/movie.dart';
import 'screens/movie_details_screen.dart';

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
      theme: AppTheme.lightTheme,
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
    final isTablet = ResponsiveUtils.isTablet(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: isMobile ? 200 : 250,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.accent,
                    ],
                  ),
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
                            Container(
                              padding: const EdgeInsets.all(AppConstants.spacingM),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                              ),
                              child: const Icon(
                                Icons.movie_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: AppConstants.spacingL),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppConstants.appName,
                                    style: isMobile 
                                      ? AppTextStyles.displayMedium.copyWith(color: Colors.white)
                                      : AppTextStyles.displayLarge.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: AppConstants.spacingXS),
                                  Text(
                                    'Descubra seu próximo filme favorito',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: Colors.white.withOpacity(0.9),
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
              padding: EdgeInsets.all(isMobile ? AppConstants.spacingL : AppConstants.spacingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Genre Selection
                  Container(
                    padding: EdgeInsets.all(isMobile ? AppConstants.spacingL : AppConstants.spacingXL),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
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
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              ),
                              child: const Icon(
                                Icons.category_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppConstants.spacingM),
                            Text(
                              'Escolha um Gênero',
                              style: isMobile 
                                ? AppTextStyles.headlineSmall
                                : AppTextStyles.headlineMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingL),
                        _buildGenreGrid(context, isMobile, isTablet),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingXL),
                  
                  // Sort Button
                  SizedBox(
                    height: isMobile ? 56 : 64,
                    child: ElevatedButton(
                      onPressed: selectedGenre != null ? _sortearFilme : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.spacingL),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shuffle, size: 24),
                                const SizedBox(width: AppConstants.spacingM),
                                Text(
                                  'Sortear Filme',
                                  style: isMobile 
                                    ? AppTextStyles.labelLarge.copyWith(color: Colors.white)
                                    : AppTextStyles.headlineMedium.copyWith(color: Colors.white),
                                ),
                              ],
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

  Widget _buildGenreGrid(BuildContext context, bool isMobile, bool isTablet) {
    final crossAxisCount = ResponsiveUtils.getResponsiveGridColumns(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genre = genres[index];
        final isSelected = selectedGenre == genre;
        
        return AnimatedContainer(
          duration: AppConstants.fastAnimation,
          curve: Curves.easeInOut,
          child: InkWell(
            onTap: () {
              setState(() {
                selectedGenre = genre;
                selectedMovie = null;
              });
            },
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            child: Container(
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppColors.primaryGradient
                    : null,
                color: isSelected ? null : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.textTertiary.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  genre,
                  style: (isMobile ? AppTextStyles.labelMedium : AppTextStyles.labelLarge).copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieCard(BuildContext context, bool isMobile) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: AnimatedContainer(
            duration: AppConstants.slowAnimation,
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(isMobile ? AppConstants.spacingL : AppConstants.spacingXL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
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
                  // Movie Poster
                  Container(
                    width: isMobile ? 100 : 120,
                    height: isMobile ? 150 : 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                      child: selectedMovie!.fullPosterUrl.isNotEmpty
                          ? Image.network(
                              selectedMovie!.fullPosterUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.surfaceVariant,
                                  child: const Icon(
                                    Icons.movie_outlined,
                                    size: 48,
                                    color: AppColors.textTertiary,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.surfaceVariant,
                              child: const Icon(
                                Icons.movie_outlined,
                                size: 48,
                                color: AppColors.textTertiary,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(width: AppConstants.spacingL),
                  
                  // Movie Info
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
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppConstants.spacingS),
                          ),
                          child: Text(
                            'Filme Sorteado',
                            style: (isMobile ? AppTextStyles.labelSmall : AppTextStyles.labelMedium).copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppConstants.spacingM),
                        
                        AnimatedDefaultTextStyle(
                          duration: AppConstants.slowAnimation,
                          style: (isMobile 
                            ? AppTextStyles.headlineMedium 
                            : AppTextStyles.headlineLarge).copyWith(
                              color: AppColors.textPrimary,
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
                            child: Text(selectedMovie!.year),
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
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.spacingS),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: AppConstants.spacingXS),
                                  Text(
                                    selectedMovie!.voteAverage.toStringAsFixed(1),
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
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
                              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.touch_app_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: AppConstants.spacingXS),
                              Text(
                                'Ver Detalhes',
                                style: (isMobile ? AppTextStyles.labelMedium : AppTextStyles.labelLarge).copyWith(
                                  color: Colors.white,
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
        );
      },
    );
  }
}
