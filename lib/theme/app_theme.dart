import 'package:flutter/material.dart';

class AppColors {
  // Cinema Classic Theme - Refined Yellow, Black & White

  // Primary Colors - Premium Cinema Gold
  static const Color primary = Color(0xFFFFD700); // Rich Gold
  static const Color primaryLight = Color(0xFFFFE55C); // Soft Gold
  static const Color primaryDark = Color(0xFFFFC107); // Deep Gold

  // Secondary Colors - Elegant Crimson
  static const Color secondary = Color(0xFFE91E63); // Modern Pink
  static const Color secondaryLight = Color(0xFFFF4081); // Light Pink
  static const Color secondaryDark = Color(0xFFC2185B); // Deep Pink

  // Accent Colors - Pure Whites
  static const Color accent = Color(0xFFF8F8F8); // Warm White
  static const Color accentLight = Color(0xFFFFFFFF); // Pure White
  static const Color accentDark = Color(0xFFE8E8E8); // Soft Gray

  // Background Colors - Sophisticated Dark
  static const Color backgroundDark = Color(0xFF0A0A0A); // Deep Black
  static const Color surfaceDark = Color(0xFF121212); // Rich Dark
  static const Color surfaceVariantDark = Color(0xFF1E1E1E); // Medium Dark
  static const Color surfaceElevated = Color(0xFF2A2A2A); // Elevated Surface

  // Text Colors - Enhanced Contrast
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure White
  static const Color textSecondary = Color(0xFFFFD700); // Gold
  static const Color textTertiary = Color(0xFFB3B3B3); // Light Gray
  static const Color textMuted = Color(0xFF808080); // Medium Gray
  static const Color textHint = Color(0xFF606060); // Hint Gray

  // Interactive Colors - Smooth Interactions
  static const Color interactive = Color(0xFFFFD700); // Gold
  static const Color interactiveLight = Color(0xFFFFE55C); // Light Gold
  static const Color interactiveDark = Color(0xFFFFC107); // Dark Gold
  static const Color interactiveHover = Color(0xFFFFEB3B); // Hover Gold

  // Legacy compatibility
  static const Color background = backgroundDark;
  static const Color surface = surfaceDark;
  static const Color surfaceVariant = surfaceVariantDark;

  // Cinema Specific Colors - Enhanced
  static const Color filmStrip = Color(0xFF1A1A1A); // Dark Film
  static const Color projectorLight = Color(0xFFFFF8E1); // Warm Light
  static const Color curtainRed = secondary; // Elegant Red

  // Status Colors - Modern Palette
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color error = Color(0xFFF44336); // Red
  static const Color info = primary; // Gold

  // Subtle Colors - For Depth
  static const Color shadowLight = Color(0x1FFFFFFF); // White Shadow
  static const Color shadowDark = Color(0x4D000000); // Black Shadow
  static const Color borderLight = Color(0x33FFFFFF); // Light Border
  static const Color borderDark = Color(0x1FFFFFFF); // Dark Border
  
  // Enhanced Cinema Gradients - Smoother & More Elegant
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryDark, secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentDark, accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark, surfaceVariantDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.7, 1.0],
  );

  static const LinearGradient cinemaGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark, surfaceElevated, Color(0x1AFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.4, 0.8, 1.0],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // Enhanced film effect gradient
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x14FFD700), // Subtle gold tint
      Color(0x05FFD700),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );  // New gradients for enhanced UI
  static const LinearGradient cardGradient = LinearGradient(
    colors: [surfaceDark, surfaceElevated],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient hoverGradient = LinearGradient(
    colors: [interactiveDark, interactive],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
  );
}

class AppTextStyles {
  // Enhanced Typography - Premium & Refined

  // Display Styles - Bold & Impactful
  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -1.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.15,
    letterSpacing: -0.75,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // Headline Styles - Elegant & Clear
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.25,
    letterSpacing: -0.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.15,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.35,
    letterSpacing: -0.1,
  );

  // Body Styles - Highly Readable
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.45,
    letterSpacing: 0.05,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
    letterSpacing: 0.05,
  );

  // Label Styles - Interactive & Clear
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // Special Styles - For Emphasis
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.2,
    letterSpacing: -0.25,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
    height: 1.25,
    letterSpacing: -0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.3,
    letterSpacing: -0.1,
  );

  // Special Cinema Styles - Modern Cinema
  static const TextStyle cinemaTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle genreLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
}

class AppTheme {
  static ThemeData get darkCinemaTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        surfaceContainerHighest: AppColors.surfaceVariantDark,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        tertiary: AppColors.accent,
      ),
      
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      // Text Theme - Modern Typography
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      
      // AppBar Theme - Modern & Clean
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineLarge,
      ),
      
      // Card Theme - Modern Glass Effect
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: AppColors.surfaceDark,
        shadowColor: Colors.transparent,
      ),
      
      // Elevated Button Theme - Modern & Sleek
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        modalBackgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),
    );
  }
}