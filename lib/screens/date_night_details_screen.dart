import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/app_theme.dart';
import '../models/date_night_combo.dart';
import '../models/movie.dart';
import '../services/recipe_service_firebase.dart';
import '../services/movie_service.dart';
import '../utils/app_logger.dart';
import '../utils/localized_enums.dart';
import '../utils/color_extensions.dart';
import '../utils/page_transitions.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/optimized_widgets.dart';
import '../widgets/date_night_widgets.dart';
import 'recipe_details_screen.dart';
import 'movie_details_screen.dart';
import 'package:rollflix/l10n/app_localizations.dart';

class DateNightDetailsScreen extends StatefulWidget {
  final DateNightCombo combo;

  const DateNightDetailsScreen({
    super.key,
    required this.combo,
  });

  @override
  State<DateNightDetailsScreen> createState() => _DateNightDetailsScreenState();
}

class _DateNightDetailsScreenState extends State<DateNightDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late DateNightCombo _currentCombo;
  bool _isLoadingMovie = false;
  bool _isLoadingMeal = false;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentCombo = widget.combo;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isMobile),
          _buildContent(isMobile),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isMobile) {
    return SliverAppBar(
      expandedHeight: isMobile ? 200 : 250,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share, color: AppColors.textPrimary),
          onPressed: _shareDetails,
          tooltip: AppLocalizations.of(context)!.shareTooltip,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: SafeText(
          _getThemeTitle(),
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: AppColors.backgroundDark.withValues(alpha: 0.8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: _romanticGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SafeText(
                    _currentCombo.theme,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Tabs de navegação
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: _primaryRose,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: _primaryRose,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: false,
              labelPadding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w400,
              ),
              tabs: [
                Tab(
                  text: AppLocalizations.of(context)!.movieTab,
                  icon: Icon(Icons.movie, size: isMobile ? 18 : 20),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
                Tab(
                  text: AppLocalizations.of(context)!.mealTab,
                  icon: Icon(Icons.restaurant, size: isMobile ? 18 : 20),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
                Tab(
                  text: AppLocalizations.of(context)!.checklistTab,
                  icon: Icon(Icons.checklist, size: isMobile ? 18 : 20),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
              ],
            ),
          ),
          
          // Conteúdo das tabs com altura calculada
          LayoutBuilder(
            builder: (context, constraints) {
              // Calcula altura disponível (altura da tela - app bar - tabs - padding)
              final screenHeight = MediaQuery.of(context).size.height;
              final appBarHeight = isMobile ? 200.0 : 250.0;
              final tabBarHeight = 72.0; // Altura aproximada do TabBar
              final availableHeight = screenHeight - appBarHeight - tabBarHeight - 100;
              
              return SizedBox(
                height: availableHeight.clamp(400.0, 800.0), // Min 400, Max 800
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMovieTab(isMobile),
                    _buildMealTab(isMobile),
                    _buildShoppingListTab(isMobile),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Retorna o título baseado no tema do encontro
  String _getThemeTitle() {
    // Extrai o estilo do tema (ex: "Jantar Romântico à Luz de Velas" -> "Romântico")
    final theme = _currentCombo.theme.toLowerCase();
    
    if (theme.contains('romântico') || theme.contains('romantico')) {
      return AppLocalizations.of(context)!.romanticDate;
    } else if (theme.contains('casual')) {
      return AppLocalizations.of(context)!.casualDate;
    } else if (theme.contains('elegante') || theme.contains('sofisticado')) {
      return AppLocalizations.of(context)!.elegantDate;
    } else if (theme.contains('divertido') || theme.contains('descontraído')) {
      return AppLocalizations.of(context)!.funDate;
    } else if (theme.contains('aconchegante') || theme.contains('conforto')) {
      return AppLocalizations.of(context)!.cozyDate;
    } else {
      return AppLocalizations.of(context)!.dateDetails;
    }
  }

  Widget _buildMovieTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                // Título com botão de trocar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SafeText(
                      AppLocalizations.of(context)!.selectedMovie,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _isLoadingMovie
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: Icon(Icons.refresh, color: _primaryRose),
                            onPressed: _changeMovie,
                            tooltip: AppLocalizations.of(context)!.changeMovie,
                          ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Poster e informações básicas
                isMobile 
                  ? Column(
                      children: [
                        // Poster em mobile (layout vertical)
                        Center(
                          child: InkWell(
                            onTap: _navigateToMovieDetails,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 150,
                              height: 225,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: _romanticGradient.scale(0.5),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _currentCombo.moviePosterPath.isNotEmpty
                                        ? OptimizedNetworkImage(
                                            imageUrl: 'https://image.tmdb.org/t/p/w500${_currentCombo.moviePosterPath}',
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: AppColors.surfaceDark,
                                            child: Icon(
                                              Icons.movie,
                                              size: 48,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                  ),
                                  // Ícone de informação no canto
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: _primaryRose,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Informações do filme em mobile
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SafeText(
                              _currentCombo.movieTitle,
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            SafeText(
                              'Ano: ${_currentCombo.movieYear}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 20,
                                  color: _secondaryGold,
                                ),
                                const SizedBox(width: 4),
                                SafeText(
                                  '${_currentCombo.movieRating.toStringAsFixed(1)}/10',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _primaryRose.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: _primaryRose,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: SafeText(
                                      'Perfeito para encontros!',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: _primaryRose,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Gêneros em mobile
                            if (_currentCombo.movieGenres.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: _currentCombo.movieGenres.map((genre) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [_primaryRose, _secondaryGold],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: SafeText(
                                      genre,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Poster para tablet/desktop
                        InkWell(
                          onTap: _navigateToMovieDetails,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 150,
                            height: 225,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: _romanticGradient.scale(0.5),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _currentCombo.moviePosterPath.isNotEmpty
                                      ? OptimizedNetworkImage(
                                          imageUrl: 'https://image.tmdb.org/t/p/w500${_currentCombo.moviePosterPath}',
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: AppColors.surfaceDark,
                                          child: Icon(
                                            Icons.movie,
                                            size: 48,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                ),
                                // Ícone de informação no canto
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: _primaryRose,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // Informações do filme para tablet/desktop
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SafeText(
                                _currentCombo.movieTitle,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              SafeText(
                                'Ano: ${_currentCombo.movieYear}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (_currentCombo.movieReleaseDate.isNotEmpty && _currentCombo.movieReleaseDate != 'Data não disponível')
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SafeText(
                                    '${AppLocalizations.of(context)!.releaseLabel} ${_currentCombo.movieReleaseDate}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              if (_currentCombo.movieRuntime.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SafeText(
                                    '${AppLocalizations.of(context)!.durationLabel} ${_currentCombo.movieRuntime}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: _secondaryGold,
                                  ),
                                  const SizedBox(width: 4),
                                  SafeText(
                                    '${_currentCombo.movieRating.toStringAsFixed(1)}/10',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _primaryRose.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: _primaryRose,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: SafeText(
                                        'Perfeito para encontros!',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: _primaryRose,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Gêneros em desktop
                              if (_currentCombo.movieGenres.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _currentCombo.movieGenres.map((genre) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [_primaryRose, _secondaryGold],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: SafeText(
                                        genre,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white,
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
                
                const SizedBox(height: 20),
                
                // Sinopse
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeText(
                      AppLocalizations.of(context)!.synopsis,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SafeText(
                      _currentCombo.movieOverview.isNotEmpty 
                          ? _currentCombo.movieOverview
                          : AppLocalizations.of(context)!.defaultMovieOverview,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                
                // Informações Técnicas
                if (_currentCombo.movieProductionCompanies.isNotEmpty || 
                    _currentCombo.movieOriginalLanguage.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeText(
                        AppLocalizations.of(context)!.technicalInfo,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      if (_currentCombo.movieOriginalLanguage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.language,
                                size: 18,
                                color: _primaryRose,
                              ),
                              const SizedBox(width: 8),
                              SafeText(
                                'Idioma Original: ',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: SafeText(
                                  _currentCombo.movieOriginalLanguage.toUpperCase(),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      if (_currentCombo.movieProductionCompanies.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.business,
                              size: 18,
                              color: _primaryRose,
                            ),
                            const SizedBox(width: 8),
                            SafeText(
                              AppLocalizations.of(context)!.productionLabel,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: SafeText(
                                _currentCombo.movieProductionCompanies.take(3).join(', '),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
                
                // Onde Assistir
                if (_currentCombo.movieWatchProviders.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_primaryRose, _secondaryGold],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryRose.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SafeText(
                            'Onde Assistir',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      _buildWatchProvidersSection(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          // Título com botão de trocar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SafeText(
                '🍽️ Menu Selecionado',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _isLoadingMeal
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: Icon(Icons.refresh, color: _primaryRose),
                      onPressed: _changeMeal,
                      tooltip: AppLocalizations.of(context)!.changeMeal,
                    ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Prato Principal
          _buildRecipeCard(
            title: 'Prato Principal',
            recipeName: _currentCombo.mainDish,
            icon: Icons.restaurant_menu,
            recipeId: _currentCombo.mainCourseRecipeId,
            showDetails: true,
            isMobile: isMobile,
          ),
          
          const SizedBox(height: 16),
          
          // Sobremesa
          _buildRecipeCard(
            title: 'Sobremesa',
            recipeName: _currentCombo.dessert,
            icon: Icons.cake,
            recipeId: _currentCombo.dessertRecipeId,
            isMobile: isMobile,
          ),
          
          const SizedBox(height: 16),
          
          // Petiscos e Acompanhamentos
          if (_currentCombo.snacks.isNotEmpty) ...[
            if (_currentCombo.appetizerRecipeId != null)
              _buildRecipeCard(
                title: 'Petisco',
                recipeName: _currentCombo.snacks.isNotEmpty ? _currentCombo.snacks[0] : 'Petisco',
                icon: Icons.emoji_food_beverage,
                recipeId: _currentCombo.appetizerRecipeId,
                isMobile: isMobile,
              ),
            
            if (_currentCombo.appetizerRecipeId != null && _currentCombo.sideDishRecipeId != null)
              const SizedBox(height: 16),
            
            if (_currentCombo.sideDishRecipeId != null)
              _buildRecipeCard(
                title: 'Acompanhamento',
                recipeName: _currentCombo.snacks.length > 1 ? _currentCombo.snacks[1] : 'Acompanhamento',
                icon: Icons.restaurant,
                recipeId: _currentCombo.sideDishRecipeId,
                isMobile: isMobile,
              ),
            
            const SizedBox(height: 16),
          ],
          
          // Bebida (não tem receita, só informação)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_bar, color: _primaryRose, size: 20),
                    const SizedBox(width: 8),
                    SafeText(
                      'Bebida',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SafeText(
                  _currentCombo.drink,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Dicas de preparo
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: _secondaryGold, size: 20),
                    const SizedBox(width: 8),
                    SafeText(
                      'Dica do Chef',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SafeText(
                  _currentCombo.cookingTips,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  // Card de receita clicável
  Widget _buildRecipeCard({
    required String title,
    required String recipeName,
    required IconData icon,
    required int? recipeId,
    bool showDetails = false,
    required bool isMobile,
  }) {
    final hasRecipe = recipeId != null;
    
    return InkWell(
      onTap: hasRecipe ? () => _openRecipeDetails(recipeId, recipeType: title) : null,
      borderRadius: BorderRadius.circular(16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _primaryRose, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: SafeText(
                    title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (hasRecipe)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _primaryRose.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SafeText(
                          'Ver receita',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _primaryRose,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, color: _primaryRose, size: 12),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SafeText(
              recipeName,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showDetails) ...[
              const SizedBox(height: 12),
              _buildInfoRow(Icons.access_time, AppLocalizations.of(context)!.timeLabel, _currentCombo.preparationTime),
              _buildInfoRow(Icons.star, AppLocalizations.of(context)!.difficultyLabel, LocalizedEnums.difficultyLabel(context, _currentCombo.difficulty)),
            ],
          ],
        ),
      ),
    );
  }

  // Navegar para os detalhes da receita
  Future<void> _openRecipeDetails(int recipeId, {String recipeType = 'Receita'}) async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Mapear tipo de receita para API
      final recipeTypeMap = {
        'Prato Principal': 'main course',
        'Sobremesa': 'dessert',
        'Petisco': 'appetizer',
        'Acompanhamento': 'side dish',
      };
      
      final apiRecipeType = recipeTypeMap[recipeType] ?? 'main course';

      // Buscar detalhes completos da receita com retry automático
      final recipe = await RecipeServiceFirebase.getRecipeDetailsWithRetry(
        recipeId: recipeId,
        recipeType: apiRecipeType,
        maxRetries: 3,
      );

      if (!mounted) return;
      
      // Fechar loading
      Navigator.of(context).pop();

      // Navegar para a tela de detalhes
      Navigator.of(context).pushDetails(
        RecipeDetailsScreen(
          recipe: recipe,
          recipeType: recipeType,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      // Fechar loading se ainda estiver aberto
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.recipeLoadError),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // Trocar filme por outro aleatório
  Future<void> _changeMovie() async {
    setState(() => _isLoadingMovie = true);
    
    try {
      // Buscar filmes do gênero Romance
      final allMovies = await MovieService.getMoviesByGenre('Romance');
      
      if (allMovies.isEmpty) {
        throw Exception('Nenhum filme encontrado');
      }
      
      // Filtrar apenas filmes bem avaliados (>= 7.0) para Date Night
      final movies = allMovies.where((movie) => movie.voteAverage >= 7.0).toList();
      
      // Se não houver filmes bem avaliados, usar todos
      final selectedMovies = movies.isNotEmpty ? movies : allMovies;
      
      if (selectedMovies.isEmpty) {
        throw Exception('Nenhum filme encontrado');
      }
      
      // Selecionar um filme aleatório diferente do atual
      Movie? newMovie;
      final random = Random();
      
      // Tentar encontrar um filme diferente do atual
      for (int i = 0; i < 10 && newMovie == null; i++) {
        final candidate = selectedMovies[random.nextInt(selectedMovies.length)];
        if (candidate.id != _currentCombo.movieId) {
          newMovie = candidate;
        }
      }
      
      // Se não encontrou um diferente, usar qualquer um
      newMovie ??= selectedMovies[random.nextInt(selectedMovies.length)];
      
      // Buscar detalhes completos do filme
      final movieDetails = await MovieService.getMovieDetails(newMovie.id);
      
      // Atualizar combo com novo filme mantendo os dados da refeição
      _currentCombo = DateNightCombo(
        // Dados do novo filme
        movieId: movieDetails.id,
        movieTitle: movieDetails.title,
        movieYear: movieDetails.releaseDate.isNotEmpty 
            ? movieDetails.releaseDate.split('-')[0] 
            : 'N/A',
        moviePosterPath: movieDetails.posterPath,
        movieBackdropPath: movieDetails.backdropPath,
        movieRating: movieDetails.voteAverage,
        movieOverview: movieDetails.overview,
        movieGenres: movieDetails.genres.map((g) => g.name).toList(),
        movieRuntime: movieDetails.runtime > 0 ? '${movieDetails.runtime} min' : 'N/A',
        movieReleaseDate: movieDetails.releaseDate,
        movieOriginalLanguage: movieDetails.originalLanguage,
        movieProductionCompanies: movieDetails.productionCompanies,
        movieWatchProviders: [],
        
        // Manter dados da refeição atual
        mainDish: _currentCombo.mainDish,
        drink: _currentCombo.drink,
        dessert: _currentCombo.dessert,
        snacks: _currentCombo.snacks,
        atmosphere: _currentCombo.atmosphere,
        preparationTime: _currentCombo.preparationTime,
        difficulty: _currentCombo.difficulty,
        ingredients: _currentCombo.ingredients,
        cookingTips: _currentCombo.cookingTips,
        theme: _currentCombo.theme,
        playlistSuggestions: _currentCombo.playlistSuggestions,
        ambientLighting: _currentCombo.ambientLighting,
        estimatedCost: _currentCombo.estimatedCost,
        mainCourseRecipeId: _currentCombo.mainCourseRecipeId,
        dessertRecipeId: _currentCombo.dessertRecipeId,
        appetizerRecipeId: _currentCombo.appetizerRecipeId,
        sideDishRecipeId: _currentCombo.sideDishRecipeId,
      );
      
      setState(() => _isLoadingMovie = false);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.newMovieSelected),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() => _isLoadingMovie = false);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorChangingMovie(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Trocar refeição por outra aleatória
  Future<void> _changeMeal() async {
    setState(() => _isLoadingMeal = true);
    
    try {
      // Gerar novo menu do Firebase
      final menu = await RecipeServiceFirebase.generateDateNightMenu();
      
      if (menu['mainCourse'] == null || menu['dessert'] == null) {
        throw Exception('Menu não foi gerado corretamente');
      }
      
      final mainCourse = menu['mainCourse']!;
      final dessert = menu['dessert']!;
      
      // Atualizar combo com nova refeição mantendo os dados do filme
      _currentCombo = DateNightCombo(
        // Manter dados do filme atual
        movieId: _currentCombo.movieId,
        movieTitle: _currentCombo.movieTitle,
        movieYear: _currentCombo.movieYear,
        moviePosterPath: _currentCombo.moviePosterPath,
        movieBackdropPath: _currentCombo.movieBackdropPath,
        movieRating: _currentCombo.movieRating,
        movieOverview: _currentCombo.movieOverview,
        movieGenres: _currentCombo.movieGenres,
        movieRuntime: _currentCombo.movieRuntime,
        movieReleaseDate: _currentCombo.movieReleaseDate,
        movieOriginalLanguage: _currentCombo.movieOriginalLanguage,
        movieProductionCompanies: _currentCombo.movieProductionCompanies,
        movieWatchProviders: _currentCombo.movieWatchProviders,
        
        // Dados da nova refeição
        mainDish: mainCourse.title,
        drink: 'Vinho ou Suco',
        dessert: dessert.title,
        snacks: ['Petiscos variados'],
        atmosphere: 'Ambiente acolhedor',
        preparationTime: '${mainCourse.readyInMinutes} min',
        difficulty: mainCourse.vegetarian == true ? AppLocalizations.of(context)!.easy : AppLocalizations.of(context)!.medium,
        ingredients: mainCourse.extendedIngredients
            ?.map((i) => i.original)
            .take(8)
            .toList() ?? ['Ingredientes variados'],
        cookingTips: 'Siga as instruções da receita',
        theme: 'Noite romântica',
        playlistSuggestions: [AppLocalizations.of(context)!.jazzSmooth, AppLocalizations.of(context)!.bossaNova, AppLocalizations.of(context)!.romanticMusic],
        ambientLighting: 'Luzes suaves',
        estimatedCost: 'R\$ 80-120',
        mainCourseRecipeId: mainCourse.id,
        dessertRecipeId: dessert.id,
        appetizerRecipeId: menu['appetizer']?.id,
        sideDishRecipeId: menu['sideDish']?.id,
      );
      
      setState(() => _isLoadingMeal = false);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.newMenuSelected),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() => _isLoadingMeal = false);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorChangingMenu(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Compartilhar detalhes do encontro
  Future<void> _shareDetails() async {
    try {
      // Buscar informações do trailer
      final videos = await MovieService.getMovieVideos(_currentCombo.movieId);
      String? trailerUrl;
      
      if (videos != null && videos.trailers.isNotEmpty) {
        // Pegar o primeiro trailer oficial se disponível
        final officialTrailer = videos.trailers.firstWhere(
          (video) => video.official,
          orElse: () => videos.trailers.first,
        );
        trailerUrl = officialTrailer.youtubeUrl;
      }
      
      // Criar texto formatado com os detalhes do encontro
      final StringBuffer message = StringBuffer();
      
      message.writeln('🎬✨ PLANO DE ENCONTRO PERFEITO ✨🍽️');
      message.writeln('');
      message.writeln('═══════════════════════════');
      message.writeln('🎬 FILME');
      message.writeln('═══════════════════════════');
      message.writeln('Título: ${_currentCombo.movieTitle}');
      message.writeln('Ano: ${_currentCombo.movieYear}');
      message.writeln('⭐ Avaliação: ${_currentCombo.movieRating.toStringAsFixed(1)}/10');
      
      if (_currentCombo.movieGenres.isNotEmpty) {
        message.writeln('Gêneros: ${_currentCombo.movieGenres.join(", ")}');
      }
      
      if (_currentCombo.movieRuntime.isNotEmpty && _currentCombo.movieRuntime != 'N/A') {
        message.writeln('Duração: ${_currentCombo.movieRuntime}');
      }
      
      // Adicionar poster do filme
      if (_currentCombo.moviePosterPath.isNotEmpty) {
        message.writeln('');
        message.writeln('🖼️ Poster: https://image.tmdb.org/t/p/w500${_currentCombo.moviePosterPath}');
      }
      
      // Adicionar trailer se disponível
      if (trailerUrl != null && trailerUrl.isNotEmpty) {
        message.writeln('');
        message.writeln('🎥 Trailer: $trailerUrl');
      }
      
      message.writeln('');
      message.writeln('═══════════════════════════');
      message.writeln('🍽️ MENU');
      message.writeln('═══════════════════════════');
      message.writeln('Prato Principal: ${_currentCombo.mainDish}');
      message.writeln('Sobremesa: ${_currentCombo.dessert}');
      message.writeln('Bebida: ${_currentCombo.drink}');
      
      if (_currentCombo.snacks.isNotEmpty) {
        message.writeln('Petiscos: ${_currentCombo.snacks.join(", ")}');
      }
      
      message.writeln('');
      message.writeln('${AppLocalizations.of(context)!.preparationTimePrefix} ${_currentCombo.preparationTime}');
      message.writeln('${AppLocalizations.of(context)!.difficultyPrefix} ${LocalizedEnums.difficultyLabel(context, _currentCombo.difficulty)}');
      
      message.writeln('');
      message.writeln('═══════════════════════════');
      message.writeln('Criado com Rollflix 🎬🍿');
      
      // Compartilhar o texto
      await SharePlus.instance.share(
        ShareParams(
          text: message.toString(),
          subject: '🎬 Plano de Encontro Perfeito',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorSharing(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Navegar para detalhes do filme
  Future<void> _navigateToMovieDetails() async {
    try {
      // Criar objeto Movie a partir dos dados do combo
      final movie = Movie(
        id: _currentCombo.movieId,
        title: _currentCombo.movieTitle,
        overview: _currentCombo.movieOverview,
        posterPath: _currentCombo.moviePosterPath,
        backdropPath: _currentCombo.movieBackdropPath,
        voteAverage: _currentCombo.movieRating,
        voteCount: 0,
        releaseDate: _currentCombo.movieReleaseDate,
        genreIds: [],
        genres: _currentCombo.movieGenres.map((name) => Genre(id: 0, name: name)).toList(),
        runtime: int.tryParse(_currentCombo.movieRuntime.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        originalLanguage: _currentCombo.movieOriginalLanguage,
        productionCompanies: _currentCombo.movieProductionCompanies,
      );

      // Navegar para a tela de detalhes do filme
      await Navigator.of(context).pushDetails(
        MovieDetailsScreen(movie: movie),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorOpeningDetails(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildShoppingListTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          // Checklist interativa de ingredientes
          FutureBuilder<Map<String, List<String>>>(
            future: _getCategorizedIngredients(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final categorizedIngredients = snapshot.data ?? {};
              
              return IngredientsChecklistWidget(
                ingredients: _currentCombo.ingredients,
                mainCourseIngredients: categorizedIngredients['mainCourse'],
                dessertIngredients: categorizedIngredients['dessert'],
                appetizerIngredients: categorizedIngredients['appetizer'],
                sideDishIngredients: categorizedIngredients['sideDish'],
              );
            },
          ),

          const SizedBox(height: 24),
          
          const SizedBox(height: 16),
          
          // Dica adicional
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primaryRose.withOpacitySafe(0.1),
                  _secondaryGold.withOpacitySafe(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _secondaryGold.withOpacitySafe(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: _secondaryGold,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SafeText(
                    AppLocalizations.of(context)!.checklistHint,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _primaryRose),
          const SizedBox(width: 8),
          SafeText(
            '$label: ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SafeText(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchProvidersSection() {
    final streamingProviders = _currentCombo.movieWatchProviders
        .where((p) => p['type'] == 'streaming')
        .toList();
    final rentProviders = _currentCombo.movieWatchProviders
        .where((p) => p['type'] == 'rent')
        .toList();
    final buyProviders = _currentCombo.movieWatchProviders
        .where((p) => p['type'] == 'buy')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (streamingProviders.isNotEmpty) ...[
          SafeText(
            AppLocalizations.of(context)!.streamingIncluded,
            style: AppTextStyles.bodyLarge.copyWith(
              color: _primaryRose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: streamingProviders.map((provider) {
              return _buildProviderCard(provider);
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
        
        if (rentProviders.isNotEmpty) ...[
          SafeText(
            'Aluguel:',
            style: AppTextStyles.bodyLarge.copyWith(
              color: _primaryRose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: rentProviders.map((provider) {
              return _buildProviderCard(provider);
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
        
        if (buyProviders.isNotEmpty) ...[
          SafeText(
            'Compra:',
            style: AppTextStyles.bodyLarge.copyWith(
              color: _primaryRose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: buyProviders.map((provider) {
              return _buildProviderCard(provider);
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return GestureDetector(
      onTap: () => _openProvider(provider),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _primaryRose.withValues(alpha: 0.1),
              _secondaryGold.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _primaryRose.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: provider['logoPath'] != null && provider['logoPath'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: OptimizedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w92${provider['logoPath']}',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.play_circle_fill,
                      color: _primaryRose,
                      size: 20,
                    ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: SafeText(
                provider['name'] ?? 'Provedor',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openProvider(Map<String, dynamic> provider) {
    // Implementar abertura do provedor
    // Por enquanto, vamos mostrar um snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SafeText(
          'Abrindo ${provider['name']} para assistir ${_currentCombo.movieTitle}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryRose,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<Map<String, List<String>>> _getCategorizedIngredients() async {
    final Map<String, List<String>> categorized = {};

    try {
      // Buscar ingredientes do prato principal
      if (_currentCombo.mainCourseRecipeId != null) {
        final recipe = await RecipeServiceFirebase.getRecipeDetails(_currentCombo.mainCourseRecipeId!);
        if (recipe.extendedIngredients != null && recipe.extendedIngredients!.isNotEmpty) {
          categorized['mainCourse'] = recipe.extendedIngredients!.map((i) => i.original).toList();
        }
      }

      // Buscar ingredientes da sobremesa
      if (_currentCombo.dessertRecipeId != null) {
        final recipe = await RecipeServiceFirebase.getRecipeDetails(_currentCombo.dessertRecipeId!);
        if (recipe.extendedIngredients != null && recipe.extendedIngredients!.isNotEmpty) {
          categorized['dessert'] = recipe.extendedIngredients!.map((i) => i.original).toList();
        }
      }

      // Buscar ingredientes do petisco
      if (_currentCombo.appetizerRecipeId != null) {
        final recipe = await RecipeServiceFirebase.getRecipeDetails(_currentCombo.appetizerRecipeId!);
        if (recipe.extendedIngredients != null && recipe.extendedIngredients!.isNotEmpty) {
          categorized['appetizer'] = recipe.extendedIngredients!.map((i) => i.original).toList();
        }
      }

      // Buscar ingredientes do acompanhamento
      if (_currentCombo.sideDishRecipeId != null) {
        final recipe = await RecipeServiceFirebase.getRecipeDetails(_currentCombo.sideDishRecipeId!);
        if (recipe.extendedIngredients != null && recipe.extendedIngredients!.isNotEmpty) {
          categorized['sideDish'] = recipe.extendedIngredients!.map((i) => i.original).toList();
        }
      }
    } catch (e, stack) {
      AppLogger.error('Erro ao buscar ingredientes categorizados', error: e, stackTrace: stack);
    }

    return categorized;
  }
}
