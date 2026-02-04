# 🎬 RollFlix

**Descubra filmes e séries de forma aleatória e divertida!**

RollFlix é um aplicativo Flutter moderno que ajuda você a descobrir conteúdo usando a API do The Movie Database (TMDb). Escolha um gênero, gire a roda e deixe o app escolher algo incrível para você assistir.

---

## 🚀 Funcionalidades

### 🎭 Sistema Dual (Filmes & Séries)
- Alterne entre modos de filmes e séries com um toque
- Paleta de cores dinâmica: dourado para filmes, roxo para séries
- Gêneros específicos para cada tipo de conteúdo
- Interface adaptativa que muda automaticamente

### 🎲 Roleta de Descoberta
- Roda interativa de gêneros com animação suave
- Sistema de sorteio aleatório com filtros personalizáveis
- Preferências avançadas: ano, classificação etária, idioma
- Pré-visualização de trailers (quando disponível)

### 🔐 Autenticação & Sincronização
- Login com Google integrado ao Firebase
- Sincronização automática de dados na nuvem
- Suporte offline para funcionalidades básicas
- Gerenciamento de perfil e estatísticas

### ⭐ Favoritos & Assistidos
- Marque filmes/séries como favoritos
- Registre conteúdo já assistido
- Sincronização entre dispositivos via Firebase
- Listas organizadas e pesquisáveis

### 📊 Sistema de Recursos
- **Recursos Diários Limitados**:
  - 5 rolagens por dia
  - 5 favoritos por dia
  - 5 itens assistidos por dia
- **Opções de Recarga**:
  - Recarga automática diária (meia-noite)
  - Assistir anúncios para ganhar recursos extras
  - Assinatura premium para recursos ilimitados

### 💎 Planos Premium
- **Mensal**: Recursos ilimitados + sem anúncios
- **Anual**: Economia de ~42% comparado ao plano mensal
- Integração com RevenueCat e Google Play Billing
- Cancelamento fácil direto na Play Store

### 🔔 Notificações Inteligentes
- Alertas de novos episódios de séries favoritas
- Notificações de lançamentos importantes
- Agendamento automático em background
- Personalização de horários e preferências

### 🔍 Pesquisa Avançada
- Busca em tempo real por filmes e séries
- Filtros por gênero, ano e popularidade
- Resultados paginados para melhor performance
- Acesso direto aos detalhes

### 📱 Detalhes Completos
- Sinopse, elenco e avaliações
- Trailers e vídeos relacionados
- Informações de temporadas e episódios (séries)
- Links para plataformas de streaming (quando disponível)
- Compartilhamento social integrado

### 🎨 Interface Moderna
- Design Material 3 com tema dark
- Animações suaves e responsivas
- Gradientes dinâmicos
- Suporte para múltiplos idiomas (PT, EN, ES, FR)
- Layout responsivo (mobile e tablet)

---

## 🛠️ Tecnologias

### Frontend
- **Flutter** 3.32+ / Dart 3.9.2
- Material Design 3
- Custom animations & transitions

### Backend & Serviços
- **Firebase**:
  - Authentication (Google Sign-In)
  - Cloud Firestore (sincronização de dados)
  - Cloud Messaging (notificações push)
  - ⚠️ **CONFIGURAÇÃO OBRIGATÓRIA**: Siga o guia [FIREBASE_CONFIGURATION.md](FIREBASE_CONFIGURATION.md)
- **RevenueCat**: Gerenciamento de assinaturas
- **Google Mobile Ads**: Sistema de anúncios recompensados
- **The Movie Database (TMDb)**: API de filmes e séries

### Arquitetura
- **Padrão MVC**: Controllers para lógica de negócio
- **Singleton Services**: Gerenciamento de estado e dados
- **Repository Pattern**: Abstração de fontes de dados
- **Dependency Injection**: Serviços centralizados

---

## 📦 Estrutura do Projeto

```
lib/
├── config/              # Configurações (API keys, RevenueCat, etc)
├── controllers/         # Lógica de negócio e estado
├── core/                # Utilitários e constantes globais
├── l10n/                # Internacionalização (i18n)
├── mixins/              # Comportamentos reutilizáveis
├── models/              # Modelos de dados
├── repositories/        # Acesso a dados (cache + API)
├── screens/             # Telas da aplicação
├── services/            # Serviços (Auth, Ads, Notificações, etc)
├── theme/               # Tema visual e estilos
├── utils/               # Funções utilitárias
└── widgets/             # Componentes reutilizáveis
```

