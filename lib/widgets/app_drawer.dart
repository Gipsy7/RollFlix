import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../controllers/app_mode_controller.dart';
import '../controllers/movie_controller.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/error_widgets.dart';
import '../screens/search_screen.dart';
import '../screens/tv_series_search_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/watched_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/notification_history_screen.dart';
import '../screens/about_screen.dart';
import '../services/auth_service.dart';
import '../services/recipe_cache_service.dart';
import '../utils/page_transitions.dart';

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
              Navigator.of(context).pushSearch(const SearchScreen());
            },
          ),
        if (appModeController.isSeriesMode)
          _buildDrawerItem(
            context: context,
            icon: Icons.search,
            title: 'Pesquisar Séries',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushSearch(const TVSeriesSearchScreen());
            },
          ),
          
        _buildDrawerItem(
          context: context,
          icon: AuthService.isUserLoggedIn() ? Icons.person : Icons.login,
          title: AuthService.isUserLoggedIn() ? 'Meu Perfil' : 'Entrar',
          onTap: () {
            Navigator.pop(context);
            if (AuthService.isUserLoggedIn()) {
              Navigator.of(context).pushSmooth(const ProfileScreen());
            } else {
              Navigator.of(context).pushSmooth(const LoginScreen());
            }
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.favorite,
          title: 'Meus Favoritos',
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushSmooth(const FavoritesScreen());
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.check_circle,
          title: 'Já Assisti',
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushSmooth(const WatchedScreen());
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.favorite_border,
          title: 'Date Night 🚧',
          onTap: () {
            Navigator.pop(context);
            // Modo bloqueado - em desenvolvimento
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.construction, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Date Night em desenvolvimento!\nEm breve disponível 🚀',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange.shade700,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.refresh,
          title: 'Limpar Cache',
          onTap: () async {
            movieController.clearCache();
            await RecipeCacheService.clearAllCache();
            if (!context.mounted) return;
            Navigator.pop(context);
            AppSnackBar.showSuccess(context, 'Cache de filmes e receitas limpo!');
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
            Navigator.of(context).pushSmooth(
              const AboutScreen(),
            );
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.notifications,
          title: 'Histórico de Notificações',
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushSmooth(
              const NotificationHistoryScreen(),
            );
          },
        ),
        
        _buildDrawerItem(
          context: context,
          icon: Icons.settings,
          title: 'Configurações',
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushSettings(const SettingsScreen());
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
}
