import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';
import '../models/movie.dart';
import 'common_widgets.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool showDetails;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width,
    this.height,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? 200;
    final cardHeight = height ?? 300;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusL),
                ),
                child: ImageUtils.buildNetworkImage(
                  imageUrl: movie.fullPosterUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.movie,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
            
            if (showDetails) ...[
              // Movie Details
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: AppTextStyles.labelLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppConstants.spacingXS),
                      if (movie.year.isNotEmpty) ...[
                        Text(
                          movie.year,
                          style: AppTextStyles.labelMedium,
                        ),
                      ],
                      const Spacer(),
                      if (movie.voteAverage > 0) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: AppConstants.spacingXS),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: AppTextStyles.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MoviePoster extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool showOverlay;

  const MoviePoster({
    super.key,
    required this.movie,
    this.onTap,
    this.width = 120,
    this.height = 180,
    this.showOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget poster = ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: ImageUtils.buildNetworkImage(
        imageUrl: movie.fullPosterUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorWidget: Container(
          width: width,
          height: height,
          color: AppColors.surfaceVariant,
          child: const Icon(
            Icons.movie,
            size: 48,
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );

    if (showOverlay) {
      poster = Stack(
        children: [
          poster,
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
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
          ),
          Positioned(
            bottom: AppConstants.spacingS,
            left: AppConstants.spacingS,
            right: AppConstants.spacingS,
            child: Text(
              movie.title,
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: poster,
        ),
      );
    }

    return poster;
  }
}

class MovieGridView extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const MovieGridView({
    super.key,
    required this.movies,
    required this.onMovieTap,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppLoadingIndicator(
        message: 'Carregando filmes...',
      );
    }

    if (errorMessage != null) {
      return AppErrorWidget(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    if (movies.isEmpty) {
      return const AppEmptyState(
        title: 'Nenhum filme encontrado',
        subtitle: 'Tente selecionar outro gênero ou recarregar a página.',
        icon: Icons.movie_outlined,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveUtils.getResponsiveGridColumns(context);
        final spacing = ResponsiveUtils.isMobile(context) 
          ? AppConstants.spacingM 
          : AppConstants.spacingL;

        return GridView.builder(
          padding: EdgeInsets.all(spacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 0.67, // Aspect ratio for movie cards
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(
              movie: movies[index],
              onTap: () => onMovieTap(movies[index]),
            );
          },
        );
      },
    );
  }
}

class MovieListView extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap;
  final Axis scrollDirection;
  final double itemWidth;
  final double itemHeight;

  const MovieListView({
    super.key,
    required this.movies,
    required this.onMovieTap,
    this.scrollDirection = Axis.horizontal,
    this.itemWidth = 120,
    this.itemHeight = 180,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: scrollDirection == Axis.horizontal ? itemHeight + 40 : null,
      child: ListView.builder(
        scrollDirection: scrollDirection,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              right: scrollDirection == Axis.horizontal 
                ? AppConstants.spacingM 
                : 0,
              bottom: scrollDirection == Axis.vertical 
                ? AppConstants.spacingM 
                : 0,
            ),
            child: MoviePoster(
              movie: movies[index],
              width: itemWidth,
              height: itemHeight,
              onTap: () => onMovieTap(movies[index]),
              showOverlay: true,
            ),
          );
        },
      ),
    );
  }
}