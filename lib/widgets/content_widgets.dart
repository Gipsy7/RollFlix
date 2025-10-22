import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart' as app_utils;
import '../utils/page_transitions.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/optimized_widgets.dart';
import '../mixins/animation_mixin.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../screens/movie_details_screen.dart';
import '../screens/tv_show_details_screen.dart';
import '../controllers/favorites_controller.dart';

/// Widget que exibe um card de filme ou série com detalhes
class ContentCard extends StatelessWidget {
  final Movie? movie;
  final TVShow? tvShow;
  final Animation<double> animation;
  final LinearGradient currentGradient;
  final Color accentColor;
  final bool isMobile;

  const ContentCard({
    super.key,
    this.movie,
    this.tvShow,
    required this.animation,
    required this.currentGradient,
    required this.accentColor,
    required this.isMobile,
  }) : assert(movie != null || tvShow != null, 'Either movie or tvShow must be provided');

  bool get isMovie => movie != null;

  @override
  Widget build(BuildContext context) {
    final favoritesController = FavoritesController.instance;
    
    return OptimizedAnimatedBuilder(
      animation: animation,
      builder: (context, animationValue) {
        return Transform.scale(
          scale: animationValue,
          child: Stack(
            children: [
              AppCard(
                onTap: () => _navigateToDetails(context),
                padding: EdgeInsets.all(isMobile ? 20 : 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPoster(),
                    const SizedBox(width: 20),
                    Expanded(child: _buildDetails()),
                  ],
                ),
              ),
              // Botão de favorito flutuante
              Positioned(
                top: 8,
                right: 8,
                child: ListenableBuilder(
                  listenable: favoritesController,
                  builder: (context, _) {
                    final isFavorite = isMovie
                        ? favoritesController.isMovieFavorite(movie!)
                        : favoritesController.isTVShowFavorite(tvShow!);
                    
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => _toggleFavorite(context, favoritesController),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isFavorite 
                                  ? AppColors.error 
                                  : AppColors.textSecondary.withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? AppColors.error : AppColors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleFavorite(BuildContext context, FavoritesController controller) {
    if (isMovie) {
      controller.toggleMovieFavorite(movie!);
      final isFavorite = controller.isMovieFavorite(movie!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite 
                ? AppLocalizations.of(context)!.addedToFavorites(movie!.title)
                : '${movie!.title} ${AppLocalizations.of(context)!.removedFromFavorites.toLowerCase()}',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: isFavorite ? AppColors.success : AppColors.surfaceDark,
        ),
      );
    } else {
      controller.toggleTVShowFavorite(tvShow!);
      final isFavorite = controller.isTVShowFavorite(tvShow!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite 
                ? AppLocalizations.of(context)!.addedToFavorites(tvShow!.name)
                : '${tvShow!.name} ${AppLocalizations.of(context)!.removedFromFavorites.toLowerCase()}',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: isFavorite ? AppColors.success : AppColors.surfaceDark,
        ),
      );
    }
  }

  void _navigateToDetails(BuildContext context) {
    if (isMovie) {
      Navigator.of(context).pushDetails(
        MovieDetailsScreen(movie: movie!),
      );
    } else {
      Navigator.of(context).pushDetails(
        TVShowDetailsScreen(tvShow: tvShow!),
      );
    }
  }

  Widget _buildPoster() {
    final posterPath = isMovie ? movie!.posterPath : tvShow!.posterPath;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppColors.glassGradient,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: OptimizedNetworkImage(
        imageUrl: posterPath.isNotEmpty 
            ? 'https://image.tmdb.org/t/p/w500$posterPath'
            : '',
        width: isMobile ? 100 : 120,
        height: isMobile ? 150 : 180,
        borderRadius: BorderRadius.circular(14),
        errorWidget: _buildPosterFallback(),
        placeholder: Container(
          width: isMobile ? 100 : 120,
          height: isMobile ? 150 : 180,
          decoration: BoxDecoration(
            gradient: AppColors.glassGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const OptimizedLoadingIndicator(size: 24),
        ),
      ),
    );
  }

  Widget _buildPosterFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: isMovie ? AppColors.primaryGradient : currentGradient,
      ),
      child: Icon(
        isMovie ? Icons.movie : Icons.tv,
        color: AppColors.backgroundDark,
        size: 48,
      ),
    );
  }

  Widget _buildDetails() {
    final title = isMovie ? movie!.title : tvShow!.name;
    final date = isMovie ? movie!.releaseDate : tvShow!.firstAirDate;
    final rating = isMovie ? movie!.voteAverage : tvShow!.voteAverage;
    final overview = isMovie ? movie!.overview : tvShow!.overview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title),
        const SizedBox(height: 12),
        if (date.isNotEmpty) ...[
          _buildDate(date),
          const SizedBox(height: 12),
        ],
        _buildRating(rating),
        const SizedBox(height: 16),
        if (overview.isNotEmpty) ...[
          _buildOverview(overview),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 8),
        _buildDetailsHint(),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return SafeText(
      title,
      style: (isMobile 
          ? AppTextStyles.headlineSmall
          : AppTextStyles.headlineMedium).copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDate(String date) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.calendar_today,
            size: 16,
            color: accentColor,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: SafeText(
            app_utils.DateUtils.formatReleaseDate(date),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.star,
            size: 16,
            color: accentColor,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: SafeText(
            '${rating.toStringAsFixed(1)}/10',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverview(String overview) {
    return SafeText(
      overview,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      maxLines: isMobile ? 3 : 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDetailsHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app,
            size: 16,
            color: AppColors.backgroundDark,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useShortText = constraints.maxWidth < 120 || isMobile;
                return SafeText(
                  useShortText ? AppLocalizations.of(context)!.tapForDetails : AppLocalizations.of(context)!.tapForMoreDetails,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.backgroundDark,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget que exibe o contador de filmes/séries rolados
class ContentCounter extends StatelessWidget {
  final int count;
  final bool isSeriesMode;

  const ContentCounter({
    super.key,
    required this.count,
    required this.isSeriesMode,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    
    final icon = isSeriesMode ? Icons.tv : Icons.movie_filter;
    final counterText = isSeriesMode 
        ? AppLocalizations.of(context)!.seriesRolled(count)
        : AppLocalizations.of(context)!.movieRolled(count);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          counterText,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
