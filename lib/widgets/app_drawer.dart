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
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

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
    // Ícone e texto adaptativos baseados no modo
    final headerIcon = appModeController.isSeriesMode 
        ? Icons.tv // TV para séries
        : Icons.local_movies; // Cinema para filmes
    
    final headerSubtitle = appModeController.isSeriesMode
        ? 'Descubra séries incríveis'
        : 'Roll and chill';
    
    // Cor adaptativa para o subtítulo
    final subtitleColor = appModeController.isSeriesMode 
        ? const Color(0xFFBB86FC) // Roxo claro para séries
        : AppColors.textSecondary; // Dourado para filmes
    
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
                headerIcon,
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
            headerSubtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color: subtitleColor,
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
          icon: AuthService.isUserLoggedIn() ? Icons.person : Icons.login,
          title: AuthService.isUserLoggedIn() ? 'Meu Perfil' : 'Entrar',
          onTap: () {
            Navigator.pop(context);
            if (AuthService.isUserLoggedIn()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.favorite,
          title: 'Meus Favoritos',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoritesScreen(),
              ),
            );
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.favorite_border,
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
        
        Divider(
          color: appModeController.isSeriesMode 
              ? const Color(0xFFBB86FC).withAlpha(80) // Roxo transparente
              : AppColors.textSecondary, // Dourado
        ),
        
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
    // Cor adaptativa baseada no modo
    final iconColor = appModeController.isSeriesMode 
        ? const Color(0xFFBB86FC) // Roxo claro para séries
        : AppColors.primary; // Dourado para filmes
    
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
        size: 24,
      ),
      title: SafeText(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      splashColor: iconColor.withAlpha(30),
      hoverColor: iconColor.withAlpha(15),
    );
  }

  Widget _buildFooter() {
    // Cor adaptativa para o texto do footer
    final footerColor = appModeController.isSeriesMode 
        ? const Color(0xFFBB86FC).withAlpha(150) // Roxo semi-transparente
        : AppColors.textSecondary; // Dourado
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: SafeText(
        'Versão ${AppConstants.appVersion}',
        style: AppTextStyles.bodySmall.copyWith(
          color: footerColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    // Cor adaptativa para textos e botão
    final accentColor = appModeController.isSeriesMode 
        ? const Color(0xFFBB86FC) // Roxo claro para séries
        : AppColors.primary; // Dourado para filmes
    
    final secondaryTextColor = appModeController.isSeriesMode 
        ? const Color(0xFFBB86FC).withAlpha(180) // Roxo mais transparente
        : AppColors.textSecondary; // Dourado
    
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
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            SafeText(
              'Desenvolvido com Flutter',
              style: AppTextStyles.bodySmall.copyWith(
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            SafeText(
              'Dados fornecidos por The Movie Database (TMDb)',
              style: AppTextStyles.bodySmall.copyWith(
                color: secondaryTextColor,
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
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
