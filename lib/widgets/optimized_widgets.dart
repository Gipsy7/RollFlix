import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

/// Widget otimizado para imagens com cache e fallback
class OptimizedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  State<OptimizedNetworkImage> createState() => _OptimizedNetworkImageState();
}

class _OptimizedNetworkImageState extends State<OptimizedNetworkImage> {
  late ImageProvider _imageProvider;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _imageProvider = NetworkImage(widget.imageUrl);
  }

  @override
  void didUpdateWidget(OptimizedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _imageProvider = NetworkImage(widget.imageUrl);
      _hasError = false;
    }
  }

  Widget _buildPlaceholder() {
    return widget.placeholder ?? 
      Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: widget.borderRadius,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
  }

  Widget _buildErrorWidget() {
    return widget.errorWidget ??
      Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: widget.borderRadius,
        ),
        child: Icon(
          Icons.movie,
          color: AppColors.backgroundDark,
          size: (widget.width ?? 100) * 0.4,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Image(
        image: _imageProvider,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedSwitcher(
            duration: AppConstants.fastAnimation,
            child: frame != null ? child : _buildPlaceholder(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _hasError = true);
            }
          });
          return _buildErrorWidget();
        },
      ),
    );
  }
}

/// Widget para layout responsivo otimizado
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isMobile, bool isTablet) builder;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < AppConstants.mobileBreakpoint;
        final isTablet = width >= AppConstants.mobileBreakpoint && 
                        width < AppConstants.desktopBreakpoint;
        
        return builder(context, isMobile, isTablet);
      },
    );
  }
}

/// Widget de loading otimizado
class OptimizedLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const OptimizedLoadingIndicator({
    super.key,
    this.message,
    this.size = 32,
    this.color,
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
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Constrained box otimizado para conteúdo
class OptimizedConstrainedBox extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const OptimizedConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? AppConstants.desktopBreakpoint,
        ),
        child: child,
      ),
    );
  }
}