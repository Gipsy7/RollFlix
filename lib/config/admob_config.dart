import 'dart:io';
import '../config/secure_config.dart';

/// Configuração de IDs do AdMob
/// 
/// ATUALIZADO: Agora usa SecureConfig para chaves sensíveis
/// 
/// Para produção, forneça as chaves via --dart-define:
/// ```bash
/// flutter build apk --dart-define=ADMOB_ANDROID_APP_ID=sua_chave
/// ```
class AdMobConfig {
  // ==================== IDs DO APP ====================
  
  /// ID do App para Android
  static String get androidAppId => SecureConfig.admobAndroidAppId;
  
  /// ID do App para iOS
  static String get iosAppId => SecureConfig.admobIosAppId;
  
  // ==================== IDs DE ANÚNCIOS RECOMPENSADOS ====================
  
  /// ID do anúncio recompensado para Android
  static String get androidRewardedAdId => SecureConfig.admobAndroidRewardedId;
  
  /// ID do anúncio recompensado para iOS
  static String get iosRewardedAdId => SecureConfig.admobIosRewardedId;
  
  // ==================== GETTERS ====================
  
  /// Retorna o ID do app baseado na plataforma
  static String get appId {
    if (Platform.isAndroid) {
      return androidAppId;
    } else if (Platform.isIOS) {
      return iosAppId;
    }
    throw UnsupportedError('Plataforma não suportada para AdMob');
  }
  
  /// Retorna o ID do anúncio recompensado baseado na plataforma
  static String get rewardedAdId {
    if (Platform.isAndroid) {
      return androidRewardedAdId;
    } else if (Platform.isIOS) {
      return iosRewardedAdId;
    }
    throw UnsupportedError('Plataforma não suportada para AdMob');
  }
  
  // ==================== CONFIGURAÇÕES ====================
  
  /// Modo de teste (true para usar IDs de teste)
  static const bool testMode = false;
  
  /// Tempo de espera para carregar anúncio (segundos)
  static const int adLoadTimeout = 10;
  
  /// Tempo entre tentativas de recarregar anúncio falho (segundos)
  static const int retryDelay = 30;
}
