import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/ux_components.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/watched_controller.dart';
import '../controllers/user_preferences_controller.dart';
import 'package:rollflix/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await AuthService.signInWithGoogle();
      
      if (userCredential != null && mounted) {
        // Sincroniza favoritos, assistidos e preferências após login
        await Future.wait([
          FavoritesController.instance.syncAfterLogin(),
          WatchedController.instance.syncAfterLogin(),
          UserPreferencesController.instance.syncAfterLogin(),
        ]);
        
        // O AuthWrapper detectará automaticamente a mudança de autenticação
        // e navegará para MovieSorterApp
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.loginError(e.toString())),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cinemaGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 24 : 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.movie_filter,
                    size: isMobile ? 80 : 120,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  
                  // Título
                  SafeText(
                    'RollFlix',
                    style: (isMobile 
                        ? AppTextStyles.displaySmall
                        : AppTextStyles.displayMedium).copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtítulo
                  SafeText(
                    AppLocalizations.of(context)!.rollAndChill,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: isMobile ? 48 : 64),
                  
                  // Card de login
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SafeText(
                          AppLocalizations.of(context)!.welcome,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        SafeText(
                          AppLocalizations.of(context)!.loginToAccess,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        if (_isLoading)
                          UXComponents.loadingWithText(
                            text: AppLocalizations.of(context)!.connectingGoogle,
                          )
                        else
                          // Botão Google
                          _buildSocialButton(
                            onPressed: _signInWithGoogle,
                            icon: Icons.g_mobiledata,
                            label: AppLocalizations.of(context)!.continueWithGoogle,
                            color: Colors.white,
                            textColor: Colors.black87,
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Informação adicional
                  SafeText(
                    AppLocalizations.of(context)!.loginTerms,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
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

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            SafeText(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
