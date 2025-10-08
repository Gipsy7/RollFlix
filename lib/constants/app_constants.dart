class AppConstants {
  // App Information
  static const String appName = 'RollFlix';
  static const String appVersion = '1.0.0';
  
  // API Constants
  static const String tmdbApiKey = '4e44d9029b1270a757cddc766a1bcb63';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String tmdbBackdropBaseUrl = 'https://image.tmdb.org/t/p/w1280';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 300);
  static const Duration normalAnimation = Duration(milliseconds: 500);
  static const Duration slowAnimation = Duration(milliseconds: 800);
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  
  // Movie Genres with TMDb IDs
  static const Map<String, int> genreIds = {
    'Novidades': 0, // Special case - uses now_playing endpoint
    'Ação': 28,
    'Aventura': 12,
    'Animação': 16,
    'Comédia': 35,
    'Crime': 80,
    'Documentário': 99,
    'Drama': 18,
    'Família': 10751,
    'Fantasia': 14,
    'História': 36,
    'Terror': 27,
    'Música': 10402,
    'Mistério': 9648,
    'Romance': 10749,
    'Ficção Científica': 878,
    'Suspense': 53,
    'Guerra': 10752,
    'Western': 37,
  };

  // Genre list for UI (includes special local genres)
  static final List<String> movieGenres = [
    ...genreIds.keys,
    'Favoritos',
    'Assistidos',
  ];
}