import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/app_mode_controller.dart';
import '../../../controllers/user_preferences_controller.dart';
import '../../../widgets/responsive_widgets.dart';
import '../../../core/constants/constants.dart';

/// AppBar customizada da tela principal
/// 
/// Contém:
/// - Logo e título do app
/// - Botão de preferências (com indicador de filtros ativos)
/// - Botão de alternar entre Filmes/Séries
/// - Gradiente dinâmico baseado no modo atual
class HomeAppBar extends StatelessWidget {
  final bool isMobile;
  final LinearGradient currentGradient;
  final Color currentAccentColor;
  final AppModeController appModeController;
  final UserPreferencesController userPreferencesController;
  final VoidCallback onToggleContentMode;
  final VoidCallback onOpenPreferences;
  final Widget Function() buildHeader;

  const HomeAppBar({
    super.key,
    required this.isMobile,
    required this.currentGradient,
    required this.currentAccentColor,
    required this.appModeController,
    required this.userPreferencesController,
    required this.onToggleContentMode,
    required this.onOpenPreferences,
    required this.buildHeader,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: isMobile ? AppNumbers.appBarExpandedHeightMobile : AppNumbers.appBarExpandedHeightDesktop,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: AppColors.textPrimary,
            size: AppNumbers.menuIconSize,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: AppLocalizations.of(context)!.menu,
        ),
      ),
      actions: [
        _buildPreferencesButton(context),
        SizedBox(width: isMobile ? AppNumbers.spacingSmall : AppNumbers.spacingMedium),
        _buildSwapButton(context),
        SizedBox(width: isMobile ? AppNumbers.spacingSmall : AppNumbers.spacingLarge),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: currentGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? AppNumbers.paddingMobile : AppNumbers.paddingDesktop),
              child: buildHeader(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesButton(BuildContext context) {
    final hasFilters = userPreferencesController.rollPreferences.hasFilters;

    return AnimatedContainer(
      duration: AppDurations.container,
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(vertical: AppNumbers.verticalMargin),
      decoration: BoxDecoration(
        gradient: appModeController.isSeriesMode
            ? AppColors.secondaryGradient
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppNumbers.borderRadiusMedium),
        border: Border.all(
          color: appModeController.isSeriesMode
              ? AppColors.secondary.withValues(alpha: AppNumbers.borderOpacity)
              : AppColors.primary.withValues(alpha: AppNumbers.borderOpacity),
          width: AppNumbers.borderWidth,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppNumbers.borderRadiusMedium),
          onTap: onOpenPreferences,
          splashColor: currentAccentColor.withValues(alpha: AppNumbers.splashOpacity),
          highlightColor: currentAccentColor.withValues(alpha: AppNumbers.highlightOpacity),
          child: AnimatedPadding(
            duration: AppDurations.medium,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(isMobile ? AppNumbers.iconButtonPaddingMobile : AppNumbers.iconButtonPaddingDesktop),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: AppDurations.medium,
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                    child: Icon(
                      Icons.tune,
                      key: ValueKey(hasFilters),
                      color: !appModeController.isSeriesMode
                          ? Colors.black
                          : AppColors.textPrimary,
                      size: isMobile ? AppNumbers.iconSizeMediumMobile : AppNumbers.iconSizeMediumDesktop,
                    ),
                  ),
                  if (hasFilters)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: AnimatedContainer(
                        duration: AppDurations.medium,
                        curve: Curves.easeOutBack,
                        width: AppNumbers.filterIndicatorSize,
                        height: AppNumbers.filterIndicatorSize,
                        decoration: BoxDecoration(
                          color: !appModeController.isSeriesMode
                              ? Colors.black
                              : AppColors.textPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: appModeController.isSeriesMode
                                ? AppColors.secondary
                                : AppColors.primary,
                            width: AppNumbers.filterIndicatorBorderWidth,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (!appModeController.isSeriesMode
                                      ? Colors.black
                                      : AppColors.textPrimary)
                                  .withValues(alpha: AppNumbers.shadowOpacity),
                              blurRadius: AppNumbers.shadowBlurMedium,
                              offset: Offset(0, AppNumbers.shadowOffsetMedium),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color: !appModeController.isSeriesMode
                              ? AppColors.primary
                              : AppColors.secondary,
                          size: AppNumbers.filterIndicatorIconSize,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwapButton(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.container,
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(vertical: AppNumbers.verticalMargin),
      decoration: BoxDecoration(
        gradient: appModeController.isSeriesMode
            ? AppColors.secondaryGradient
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppNumbers.borderRadiusPill),
        border: Border.all(
          color: appModeController.isSeriesMode
              ? AppColors.secondary.withValues(alpha: AppNumbers.borderOpacity)
              : AppColors.primary.withValues(alpha: AppNumbers.borderOpacity),
          width: AppNumbers.borderWidth,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppNumbers.borderRadiusPill),
          onTap: onToggleContentMode,
          splashColor: currentAccentColor.withValues(alpha: AppNumbers.splashOpacity),
          highlightColor: currentAccentColor.withValues(alpha: AppNumbers.highlightOpacity),
          child: AnimatedPadding(
            duration: AppDurations.medium,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppNumbers.buttonPaddingHorizontalMobile : AppNumbers.buttonPaddingHorizontalDesktop,
              vertical: AppNumbers.buttonPaddingVertical,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: AppDurations.medium,
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  ),
                  child: Icon(
                    appModeController.isSeriesMode ? Icons.tv : Icons.movie,
                    key: ValueKey(appModeController.isSeriesMode),
                    color: !appModeController.isSeriesMode 
                        ? Colors.black 
                        : AppColors.textPrimary,
                    size: isMobile ? AppNumbers.iconSizeSmallMobile : AppNumbers.iconSizeSmallDesktop,
                  ),
                ),
                SizedBox(width: AppNumbers.spacingSmall),
                AnimatedSwitcher(
                  duration: AppDurations.medium,
                  transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                  child: SafeText(
                    appModeController.isSeriesMode 
                        ? AppLocalizations.of(context)!.seriesUpper 
                        : AppLocalizations.of(context)!.moviesUpper,
                    key: ValueKey(appModeController.isSeriesMode),
                    style: (isMobile
                        ? AppTextStyles.labelMedium
                        : AppTextStyles.labelLarge).copyWith(
                      color: !appModeController.isSeriesMode 
                          ? Colors.black 
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: AppNumbers.letterSpacingCaps,
                      shadows: [
                        Shadow(
                          color: AppColors.backgroundDark.withValues(alpha: AppNumbers.glassOpacity),
                          blurRadius: AppNumbers.shadowBlurSmall,
                          offset: Offset(0, AppNumbers.shadowOffsetSmall),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppNumbers.spacingSmall),
                AnimatedSwitcher(
                  duration: AppDurations.medium,
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: Tween<double>(
                      begin: AppNumbers.rotationTweenBegin,
                      end: AppNumbers.rotationTweenEnd,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.elasticOut,
                    )),
                    child: ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    key: ValueKey('swap_${appModeController.isSeriesMode}'),
                    color: !appModeController.isSeriesMode 
                          ? Colors.black 
                          : AppColors.textPrimary,
                    size: isMobile ? AppNumbers.iconSizeSmallMobile : AppNumbers.iconSizeSmallDesktop,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
