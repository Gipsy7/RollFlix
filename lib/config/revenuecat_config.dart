import 'package:flutter/foundation.dart';

/// Configuration for RevenueCat integration.
///
/// IMPORTANTE: A chave de API deve ser fornecida via:
/// 1. --dart-define no build (CI/CD e produção)
/// 2. Variáveis de ambiente
/// 
/// Exemplo de uso:
/// ```bash
/// flutter run --dart-define=REVENUECAT_API_KEY=sua_chave_aqui
/// flutter build apk --dart-define=REVENUECAT_API_KEY=sua_chave_aqui
/// ```
class RevenueCatConfig {
  // ==================== API KEY ====================
  
  /// RevenueCat API Key (public key from RevenueCat dashboard)
  /// Obtenha em: https://app.revenuecat.com/settings/api-keys
  /// 
  /// Para desenvolvimento local, você pode:
  /// 1. Usar --dart-define ao executar
  /// 2. Criar um arquivo .env (não commitado)
  /// 3. Configurar no IDE (Run Configuration)
  static const String apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: '', // Desenvolvimento apenas - REMOVER em produção
  );

  // ==================== PRODUCT IDS ====================
  
  // Product identifiers as configured in App Store / Play Console and mapped
  // to offerings in the RevenueCat dashboard.
  static const String monthlyProductId = 'rollflix_monthly';
  static const String annualProductId = 'rollflix_annual';

  // ==================== ENTITLEMENT ====================
  
  // Entitlement id used in RevenueCat (grant this entitlement when purchase is active)
  // Typically you create an entitlement like 'premium' or 'no_ads'.
  static const String premiumEntitlementId = 'premium';
  
  // ==================== VALIDAÇÕES ====================
  
  /// Valida se a configuração está presente
  static void validate() {
    if (!kDebugMode) {
      assert(apiKey.isNotEmpty && apiKey != 'goog_HGrpbCtandPQvePmZAHmLakOAhZ', 
        '⚠️ REVENUECAT_API_KEY não configurada ou usando chave de desenvolvimento. '
        'Use --dart-define=REVENUECAT_API_KEY=sua_chave');
      
      assert(monthlyProductId.isNotEmpty, 
        '⚠️ monthlyProductId não configurado');
      
      assert(annualProductId.isNotEmpty, 
        '⚠️ annualProductId não configurado');
      
      assert(premiumEntitlementId.isNotEmpty, 
        '⚠️ premiumEntitlementId não configurado');
    }
    
    if (kDebugMode) {
      debugPrint('🔐 RevenueCatConfig carregada:');
      debugPrint('  API Key: ${apiKey.isNotEmpty ? "✅ Configurada" : "❌ Faltando"}');
      debugPrint('  Monthly Product: $monthlyProductId');
      debugPrint('  Annual Product: $annualProductId');
      debugPrint('  Premium Entitlement: $premiumEntitlementId');
    }
  }
  
  // ==================== HELPERS ====================
  
  /// Verifica se está usando chaves de produção
  static bool get isProduction => 
    !kDebugMode && 
    apiKey.isNotEmpty && 
    apiKey != '';
  
  /// Verifica se está configurado para desenvolvimento
  static bool get isDevelopment => kDebugMode;
}