---

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.32+
- Dart SDK 3.9.2+
- Conta TMDb (para API key)
- Projeto Firebase configurado
- Conta RevenueCat (opcional, para assinaturas)
- Conta AdMob (opcional, para anúncios)

### Configuração

1. **Clone o repositório**
```bash
git clone <repository-url>
cd testeapp
```

2. **Instale dependências**
```bash
flutter pub get
```

3. **Configure as API Keys**

Crie um arquivo `lib/config/secure_config.dart`:
```dart
class SecureConfig {
  static const String tmdbApiKey = 'SUA_API_KEY_TMDB';
  static const String tmdbAccessToken = 'SEU_ACCESS_TOKEN_TMDB';
  
  static void validate() {
    assert(tmdbApiKey.isNotEmpty, 'TMDB API Key não configurada');
  }
}
```

4. **Configure Firebase**
- **OBRIGATÓRIO**: Siga o guia completo [FIREBASE_CONFIGURATION.md](FIREBASE_CONFIGURATION.md)
- Execute `flutterfire configure` para gerar `firebase_options.dart`
- Adicione restrições nas API Keys no Google Cloud Console
- Baixe `google-services.json` e `GoogleService-Info.plist`
- **⚠️ NUNCA commite os arquivos com as API keys reais**

5. **Configure RevenueCat** (opcional)
- Edite `lib/config/revenuecat_config.dart` com sua API key
- Ou use `--dart-define=REVENUECAT_API_KEY=sua_chave`

6. **Execute o app**
```bash
flutter run
```

### Build para Produção

**Android (App Bundle)**:
```bash
flutter build appbundle --release
```

**Android (APK)**:
```bash
flutter build apk --release
```

**iOS**:
```bash
flutter build ios --release
```

---

## 🔑 Variáveis de Ambiente

Para builds em CI/CD, use `--dart-define`:

```bash
flutter build appbundle \
  --dart-define=REVENUECAT_API_KEY=sua_chave_revenuecat \
  --release
```

---

## 📱 Funcionalidades por Tela

### 🏠 Home
- Roda de gêneros interativa
- Botão de sorteio centralizado
- Cards de filme/série com animação
- Estatísticas rápidas de recursos
- Toggle filme/série

### 🔍 Pesquisa
- Campo de busca em tempo real
- Filtros avançados
- Grid de resultados paginado
- Acesso rápido aos detalhes

### ⭐ Favoritos
- Lista de favoritos do usuário
- Separação por filmes/séries
- Remoção individual ou em massa
- Sincronização na nuvem

### 👤 Perfil
- Informações da conta
- Estatísticas de uso
- Gerenciamento de assinatura
- Opções de logout e configurações

### 📄 Detalhes
- Informações completas
- Trailers e vídeos
- Botões de favoritar/assistido
- Compartilhamento social
- Recomendações similares

---

## 🌐 Idiomas Suportados

- 🇧🇷 Português (Brasil)
- 🇺🇸 English (Estados Unidos)
- 🇪🇸 Español (Espanha)
- 🇫🇷 Français (França)

---

## 📊 Métricas & Performance

- **Redução de código**: ~56% desde refatoração
- **Cache inteligente**: Redução de chamadas à API
- **Sincronização otimizada**: Batch operations no Firebase
- **Animações fluidas**: 60 FPS consistente
- **Startup rápido**: Pré-carregamento estratégico

---

## 🔒 Segurança

- ✅ API Keys nunca commitadas no repositório
- ✅ Validação de configurações em runtime
- ✅ Autenticação segura via Firebase Auth
- ✅ Regras de segurança no Firestore
- ✅ Tokens de acesso protegidos

---

## 📝 Licença

Este projeto é privado e proprietário.

---

## 👨‍💻 Desenvolvimento

**Versão**: 4.0+  
**Última atualização**: Fevereiro 2026

---

**Desenvolvido com ❤️ usando Flutter**
