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
      // Direct product purchase. After the purchase, fetch the latest
      // customer info from RevenueCat to inspect entitlements.
      await Purchases.purchaseProduct(productIdentifier);
  final info = await Purchases.getCustomerInfo();
  return _isPremiumActive(info);
    } catch (e) {
      debugPrint('❌ Purchase error for $productIdentifier: $e');
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
      final ent = info.entitlements.all[RevenueCatConfig.premiumEntitlementId];
      if (ent == null) return false;
      return ent.isActive;
    } catch (e) {
      debugPrint('⚠️ Error checking entitlement: $e');
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
}
