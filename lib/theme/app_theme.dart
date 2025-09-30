import 'package:flutter/material.dart';

class AppColors {
  // Cinema Classic Theme Colors
  
  // Primary Colors - Gold/Bronze Film Reel
  static const Color primary = Color(0xFFD4AF37); // Gold
  static const Color primaryLight = Color(0xFFFFD700); // Bright Gold
  static const Color primaryDark = Color(0xFFB8860B); // Dark Goldenrod
  
  // Secondary Colors - Vintage Red (Cinema Seats)
  static const Color secondary = Color(0xFFDC143C); // Crimson Red
  static const Color secondaryLight = Color(0xFFFF6B6B); // Light Red
  static const Color secondaryDark = Color(0xFF8B0000); // Dark Red
  
  // Accent Colors - Popcorn Yellow
  static const Color accent = Color(0xFFFFFACD); // Lemon Chiffon
  static const Color accentLight = Color(0xFFFFFFF0); // Ivory
  static const Color accentDark = Color(0xFFFFE135); // Banana Yellow
  
  // Dark Cinema Colors
  static const Color backgroundDark = Color(0xFF0D1117); // Very Dark Blue
  static const Color surfaceDark = Color(0xFF161B22); // Dark Gray
  static const Color surfaceVariantDark = Color(0xFF21262D); // Medium Dark
  
  // Text Colors for Dark Theme
  static const Color textPrimary = Color(0xFFF0F6FC); // Almost White
  static const Color textSecondary = Color(0xFFB1BAC4); // Light Gray
  static const Color textTertiary = Color(0xFF8B949E); // Medium Gray
  
  // Legacy Background Colors (keeping for compatibility)
  static const Color background = backgroundDark;
  static const Color surface = surfaceDark;
  static const Color surfaceVariant = surfaceVariantDark;
  
  // Cinema Specific Colors
  static const Color filmStrip = Color(0xFF2F2F2F); // Dark Gray
  static const Color projectorLight = Color(0xFFF5F5DC); // Beige Light
  static const Color curtainRed = Color(0xFF800020); // Burgundy
  
  // Status Colors
  static const Color success = Color(0xFF32D74B); // Bright Green
  static const Color warning = Color(0xFFFF9F0A); // Orange
  static const Color error = Color(0xFFFF453A); // Red
  static const Color info = Color(0xFF007AFF); // Blue
  
  // Cinema Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, Color(0xFF1C2128)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient cinemaGradient = LinearGradient(
    colors: [backgroundDark, filmStrip, backgroundDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  // Cinema Classic Typography
  
  // Display Styles - Bold Cinema Headers
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
    height: 1.2,
    fontFamily: 'serif',
    shadows: [
      Shadow(
        offset: Offset(2, 2),
        blurRadius: 4,
        color: Color(0x40000000),
      ),
    ],
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    height: 1.3,
    fontFamily: 'serif',
    shadows: [
      Shadow(
        offset: Offset(1, 1),
        blurRadius: 3,
        color: Color(0x40000000),
      ),
    ],
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.3,
    fontFamily: 'serif',
  );
  
  // Headline Styles - Classic Cinema Look
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.3,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.2,
  );
  
  // Body Styles - Readable Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
  );
  
  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.1,
  );
  
  // Special Cinema Styles
  static const TextStyle cinemaTitle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
    fontFamily: 'serif',
    letterSpacing: 2.0,
    shadows: [
      Shadow(
        offset: Offset(3, 3),
        blurRadius: 6,
        color: Color(0x60000000),
      ),
    ],
  );
  
  static const TextStyle genreLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
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
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        surfaceVariant: AppColors.surfaceVariantDark,
        onPrimary: AppColors.backgroundDark,
        onSecondary: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      // Text Theme
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
      
      // AppBar Theme - Cinema Style
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.primary,
        centerTitle: true,
        titleTextStyle: AppTextStyles.cinemaTitle.copyWith(fontSize: 24),
        shadowColor: AppColors.primary.withOpacity(0.3),
      ),
      
      // Card Theme - Film Strip Style
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: AppColors.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.filmStrip,
            width: 2,
          ),
        ),
        color: AppColors.surfaceDark,
      ),
      
      // Elevated Button Theme - Golden Tickets
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDark,
          shadowColor: AppColors.primary.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.filmStrip,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.filmStrip,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: AppColors.textTertiary,
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.primary,
        size: 24,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // Keep legacy method for compatibility
  static ThemeData get lightTheme => darkCinemaTheme;
}