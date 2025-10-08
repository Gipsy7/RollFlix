import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorUtils {
  /// Extrai cores dominantes de uma imagem de rede
  static Future<Map<String, Color>> extractColorsFromImage(String imageUrl) async {
    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
        maximumColorCount: 20,
      );

      final dominantColor = paletteGenerator.dominantColor?.color ?? 
        const Color(0xFF6366F1);
      final vibrantColor = paletteGenerator.vibrantColor?.color ?? 
        const Color(0xFF8B5CF6);
      final mutedColor = paletteGenerator.mutedColor?.color ?? 
        const Color(0xFF64748B);

      return {
        'dominant': dominantColor,
        'vibrant': vibrantColor,
        'muted': mutedColor,
        'background': _generateBackgroundColor(dominantColor),
        'surface': _generateSurfaceColor(dominantColor),
        'onSurface': _generateOnSurfaceColor(dominantColor),
      };
    } catch (e) {
      // Retorna cores padrão em caso de erro
      return {
        'dominant': const Color(0xFF6366F1),
        'vibrant': const Color(0xFF8B5CF6),
        'muted': const Color(0xFF64748B),
        'background': Colors.white,
        'surface': const Color(0xFFF8FAFC),
        'onSurface': const Color(0xFF1E293B),
      };
    }
  }

  /// Gera cor de fundo baseada na cor dominante
  static Color _generateBackgroundColor(Color dominantColor) {
    return Color.lerp(dominantColor, Colors.white, 0.95) ?? Colors.white;
  }

  /// Gera cor de superfície baseada na cor dominante
  static Color _generateSurfaceColor(Color dominantColor) {
    return Color.lerp(dominantColor, Colors.white, 0.85) ?? const Color(0xFFF8FAFC);
  }

  /// Gera cor de texto baseada na cor dominante
  static Color _generateOnSurfaceColor(Color dominantColor) {
    final luminance = dominantColor.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF1E293B) : Colors.white;
  }

  /// Calcula se uma cor é clara ou escura
  static bool isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }

  /// Gera cor de texto com contraste adequado
  static Color getContrastingTextColor(Color backgroundColor) {
    return isLightColor(backgroundColor) ? Colors.black : Colors.white;
  }

  /// Cria uma versão mais clara da cor
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Cria uma versão mais escura da cor
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Gera uma paleta de cores harmoniosas
  static List<Color> generateHarmoniousPalette(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    
    return [
      baseColor,
      hsl.withHue((hsl.hue + 30) % 360).toColor(),
      hsl.withHue((hsl.hue + 60) % 360).toColor(),
      hsl.withHue((hsl.hue + 120) % 360).toColor(),
      hsl.withHue((hsl.hue + 180) % 360).toColor(),
    ];
  }

  /// Converte uma cor para string hexadecimal
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Converte string hexadecimal para cor
  static Color hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  /// Cria um gradiente baseado em uma cor
  static LinearGradient createGradientFromColor(Color color, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    double opacity = 0.8,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        color,
        color.withValues(alpha: opacity),
      ],
    );
  }

  /// Mistura duas cores
  static Color blendColors(Color color1, Color color2, [double ratio = 0.5]) {
    return Color.lerp(color1, color2, ratio) ?? color1;
  }
}