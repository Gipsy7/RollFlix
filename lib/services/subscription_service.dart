import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

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
        loadSubscription();
      }
    });
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
  static Future<void> setSubscription(Plan plan, DateTime start, DateTime expiry) async {
    final userDoc = _currentUserDoc;
    if (userDoc == null) throw Exception('Usuário não logado');

    final payload = {
      'subscription': {
        'plan': plan == Plan.monthly ? 'monthly' : plan == Plan.annual ? 'annual' : 'free',
        'startDate': start.toUtc().toIso8601String(),
        'expiryDate': expiry.toUtc().toIso8601String(),
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
  }

  /// Método que simula compra de plano mensal (1 BRL)
  /// Observação: implementar integração real com Google Play / App Store ou gateway de pagamento em produção.
  static Future<void> purchaseMonthly() async {
    // Aqui é onde deveria ocorrer o fluxo real de pagamento.
    // Por enquanto simulamos sucesso imediato.
    final now = DateTime.now().toUtc();
    final expiry = now.add(const Duration(days: 30));
    await setSubscription(Plan.monthly, now, expiry);
  }

  /// Método que simula compra de plano anual (7 BRL)
  static Future<void> purchaseAnnual() async {
    final now = DateTime.now().toUtc();
    final expiry = now.add(const Duration(days: 365));
    await setSubscription(Plan.annual, now, expiry);
  }

  /// Verifica se o usuário tem assinatura ativa (async)
  static Future<bool> isSubscriptionActive() async {
    // Garante que os dados estejam carregados
    await loadSubscription();
    return _cachedIsActive;
  }

  /// Getter síncrono para uso rápido (pode ser desatualizado)
  static bool get isSubscribedCached => _cachedIsActive;

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
