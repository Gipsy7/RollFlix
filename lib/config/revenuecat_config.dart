import 'package:flutter/foundation.dart';

class RevenueCatConfig {
  static const String apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: '',
  );

  static const String monthlyProductId = 'rollflix_monthly';
  static const String annualProductId = 'rollflix_annual';
  static const String premiumEntitlementId = 'premium';
  
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
  
  static bool get isProduction => 
    !kDebugMode && 
    apiKey.isNotEmpty && 
    apiKey != '';
  
  static bool get isDevelopment => kDebugMode;
}
