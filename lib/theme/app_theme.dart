import 'package:flutter/material.dart';

class AppColors {
  // Cinema Classic Theme - Yellow, Black & White
  
  // Primary Colors - Classic Cinema Gold
  static const Color primary = Color(0xFFFFD700); // Gold
  static const Color primaryLight = Color(0xFFFFF176); // Light Gold
  static const Color primaryDark = Color(0xFFFFC107); // Dark Gold
  
  // Secondary Colors - Classic Red
  static const Color secondary = Color(0xFFDC143C); // Crimson Red
  static const Color secondaryLight = Color(0xFFFF5722); // Light Red
  static const Color secondaryDark = Color(0xFFB71C1C); // Dark Red
  
  // Accent Colors - Classic White/Silver
  static const Color accent = Color(0xFFF5F5F5); // Off White
  static const Color accentLight = Color(0xFFFFFFFF); // Pure White
  static const Color accentDark = Color(0xFFE0E0E0); // Light Gray
  
  // Background Colors - Classic Dark Cinema
  static const Color backgroundDark = Color(0xFF0D0D0D); // Near Black
  static const Color surfaceDark = Color(0xFF1A1A1A); // Dark Gray
  static const Color surfaceVariantDark = Color(0xFF2D2D2D); // Medium Gray
  
  // Text Colors - High Contrast Cinema
  static const Color textPrimary = Color(0xFFFFFFF8); // Cream White
  static const Color textSecondary = Color(0xFFFFD700); // Gold
  static const Color textTertiary = Color(0xFFB8B8B8); // Light Gray
  static const Color textMuted = Color(0xFF757575); // Medium Gray
  
  // Interactive Colors - Cinema Gold
  static const Color interactive = Color(0xFFFFD700); // Gold
  static const Color interactiveLight = Color(0xFFFFF176); // Light Gold
  static const Color interactiveDark = Color(0xFFFFC107); // Dark Gold
  // Legacy compatibility
  static const Color background = backgroundDark;
  static const Color surface = surfaceDark;
  static const Color surfaceVariant = surfaceVariantDark;
  
  // Cinema Specific Colors - Classic Theme
  static const Color filmStrip = Color(0xFF2D2D2D); // Dark Gray
  static const Color projectorLight = Color(0xFFFFF9C4); // Warm light
  static const Color curtainRed = secondary; // Classic red curtain
  
  // Status Colors - Cinema Theme
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color error = secondary; // Red
  static const Color info = primary; // Gold
  
  // Classic Cinema Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryDark, secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentDark, accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient cinemaGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.7, 1.0],
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Classic film effect gradient
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x15FFD700), // Gold tint
      Color(0x05FFD700),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  // Modern Typography - Clean & Elegant
  
  // Display Styles - Modern Headers
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
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.25,
  );
  
  // Headline Styles - Modern & Clean
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: 0.5,
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
    height: 1.3,
  );
  
  // Body Styles - Clean & Readable
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );
  
  // Label Styles - Modern & Clean
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.3,
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