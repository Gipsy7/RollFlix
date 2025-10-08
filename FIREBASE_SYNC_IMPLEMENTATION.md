# Sincronização de Favoritos e Assistidos com Firebase

## 📋 Visão Geral

Sistema de sincronização em nuvem para favoritos e assistidos, associado à conta do usuário via Firebase Authentication e Firestore.

## 🏗️ Arquitetura

### Camadas Implementadas

```
┌─────────────────────────────────────────┐
│         UI Layer (Screens)              │
│   - LoginScreen                         │
│   - FavoritesScreen                     │
│   - WatchedScreen                       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      Controllers Layer                  │
│   - FavoritesController                 │
│   - WatchedController                   │
│     ▪ Gerenciam estado local            │
│     ▪ Sincronizam com Firebase          │
│     ▪ Fallback para SharedPreferences   │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│       Services Layer                    │
│   - UserDataService                     │
│     ▪ CRUD no Firestore                 │
│     ▪ Streams em tempo real             │
│     ▪ Merge de dados                    │
│   - AuthService                         │
│     ▪ Google Sign-In                    │
│     ▪ Firebase Auth                     │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      Firebase Backend                   │
│   - Firestore Database                  │
│     Collection: users/{userId}/         │
│       ▪ favorites: []                   │
│       ▪ watched: []                     │
│       ▪ lastUpdated: timestamp          │
│   - Firebase Authentication             │
│     ▪ Google Provider                   │
└─────────────────────────────────────────┘
```

## 📁 Estrutura de Dados no Firestore

```typescript
users/{userId} {
  favorites: [
    {
      id: string,
      title: string,
      posterPath: string?,
      overview: string?,
      voteAverage: number,
      releaseDate: string,
      isTVShow: boolean,
      addedAt: timestamp,
      originalTitle: string?,
      runtime: number?,
      originalName: string?,
      numberOfSeasons: number?,
      numberOfEpisodes: number?
    },
    ...
  ],
  watched: [
    {
      id: string,
      title: string,
      posterPath: string?,
      overview: string?,
      voteAverage: number,
      releaseDate: string,
      isTVShow: boolean,
      watchedAt: timestamp,
      originalTitle: string?,
      runtime: number?,
      originalName: string?,
      numberOfSeasons: number?,
      numberOfEpisodes: number?
    },
    ...
  ],
  lastUpdated: timestamp
}
```

## 🔄 Fluxo de Sincronização

### 1. **Login**

```
Usuário faz login → AuthService.signInWithGoogle()
  ↓
LoginScreen.syncAfterLogin()
  ↓
Controllers carregam dados locais (SharedPreferences)
  ↓
Controllers carregam dados da nuvem (Firestore)
  ↓
Merge de dados (prioriza nuvem, adiciona exclusivos locais)
  ↓
Salva dados mesclados na nuvem
  ↓
Atualiza UI
```

### 2. **Adicionar Favorito/Assistido**

```
Usuário marca como favorito
  ↓
Controller adiciona à lista local
  ↓
Salva em SharedPreferences (backup)
  ↓
Se usuário logado: salva no Firestore
  ↓
Atualiza UI
```

### 3. **Remover Favorito/Assistido**

```
Usuário remove favorito
  ↓
Controller remove da lista local
  ↓
Salva em SharedPreferences
  ↓
Se usuário logado: atualiza Firestore
  ↓
Atualiza UI
```

## 🚀 Novos Recursos

### UserDataService

**Localização:** `lib/services/user_data_service.dart`

**Métodos:**

- `saveFavorites(List<FavoriteItem>)` - Salva favoritos no Firestore
- `loadFavorites()` - Carrega favoritos do Firestore
- `favoritesStream()` - Stream em tempo real de favoritos
- `saveWatched(List<WatchedItem>)` - Salva assistidos no Firestore
- `loadWatched()` - Carrega assistidos do Firestore
- `watchedStream()` - Stream em tempo real de assistidos
- `syncAfterLogin()` - Sincroniza dados locais com nuvem
- `clearUserData()` - Limpa dados do usuário (logout)

### FavoritesController - Novos Métodos

- `syncAfterLogin()` - Mescla favoritos locais com Firebase após login

### WatchedController - Novos Métodos

- `syncAfterLogin()` - Mescla assistidos locais com Firebase após login

## 💾 Estratégia de Armazenamento

### Duplo Armazenamento

1. **SharedPreferences** (Local)
   - ✅ Sempre salva localmente
   - ✅ Funciona offline
   - ✅ Backup caso Firebase falhe
   - ✅ Rápido acesso

