import 'package:flutter/foundation.dart';

/// Configuração segura de credenciais da aplicação
/// 
/// IMPORTANTE: As chaves reais devem ser fornecidas via:
/// 1. Arquivo .env (desenvolvimento local)
/// 2. --dart-define no build (CI/CD e produção)
/// 3. Variáveis de ambiente
/// 
/// Exemplo de uso:
/// ```bash
/// flutter run --dart-define=TMDB_API_KEY=sua_chave_aqui
/// flutter build apk --dart-define=TMDB_API_KEY=sua_chave_aqui
/// ```
class SecureConfig {
  // ==================== TMDb API ====================
  
  /// Chave de API do The Movie Database
  /// Obtenha em: https://www.themoviedb.org/settings/api
  static const String tmdbApiKey = String.fromEnvironment(
    'TMDB_API_KEY',defaultValue: '', // Em produção, DEVE ser fornecida via --dart-define
  );
  
  // ==================== Firebase ====================
  
  /// NOTA: As configurações do Firebase vêm do arquivo firebase_options.dart
  /// gerado automaticamente pelo FlutterFire CLI. 
  /// 
  /// Chaves sensíveis do Firebase (como API keys) são públicas por design,
  /// mas protegidas por regras de segurança do Firebase.
  /// 
  /// Mais info: https://firebase.google.com/docs/projects/api-keys
  
  // ==================== AdMob ====================
  
  /// App ID do AdMob para Android
  static const String admobAndroidAppId = String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
    defaultValue: '',
  );
  
  /// App ID do AdMob para iOS
  static const String admobIosAppId = String.fromEnvironment(
    'ADMOB_IOS_APP_ID',
    defaultValue: '',
  );
  
  /// ID do anúncio recompensado para Android
  static const String admobAndroidRewardedId = String.fromEnvironment(
    'ADMOB_ANDROID_REWARDED_ID',
    defaultValue: '',
  );
  
  /// ID do anúncio recompensado para iOS
  static const String admobIosRewardedId = String.fromEnvironment(
    'ADMOB_IOS_REWARDED_ID',
    defaultValue: '',
  );
  
  // ==================== Validações ====================
  
  /// Valida se todas as configurações necessárias estão presentes
  static void validate() {
    if (!kDebugMode) {
      assert(tmdbApiKey.isNotEmpty, 
        '⚠️ TMDB_API_KEY não configurada. Use --dart-define=TMDB_API_KEY=sua_chave');
      
      assert(admobAndroidAppId.isNotEmpty || admobIosAppId.isNotEmpty,
        '⚠️ IDs do AdMob não configurados');
    }
    
    if (kDebugMode) {
      debugPrint('🔐 SecureConfig carregada:');
      debugPrint('  TMDb API: ${tmdbApiKey.isNotEmpty ? "✅ Configurada" : "❌ Faltando"}');
      debugPrint('  AdMob Android: ${admobAndroidAppId.isNotEmpty ? "✅ Configurada" : "❌ Faltando"}');
      debugPrint('  AdMob iOS: ${admobIosAppId.isNotEmpty ? "✅ Configurada" : "❌ Faltando"}');
    }
  }
  
  // ==================== Helpers ====================
  
  /// Verifica se está usando chaves de produção
  static bool get isProduction => !kDebugMode && tmdbApiKey.isNotEmpty;
  
  /// Verifica se está configurado para desenvolvimento
  static bool get isDevelopment => kDebugMode;
}
