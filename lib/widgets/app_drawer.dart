import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../controllers/app_mode_controller.dart';
import '../controllers/movie_controller.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/error_widgets.dart';
import '../screens/search_screen.dart';
import '../screens/tv_series_search_screen.dart';
import '../screens/date_night_screen.dart';

/// Widget do menu lateral (drawer) da aplicação
/// Gerencia navegação e opções do app
class AppDrawer extends StatelessWidget {
  final AppModeController appModeController;
  final MovieController movieController;
  final LinearGradient currentGradient;
  final bool isMobile;

  const AppDrawer({
    super.key,
    required this.appModeController,
    required this.movieController,
    required this.currentGradient,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundDark,
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: _buildMenuItems(context),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: currentGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_movies,
                color: AppColors.textPrimary,
                size: 32,
              ),
              const SizedBox(width: 12),
              SafeText(
                'RollFlix',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SafeText(
            'Roll and chill',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildDrawerItem(
          context: context,
          icon: Icons.home,
          title: 'Início',
          onTap: () => Navigator.pop(context),
        ),
        
        // Pesquisa baseada no modo atual
        if (!appModeController.isSeriesMode)
          _buildDrawerItem(
            context: context,
            icon: Icons.search,
            title: 'Pesquisar Filmes',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        if (appModeController.isSeriesMode)
          _buildDrawerItem(
            context: context,
            icon: Icons.search,
            title: 'Pesquisar Séries',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TVSeriesSearchScreen(),
                ),
              );
            },
          ),
          
        _buildDrawerItem(
          context: context,
          icon: Icons.favorite,
          title: 'Date Night',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DateNightScreen(),
              ),
            );
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.refresh,
          title: 'Limpar Cache',
          onTap: () {
            movieController.clearCache();
            Navigator.pop(context);
            AppSnackBar.showSuccess(context, 'Cache limpo com sucesso!');
          },
        ),
        
        const Divider(color: AppColors.textSecondary),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.info_outline,
          title: 'Sobre o App',
          onTap: () {
            Navigator.pop(context);
            _showAboutDialog(context);
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.settings,
          title: 'Configurações',
          onTap: () {
            Navigator.pop(context);
            AppSnackBar.showInfo(context, 'Em breve: Configurações');
          },
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: 24,
      ),
      title: SafeText(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      splashColor: AppColors.primary.withAlpha(1),
      hoverColor: AppColors.primary.withAlpha(05),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SafeText(
        'Versão ${AppConstants.appVersion}',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        title: SafeText(
          'Sobre o RollFlix',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeText(
              'Aplicativo para descobrir filmes e séries aleatórios por gênero.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SafeText(
              'Desenvolvido com Flutter',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SafeText(
              'Dados fornecidos por The Movie Database (TMDb)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: SafeText(
              'Fechar',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
