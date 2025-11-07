import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../core/constants/constants.dart';
import '../../../controllers/user_preferences_controller.dart';
import '../../../services/subscription_service.dart';

/// Seção de estatísticas rápidas de recursos (Rolls, Favorites, Watched)
/// 
/// Exibe:
/// - Contador de recursos disponíveis
/// - Status de cooldown para recursos esgotados
/// - Indicador de possibilidade de assistir anúncio para recarregar
/// - Botão interativo para assistir anúncio (quando disponível)
class QuickStatsSection extends StatelessWidget {
  final bool isMobile;
  final UserPreferencesController userPreferencesController;
  final bool isSeriesMode;
  final Color currentAccentColor;
  final Function(ResourceType resourceType, String resourceName) onAdTapped;

  const QuickStatsSection({
    super.key,
    required this.isMobile,
    required this.userPreferencesController,
    required this.isSeriesMode,
    required this.currentAccentColor,
    required this.onAdTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: userPreferencesController,
      builder: (context, _) {
        return Container(
          padding: EdgeInsets.all(AppNumbers.spacingMedium + 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: AppNumbers.glassOpacity),
            borderRadius: BorderRadius.circular(AppNumbers.borderRadiusSmall),
            border: Border.all(
              color: Colors.white.withValues(alpha: AppNumbers.highlightOpacity),
              width: AppNumbers.borderWidth / 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildResourceItem(
                context: context,
                icon: Icons.play_circle_filled,
                label: AppLocalizations.of(context)!.rolls,
                resourceType: ResourceType.roll,
                color: Colors.blue,
              ),
              _buildResourceItem(
                context: context,
                icon: Icons.favorite,
                label: AppLocalizations.of(context)!.favorites,
                resourceType: ResourceType.favorite,
                color: Colors.red,
              ),
              _buildResourceItem(
                context: context,
                icon: Icons.check_circle,
                label: AppLocalizations.of(context)!.watched,
                resourceType: ResourceType.watched,
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResourceItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ResourceType resourceType,
    required Color color,
  }) {
    final uses = userPreferencesController.userResources.getUses(resourceType);
    final canUse = userPreferencesController.canUseResource(resourceType);
    final isSubscribed = SubscriptionService.isSubscribedCached;
    final cooldown = userPreferencesController.getResourceCooldown(resourceType);
    final maxUses = UserResources.maxUses;

    String displayValue;
    Color displayColor = color;
    String? subtitle;
    bool canWatchAd = uses < maxUses; // Pode assistir anúncio se tiver menos de 5

    if (isSubscribed) {
      // Usuário assinante: exibe infinito e não permite ver anúncios para recarregar
      displayValue = '∞';
      subtitle = 'Ilimitado';
      canWatchAd = false;
      displayColor = color;
    } else {
      if (canUse) {
        displayValue = uses.toString();
        subtitle = AppLocalizations.of(context)!.available;
      } else if (cooldown != null) {
        // Formatar tempo restante
        final hours = cooldown.inHours;
        final minutes = cooldown.inMinutes.remainder(60);
        displayValue = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
        displayColor = Colors.grey;
        subtitle = AppLocalizations.of(context)!.reloading;
      } else {
        displayValue = '0';
        displayColor = Colors.grey;
        subtitle = AppLocalizations.of(context)!.unavailable;
      }
    }

    // Widget base: usa constraints para manter boa responsividade e área de toque
    final minWidth = isMobile ? 72.0 : 110.0;
    final minHeight = isMobile ? 64.0 : 80.0;

    final content = ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: displayColor, size: isMobile ? 20 : 24),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                displayValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (isMobile ? AppTextStyles.labelLarge : AppTextStyles.headlineSmall).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: canUse ? Colors.white.withValues(alpha: 0.7) : Colors.red.withValues(alpha: 0.7),
                  fontSize: isMobile ? 10 : 12,
                ),
              ),
            ),
            // Indicador visual de que pode assistir anúncio
            if (canWatchAd)
              Padding(
                padding: EdgeInsets.only(top: AppNumbers.spacingSmall - 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videocam,
                      size: isMobile ? 12 : 14,
                      color: AppColors.primary.withValues(alpha: 0.9),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.tapPlusOne,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 12,
                          color: AppColors.primary.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    // Envolve num Material para garantir efeito ripple correto e área de toque maior
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canWatchAd ? () => onAdTapped(resourceType, label) : null,
        borderRadius: BorderRadius.circular(AppNumbers.borderRadiusSmall),
        splashFactory: InkRipple.splashFactory,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppNumbers.spacingSmall,
            vertical: AppNumbers.spacingSmall - 2,
          ),
          child: content,
        ),
      ),
    );
  }
}
