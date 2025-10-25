import 'package:flutter/material.dart';

import '../models/date_night_combo.dart';
import '../models/date_night_preferences.dart';
import '../models/movie.dart';
import '../models/recipe.dart';
import '../models/watch_providers.dart';
import '../services/movie_service.dart';
import '../services/preferences_service.dart';
import '../services/recipe_service_firebase.dart';
import '../theme/app_theme.dart';
import '../utils/app_logger.dart';
import '../utils/page_transitions.dart';
import '../widgets/common_widgets.dart';
import '../widgets/responsive_widgets.dart';
import 'date_night_details_screen.dart';
import 'date_night_preferences_screen.dart';
import 'package:rollflix/l10n/app_localizations.dart';

class DateNightScreen extends StatefulWidget {
  const DateNightScreen({super.key});

  @override
  State<DateNightScreen> createState() => _DateNightScreenState();
}

class _DateNightScreenState extends State<DateNightScreen> {
  String? _selectedDateType;
  DateNightCombo? _currentCombo;
  bool _isLoading = false;
  DateNightPreferences _preferences = const DateNightPreferences();

  @override
  void initState() {
    super.initState();

    // Seleciona automaticamente o primeiro tipo
    final dateTypes = DateNightService.getAvailableDateTypes(AppLocalizations.of(context));
    if (dateTypes.isNotEmpty) {
      _selectedDateType = dateTypes.first;
    }

    // Carregar preferências salvas
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await PreferencesService.loadPreferences();
    setState(() {
      _preferences = prefs;
    });
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
      _showError(AppLocalizations.of(context)!.selectDateNightType);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Buscar filmes românticos baseado no tipo selecionado
      final movieTypeKey = DateNightService.getMovieTypeKey(_selectedDateType!, AppLocalizations.of(context));
      List<Movie> movies = [];
      
      switch (movieTypeKey) {
        case 'romance_classic':
          movies = await MovieService.getMoviesByGenre('Romance');
          break;
        case 'romantic_comedy':
          final comedyRomanceMovies = await MovieService.getMoviesByGenres([35, 10749]); // Comedy + Romance
          movies = comedyRomanceMovies ?? [];
          break;
        case 'drama_romantic':
          final dramaRomanceMovies = await MovieService.getMoviesByGenres([18, 10749]); // Drama + Romance
          movies = dramaRomanceMovies ?? [];
          break;
        case 'musical_romance':
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
        // Filtrar apenas filmes bem avaliados para encontros românticos (>= 7.0)
        final goodMovies = movies.where((movie) => movie.voteAverage >= 7.0).toList();
        final selectedMovies = goodMovies.isNotEmpty ? goodMovies : movies;
        
        // Sortear um filme
        final randomMovie = selectedMovies[DateTime.now().millisecondsSinceEpoch % selectedMovies.length];
        
        // Buscar detalhes completos do filme e receitas em paralelo
        Movie detailedMovie;
        List<Map<String, dynamic>> watchProviders = [];
        Map<String, Recipe>? recipeMenu;
        
        try {
          final cuisine = RecipeServiceFirebase.getDateTypeCuisine(_selectedDateType!);
          final diet = RecipeServiceFirebase.getDietFromRestriction(_preferences.dietaryRestriction.toString());
          
          AppLogger.debug('🍽️ Preferências aplicadas:');
          AppLogger.debug('  - Restrição Dietética: ${_preferences.dietaryRestriction}');
          AppLogger.debug('  - Diet para API: $diet');
          AppLogger.debug('  - Culinária: $cuisine');
          
          final results = await Future.wait([
            MovieService.getMovieDetails(randomMovie.id),
            MovieService.getWatchProviders(randomMovie.id),
            RecipeServiceFirebase.generateDateNightMenu(
              cuisine: cuisine,
              diet: diet,
              dateType: _selectedDateType, // Passa o tipo para fallback apropriado
            ),
          ]);
          
          detailedMovie = results[0] as Movie;
          final watchProvidersData = results[1] as WatchProviders?;
          recipeMenu = results[2] as Map<String, Recipe>?;
          
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
          recipeMenu = null; // Usar dados estáticos se a API falhar
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
          mealType: DateNightService.getMovieTypeKey(_selectedDateType!, AppLocalizations.of(context)),
          localizations: AppLocalizations.of(context),
        );

        // Atualizar combo com dados das receitas se disponível
        if (recipeMenu != null) {
          final mainCourse = recipeMenu['mainCourse'];
          final dessert = recipeMenu['dessert'];
          final appetizer = recipeMenu['appetizer'];
          final sideDish = recipeMenu['sideDish'];
          
          // Log para verificar se os IDs estão corretos
          AppLogger.debug('📋 Verificando receitas do combo:');
          AppLogger.debug('  - Main Course: ${mainCourse?.title} (ID: ${mainCourse?.id})');
          AppLogger.debug('  - Dessert: ${dessert?.title} (ID: ${dessert?.id})');
          AppLogger.debug('  - Appetizer: ${appetizer?.title} (ID: ${appetizer?.id})');
          AppLogger.debug('  - Side Dish: ${sideDish?.title} (ID: ${sideDish?.id})');
          
          // Criar novo combo com IDs das receitas
          final updatedCombo = DateNightCombo(
            movieId: combo.movieId,
            movieTitle: combo.movieTitle,
            movieYear: combo.movieYear,
            moviePosterPath: combo.moviePosterPath,
            movieBackdropPath: combo.movieBackdropPath,
            movieRating: combo.movieRating,
            movieOverview: combo.movieOverview,
            movieGenres: combo.movieGenres,
            movieRuntime: combo.movieRuntime,
            movieReleaseDate: combo.movieReleaseDate,
            movieOriginalLanguage: combo.movieOriginalLanguage,
            movieProductionCompanies: combo.movieProductionCompanies,
            movieWatchProviders: combo.movieWatchProviders,
            mainDish: mainCourse?.title ?? combo.mainDish,
            drink: combo.drink,
            dessert: dessert?.title ?? combo.dessert,
            snacks: [
              if (appetizer != null) appetizer.title,
              if (sideDish != null) sideDish.title,
            ].isNotEmpty ? [
              if (appetizer != null) appetizer.title,
              if (sideDish != null) sideDish.title,
            ] : combo.snacks,
            atmosphere: combo.atmosphere,
            preparationTime: mainCourse?.formattedTime ?? combo.preparationTime,
            difficulty: combo.difficulty,
            ingredients: mainCourse?.extendedIngredients?.map((i) => i.original).toList() ?? combo.ingredients,
            cookingTips: combo.cookingTips,
            theme: combo.theme,
            playlistSuggestions: combo.playlistSuggestions,
            ambientLighting: combo.ambientLighting,
            estimatedCost: combo.estimatedCost,
            mainCourseRecipeId: mainCourse?.id,
            dessertRecipeId: dessert?.id,
            appetizerRecipeId: appetizer?.id,
            sideDishRecipeId: sideDish?.id,
          );
          
          setState(() {
            _currentCombo = updatedCombo;
          });
        } else {
          setState(() {
            _currentCombo = combo;
          });
        }

        // Auto-navegar para os detalhes do encontro após criar
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _viewComboDetails();
          });
        }

      } else {
        _showError(AppLocalizations.of(context)!.noMoviesForDateNight);
      }
    } catch (e) {
      _showError(AppLocalizations.of(context)!.errorGeneratingDateNight(e.toString()));
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
      Navigator.of(context).pushDetails(
        DateNightDetailsScreen(combo: _currentCombo!),
      );
    }
  }

  void _openPreferences() async {
    final result = await Navigator.of(context).pushSmooth<DateNightPreferences>(
      DateNightPreferencesScreen(
        initialPreferences: _preferences,
      ),
    );

    // Se o usuário salvou as preferências, atualizar
    if (result != null) {
      setState(() {
        _preferences = result;
      });
  AppLogger.debug('✓ Preferências atualizadas: ${_preferences.dietaryRestriction.label}');
    }
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
        AppLocalizations.of(context)!.dateNight,
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.white),
          onPressed: _openPreferences,
          tooltip: AppLocalizations.of(context)!.preferences,
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
    final dateTypes = DateNightService.getAvailableDateTypes(AppLocalizations.of(context));
    
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
                AppLocalizations.of(context)!.chooseStyle,
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
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      if (dateType == localizations.classicRomance) return Icons.local_florist;
      if (dateType == localizations.romanticComedy) return Icons.emoji_emotions;
      if (dateType == localizations.romanticDrama) return Icons.theater_comedy;
      if (dateType == localizations.musicalRomance) return Icons.music_note;
      if (dateType == localizations.adventureRomance) return Icons.explore;
      if (dateType == localizations.thrillerRomance) return Icons.visibility;
    }
    
    // Fallback to Portuguese hardcoded strings
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
      text: _isLoading ? AppLocalizations.of(context)!.preparing : AppLocalizations.of(context)!.createPerfectDate,
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
