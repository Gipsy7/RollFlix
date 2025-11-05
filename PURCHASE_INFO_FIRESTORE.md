# 📋 Estrutura de Dados de Compra no Firestore

## 🎯 Objetivo

Armazenar informações completas de cada compra/assinatura para facilitar:
- Estornos manuais
- Suporte ao cliente
- Auditoria de transações
- Gerenciamento de assinaturas

## 📊 Estrutura no Firestore

### Caminho do Documento
```
users/{userId}/subscription/purchaseInfo
```

### Campos Armazenados

Quando um usuário assina o plano mensal ou anual, os seguintes dados são salvos:

```json
{
  "subscription": {
    "plan": "monthly",  // ou "annual" ou "free"
    "startDate": "2025-11-04T20:30:00.000Z",
    "expiryDate": "2025-12-04T20:30:00.000Z",
    "purchaseInfo": {
      "appUserId": "$RCAnonymousID:abc123xyz456",  // ID único no RevenueCat
      "productId": "rollflix_monthly",              // ou "rollflix_annual"
      "purchaseDate": "2025-11-04T20:30:00.000Z",  // Data da compra
      "originalPurchaseDate": "2025-11-04T20:30:00.000Z",  // Primeira compra (renovações mantêm esta)
      "expirationDate": "2025-12-04T20:30:00.000Z",
      "willRenew": true,                            // Se vai renovar automaticamente
      "store": "PLAY_STORE",                        // ou "APP_STORE"
      "periodType": "normal",                       // ou "trial", "intro"
      "timestamp": "2025-11-04T20:30:15.123Z"      // Timestamp do registro
    }
  },
  "lastUpdated": Timestamp(2025-11-04 20:30:15)
}
```

## 🔍 Como Usar para Estorno

### 1. Encontrar o Usuário no Firestore

1. Acesse Firebase Console → Firestore Database
2. Navegue até `users/{userId}`
3. Veja o campo `subscription.purchaseInfo`

### 2. Identificadores Importantes

- **`appUserId`**: Use este ID no RevenueCat Dashboard para encontrar o cliente
- **`productId`**: Identifica qual produto foi comprado
- **`purchaseDate`**: Para verificar elegibilidade de reembolso (≤ 5 dias)
- **`originalPurchaseDate`**: Identifica a primeira compra (útil para renovações)

### 3. Processar Estorno no RevenueCat

1. Acesse https://app.revenuecat.com
2. Vá em **Customers**
3. Busque pelo `appUserId` (ex: `$RCAnonymousID:abc123xyz456`)
4. Você verá:
   - Todas as transações do usuário
   - Status da assinatura
   - Entitlements ativos
5. Clique em **Revoke entitlement** ou **Issue refund**

### 4. Processar Estorno no Google Play Console

1. Acesse Play Console → Order Management
2. Busque por:
   - Email do usuário (se disponível)
   - Order ID (se disponível no RevenueCat)
3. Selecione a transação
4. Clique em **Refund** ou **Cancel subscription**

## 📱 Exemplo de Query no Firestore

Para buscar todos os usuários com assinaturas ativas:

```javascript
// Firebase Admin SDK (Node.js)
const snapshot = await db.collection('users')
  .where('subscription.plan', '!=', 'free')
  .where('subscription.expiryDate', '>', new Date().toISOString())
  .get();

snapshot.forEach(doc => {
  const data = doc.data();
  const purchaseInfo = data.subscription?.purchaseInfo;
  
  console.log('User ID:', doc.id);
  console.log('RevenueCat ID:', purchaseInfo?.appUserId);
  console.log('Product:', purchaseInfo?.productId);
  console.log('Purchase Date:', purchaseInfo?.purchaseDate);
  console.log('---');
});
```

## 🛡️ Segurança

As informações de compra estão protegidas pelas **Firestore Security Rules**. Apenas:
- O próprio usuário pode ler seus dados
- Admins (via Firebase Admin SDK) podem acessar para suporte

### Security Rules Recomendadas

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      // Usuário pode ler apenas seus próprios dados
      allow read: if request.auth != null && request.auth.uid == userId;
      
      // Apenas o próprio usuário ou cloud functions podem escrever
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📊 Relatórios e Analytics

Para gerar relatórios de vendas, use Firebase Extensions:
- **Run Subscription Payments with Stripe** (se usar Stripe)
- **Export Collections to BigQuery** (para análises avançadas)

Ou crie Cloud Functions para:
- Exportar dados de compras para CSV
- Enviar relatórios por email
- Sincronizar com sistemas de contabilidade

## ⚠️ Importante

- ✅ **Nunca** armazene números de cartão ou dados sensíveis de pagamento
- ✅ **Sempre** use o `appUserId` do RevenueCat como identificador principal
- ✅ **Mantenha** logs de todas as operações de estorno
- ✅ **Respeite** as políticas de reembolso (5 dias para Google Play)
