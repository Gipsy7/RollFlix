import 'package:flutter/material.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/app_mode_controller.dart';
import '../models/favorite_item.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/error_widgets.dart';
import '../widgets/ux_components.dart';
import 'movie_details_screen.dart';
import 'tv_show_details_screen.dart';

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
            title: LayoutBuilder(
              builder: (context, constraints) {
                // Se a largura disponível for menor que 300, mostra apenas "Favoritos"
                final showFullTitle = constraints.maxWidth > 300;
                return SafeText(
                  showFullTitle ? 'Meus Favoritos' : 'Favoritos',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
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
                tooltip: 'Limpar todos',
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
                  _appModeController.isSeriesMode ? 'SÉRIES' : 'FILMES',
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
      return UXComponents.loadingWithText(
        text: 'Carregando favoritos...',
      );
    }

    if (favorites.isEmpty) {
      final contentType = _appModeController.isSeriesMode ? 'séries' : 'filmes';
      return UXComponents.emptyState(
        title: 'Nenhum favorito ainda',
        message: 'Adicione $contentType aos favoritos\npara vê-los aqui!',
        icon: _appModeController.isSeriesMode ? Icons.tv : Icons.movie,
      );
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

  Widget _buildFavoriteCard(FavoriteItem favorite, bool isMobile, Color accentColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (favorite.isTVShow) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TVShowDetailsScreen(
                  tvShow: favorite.toTVShow(),
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(
                  movie: favorite.toMovie(),
                ),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: favorite.posterPath != null
                    ? Image.network(
                        '${AppConstants.tmdbImageBaseUrl}${favorite.posterPath}',
                        width: isMobile ? 80 : 100,
                        height: isMobile ? 120 : 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPosterPlaceholder(isMobile),
                      )
                    : _buildPosterPlaceholder(isMobile),
              ),
              const SizedBox(width: 16),
              
              // Informações
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _appModeController.isSeriesMode ? Icons.tv : Icons.movie,
                          size: 16,
                          color: accentColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: SafeText(
                            favorite.title,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: accentColor,
                        ),
                        const SizedBox(width: 4),
                        SafeText(
                          favorite.voteAverage.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SafeText(
                          favorite.year,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SafeText(
                          favorite.typeDescription,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (favorite.overview != null && favorite.overview!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      SafeText(
                        favorite.overview!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Botão remover
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                onPressed: () => _removeFavorite(favorite),
                tooltip: 'Remover dos favoritos',
              ),
            ],
          ),
        ),
      ),
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
          'Remover favorito?',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: SafeText(
          'Deseja remover "${favorite.title}" dos favoritos?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: SafeText(
              'Cancelar',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _favoritesController.removeFavorite(favorite.id);
              Navigator.pop(context);
              AppSnackBar.showSuccess(context, 'Removido dos favoritos');
            },
            child: SafeText(
              'Remover',
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
      final contentType = _appModeController.isSeriesMode ? 'séries' : 'filmes';
      AppSnackBar.showInfo(context, 'Não há $contentType favoritos para limpar');
      return;
    }

    final contentType = _appModeController.isSeriesMode ? 'séries' : 'filmes';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: SafeText(
          'Limpar todos os favoritos?',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: SafeText(
          'Todos os ${currentFavorites.length} $contentType favoritos serão removidos. Esta ação não pode ser desfeita.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: SafeText(
              'Cancelar',
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
              AppSnackBar.showSuccess(context, 'Todos os $contentType favoritos foram removidos');
            },
            child: SafeText(
              'Limpar Tudo',
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
