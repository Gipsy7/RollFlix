import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'revenuecat_service.dart';
import 'prefs_service.dart';
import '../config/revenuecat_config.dart';

/// Serviço para gerenciar assinaturas do usuário (mensal / anual)
class SubscriptionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference get _usersCollection => _firestore.collection('users');

  static DocumentReference? get _currentUserDoc {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return null;
    return _usersCollection.doc(uid);
  }

  /// Plano atual (valor padrão: free)
  static final ValueNotifier<Plan> currentPlan = ValueNotifier(Plan.free);

  /// Se a assinatura está ativa (true) ou não (false)
  static final ValueNotifier<bool> isActive = ValueNotifier(false);

  /// Cache rápido usado por partes que precisam checar sincronamente
  static bool _cachedIsActive = false;

  /// Inicializa o serviço — deve ser chamado pelo app startup
  static void init() {
    // Observa mudanças de autenticação para recarregar o plano
    AuthService.authStateChanges.listen((user) {
      if (user == null) {
        _setFreeLocally();
      } else {
        // Carrega do Firestore primeiro (rápido) e depois tenta um refresh
        // a partir do RevenueCat (somente quando necessário).
        loadSubscription().then((_) => _maybeRefreshFromRevenueCat(user.uid));
      }
    });
  }

  /// Verifica com o RevenueCat informações mais recentes da conta do usuário
  /// e atualiza o Firestore caso encontre assinaturas ativas.
  /// 
  /// IMPORTANTE: Esta função sempre consulta o RevenueCat para detectar
  /// cancelamentos/estornos recentes. Rate-limit de 1 hora.
  ///
  /// Esta chamada é rate-limited via SharedPreferences (evita chamadas excessivas).
  static Future<void> _maybeRefreshFromRevenueCat(String userId) async {
    try {
      final key = 'subscription_last_refresh_$userId';
      final lastStr = PrefsService.getString(key);
      DateTime? last;
      if (lastStr != null) {
        try {
          last = DateTime.parse(lastStr);
        } catch (_) {
          last = null;
        }
      }

      // Se já checamos na última hora, não checar de novo
      // (Reduzido de 12h para 1h para detectar cancelamentos mais rapidamente)
      if (last != null && DateTime.now().difference(last) < const Duration(hours: 1)) {
        debugPrint('🔁 Subscription refresh skipped (last checked: $last)');
        return;
      }

      debugPrint('🔄 Refreshing subscription from RevenueCat for user $userId');
      debugPrint('📊 Checking for active entitlements, cancellations, and refunds...');
      
      final info = await RevenueCatService.instance.getCustomerInfo();
      if (info == null) {
        debugPrint('⚠️ No customer info returned from RevenueCat');
        await PrefsService.setString(key, DateTime.now().toUtc().toIso8601String());
        return;
      }

      debugPrint('📋 CustomerInfo received: ${info.entitlements.all.length} entitlement(s)');
      
      // Use RevenueCatService's heuristics to determine if user is premium
      final isPremium = RevenueCatService.isPremiumActiveFromInfo(info);
      debugPrint('💎 Premium status from RevenueCat: $isPremium');
      
      if (isPremium) {
        final ent = info.entitlements.all[RevenueCatConfig.premiumEntitlementId];
        if (ent == null) {
          debugPrint('⚠️ Entitlement expected but not found in info');
          await PrefsService.setString(key, DateTime.now().toUtc().toIso8601String());
          return;
        }
        
        debugPrint('✅ Active entitlement found:');
        debugPrint('   - Product: ${ent.productIdentifier}');
        debugPrint('   - Active: ${ent.isActive}');
        debugPrint('   - Will renew: ${ent.willRenew}');
        debugPrint('   - Expiry: ${ent.expirationDate}');
        debugPrint('   - Latest purchase: ${ent.latestPurchaseDate}');
        
        // Parsear datas
        DateTime now = DateTime.now().toUtc();
        DateTime expiry = now.add(const Duration(days: 365));
        DateTime start = now;

        DateTime? tryParse(dynamic v) {
          if (v == null) return null;
          if (v is DateTime) return v.toUtc();
          if (v is String) {
            try {
              return DateTime.parse(v).toUtc();
            } catch (_) {
              return null;
            }
          }
          return null;
        }

  final parsedExp = tryParse(ent.expirationDate);
  final parsedLatest = tryParse(ent.latestPurchaseDate);
        if (parsedExp != null) expiry = parsedExp;
        if (parsedLatest != null) start = parsedLatest;

        final purchaseInfo = {
          'appUserId': info.originalAppUserId,
          'productId': ent.productIdentifier,
          'purchaseDate': ent.latestPurchaseDate,
          'originalPurchaseDate': ent.originalPurchaseDate,
          'expirationDate': ent.expirationDate,
          'willRenew': ent.willRenew,
          'store': ent.store.toString(),
          'periodType': ent.periodType.toString(),
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        };

  final plan = ent.productIdentifier.contains('annual') ? Plan.annual : Plan.monthly;

        // Atualiza Firestore com as informações obtidas
        await setSubscription(plan, start, expiry, purchaseInfo: purchaseInfo);
        debugPrint('✅ Subscription refreshed from RevenueCat and saved to Firestore');
        debugPrint('   - Plan: $plan');
        debugPrint('   - Start: $start');
        debugPrint('   - Expiry: $expiry');
      } else {
        // Nenhuma assinatura ativa encontrada - pode ser cancelamento/estorno
        debugPrint('⚠️ No active entitlement found on RevenueCat for user $userId');
        debugPrint('🔍 This may indicate:');
        debugPrint('   - User never subscribed');
        debugPrint('   - Subscription was cancelled and expired');
        debugPrint('   - Purchase was refunded');
        debugPrint('   - Subscription period ended without renewal');
        
        // Verifica se há plano ativo no Firestore mas não no RevenueCat
        final currentSnapshot = await _currentUserDoc?.get();
        if (currentSnapshot != null && currentSnapshot.exists) {
          final data = currentSnapshot.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('subscription')) {
            final sub = data['subscription'] as Map<String, dynamic>;
            final planStr = sub['plan'] as String?;
            if (planStr != null && planStr != 'free') {
              debugPrint('🚨 MISMATCH DETECTED:');
              debugPrint('   - Firestore shows active plan: $planStr');
              debugPrint('   - RevenueCat shows no active entitlement');
              debugPrint('   - Setting subscription to FREE to sync state');
              
              // Remove assinatura do Firestore já que RevenueCat não tem entitlement ativo
              await _currentUserDoc?.set({
                'subscription': {
                  'plan': 'free',
                  'startDate': DateTime.now().toUtc().toIso8601String(),
                  'expiryDate': DateTime.now().toUtc().toIso8601String(),
                  'syncedFromRevenueCat': true,
                  'syncTimestamp': DateTime.now().toUtc().toIso8601String(),
                }
              }, SetOptions(merge: true));
              
              // Atualiza cache local
              _setFreeLocally();
            }
          }
        }
      }

      await PrefsService.setString(key, DateTime.now().toUtc().toIso8601String());
    } catch (e) {
      debugPrint('❌ Error refreshing subscription from RevenueCat: $e');
    }
  }

  static void _setFreeLocally() {
    currentPlan.value = Plan.free;
    isActive.value = false;
    _cachedIsActive = false;
  }

  /// Carrega a informação de assinatura do Firestore
  static Future<void> loadSubscription() async {
    final userDoc = _currentUserDoc;
    if (userDoc == null) {
      _setFreeLocally();
      return;
    }

    try {
      final snapshot = await userDoc.get();
      if (!snapshot.exists) {
        _setFreeLocally();
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('subscription')) {
        _setFreeLocally();
        return;
      }

      final sub = data['subscription'] as Map<String, dynamic>;
      final planStr = sub['plan'] as String?;
      final expiryStr = sub['expiryDate'] as String?;

      Plan plan = Plan.free;
      if (planStr == 'monthly') plan = Plan.monthly;
      if (planStr == 'annual') plan = Plan.annual;

      DateTime? expiry;
      if (expiryStr != null) {
        try {
          expiry = DateTime.parse(expiryStr);
        } catch (_) {
          expiry = null;
        }
      }

      final now = DateTime.now().toUtc();
      final active = expiry != null ? expiry.toUtc().isAfter(now) : false;

      currentPlan.value = plan;
      isActive.value = active;
      _cachedIsActive = active;

      debugPrint('🔁 Subscription loaded -> plan=$plan, active=$active, expiry=$expiry');
    } catch (e) {
      debugPrint('❌ Erro ao carregar subscription: $e');
      _setFreeLocally();
    }
  }

  /// Seta a assinatura no Firestore (escreve o documento do usuário)
  static Future<void> setSubscription(
    Plan plan, 
    DateTime start, 
    DateTime expiry, {
    Map<String, dynamic>? purchaseInfo,
  }) async {
    final userDoc = _currentUserDoc;
    if (userDoc == null) throw Exception('Usuário não logado');

    final payload = {
      'subscription': {
        'plan': plan == Plan.monthly ? 'monthly' : plan == Plan.annual ? 'annual' : 'free',
        'startDate': start.toUtc().toIso8601String(),
        'expiryDate': expiry.toUtc().toIso8601String(),
        // Armazenar informações de compra para estorno
        if (purchaseInfo != null) 'purchaseInfo': purchaseInfo,
      },
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    await userDoc.set(payload, SetOptions(merge: true));

    // Atualiza cache/local
    currentPlan.value = plan;
    final now = DateTime.now().toUtc();
    final active = expiry.toUtc().isAfter(now);
    isActive.value = active;
    _cachedIsActive = active;

    debugPrint('✅ Subscription set -> plan=$plan, active=$active');
    if (purchaseInfo != null) {
      debugPrint('📋 Purchase info stored: ${purchaseInfo['appUserId']}');
    }
  }

  /// Método que simula compra de plano mensal (1 BRL)
  /// Observação: implementar integração real com Google Play / App Store ou gateway de pagamento em produção.
  static Future<void> purchaseMonthly() async {
    // Real purchase flow using RevenueCat. Product IDs must be configured in
    // lib/config/revenuecat_config.dart and in your RevenueCat dashboard.
    try {
      final ok = await RevenueCatService.instance.purchaseProduct(RevenueCatConfig.monthlyProductId);
      if (!ok) throw Exception('purchase failed or entitlement not active');

      // Get latest customer info to determine expiration (best-effort)
      final info = await RevenueCatService.instance.getCustomerInfo();
      DateTime now = DateTime.now().toUtc();
      DateTime expiry = now.add(const Duration(days: 30));

      // Coletar informações de compra para armazenar
      Map<String, dynamic>? purchaseInfo;
      
      if (info != null) {
        final ent = info.entitlements.all[RevenueCatConfig.premiumEntitlementId];
        if (ent != null) {
          DateTime? parsedExp;
          DateTime? parsedLatest;
          final expVal = ent.expirationDate;
          final latestVal = ent.latestPurchaseDate;
          final originalPurchaseVal = ent.originalPurchaseDate;
          
          DateTime? tryParse(dynamic v) {
            if (v == null) return null;
            if (v is DateTime) return v.toUtc();
            if (v is String) {
              try {
                return DateTime.parse(v).toUtc();
              } catch (_) {
                return null;
              }
            }
            return null;
          }

          parsedExp = tryParse(expVal);
          parsedLatest = tryParse(latestVal);
          if (parsedExp != null) expiry = parsedExp;
          if (parsedLatest != null) now = parsedLatest;
          
          // Armazenar informações para estorno
          purchaseInfo = {
            'appUserId': info.originalAppUserId,
            'productId': ent.productIdentifier,
            'purchaseDate': latestVal,
            'originalPurchaseDate': originalPurchaseVal,
            'expirationDate': expVal,
            'willRenew': ent.willRenew,
            'store': ent.store.toString(),
            'periodType': ent.periodType.toString(),
            'timestamp': DateTime.now().toUtc().toIso8601String(),
          };
        }
      }

      await setSubscription(Plan.monthly, now, expiry, purchaseInfo: purchaseInfo);
    } catch (e) {
      debugPrint('❌ purchaseMonthly failed: $e');
      rethrow;
    }
  }

  /// Método que simula compra de plano anual (7 BRL)
  static Future<void> purchaseAnnual() async {
    try {
      final ok = await RevenueCatService.instance.purchaseProduct(RevenueCatConfig.annualProductId);
      if (!ok) throw Exception('purchase failed or entitlement not active');

      final info = await RevenueCatService.instance.getCustomerInfo();
      DateTime now = DateTime.now().toUtc();
      DateTime expiry = now.add(const Duration(days: 365));

      // Coletar informações de compra para armazenar
      Map<String, dynamic>? purchaseInfo;

      if (info != null) {
        final ent = info.entitlements.all[RevenueCatConfig.premiumEntitlementId];
        if (ent != null) {
          DateTime? parsedExp;
          DateTime? parsedLatest;
          final expVal = ent.expirationDate;
          final latestVal = ent.latestPurchaseDate;
          final originalPurchaseVal = ent.originalPurchaseDate;
          
          DateTime? tryParse(dynamic v) {
            if (v == null) return null;
            if (v is DateTime) return v.toUtc();
            if (v is String) {
              try {
                return DateTime.parse(v).toUtc();
              } catch (_) {
                return null;
              }
            }
            return null;
          }

          parsedExp = tryParse(expVal);
          parsedLatest = tryParse(latestVal);
          if (parsedExp != null) expiry = parsedExp;
          if (parsedLatest != null) now = parsedLatest;
          
          // Armazenar informações para estorno
          purchaseInfo = {
            'appUserId': info.originalAppUserId,
            'productId': ent.productIdentifier,
            'purchaseDate': latestVal,
            'originalPurchaseDate': originalPurchaseVal,
            'expirationDate': expVal,
            'willRenew': ent.willRenew,
            'store': ent.store.toString(),
            'periodType': ent.periodType.toString(),
            'timestamp': DateTime.now().toUtc().toIso8601String(),
          };
        }
      }

      await setSubscription(Plan.annual, now, expiry, purchaseInfo: purchaseInfo);
    } catch (e) {
      debugPrint('❌ purchaseAnnual failed: $e');
      rethrow;
    }
  }

  /// Verifica se o usuário tem assinatura ativa (async)
  static Future<bool> isSubscriptionActive() async {
    // Garante que os dados estejam carregados
    await loadSubscription();
    return _cachedIsActive;
  }

  /// Getter síncrono para uso rápido (pode ser desatualizado)
  static bool get isSubscribedCached => _cachedIsActive;

  /// Força verificação imediata do status da assinatura no RevenueCat
  /// (ignora rate-limit). Útil para debug ou quando o usuário reporta problema.
  static Future<void> forceRefreshSubscription() async {
    final user = AuthService.currentUser;
    if (user == null) {
      debugPrint('⚠️ forceRefreshSubscription: No user logged in');
      return;
    }
    
    // Limpa o timestamp de última verificação para forçar refresh
    final key = 'subscription_last_refresh_${user.uid}';
    await PrefsService.remove(key);
    
    debugPrint('🔄 Force refreshing subscription status...');
    await _maybeRefreshFromRevenueCat(user.uid);
    await loadSubscription();
    debugPrint('✅ Force refresh completed');
  }

  /// Retorna label legível do plano (em PT-BR)
  static String planLabel(Plan plan) {
    switch (plan) {
      case Plan.monthly:
        return 'Mensal';
      case Plan.annual:
        return 'Anual';
      case Plan.free:
        return 'Free';
    }
  }
}

enum Plan { free, monthly, annual }
