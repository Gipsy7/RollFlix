RevenueCat integration (quick guide)
=================================

This project includes a minimal integration with RevenueCat via the
`purchases_flutter` SDK. The wrapper is in `lib/services/revenuecat_service.dart`.

Quick steps to enable real purchases:

1. Create a project in RevenueCat (https://app.revenuecat.com) and add your app.
2. Create product identifiers in App Store Connect and Google Play Console. These
   must match the `monthlyProductId` and `annualProductId` values in
   `lib/config/revenuecat_config.dart`.
3. Create an entitlement (for example `premium`) and map your products to that
   entitlement in the RevenueCat dashboard. Set `premiumEntitlementId` in
   `lib/config/revenuecat_config.dart` accordingly.
4. Set your RevenueCat API key (public SDK key) in
   `lib/config/revenuecat_config.dart` (keep keys out of public repos).
5. In `lib/main.dart` call `await RevenueCatService.instance.init();` early in
   startup (this repository already calls it if configured).
6. Test purchases using RevenueCat's sandbox/test mode and Google's / Apple's
   test purchase flows. Use RevenueCat offerings to present product prices.

Platform notes
- Android: Ensure billing permission is enabled (Play Billing v4+), and your
  app's package name matches the Play Console entry for the product ids.
- iOS: Configure the In-App Purchases in App Store Connect and ensure the app
  bundle id matches RevenueCat and App Store Connect.

Security recommendation
-----------------------
- The current flow updates the Firestore user document with the subscription
  information client-side. For production, validate receipts server-side or use
  RevenueCat webhooks to sync subscription state securely to your backend and
  then to Firestore.

If you want, I can also:
- Wire offerings into `ProfileScreen` so the price label is shown dynamically.
- Add server webhook handling sample for validating and syncing subscription
  state.
