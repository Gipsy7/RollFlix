import 'package:flutter/material.dart';

/// Mixin para gerenciamento otimizado de animações
/// Previne vazamentos de memória e melhora performance
mixin AnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late final AnimationController _movieCardController;
  late final Animation<double> _movieCardAnimation;
  
  // Lazy initialization para melhor performance
  AnimationController get movieCardController => _movieCardController;
  Animation<double> get movieCardAnimation => _movieCardAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _movieCardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _movieCardAnimation = Tween<double>(
      begin: 0.0, 
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _movieCardController,
      curve: Curves.elasticOut,
    ));
  }

  /// Anima a entrada do card do filme
  void animateMovieCard() {
    _movieCardController.reset();
    _movieCardController.forward();
  }

  @override
  void dispose() {
    _movieCardController.dispose();
    super.dispose();
  }
}

/// Widget otimizado para evitar rebuilds desnecessários
class OptimizedAnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, double value) builder;

  const OptimizedAnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => builder(context, animation.value),
    );
  }
}