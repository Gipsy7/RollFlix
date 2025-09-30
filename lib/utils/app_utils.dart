import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= AppConstants.mobileBreakpoint;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > AppConstants.mobileBreakpoint && width <= AppConstants.tabletBreakpoint;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > AppConstants.tabletBreakpoint;
  }
  
  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }
  
  static EdgeInsets getResponsivePadding(BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isMobile(context)) return mobile ?? const EdgeInsets.all(16);
    if (isTablet(context)) return tablet ?? const EdgeInsets.all(24);
    return desktop ?? const EdgeInsets.all(32);
  }
  
  static int getResponsiveGridColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 4;
    return 6;
  }
}

class ImageUtils {
  static String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    return '${AppConstants.tmdbImageBaseUrl}$imagePath';
  }
  
  static String getFullBackdropUrl(String? backdropPath) {
    if (backdropPath == null || backdropPath.isEmpty) return '';
    return '${AppConstants.tmdbBackdropBaseUrl}$backdropPath';
  }
  
  static Widget buildNetworkImage({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? 
          Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? 
          Container(
            width: width,
            height: height,
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
            ),
          );
      },
    );
  }
}

class DateUtils {
  static String formatReleaseDate(String? releaseDate) {
    if (releaseDate == null || releaseDate.isEmpty) return '';
    
    try {
      final date = DateTime.parse(releaseDate);
      return date.year.toString();
    } catch (e) {
      return releaseDate;
    }
  }
  
  static String formatRuntime(int? runtime) {
    if (runtime == null || runtime == 0) return '';
    
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}min';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}min';
    }
  }
}

class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  static String? validateRequired(String? value, [String fieldName = 'Campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }
}

class AnimationUtils {
  static Widget fadeInAnimation({
    required Widget child,
    Duration duration = AppConstants.normalAnimation,
    Curve curve = Curves.easeInOut,
    double opacity = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: opacity),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
  
  static Widget slideInAnimation({
    required Widget child,
    Duration duration = AppConstants.normalAnimation,
    Curve curve = Curves.easeInOut,
    Offset begin = const Offset(0, 0.3),
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: begin, end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }
}