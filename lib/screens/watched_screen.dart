import 'package:flutter/material.dart';
import '../controllers/watched_controller.dart';
import '../controllers/app_mode_controller.dart';
import '../models/watched_item.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/responsive_widgets.dart';
import 'movie_details_screen.dart';
import 'tv_show_details_screen.dart';

class WatchedScreen extends StatefulWidget {
  const WatchedScreen({super.key});

  @override
  State<WatchedScreen> createState() => _WatchedScreenState();
}

class _WatchedScreenState extends State<WatchedScreen> {
  late final WatchedController _watchedController;
  late final AppModeController _appModeController;
  
  @override
  void initState() {
    super.initState();
    _watchedController = WatchedController.instance;
    _appModeController = AppModeController.instance;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return ListenableBuilder(
      listenable: Listenable.merge([
        _watchedController,
        _appModeController,
      ]),
      builder: (context, _) {
        // Obtém os assistidos baseado no modo atual
        final currentWatched = _appModeController.isSeriesMode
            ? _watchedController.tvShows
            : _watchedController.movies;
        
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
              'Já Assisti',
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
                tooltip: 'Limpar todos',
                color: accentColor,
                onPressed: currentWatched.isEmpty ? null : _showClearAllDialog,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _buildBody(currentWatched, isMobile, accentColor),
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

  Widget _buildBody(List<WatchedItem> watchedItems, bool isMobile, Color accentColor) {
    if (_watchedController.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
        ),
      );
    }

    if (watchedItems.isEmpty) {
      return _buildEmptyState(accentColor);
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: watchedItems.length,
      itemBuilder: (context, index) {
        final watchedItem = watchedItems[index];
        return _buildWatchedCard(watchedItem, isMobile, accentColor);
      },
    );
  }

  Widget _buildEmptyState(Color accentColor) {
    final contentType = _appModeController.isSeriesMode ? 'séries' : 'filmes';
    
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
            'Nenhum item assistido',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SafeText(
              'Marque os $contentType que você já assistiu para vê-los aqui',
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

  Widget _buildWatchedCard(WatchedItem item, bool isMobile, Color accentColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetails(item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              _buildPoster(item, isMobile),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: _buildInfo(item, isMobile, accentColor),
              ),
              // Remove button
              IconButton(
                icon: const Icon(Icons.check_circle),
                color: accentColor,
                onPressed: () => _removeFromWatched(item),
                tooltip: 'Remover de assistidos',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoster(WatchedItem item, bool isMobile) {
    final width = isMobile ? 80.0 : 100.0;
    final height = isMobile ? 120.0 : 150.0;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: item.posterPath != null && item.posterPath!.isNotEmpty
          ? Image.network(
              '${AppConstants.tmdbImageBaseUrl}${item.posterPath}',
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(width, height),
            )
          : _buildPlaceholder(width, height),
    );
  }

  Widget _buildPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceDark,
      child: Icon(
        Icons.movie,
        color: AppColors.textSecondary.withValues(alpha: 0.3),
        size: 40,
      ),
    );
  }

  Widget _buildInfo(WatchedItem item, bool isMobile, Color accentColor) {
    final year = item.releaseDate.isNotEmpty 
        ? item.releaseDate.split('-')[0] 
        : '';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        SafeText(
          item.title,
          style: (isMobile 
              ? AppTextStyles.bodyLarge
              : AppTextStyles.headlineSmall).copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Ano e tipo
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
              item.isTVShow ? Icons.tv : Icons.movie,
              size: 14,
              color: accentColor,
            ),
            const SizedBox(width: 4),
            SafeText(
              item.isTVShow ? 'Série' : 'Filme',
              style: AppTextStyles.bodySmall.copyWith(
                color: accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Avaliação
        Row(
          children: [
            Icon(
              Icons.star,
              size: 16,
              color: AppColors.accent,
            ),
            const SizedBox(width: 4),
            SafeText(
              item.voteAverage.toStringAsFixed(1),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Data assistido
        SafeText(
          _formatWatchedDate(item.watchedAt),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  String _formatWatchedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Assistido hoje';
    } else if (difference.inDays == 1) {
      return 'Assistido ontem';
    } else if (difference.inDays < 7) {
      return 'Assistido há ${difference.inDays} dias';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Assistido há $weeks ${weeks == 1 ? "semana" : "semanas"}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Assistido há $months ${months == 1 ? "mês" : "meses"}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Assistido há $years ${years == 1 ? "ano" : "anos"}';
    }
  }

  void _navigateToDetails(WatchedItem item) {
    if (item.isTVShow) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TVShowDetailsScreen(
            tvShow: item.toTVShow(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsScreen(
            movie: item.toMovie(),
          ),
        ),
      );
    }
  }

  void _removeFromWatched(WatchedItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: SafeText(
          'Remover de assistidos?',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: SafeText(
          'Tem certeza que deseja remover "${item.title}" da lista de assistidos?',
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _watchedController.removeWatchedItem(item.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: SafeText('Removido de assistidos'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: SafeText(
              'Remover',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    final contentType = _appModeController.isSeriesMode ? 'séries' : 'filmes';
    final count = _appModeController.isSeriesMode 
        ? _watchedController.tvShows.length
        : _watchedController.movies.length;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: SafeText(
          'Limpar todos os assistidos?',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: SafeText(
          'Tem certeza que deseja remover todos os $count $contentType assistidos?',
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Remove apenas do modo atual
              if (_appModeController.isSeriesMode) {
                for (var show in _watchedController.tvShows.toList()) {
                  _watchedController.removeWatchedItem(show.id);
                }
              } else {
                for (var movie in _watchedController.movies.toList()) {
                  _watchedController.removeWatchedItem(movie.id);
                }
              }
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: SafeText('Todos os $contentType foram removidos'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: SafeText(
              'Limpar Tudo',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
