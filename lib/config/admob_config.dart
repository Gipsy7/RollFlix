import 'dart:io';

/// Configuração de IDs do AdMob
/// 
/// IMPORTANTE: Estes são IDs de TESTE do Google AdMob.
/// Para produção, você DEVE substituir pelos seus próprios IDs:
/// 
/// 1. Acesse https://admob.google.com
/// 2. Crie uma conta e adicione seu aplicativo
/// 3. Crie unidades de anúncio do tipo "Recompensado"
/// 4. Substitua os IDs abaixo pelos IDs reais
class AdMobConfig {
  // ==================== IDs DO APP ====================
  
  /// ID do App para Android (TESTE - substitua pelo seu)
  static const String androidAppId = 'ca-app-pub-8627801071005444~5894654302';
  
  /// ID do App para iOS (TESTE - substitua pelo seu)
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458002511';
  
  // ==================== IDs DE ANÚNCIOS RECOMPENSADOS ====================
  
  /// ID do anúncio recompensado para Android (TESTE)
  /// Para produção, use: ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
  static const String androidRewardedAdId = 'ca-app-pub-8627801071005444/4888694395';
  
  /// ID do anúncio recompensado para iOS (TESTE)
  /// Para produção, use: ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
  static const String iosRewardedAdId = 'ca-app-pub-3940256099942544/1712485313';
  
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
