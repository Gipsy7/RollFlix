import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../constants/app_constants.dart';
import '../../../core/constants/constants.dart';

/// Header da tela inicial com logo e título
/// 
/// Componente visual que exibe:
/// - Logo do app com animação
/// - Título "Rollflix"
/// - Subtítulo com modo atual (Filmes/Séries)
class HomeHeader extends StatelessWidget {
  final bool isMobile;
  final String currentModeLabel;

  const HomeHeader({
    super.key,
    required this.isMobile,
    required this.currentModeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            _buildLogo(),
            const SizedBox(width: 20),
            Expanded(child: _buildTitleSection(context)),
          ],
        ),
      ],
    );
  }

  /// Logo com gradiente e sombra
  Widget _buildLogo() {
    return Container(
      width: isMobile ? AppNumbers.logoSizeMobile : AppNumbers.logoSizeDesktop,
      height: isMobile ? AppNumbers.logoSizeMobile : AppNumbers.logoSizeDesktop,
      padding: EdgeInsets.all(AppNumbers.spacingSmall),
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: BorderRadius.circular(AppNumbers.borderRadiusCard),
        border: Border.all(
          color: Colors.white.withValues(alpha: AppNumbers.glassOpacity),
          width: AppNumbers.borderWidth / 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.local_movies,
        color: AppColors.textPrimary,
        size: isMobile ? 40 : 48,
      ),
    );
  }

  /// Seção de título com nome do app e subtítulo
  Widget _buildTitleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.appName,
          style: AppTextStyles.headlineLarge.copyWith(
            fontSize: isMobile ? 28 : 36,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: AppColors.backgroundDark.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          // Placeholder - será substituído por localização real
          'Roll & Chill with $currentModeLabel',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            fontSize: isMobile ? 14 : 16,
            shadows: [
              Shadow(
                color: AppColors.backgroundDark.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
