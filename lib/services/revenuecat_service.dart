import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/revenuecat_config.dart';

/// Simple wrapper around RevenueCat's purchases_flutter SDK.
///
/// This class centralizes initialization and exposes common operations used by
/// the app: initializing the SDK, fetching offerings, purchasing, restoring
/// purchases and checking entitlements.
class RevenueCatService {
  RevenueCatService._internal();
  static final RevenueCatService instance = RevenueCatService._internal();

  bool _initialized = false;

  /// Initialize the SDK. Call early in app startup (before showing purchase UI).
  Future<void> init({String? apiKey}) async {
    if (_initialized) return;
    final key = apiKey ?? RevenueCatConfig.apiKey;
    if (key.isEmpty || key.contains('<REVENUECAT')) {
      debugPrint('⚠️ RevenueCat API key not configured (RevenueCatConfig.apiKey)');
      // Don't throw - allow app to run in dev without purchases.
      return;
    }

    try {
      await Purchases.setDebugLogsEnabled(true);
      await Purchases.configure(PurchasesConfiguration(key));
      _initialized = true;
      debugPrint('✅ RevenueCat initialized');
    } catch (e) {
      debugPrint('❌ RevenueCat initialization failed: $e');
    }
  }

  /// Returns Offerings (may be null if not configured)
  Future<Offerings?> getOfferings() async {
    try {
      if (!_initialized) return null;
      final offerings = await Purchases.getOfferings();
      return offerings;
    } catch (e) {
      debugPrint('⚠️ Error fetching offerings: $e');
      return null;
    }
  }

  /// Purchase a product by identifier (product ids are configured in RevenueCat)
  /// Returns true if purchase resulted in an active entitlement being granted.
  Future<bool> purchaseProduct(String productIdentifier) async {
    if (!_initialized) {
      debugPrint('⚠️ RevenueCat not initialized, cannot purchase');
      return false;
    }

    try {
      debugPrint('🛒 Starting purchase for: $productIdentifier');
      
      // NOVA ABORDAGEM: Buscar o package da offering ao invés de comprar direto
      debugPrint('📡 Fetching offerings to find package...');
      final offerings = await Purchases.getOfferings();
      
      if (offerings.current == null) {
        debugPrint('❌ No current offering found in RevenueCat');
        return false;
      }
      
      // Procurar o package que corresponde ao produto
      Package? targetPackage;
      for (var package in offerings.current!.availablePackages) {
        final storeProductId = package.storeProduct.identifier;
        debugPrint('   - Checking package: ${package.identifier} (product: $storeProductId)');
        
        // Comparar: pode ser exato ou com base plan (rollflix_monthly:monthly)
        if (storeProductId == productIdentifier || 
            storeProductId.startsWith('$productIdentifier:')) {
          targetPackage = package;
          debugPrint('   ✅ Found matching package: ${package.identifier}');
          break;
        }
      }
      
      if (targetPackage == null) {
        debugPrint('❌ Product $productIdentifier not found in current offering');
        debugPrint('   Available products: ${offerings.current!.availablePackages.map((p) => p.storeProduct.identifier).toList()}');
        return false;
      }
      
      // Comprar usando o Package (método recomendado pelo RevenueCat)
      debugPrint('💳 Purchasing package: ${targetPackage.identifier}');
      await Purchases.purchasePackage(targetPackage);
      
      debugPrint('✅ Purchase API call completed for $productIdentifier');
      debugPrint('📡 Fetching customer info to check entitlements...');
      
      final info = await Purchases.getCustomerInfo();
      
      debugPrint('📦 Customer Info received:');
      debugPrint('   - All entitlements: ${info.entitlements.all.keys.toList()}');
      debugPrint('   - Active entitlements: ${info.entitlements.active.keys.toList()}');
      debugPrint('   - Looking for entitlement: ${RevenueCatConfig.premiumEntitlementId}');
      
      final ent = info.entitlements.all[RevenueCatConfig.premiumEntitlementId];
      if (ent != null) {
        debugPrint('   - Premium entitlement found!');
        debugPrint('   - isActive: ${ent.isActive}');
        debugPrint('   - willRenew: ${ent.willRenew}');
        debugPrint('   - expirationDate: ${ent.expirationDate}');
        debugPrint('   - latestPurchaseDate: ${ent.latestPurchaseDate}');
        debugPrint('   - productIdentifier: ${ent.productIdentifier}');
      } else {
        debugPrint('   - ❌ Premium entitlement NOT FOUND');
        debugPrint('   - Expected entitlement: ${RevenueCatConfig.premiumEntitlementId}');
      }
      
      final isActive = _isPremiumActive(info);
      debugPrint('🎯 Final result: isPremiumActive = $isActive');
      
      return isActive;
    } catch (e) {
      debugPrint('❌ Purchase error for $productIdentifier: $e');
      debugPrint('   Error type: ${e.runtimeType}');
      return false;
    }
  }

