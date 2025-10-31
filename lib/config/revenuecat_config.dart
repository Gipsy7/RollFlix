/// Configuration placeholders for RevenueCat integration.
///
/// Fill these with the keys/product IDs/entitlement IDs you create in
/// your RevenueCat dashboard. Do NOT commit real API keys to a public
/// repository. Consider using secure storage or CI secrets for production.
class RevenueCatConfig {
  // RevenueCat API Key (public key from RevenueCat dashboard)
  // Android and iOS can use the same key if you created a project per platform.
  static const String apiKey = 'goog_HGrpbCtandPQvePmZAHmLakOAhZ';

  // Product identifiers as configured in App Store / Play Console and mapped
  // to offerings in the RevenueCat dashboard.
  static const String monthlyProductId = 'rollflix_monthly';
  static const String annualProductId = 'rollflix_annual';

  // Entitlement id used in RevenueCat (grant this entitlement when purchase is active)
  // Typically you create an entitlement like 'premium' or 'no_ads'.
  static const String premiumEntitlementId = 'premium';
}
