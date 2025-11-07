/// Constantes de duração usadas em toda a aplicação
/// 
/// Centraliza todos os valores de Duration para facilitar ajustes
/// e manter consistência na UX
class AppDurations {
  AppDurations._(); // Previne instanciação

  // ============================================
  // ANIMAÇÕES
  // ============================================
  
  /// Duração padrão para animações rápidas (transições sutis)
  static const Duration fast = Duration(milliseconds: 200);
  
  /// Duração padrão para animações médias (maioria das transições)
  static const Duration medium = Duration(milliseconds: 300);
  
  /// Duração para animações de botões
  static const Duration buttonAnimation = Duration(milliseconds: 250);
  
  /// Duração para animações de containers e cards
  static const Duration container = Duration(milliseconds: 350);
  
  /// Duração para animações longas (efeitos elaborados)
  static const Duration slow = Duration(milliseconds: 500);
  
  /// Duração extra longa para animações especiais
  static const Duration extraSlow = Duration(milliseconds: 1000);
  
  /// Duração para animações muito elaboradas
  static const Duration veryLong = Duration(milliseconds: 1500);
  
  /// Duração para wheel/spinner animations
  static const Duration wheel = Duration(milliseconds: 1600);
  
  /// Duração para animações de cinema (spotlight, etc)
  static const Duration cinemaShort = Duration(seconds: 2);
  static const Duration cinemaMedium = Duration(seconds: 3);
  static const Duration cinemaLong = Duration(seconds: 4);

  // ============================================
  // UI FEEDBACK
  // ============================================
  
  /// Duração padrão para SnackBars de sucesso/info
  static const Duration snackBarShort = Duration(seconds: 2);
  
  /// Duração para SnackBars importantes
  static const Duration snackBarMedium = Duration(seconds: 3);
  
  /// Duração para SnackBars de erro/warning
  static const Duration snackBarLong = Duration(seconds: 5);

  // ============================================
  // DELAYS E TIMEOUTS
  // ============================================
  
  /// Delay mínimo para polling/checks
  static const Duration pollingDelay = Duration(milliseconds: 100);
  
  /// Delay padrão antes de executar uma ação
  static const Duration actionDelay = Duration(milliseconds: 200);
  
  /// Delay antes de navegar após ação
  static const Duration navigationDelay = Duration(milliseconds: 300);
  
  /// Timeout para carregamento de anúncios
  static const Duration adLoadTimeout = Duration(seconds: 10);
  
  /// Timeout para operações de rede padrão
  static const Duration networkTimeout = Duration(seconds: 15);
  
  /// Timeout para sincronização com Firebase
  static const Duration syncTimeout = Duration(seconds: 12);
  
  /// Delay antes de mostrar subscription offer
  static const Duration subscriptionOfferDelay = Duration(seconds: 2);

  // ============================================
  // COOLDOWNS E CACHING
  // ============================================
  
  /// Cooldown padrão para recursos (botões, ações)
  static const Duration resourceCooldown = Duration(hours: 24);
  
  /// Cache de dados do usuário
  static const Duration userDataCache = Duration(hours: 1);
  
  /// Cache de receitas
  static const Duration recipeCache = Duration(hours: 24);
  
  /// Cache de receitas curto (Firebase)
  static const Duration recipeCacheShort = Duration(hours: 1);
  
  /// Intervalo mínimo entre checks de release
  static const Duration releaseCheckInterval = Duration(hours: 6);
  
  /// Intervalo para retry com backoff
  static const Duration retryInterval = Duration(seconds: 1);
  
  /// Delay para cleanup de cache
  static const Duration cacheCleanupDelay = Duration(seconds: 2);

  // ============================================
  // PERÍODOS E EXPIRAÇÕES
  // ============================================
  
  /// Período de assinatura mensal
  static const Duration subscriptionMonthly = Duration(days: 30);
  
  /// Período de assinatura anual
  static const Duration subscriptionYearly = Duration(days: 365);
  
  /// Período antes de notificação (1 dia antes do lançamento)
  static const Duration notificationPeriod = Duration(days: 1);
  
  /// Timer para countdown (1 segundo)
  static const Duration countdownTick = Duration(seconds: 1);

  // ============================================
  // PAGE TRANSITIONS
  // ============================================
  
  /// Duração padrão para transições de página
  static const Duration pageTransitionDefault = Duration(milliseconds: 350);
  
  /// Duração rápida para transições de página
  static const Duration pageTransitionFast = Duration(milliseconds: 250);
  
  /// Duração lenta para transições de página
  static const Duration pageTransitionSlow = Duration(milliseconds: 500);
}