  /// Restore purchases (useful when user reinstalls app)
  Future<bool> restorePurchases() async {
    if (!_initialized) return false;
    try {
  await Purchases.restorePurchases();
  final info = await Purchases.getCustomerInfo();
  return _isPremiumActive(info);
    } catch (e) {
      debugPrint('⚠️ Error restoring purchases: $e');
      return false;
    }
  }

  /// Returns whether the configured premium entitlement is active
  bool _isPremiumActive(CustomerInfo info) {
    try {
      return RevenueCatService.isPremiumActiveFromInfo(info);
    } catch (e) {
      debugPrint('⚠️ Error checking entitlement: $e');
      return false;
    }
  }

  /// Public helper to evaluate entitlement info with stricter rules.
  ///
  /// This checks multiple signals (isActive, expirationDate, willRenew and
  /// latestPurchaseDate) to avoid treating cancelled/refunded purchases as
  /// active in edge cases.
  static bool isPremiumActiveFromInfo(CustomerInfo info) {
    try {
      final ent = info.entitlements.all[RevenueCatConfig.premiumEntitlementId];
      if (ent == null) return false;

      // Basic check
      if (!ent.isActive) return false;

      final now = DateTime.now().toUtc();

      // Parse expiration date if present
      DateTime? expiration;
      if (ent.expirationDate != null) {
        try {
          expiration = DateTime.parse(ent.expirationDate!).toUtc();
        } catch (_) {
          expiration = null;
        }
      }

      // If we have an expiration that is already past, it's not active
      if (expiration != null && expiration.isBefore(now)) return false;

      // If willRenew is false (user cancelled), be conservative: only treat
      // as active if the latest purchase is recent (e.g. within 365 days)
      if (ent.willRenew == false) {
        try {
          final latest = DateTime.parse(ent.latestPurchaseDate).toUtc();
          if (now.difference(latest) > const Duration(days: 365)) return false;
        } catch (_) {
          return false;
        }
      }

      // Passed all heuristics — consider premium active
      return true;
    } catch (e) {
      debugPrint('⚠️ Error evaluating premium entitlement heuristics: $e');
      return false;
    }
  }

