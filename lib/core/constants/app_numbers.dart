/// Constantes numéricas usadas em toda a aplicação
/// 
/// Centraliza valores numéricos para facilitar ajustes
/// e evitar magic numbers no código
class AppNumbers {
  AppNumbers._(); // Previne instanciação

  // ============================================
  // DIMENSÕES E TAMANHOS
  // ============================================
  
  /// Altura expandida da AppBar (mobile)
  static const double appBarExpandedHeightMobile = 200;
  
  /// Altura expandida da AppBar (desktop)
  static const double appBarExpandedHeightDesktop = 250;
  
  /// Tamanho do logo (mobile)
  static const double logoSizeMobile = 60;
  
  /// Tamanho do logo (desktop)
  static const double logoSizeDesktop = 70;
  
  /// Tamanho do ícone do menu
  static const double menuIconSize = 28;
  
  /// Tamanho de ícones pequenos (mobile)
  static const double iconSizeSmallMobile = 20;
  
  /// Tamanho de ícones pequenos (desktop)
  static const double iconSizeSmallDesktop = 22;
  
  /// Tamanho de ícones médios (mobile)
  static const double iconSizeMediumMobile = 22;
  
  /// Tamanho de ícones médios (desktop)
  static const double iconSizeMediumDesktop = 24;
  
  /// Tamanho do indicador de filtro ativo
  static const double filterIndicatorSize = 12;
  
  /// Tamanho do ícone dentro do indicador de filtro
  static const double filterIndicatorIconSize = 6;

  // ============================================
  // PADDING E SPACING
  // ============================================
  
  /// Padding padrão (mobile)
  static const double paddingMobile = 20;
  
  /// Padding padrão (desktop)
  static const double paddingDesktop = 32;
  
  /// Padding vertical de botões
  static const double buttonPaddingVertical = 10;
  
  /// Padding horizontal de botões (mobile)
  static const double buttonPaddingHorizontalMobile = 14;
  
  /// Padding horizontal de botões (desktop)
  static const double buttonPaddingHorizontalDesktop = 18;
  
  /// Padding de ícones em botões (mobile)
  static const double iconButtonPaddingMobile = 12;
  
  /// Padding de ícones em botões (desktop)
  static const double iconButtonPaddingDesktop = 14;
  
  /// Spacing pequeno
  static const double spacingSmall = 8;
  
  /// Spacing médio
  static const double spacingMedium = 12;
  
  /// Spacing grande
  static const double spacingLarge = 20;
  
  /// Padding final do scroll (mobile)
  static const double scrollPaddingMobile = 20;
  
  /// Padding final do scroll (desktop)
  static const double scrollPaddingDesktop = 40;

  // ============================================
  // BORDAS E RAIO
  // ============================================
  
  /// Raio de borda padrão para botões pequenos
  static const double borderRadiusSmall = 12;
  
  /// Raio de borda para botões médios
  static const double borderRadiusMedium = 16;
  
  /// Raio de borda para cards e containers
  static const double borderRadiusCard = 20;
  
  /// Raio de borda para botões pill (arredondados)
  static const double borderRadiusPill = 30;
  
  /// Largura de borda padrão
  static const double borderWidth = 1.5;
  
  /// Largura de borda do indicador de filtro
  static const double filterIndicatorBorderWidth = 2;

  // ============================================
  // OPACIDADE E TRANSPARÊNCIA
  // ============================================
  
  /// Opacidade para efeitos de vidro/glass
  static const double glassOpacity = 0.3;
  
  /// Opacidade para bordas
  static const double borderOpacity = 0.4;
  
  /// Opacidade para splash/highlight
  static const double splashOpacity = 0.2;
  static const double highlightOpacity = 0.1;
  
  /// Opacidade para sombras
  static const double shadowOpacity = 0.4;
  
  /// Opacidade para gradientes
  static const double gradientOpacity1 = 0.3;
  static const double gradientOpacity2 = 0.2;
  static const double gradientOpacity3 = 0.95;
  static const double gradientOpacity4 = 0.98;

  // ============================================
  // SOMBRAS E EFEITOS
  // ============================================
  
  /// Blur radius para sombras pequenas
  static const double shadowBlurSmall = 4;
  
  /// Blur radius para sombras médias
  static const double shadowBlurMedium = 6;
  
  /// Blur radius para sombras grandes
  static const double shadowBlurLarge = 20;
  
  /// Offset Y para sombras pequenas
  static const double shadowOffsetSmall = 1;
  
  /// Offset Y para sombras médias
  static const double shadowOffsetMedium = 2;
  
  /// Offset Y para sombras grandes
  static const double shadowOffsetLarge = 8;

  // ============================================
  // TIPOGRAFIA
  // ============================================
  
  /// Letter spacing para textos em maiúsculas
  static const double letterSpacingCaps = 1.5;
  
  /// Font weight para textos muito bold
  static const int fontWeightExtraBold = 800;

  // ============================================
  // ANIMAÇÕES E TRANSIÇÕES
  // ============================================
  
  /// Valor inicial do Tween de rotação
  static const double rotationTweenBegin = 0.25;
  static const double rotationTweenEnd = 0;
  
  /// Valor inicial do Tween de offset (slide)
  static const double slideOffsetX = 0.2;
  static const double slideOffsetY = 0;

  // ============================================
  // CONSTRAINTS E LIMITES
  // ============================================
  
  /// Largura mínima de dialogs
  static const double dialogMinWidth = 120;
  
  /// Largura máxima de dialogs
  static const double dialogMaxWidth = 560;
  
  /// Número máximo de linhas para textos truncados
  static const int maxLinesTitle = 1;
  static const int maxLinesSubtitle = 2;
  static const int maxLinesDescription = 3;

  // ============================================
  // GRADIENTES
  // ============================================
  
  /// Stops para gradientes complexos (5 cores)
  static const List<double> gradientStops5 = [0.0, 0.1, 0.3, 0.7, 1.0];
  
  /// Margin vertical padrão
  static const double verticalMargin = 8;
}
