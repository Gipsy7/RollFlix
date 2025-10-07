import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/movie.dart';
import '../models/date_night_combo.dart';
import '../models/watch_providers.dart';
import '../services/movie_service.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/common_widgets.dart';
import 'date_night_details_screen.dart';
import 'date_night_preferences_screen.dart';
import 'date_night_games_screen.dart';

class DateNightScreen extends StatefulWidget {
  const DateNightScreen({super.key});

  @override
  State<DateNightScreen> createState() => _DateNightScreenState();
}

class _DateNightScreenState extends State<DateNightScreen> {
  String? _selectedDateType;
  DateNightCombo? _currentCombo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Seleciona automaticamente o primeiro tipo
    final dateTypes = DateNightService.getAvailableDateTypes();
    if (dateTypes.isNotEmpty) {
      _selectedDateType = dateTypes.first;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Cores do tema romântico
  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);
  static const Color _darkRose = Color(0xFF880E4F);

  LinearGradient get _romanticGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _darkRose,
      _primaryRose,
      _secondaryGold,
    ],
  );

  Future<void> _generateDateNight() async {
    if (_selectedDateType == null) {
      _showError('Selecione um tipo de encontro primeiro');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Buscar filmes românticos baseado no tipo selecionado
      List<Movie> movies = [];
      
      switch (_selectedDateType) {
        case 'Romance Clássico':
          movies = await MovieService.getMoviesByGenre('Romance');
          break;
        case 'Comédia Romântica':
          final comedyRomanceMovies = await MovieService.getMoviesByGenres([35, 10749]); // Comedy + Romance
          movies = comedyRomanceMovies ?? [];
          break;
        case 'Drama Romântico':
          final dramaRomanceMovies = await MovieService.getMoviesByGenres([18, 10749]); // Drama + Romance
          movies = dramaRomanceMovies ?? [];
          break;
        case 'Musical Romântico':
          final musicalRomanceMovies = await MovieService.getMoviesByGenres([10402, 10749]); // Music + Romance
          movies = musicalRomanceMovies ?? [];
          break;
        case 'Romance Aventureiro':
          final adventureRomanceMovies = await MovieService.getMoviesByGenres([12, 10749]); // Adventure + Romance
          movies = adventureRomanceMovies ?? [];
          break;
        case 'Suspense Romântico':
          final thrillerRomanceMovies = await MovieService.getMoviesByGenres([53, 10749]); // Thriller + Romance
          movies = thrillerRomanceMovies ?? [];
          break;
        default:
          movies = await MovieService.getMoviesByGenre('Romance');
      }

      if (movies.isNotEmpty) {
        // Filtrar filmes com boa avaliação para encontros românticos
        final goodMovies = movies.where((movie) => movie.voteAverage >= 6.0).toList();
        final selectedMovies = goodMovies.isNotEmpty ? goodMovies : movies;
        
        // Sortear um filme
        final randomMovie = selectedMovies[DateTime.now().millisecondsSinceEpoch % selectedMovies.length];
        
        // Buscar detalhes completos do filme
        Movie detailedMovie;
        List<Map<String, dynamic>> watchProviders = [];
        try {
          final results = await Future.wait([
            MovieService.getMovieDetails(randomMovie.id),
            MovieService.getWatchProviders(randomMovie.id),
          ]);
          
          detailedMovie = results[0] as Movie;
          final watchProvidersData = results[1] as WatchProviders?;
          
          // Converter watch providers para o formato do combo
          if (watchProvidersData != null) {
            watchProviders = [
              ...watchProvidersData.flatrate.map((p) => {
                'name': p.providerName,
                'logoPath': p.logoPath,
                'type': 'streaming',
                'providerId': p.providerId,
              }),
              ...watchProvidersData.rent.map((p) => {
                'name': p.providerName,
                'logoPath': p.logoPath,
                'type': 'rent',
                'providerId': p.providerId,
              }),
              ...watchProvidersData.buy.map((p) => {
                'name': p.providerName,
                'logoPath': p.logoPath,
                'type': 'buy',
                'providerId': p.providerId,
              }),
            ];
          }
        } catch (e) {
          detailedMovie = randomMovie; // Fallback para o filme básico
        }
        
        // Criar combo de encontro com informações completas
        final combo = DateNightCombo.fromMovie(
          movieId: detailedMovie.id,
          title: detailedMovie.title,
          year: detailedMovie.releaseDate.isNotEmpty 
              ? detailedMovie.releaseDate.split('-')[0] 
              : 'N/A',
          posterPath: detailedMovie.posterPath,
          backdropPath: detailedMovie.backdropPath,
          rating: detailedMovie.voteAverage,
          overview: detailedMovie.overview,
          genres: detailedMovie.genres.map((g) => g.name).toList(),
          runtime: detailedMovie.formattedRuntime,
          releaseDate: detailedMovie.formattedReleaseDate,
          originalLanguage: detailedMovie.originalLanguage,
          productionCompanies: detailedMovie.productionCompanies,
          watchProviders: watchProviders,
          mealType: DateNightService.getMovieTypeKey(_selectedDateType!),
        );

        setState(() {
          _currentCombo = combo;
        });

        // Auto-navegar para os detalhes do encontro após criar
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _viewComboDetails();
          });
        }

      } else {
        _showError('Nenhum filme encontrado para este tipo de encontro');
      }
    } catch (e) {
      _showError('Erro ao gerar encontro: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewComboDetails() {
    if (_currentCombo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DateNightDetailsScreen(combo: _currentCombo!),
        ),
      );
    }
  }

  void _openPreferences() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DateNightPreferencesScreen(),
      ),
    );
  }

  void _openGames() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DateNightGamesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: _romanticGradient.scale(0.1),
        ),
        child: CustomScrollView(
          slivers: [
            _buildHeader(isMobile),
            _buildContent(isMobile),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: SafeText(
        'Date Night',
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.casino, color: Colors.white),
          onPressed: _openGames,
          tooltip: 'Jogos & Atividades',
        ),
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.white),
          onPressed: _openPreferences,
          tooltip: 'Preferências',
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: _romanticGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        decoration: BoxDecoration(
          gradient: _romanticGradient.scale(0.3),
        ),
        child: Column(
          children: [
            // Ícone principal (menor)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _romanticGradient.scale(0.8),
                boxShadow: [
                  BoxShadow(
                    color: _primaryRose.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            // Título e descrição (mais compactos)
            SafeText(
              'Encontro Perfeito',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 22 : 28,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 20),
              child: SafeText(
                'Filme romântico + refeição especial 💕',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                  fontSize: isMobile ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDateTypeSelection(isMobile),
            const SizedBox(height: 16),
            _buildGenerateButton(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTypeSelection(bool isMobile) {
    final dateTypes = DateNightService.getAvailableDateTypes();
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryRose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: _primaryRose,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              SafeText(
                'Escolha o Estilo',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Grid de tipos de encontro (mais compacto)
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              double childAspectRatio;
              
              if (constraints.maxWidth < 600) {
                crossAxisCount = 2; // 2 colunas no mobile
                childAspectRatio = 1.3;
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 3;
                childAspectRatio = 1.4;
              } else {
                crossAxisCount = 5;
                childAspectRatio = 1.2;
              }
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: dateTypes.length,
                itemBuilder: (context, index) {
                  final dateType = dateTypes[index];
                  final isSelected = _selectedDateType == dateType;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateType = dateType;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? _romanticGradient.scale(0.8)
                            : LinearGradient(
                                colors: [
                                  AppColors.surfaceDark.withValues(alpha: 0.95),
                                  AppColors.backgroundDark.withValues(alpha: 0.9),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? _primaryRose
                              : AppColors.textSecondary.withValues(alpha: 0.4),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected 
                          ? [
                              BoxShadow(
                                color: _primaryRose.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconForDateType(dateType),
                            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          SafeText(
                            dateType,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.95),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForDateType(String dateType) {
    switch (dateType) {
      case 'Romance Clássico':
        return Icons.local_florist;
      case 'Comédia Romântica':
        return Icons.emoji_emotions;
      case 'Drama Romântico':
        return Icons.theater_comedy;
      case 'Musical Romântico':
        return Icons.music_note;
      case 'Romance Aventureiro':
        return Icons.explore;
      case 'Suspense Romântico':
        return Icons.visibility;
      default:
        return Icons.favorite;
    }
  }

  Widget _buildGenerateButton(bool isMobile) {
    return AppButton(
      onPressed: _selectedDateType != null && !_isLoading ? _generateDateNight : null,
      text: _isLoading ? 'Preparando...' : '💕 Criar Encontro Perfeito',
      isLoading: _isLoading,
      icon: _isLoading ? null : Icons.auto_awesome,
      backgroundColor: _primaryRose,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 16 : 20,
        horizontal: 24,
      ),
    );
  }
}
