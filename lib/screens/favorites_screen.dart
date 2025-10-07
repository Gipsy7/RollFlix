import 'package:flutter/material.dart';
import '../controllers/favorites_controller.dart';
import '../models/favorite_item.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/error_widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late final FavoritesController _favoritesController;
  late final TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _favoritesController = FavoritesController.instance;
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        title: SafeText(
          'Meus Favoritos',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
        iconTheme: const IconThemeData(color: AppColors.primary),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Limpar todos',
            onPressed: _showClearAllDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Todos', icon: Icon(Icons.star)),
            Tab(text: 'Filmes', icon: Icon(Icons.movie)),
            Tab(text: 'Séries', icon: Icon(Icons.tv)),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: _favoritesController,
        builder: (context, _) {
          if (_favoritesController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildFavoritesList(_favoritesController.favorites, isMobile),
              _buildFavoritesList(_favoritesController.favoriteMovies, isMobile),
              _buildFavoritesList(_favoritesController.favoriteTVShows, isMobile),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFavoritesList(List<FavoriteItem> favorites, bool isMobile) {
    if (favorites.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return _buildFavoriteCard(favorite, isMobile);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          SafeText(
            'Nenhum favorito ainda',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SafeText(
            'Adicione filmes e séries aos favoritos\npara vê-los aqui!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(FavoriteItem favorite, bool isMobile) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: favorite.isTVShow 
              ? const Color(0xFFBB86FC).withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navegar para detalhes
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
                          favorite.isTVShow ? Icons.tv : Icons.movie,
                          size: 16,
                          color: favorite.isTVShow 
                              ? const Color(0xFFBB86FC)
                              : AppColors.primary,
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
                          color: AppColors.primary,
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
    if (!_favoritesController.hasFavorites) {
      AppSnackBar.showInfo(context, 'Não há favoritos para limpar');
      return;
    }

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
          'Todos os ${_favoritesController.count} favoritos serão removidos. Esta ação não pode ser desfeita.',
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
              _favoritesController.clearAll();
              Navigator.pop(context);
              AppSnackBar.showSuccess(context, 'Todos os favoritos foram removidos');
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