  /// Obtain latest customer info
  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_initialized) return null;
    try {
      final info = await Purchases.getCustomerInfo();
      return info;
    } catch (e) {
      debugPrint('⚠️ Error fetching customer info: $e');
      return null;
    }
  }

  /// Cancela assinatura. Se estiver dentro de 5 dias da compra, solicita reembolso.
  /// Retorna: { 'cancelled': bool, 'refundEligible': bool, 'daysFromPurchase': int }
  Future<Map<String, dynamic>> cancelSubscription() async {
    if (!_initialized) {
      return {'cancelled': false, 'refundEligible': false, 'daysFromPurchase': 0, 'error': 'Not initialized'};
    }

    try {
      debugPrint('🔄 Checking subscription status for cancellation...');
      final info = await Purchases.getCustomerInfo();
      
      final ent = info.entitlements.all[RevenueCatConfig.premiumEntitlementId];
      if (ent == null || !ent.isActive) {
        debugPrint('⚠️ No active subscription found');
        return {'cancelled': false, 'refundEligible': false, 'daysFromPurchase': 0, 'error': 'No active subscription'};
      }

      // Calcular dias desde a compra
      DateTime? purchaseDate;
      final latestPurchase = ent.latestPurchaseDate;
      try {
        purchaseDate = DateTime.parse(latestPurchase).toUtc();
      } catch (_) {
        debugPrint('⚠️ Could not parse purchase date: $latestPurchase');
      }

      final now = DateTime.now().toUtc();
      final daysFromPurchase = purchaseDate != null ? now.difference(purchaseDate).inDays : 999;
      final refundEligible = daysFromPurchase <= 5;

      debugPrint('📅 Purchase date: $purchaseDate');
      debugPrint('📊 Days from purchase: $daysFromPurchase');
      debugPrint('💰 Refund eligible: $refundEligible');

      // Obter identificadores únicos para gerenciamento
      final appUserId = info.originalAppUserId;
      final originalPurchaseDate = ent.originalPurchaseDate;
      
      debugPrint('👤 User ID (RevenueCat): $appUserId');
      debugPrint('📦 Product ID: ${ent.productIdentifier}');
      debugPrint('📅 Original Purchase: $originalPurchaseDate');

      // IMPORTANTE: RevenueCat SDK não tem API nativa para cancelar.
      // No Google Play, o usuário precisa cancelar via Play Store.
      // Aqui retornamos as informações para redirecionar o usuário.
      
      return {
        'cancelled': false, // API não cancela diretamente
        'refundEligible': refundEligible,
        'daysFromPurchase': daysFromPurchase,
        'productId': ent.productIdentifier,
        'expirationDate': ent.expirationDate,
        'willRenew': ent.willRenew,
        'appUserId': appUserId, // ID único do usuário no RevenueCat
        'purchaseDate': latestPurchase,
        'originalPurchaseDate': originalPurchaseDate,
      };
    } catch (e) {
      debugPrint('❌ Error checking cancellation: $e');
      return {'cancelled': false, 'refundEligible': false, 'daysFromPurchase': 0, 'error': e.toString()};
    }
  }

  /// Obtém informações de assinatura de um usuário específico para gerenciamento admin
  /// Útil para suporte ao cliente e estornos manuais
  Future<Map<String, dynamic>> getUserSubscriptionInfo() async {
    if (!_initialized) {
      return {'error': 'Not initialized'};
    }

    try {
      final info = await Purchases.getCustomerInfo();
      
      final result = {
        'appUserId': info.originalAppUserId, // ID único no RevenueCat
        'activeSubscriptions': <String>[],
        'allPurchasedProductIds': info.allPurchasedProductIdentifiers.toList(),
        'latestExpirationDate': null as String?,
        'entitlements': <Map<String, dynamic>>[],
      };

      // Listar todos os entitlements
      for (var entry in info.entitlements.all.entries) {
        final entId = entry.key;
        final ent = entry.value;
        
        final entInfo = {
          'identifier': entId,
          'isActive': ent.isActive,
          'willRenew': ent.willRenew,
          'productIdentifier': ent.productIdentifier,
          'purchaseDate': ent.latestPurchaseDate,
          'originalPurchaseDate': ent.originalPurchaseDate,
          'expirationDate': ent.expirationDate,
          'periodType': ent.periodType.toString(),
          'store': ent.store.toString(),
        };
        
        (result['entitlements'] as List).add(entInfo);
        
        if (ent.isActive) {
          (result['activeSubscriptions'] as List).add(ent.productIdentifier);
          
          // Encontrar data de expiração mais recente
          if (ent.expirationDate != null) {
            final currentLatest = result['latestExpirationDate'] as String?;
            if (currentLatest == null) {
              result['latestExpirationDate'] = ent.expirationDate;
            } else {
              try {
                final currentLatestDate = DateTime.parse(currentLatest);
                final thisExpiry = DateTime.parse(ent.expirationDate!);
                if (thisExpiry.isAfter(currentLatestDate)) {
                  result['latestExpirationDate'] = ent.expirationDate;
                }
              } catch (_) {}
            }
          }
        }
      }

      debugPrint('📋 User Subscription Info:');
      debugPrint('   User ID: ${result['appUserId']}');
      debugPrint('   Active Subscriptions: ${result['activeSubscriptions']}');
      debugPrint('   All Purchased: ${result['allPurchasedProductIds']}');
      
      return result;
    } catch (e) {
      debugPrint('❌ Error getting user subscription info: $e');
      return {'error': e.toString()};
    }
  }
}
