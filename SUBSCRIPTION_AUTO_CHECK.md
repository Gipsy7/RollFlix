# Verificação Automática de Assinatura

## 📋 Resumo

Sistema implementado para **verificar automaticamente o status da assinatura** sempre que o usuário:
- Faz login no app
- Abre o app já logado

Isso garante que **cancelamentos e estornos recentes** sejam detectados rapidamente.

## 🔄 Como Funciona

### 1. Verificação Automática no Login/Abertura

Quando o usuário autentica ou o app inicia com usuário logado:

```dart
// Em SubscriptionService.init()
AuthService.authStateChanges.listen((user) {
  if (user == null) {
    _setFreeLocally();
  } else {
    // 1. Carrega rápido do Firestore (cache local)
    loadSubscription().then((_) => 
      // 2. Verifica com RevenueCat (fonte verdadeira)
      _maybeRefreshFromRevenueCat(user.uid)
    );
  }
});
```

### 2. Rate-Limiting Inteligente

Para evitar chamadas excessivas ao servidor RevenueCat:
- **Rate-limit: 1 hora** (reduzido de 12h para detectar problemas mais rapidamente)
- Usa `SharedPreferences` para armazenar timestamp da última verificação
- Se verificou há menos de 1 hora, pula a chamada

### 3. Detecção de Cancelamentos/Estornos

O sistema verifica:

1. **CustomerInfo do RevenueCat** (fonte verdadeira de assinatura)
2. **Entitlement ativo** usando heurísticas:
   - `isActive == true`
   - `expirationDate` no futuro
   - `willRenew` ou `latestPurchaseDate` recente
3. **Compara com Firestore**:
   - Se RevenueCat mostra "sem assinatura" mas Firestore tem assinatura ativa
   - **MISMATCH DETECTADO** → Define como FREE
   - Logs detalhados para diagnóstico

### 4. Logs Detalhados

Logs adicionados para facilitar debugging:

```
🔄 Refreshing subscription from RevenueCat for user abc123
📊 Checking for active entitlements, cancellations, and refunds...
📋 CustomerInfo received: 1 entitlement(s)
💎 Premium status from RevenueCat: true
✅ Active entitlement found:
   - Product: monthly_plan_1
   - Active: true
   - Will renew: true
   - Expiry: 2025-12-06T10:30:00.000Z
   - Latest purchase: 2025-11-06T10:30:00.000Z
✅ Subscription refreshed from RevenueCat and saved to Firestore
```

Quando **não** há assinatura ativa:

```
⚠️ No active entitlement found on RevenueCat for user abc123
🔍 This may indicate:
   - User never subscribed
   - Subscription was cancelled and expired
   - Purchase was refunded
   - Subscription period ended without renewal
🚨 MISMATCH DETECTED:
   - Firestore shows active plan: monthly
   - RevenueCat shows no active entitlement
   - Setting subscription to FREE to sync state
```

## 🛠️ Verificação Manual (Debug)

### Botão no Profile

Foi adicionado um botão **"Verificar Assinatura"** na tela de perfil (visível apenas quando não há plano ativo).

```dart
OutlinedButton.icon(
  onPressed: _forceCheckSubscription,
  icon: Icon(Icons.refresh, size: 18),
  label: SafeText('Verificar Assinatura'),
)
```

### Método Público

Pode ser chamado programaticamente:

```dart
// Força verificação imediata (ignora rate-limit)
await SubscriptionService.forceRefreshSubscription();
```

## 📊 Fluxo Completo

```
┌─────────────────────┐
│  Usuário loga ou    │
│  abre app logado    │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│ loadSubscription()  │ ← Rápido: lê Firestore
│   (Firestore)       │
└──────────┬──────────┘
           │
           v
┌─────────────────────────────────┐
│ _maybeRefreshFromRevenueCat()   │
│                                 │
│ 1. Verifica rate-limit (1h)    │
│ 2. Consulta RevenueCat API      │
│ 3. Avalia entitlement           │
│ 4. Detecta mismatch             │
│ 5. Atualiza Firestore           │
│ 6. Atualiza cache local         │
└─────────────────────────────────┘
```

## ⚙️ Configurações

### Rate-Limit (ajustável)

Em `subscription_service.dart`:

```dart
// Linha ~67
if (last != null && DateTime.now().difference(last) < const Duration(hours: 1)) {
  debugPrint('🔁 Subscription refresh skipped (last checked: $last)');
  return;
}
```

Para ajustar:
- **Mais frequente**: `Duration(minutes: 30)`
- **Menos frequente**: `Duration(hours: 6)`
- **Debug/teste**: comente a condição ou use `forceRefreshSubscription()`

## 🧪 Como Testar

### 1. Teste Básico (Login)

1. Faça logout do app
2. Observe os logs no console
3. Faça login
4. Veja os logs de verificação de assinatura

### 2. Teste de Cancelamento/Estorno

1. Tenha uma assinatura ativa no app
2. Cancele a assinatura via Play Console (ou simule estorno)
3. Abra o app
4. Aguarde até 1 hora (ou force verificação)
5. App deve detectar ausência de entitlement e definir como FREE

### 3. Teste Manual (Botão Debug)

1. Vá para tela de Perfil
2. Se não tiver plano ativo, verá botão "Verificar Assinatura"
3. Toque no botão
4. Veja SnackBar com resultado
5. Observe logs detalhados no console

### 4. Logs Esperados

**Assinatura ativa:**
```
🔄 Refreshing subscription from RevenueCat for user abc123
💎 Premium status from RevenueCat: true
✅ Subscription refreshed from RevenueCat and saved to Firestore
   - Plan: Plan.monthly
   - Start: 2025-11-06 10:30:00.000Z
   - Expiry: 2025-12-06 10:30:00.000Z
```

**Assinatura cancelada/estornada:**
```
🔄 Refreshing subscription from RevenueCat for user abc123
⚠️ No active entitlement found on RevenueCat
🚨 MISMATCH DETECTED:
   - Firestore shows active plan: monthly
   - RevenueCat shows no active entitlement
   - Setting subscription to FREE to sync state
```

## 🔐 Segurança

- **RevenueCat é a fonte verdadeira**: Firestore é cache secundário
- **Sempre sobrescreve local com servidor**: Evita fraudes
- **Heurísticas de entitlement**: Reduz falsos positivos
- **Logs auditáveis**: Registra todas as mudanças de estado

## 📝 Arquivos Modificados

1. **`lib/services/subscription_service.dart`**
   - Reduzido rate-limit de 12h para 1h
   - Logs detalhados adicionados
   - Detecção de mismatch Firestore vs RevenueCat
   - Método `forceRefreshSubscription()` adicionado

2. **`lib/screens/profile_screen.dart`**
   - Botão "Verificar Assinatura" adicionado
   - Método `_forceCheckSubscription()` implementado
   - Feedback visual via SnackBar

## 🎯 Benefícios

✅ **Detecção rápida** de cancelamentos/estornos (em até 1 hora)  
✅ **Sincronização automática** Firestore ↔ RevenueCat  
✅ **Logs detalhados** para troubleshooting  
✅ **Rate-limiting** evita sobrecarga do servidor  
✅ **Verificação manual** disponível para debug  
✅ **Segurança**: RevenueCat sempre prevalece  

## 🚀 Próximos Passos (Opcional)

1. **Server-side Webhooks**: Configure webhooks do RevenueCat para notificações push de mudanças
2. **Analytics**: Registre eventos de cancelamento no Firebase Analytics
3. **Notificação ao usuário**: Avise quando assinatura for cancelada/expirou
4. **Grace period**: Considere período de graça antes de remover acesso
