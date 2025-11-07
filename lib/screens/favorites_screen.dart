import 'package:flutter/material.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/app_mode_controller.dart';
import '../models/favorite_item.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../utils/page_transitions.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/error_widgets.dart';
import 'movie_details_screen.dart';
import 'tv_show_details_screen.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../controllers/locale_controller.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesController _favoritesController;
  late final AppModeController _appModeController;
  
  @override
  void initState() {
    super.initState();
    _favoritesController = FavoritesController.instance;
    _appModeController = AppModeController.instance;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleController.instance,
      builder: (context, locale, _) {
        return ListenableBuilder(
          listenable: Listenable.merge([
            _favoritesController,
            _appModeController,
          ]),
          builder: (context, _) {
            // Obtém os favoritos baseado no modo atual
            final currentFavorites = _appModeController.isSeriesMode
                ? _favoritesController.favoriteTVShows
                : _favoritesController.favoriteMovies;
            
            // Gradiente baseado no modo
            final currentGradient = _appModeController.isSeriesMode 
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 0, 0, 0),
                      Color.fromARGB(255, 45, 3, 56),
                      Color.fromARGB(255, 255, 0, 128),
                    ],
                  )
                : AppColors.cinemaGradient;
            
            final accentColor = _appModeController.isSeriesMode 
                ? const Color(0xFFBB86FC)
                : AppColors.primary;
            
            return Scaffold(
              backgroundColor: AppColors.backgroundDark,
              appBar: AppBar(
                title: SafeText(
                  AppLocalizations.of(context)!.favorites,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: currentGradient,
                  ),
                ),
                iconTheme: IconThemeData(color: accentColor),
                elevation: 0,
                actions: [
                  // Botão de Swap Filme/Série
                  _buildSwapButton(isMobile, accentColor),
                  const SizedBox(width: 8),
                  // Botão de limpar
                  IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: AppLocalizations.of(context)!.clearAll,
                    color: accentColor,
                    onPressed: currentFavorites.isEmpty ? null : _showClearAllDialog,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: _buildBody(currentFavorites, isMobile, accentColor),
            );
          },
        );
      },
    );
  }

  Widget _buildSwapButton(bool isMobile, Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: _appModeController.isSeriesMode 
            ? LinearGradient(
                colors: [
                  const Color.fromARGB(255, 147, 51, 234).withValues(alpha: 0.8),
                  const Color.fromARGB(255, 219, 39, 119).withValues(alpha: 0.8),
                ],
              )
            : LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.8),
                  AppColors.primaryLight.withValues(alpha: 0.8),
                ],
              ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => _appModeController.toggleMode(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _appModeController.isSeriesMode ? Icons.tv : Icons.movie,
                  color: AppColors.textPrimary,
                  size: isMobile ? 18 : 20,
                ),
                const SizedBox(width: 8),
                SafeText(
                  _appModeController.isSeriesMode ? AppLocalizations.of(context)!.series : AppLocalizations.of(context)!.movies,
                  style: (isMobile 
                      ? AppTextStyles.labelMedium
                      : AppTextStyles.labelLarge).copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.swap_horiz,
                  color: AppColors.textPrimary,
                  size: isMobile ? 18 : 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<FavoriteItem> favorites, bool isMobile, Color accentColor) {
    if (_favoritesController.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
        ),
      );
    }

    if (favorites.isEmpty) {
      return _buildEmptyState(accentColor);
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return _buildFavoriteCard(favorite, isMobile, accentColor);
      },
    );
  }

  Widget _buildEmptyState(Color accentColor) {
    final contentType = _appModeController.isSeriesMode ? AppLocalizations.of(context)!.seriesLower : AppLocalizations.of(context)!.moviesLower;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _appModeController.isSeriesMode ? Icons.tv_off : Icons.movie_filter,
            size: 80,
            color: accentColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          SafeText(
            AppLocalizations.of(context)!.noFavoritesYet,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SafeText(
              AppLocalizations.of(context)!.addToFavoritesHint(contentType),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(FavoriteItem favorite, bool isMobile, Color accentColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (favorite.isTVShow) {
            Navigator.of(context).pushDetails(
              TVShowDetailsScreen(
                tvShow: favorite.toTVShow(),
              ),
            );
          } else {
            Navigator.of(context).pushDetails(
              MovieDetailsScreen(
                movie: favorite.toMovie(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              _buildPoster(favorite, isMobile),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: _buildInfo(favorite, isMobile, accentColor),
              ),
              // Remove button (visual parity with Watched screen)
              IconButton(
                icon: const Icon(Icons.check_circle),
                color: accentColor,
                onPressed: () => _removeFavorite(favorite),
                tooltip: AppLocalizations.of(context)!.removeFromFavoritesTooltip,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoster(FavoriteItem favorite, bool isMobile) {
    final width = isMobile ? 80.0 : 100.0;
    final height = isMobile ? 120.0 : 150.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: favorite.posterPath != null && favorite.posterPath!.isNotEmpty
          ? Image.network(
              '${AppConstants.tmdbImageBaseUrl}${favorite.posterPath}',
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPosterPlaceholder(isMobile),
            )
          : _buildPosterPlaceholder(isMobile),
    );
  }

  Widget _buildInfo(FavoriteItem favorite, bool isMobile, Color accentColor) {
  final year = favorite.releaseDate.isNotEmpty
    ? favorite.releaseDate.split('-')[0]
    : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        SafeText(
          favorite.title,
          style: (isMobile ? AppTextStyles.bodyLarge : AppTextStyles.headlineSmall).copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Year and type row (matches WatchedScreen)
        Row(
          children: [
            if (year.isNotEmpty) ...[
              Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              SafeText(
                year,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Icon(
              favorite.isTVShow ? Icons.tv : Icons.movie,
              size: 14,
              color: accentColor,
            ),
            const SizedBox(width: 4),
            SafeText(
              favorite.isTVShow ? AppLocalizations.of(context)!.seriesLabel : AppLocalizations.of(context)!.movieLabel,
              style: AppTextStyles.bodySmall.copyWith(
                color: accentColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Rating row (matches WatchedScreen)
        Row(
          children: [
            Icon(
              Icons.star,
              size: 16,
              color: AppColors.accent,
            ),
            const SizedBox(width: 4),
            SafeText(
              favorite.voteAverage.toStringAsFixed(1),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPosterPlaceholder(bool isMobile) {
    return Container(
      width: isMobile ? 80 : 100,
      height: isMobile ? 120 : 150,
      color: AppColors.surfaceVariantDark,
      child: const Icon(
        Icons.movie,
        size: 40,
        color: AppColors.textSecondary,
      ),
    );
  }

  void _removeFavorite(FavoriteItem favorite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: SafeText(
          AppLocalizations.of(context)!.removeFavorite,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: SafeText(
          AppLocalizations.of(context)!.confirmRemoveFavorite(favorite.title),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: SafeText(
              AppLocalizations.of(context)!.cancel,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _favoritesController.removeFavorite(favorite.id);
              Navigator.pop(context);
              AppSnackBar.showSuccess(context, AppLocalizations.of(context)!.removedFromFavorites);
            },
            child: SafeText(
              AppLocalizations.of(context)!.removeFromFavorites,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    final currentFavorites = _appModeController.isSeriesMode
        ? _favoritesController.favoriteTVShows
        : _favoritesController.favoriteMovies;
    
    if (currentFavorites.isEmpty) {
      final contentType = _appModeController.isSeriesMode 
          ? AppLocalizations.of(context)!.seriesLower 
          : AppLocalizations.of(context)!.moviesLower;
      AppSnackBar.showInfo(context, AppLocalizations.of(context)!.noFavoritesToClear(contentType));
      return;
    }

    final contentType = _appModeController.isSeriesMode 
        ? AppLocalizations.of(context)!.seriesLower 
        : AppLocalizations.of(context)!.moviesLower;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: SafeText(
          AppLocalizations.of(context)!.clearAllFavorites,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: SafeText(
          AppLocalizations.of(context)!.confirmClearAllFavorites(currentFavorites.length.toString(), contentType),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: SafeText(
              AppLocalizations.of(context)!.cancel,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Remove apenas os favoritos do modo atual
              for (var favorite in currentFavorites) {
                _favoritesController.removeFavorite(favorite.id);
              }
              Navigator.pop(context);
              AppSnackBar.showSuccess(context, AppLocalizations.of(context)!.allFavoritesCleared(contentType));
            },
            child: SafeText(
              AppLocalizations.of(context)!.clearAll,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