2. **Firestore** (Nuvem)
   - ✅ Disponível em qualquer dispositivo
   - ✅ Sincronização automática
   - ✅ Associado à conta do usuário
   - ✅ Persistência permanente

### Priorização

- **Login:** Dados da nuvem sobrescrevem locais (considerados mais recentes)
- **Merge:** Remove duplicatas mantendo item mais recente
- **Offline:** Continua funcionando com dados locais
- **Online:** Sincroniza automaticamente quando conectado

## 🔐 Segurança

### Regras do Firestore Sugeridas

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      // Usuário só pode ler/escrever seus próprios dados
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 🎯 Casos de Uso

### Caso 1: Usuário Não Logado

1. Adiciona favoritos → Salva apenas em SharedPreferences
2. Dados ficam no dispositivo
3. Não sincroniza com nuvem

### Caso 2: Usuário Faz Login

1. Login bem-sucedido
2. Sistema carrega dados locais e da nuvem
3. Mescla dados (remove duplicatas)
4. Salva dados mesclados no Firebase
5. Todos os dispositivos recebem dados atualizados

### Caso 3: Usuário Já Logado Adiciona Favorito

1. Adiciona favorito
2. Salva localmente (SharedPreferences)
3. Salva na nuvem (Firestore)
4. Outros dispositivos recebem atualização em tempo real (via Stream)

### Caso 4: Usuário Faz Logout

1. Logout
2. Dados continuam salvos localmente
3. Próximo login sincroniza novamente

## 📊 Estatísticas e Monitoramento

### Logs Implementados

```dart
debugPrint('✅ Favoritos carregados do Firebase')
debugPrint('✅ Favoritos salvos (local + Firebase)')
debugPrint('🔄 Sincronizando favoritos após login...')
debugPrint('⚠️ Usuário não logado - retornando favoritos vazios')
debugPrint('❌ Erro ao carregar favoritos do Firebase')
```

## 🧪 Testando

### Teste 1: Sincronização Inicial

1. Crie favoritos sem estar logado
2. Faça login
3. Verifique se favoritos foram enviados ao Firebase
4. Verifique console do Firestore

### Teste 2: Múltiplos Dispositivos

1. Faça login no dispositivo A
2. Adicione favoritos
3. Faça login no dispositivo B com mesma conta
4. Verifique se favoritos aparecem

### Teste 3: Merge de Dados

1. Dispositivo A offline: adiciona favoritos
2. Dispositivo B online: adiciona favoritos diferentes
3. Dispositivo A conecta e faz login
4. Verifique se ambos os favoritos estão presentes

## 🔧 Configuração Necessária

### Firebase Console

1. ✅ Habilitar Firebase Authentication
2. ✅ Configurar Google Sign-In
3. ✅ Criar database Firestore
4. ⚠️ **IMPORTANTE:** Configurar regras de segurança
5. ✅ Habilitar modo de produção

### Regras de Segurança Recomendadas

Ver seção [Segurança](#-segurança)

## 📝 Próximas Melhorias

- [ ] Implementar retry automático em caso de falha
- [ ] Adicionar indicador visual de sincronização
- [ ] Implementar resolução de conflitos mais sofisticada
- [ ] Adicionar cache offline do Firestore
- [ ] Implementar paginação para listas grandes
- [ ] Adicionar analytics de uso

## 🐛 Troubleshooting

### Problema: Dados não sincronizam

**Solução:**
1. Verifique se usuário está logado: `AuthService.isUserLoggedIn()`
2. Verifique regras do Firestore
3. Verifique logs de erro no console

### Problema: Duplicatas após login

**Solução:**
- Lógica de merge remove duplicatas por ID
- Se persistir, limpe SharedPreferences e refaça login

### Problema: Dados perdidos

**Solução:**
- Dados locais estão em SharedPreferences (backup)
- Dados na nuvem persistem enquanto conta existir
- Verifique Firestore Console diretamente

## ✅ Checklist de Implementação

- [x] Criar UserDataService
- [x] Atualizar FavoritesController com sincronização
- [x] Atualizar WatchedController com sincronização
- [x] Adicionar sincronização no login
- [x] Implementar duplo armazenamento (local + nuvem)
- [x] Implementar merge de dados
- [x] Adicionar logs de depuração
- [ ] Configurar regras de segurança no Firebase
- [ ] Testar em múltiplos dispositivos
- [ ] Documentar para usuários finais

## 📚 Referências

- [Firebase Authentication - Google Sign-In](https://firebase.google.com/docs/auth/web/google-signin)
- [Cloud Firestore - Get Started](https://firebase.google.com/docs/firestore/quickstart)
- [Flutter Firebase](https://firebase.flutter.dev/)
