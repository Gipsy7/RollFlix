import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../controllers/app_mode_controller.dart';
import '../widgets/responsive_widgets.dart';
import 'package:rollflix/l10n/app_localizations.dart';

/// Widget do cabeçalho que exibe o modo atual (Filme/Série)
/// e permite alternar entre os modos
class ContentModeHeader extends StatelessWidget {
  final AppModeController appModeController;
  final LinearGradient currentGradient;
  final bool isMobile;
  final VoidCallback onModeChanged;

  const ContentModeHeader({
    super.key,
    required this.appModeController,
    required this.currentGradient,
    required this.isMobile,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        gradient: currentGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SafeText(
              appModeController.isSeriesMode 
                  ? AppLocalizations.of(context)!.seriesMode 
                  : AppLocalizations.of(context)!.movieMode,
              style: isMobile
                  ? AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.backgroundDark,
                      fontWeight: FontWeight.bold,
                    )
                  : AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.backgroundDark,
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ),
          _buildSwapButton(context),
        ],
      ),
    );
  }

  Widget _buildSwapButton(BuildContext context) {
    return Tooltip(
      message: appModeController.isSeriesMode 
          ? AppLocalizations.of(context)!.switchToMovies 
          : AppLocalizations.of(context)!.switchToSeries,
      child: IconButton(
        icon: Icon(
          appModeController.isSeriesMode ? Icons.movie : Icons.tv,
          color: AppColors.backgroundDark,
          size: isMobile ? 24 : 28,
        ),
        onPressed: () {
          appModeController.toggleMode();
          onModeChanged();
        },
      ),
    );
  }
}
