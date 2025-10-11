import 'package:flutter/material.dart';

/// Tipos de transições disponíveis
enum TransitionType {
  fade,           // Fade in/out
  slide,          // Slide da direita
  slideUp,        // Slide de baixo para cima
  scale,          // Scale (zoom in/out)
  fadeScale,      // Combinação de fade e scale
  slideRotate,    // Slide com rotação sutil
  fadeSlide,      // Combinação de fade e slide
}

/// Classe utilitária para criar transições de página personalizadas
class PageTransitions {
  PageTransitions._();

  /// Duração padrão das transições
  static const Duration _defaultDuration = Duration(milliseconds: 350);
  static const Duration _fastDuration = Duration(milliseconds: 250);
  static const Duration _slowDuration = Duration(milliseconds: 500);

  /// Curva padrão para transições
  static const Curve _defaultCurve = Curves.easeInOutCubic;

  /// Cria um PageRoute com transição personalizada
  static PageRoute<T> createRoute<T>({
    required Widget page,
    TransitionType type = TransitionType.fadeSlide,
    Duration? duration,
    Curve? curve,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? _defaultDuration,
      reverseTransitionDuration: duration ?? _defaultDuration,
      fullscreenDialog: fullscreenDialog,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
          type: type,
          curve: curve ?? _defaultCurve,
        );
      },
    );
  }

  /// Constrói a transição baseada no tipo
  static Widget _buildTransition({
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
    required TransitionType type,
    required Curve curve,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: curve.flipped,
    );

    switch (type) {
      case TransitionType.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case TransitionType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );

      case TransitionType.fadeScale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.9,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );

      case TransitionType.slideRotate:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: RotationTransition(
            turns: Tween<double>(
              begin: 0.01,
              end: 0.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        );

      case TransitionType.fadeSlide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
    }
  }

  /// Transição padrão para telas de detalhes (fade + scale)
  static PageRoute<T> detailsRoute<T>(Widget page) {
    return createRoute<T>(
      page: page,
      type: TransitionType.fadeScale,
      duration: _defaultDuration,
      curve: Curves.easeOutCubic,
    );
  }

  /// Transição para telas de pesquisa (slide up)
  static PageRoute<T> searchRoute<T>(Widget page) {
    return createRoute<T>(
      page: page,
      type: TransitionType.slideUp,
      duration: _fastDuration,
      curve: Curves.easeOut,
    );
  }

  /// Transição para telas de configurações (fade + slide)
  static PageRoute<T> settingsRoute<T>(Widget page) {
    return createRoute<T>(
      page: page,
      type: TransitionType.fadeSlide,
      duration: _defaultDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  /// Transição para diálogos em tela cheia (scale)
  static PageRoute<T> dialogRoute<T>(Widget page) {
    return createRoute<T>(
      page: page,
      type: TransitionType.scale,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      fullscreenDialog: true,
    );
  }

  /// Transição suave e elegante (padrão para o app)
  static PageRoute<T> smoothRoute<T>(Widget page) {
    return createRoute<T>(
      page: page,
      type: TransitionType.fadeSlide,
      duration: _defaultDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  /// Transição rápida para navegação lateral
  static PageRoute<T> quickRoute<T>(Widget page) {
    return createRoute<T>(
      page: page,
      type: TransitionType.fadeSlide,
      duration: _fastDuration,
      curve: Curves.easeOut,
    );
  }

  /// Transição lenta e dramática
  static PageRoute<T> dramaticRoute<T>(Widget page) {
    return createRoute<T>(
      page: page,
      type: TransitionType.fadeScale,
      duration: _slowDuration,
      curve: Curves.easeInOutCubic,
    );
  }
}

/// Extension para facilitar o uso das transições
extension NavigatorTransitions on NavigatorState {
  /// Push com transição suave
  Future<T?> pushSmooth<T>(Widget page) {
    return push<T>(PageTransitions.smoothRoute(page));
  }

  /// Push para tela de detalhes
  Future<T?> pushDetails<T>(Widget page) {
    return push<T>(PageTransitions.detailsRoute(page));
  }

  /// Push para tela de pesquisa
  Future<T?> pushSearch<T>(Widget page) {
    return push<T>(PageTransitions.searchRoute(page));
  }

  /// Push para tela de configurações
  Future<T?> pushSettings<T>(Widget page) {
    return push<T>(PageTransitions.settingsRoute(page));
  }

  /// Push rápido
  Future<T?> pushQuick<T>(Widget page) {
    return push<T>(PageTransitions.quickRoute(page));
  }

  /// Push replacement com transição
  Future<T?> pushReplacementSmooth<T, TO>(Widget page) {
    return pushReplacement<T, TO>(PageTransitions.smoothRoute(page));
  }
}
