import 'package:flutter/material.dart';

/// Utilitários para responsividade
class ResponsiveUtils {
  /// Verifica se é dispositivo móvel (< 768px)
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < 768;
  
  /// Verifica se é tablet (768px - 1024px)
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 768 && 
      MediaQuery.of(context).size.width < 1024;
  
  /// Verifica se é desktop (>= 1024px)
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= 1024;
  
  /// Retorna padding responsivo baseado no tamanho da tela
  static EdgeInsets getResponsivePadding(BuildContext context, {
    required EdgeInsets mobile,
    required EdgeInsets tablet, 
    required EdgeInsets desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }
  
  /// Retorna espaçamento responsivo
  static double getResponsiveSpacing(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Retorna tamanho de fonte responsivo
  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Retorna número de colunas para grid responsivo
  static int getResponsiveGridColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  /// Retorna largura máxima do conteúdo
  static double getMaxContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isDesktop(context)) {
      return screenWidth > 1200 ? 1200 : screenWidth * 0.9;
    }
    return screenWidth;
  }
}

/// Text seguro que evita overflow - versão simplificada
class SafeText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final bool softWrap;

  const SafeText(
    this.data, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}

/// Container responsivo que adapta padding e margem
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Decoration? decoration;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = ResponsiveUtils.getResponsivePadding(
      context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(20),
      desktop: const EdgeInsets.all(24),
    );

    final effectiveMaxWidth = maxWidth ?? ResponsiveUtils.getMaxContentWidth(context);

    Widget container = Container(
      padding: padding ?? defaultPadding,
      margin: margin,
      decoration: decoration,
      child: child,
    );

    if (maxWidth != null || ResponsiveUtils.isDesktop(context)) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
          child: container,
        ),
      );
    }

    return container;
  }
}