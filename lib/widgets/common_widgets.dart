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
    // Seguindo as regras: fundo amarelo = texto preto; fundo preto = texto branco/amarelo
    final effectiveTextColor = textColor ?? 
      (isOutlined ? AppColors.primary : AppColors.backgroundDark); // Preto no fundo dourado

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          Icon(icon, size: 20, color: effectiveTextColor),
          const SizedBox(width: 12),
        ],
        Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(
            color: effectiveTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return Container(
      width: width,
      height: height ?? 56,
      decoration: BoxDecoration(
        gradient: backgroundColor != null 
          ? null 
          : (isOutlined ? null : AppColors.primaryGradient),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: isOutlined 
          ? Border.all(color: AppColors.primary, width: 2)
          : null,
        // Sombras removidas para visual mais limpo
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double borderRadius;
  final double elevation;
  final VoidCallback? onTap;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final bool enableGlassEffect;
  final bool enableHoverEffect;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius = 20,
    this.elevation = 0,
    this.onTap,
    this.border,
    this.boxShadow,
    this.enableGlassEffect = true,
    this.enableHoverEffect = true,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Visual limpo sem efeitos excessivos
    final defaultShadow = widget.boxShadow ?? (widget.elevation > 0 ? [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: widget.elevation * 3,
        offset: Offset(0, widget.elevation * 2),
      ),
    ] : null);

    Widget content = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(20),
            margin: widget.margin,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? AppColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.border ?? Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: defaultShadow,
              // Gradiente removido para visual mais limpo
            ),
            child: widget.child,
          ),
        );
      },
    );

    if (widget.onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _animationController.forward().then((_) {
              _animationController.reverse();
            });
            widget.onTap?.call();
          },
          onTapDown: widget.enableHoverEffect ? (_) {
            _animationController.forward();
          } : null,
          onTapUp: widget.enableHoverEffect ? (_) {
            _animationController.reverse();
          } : null,
          onTapCancel: widget.enableHoverEffect ? () {
            _animationController.reverse();
          } : null,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          splashColor: AppColors.primary.withValues(alpha:0.1),
          highlightColor: AppColors.primary.withValues(alpha:0.05),
          child: content,
        ),
      );
    }

    return content;
  }
}

class AppLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final String? message;
  final bool showPulse;

  const AppLoadingIndicator({
    super.key,
    this.size = 50,
    this.color,
    this.message,
    this.showPulse = true,
  });

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.showPulse
              ? AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: _buildLoadingIcon(),
                    );
                  },
                )
              : _buildLoadingIcon(),
          if (widget.message != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha:0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha:0.1),
                  width: 1,
                ),
              ),
              child: Text(
                widget.message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIcon() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha:0.1),
            AppColors.primary.withValues(alpha:0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha:0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: RotationTransition(
        turns: _rotationController,
        child: CustomPaint(
          painter: ModernLoadingPainter(
            color: widget.color ?? AppColors.primary,
          ),
          size: Size(widget.size, widget.size),
        ),
      ),
    );
  }
}

class ModernLoadingPainter extends CustomPainter {
  final Color color;

  ModernLoadingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 6) / 2;

    // Main arc with gradient effect
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    // Primary arc
    paint.color = color;
    canvas.drawArc(
      rect,
      -1.6,
      1.2,
      false,
      paint,
    );

    // Secondary accent arc
    paint.color = AppColors.secondary.withValues(alpha:0.7);
    canvas.drawArc(
      rect,
      0.5,
      0.8,
      false,
      paint,
    );

    // Tertiary subtle arc
    paint.color = AppColors.accent.withValues(alpha:0.5);
    canvas.drawArc(
      rect,
      2.2,
      0.6,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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