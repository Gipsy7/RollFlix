import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = AppConstants.radiusM,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
      (isOutlined ? Colors.transparent : AppColors.primary);
    
    final effectiveTextColor = textColor ?? 
      (isOutlined ? AppColors.primary : Colors.white);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
        ] else if (icon != null) ...[
          Icon(icon, size: 16, color: effectiveTextColor),
          const SizedBox(width: AppConstants.spacingS),
        ],
        Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(
            color: effectiveTextColor,
          ),
        ),
      ],
    );

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          elevation: 0,
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: isOutlined 
              ? BorderSide(color: AppColors.primary, width: 1)
              : BorderSide.none,
          ),
        ),
        child: content,
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double borderRadius;
  final double elevation;
  final VoidCallback? onTap;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius = AppConstants.radiusL,
    this.elevation = 0,
    this.onTap,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.spacingL),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow ?? (elevation > 0 ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ] : null),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    return content;
  }
}

class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const AppLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppConstants.spacingM),
            Text(
              message!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              message,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.spacingL),
              AppButton(
                text: 'Tentar Novamente',
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              title,
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: AppConstants.spacingL),
              AppButton(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}