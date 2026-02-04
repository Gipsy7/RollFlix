# 🔥 Configuração do Firebase

Este guia explica como configurar o Firebase corretamente no projeto RollFlix, incluindo a geração segura do arquivo `firebase_options.dart`.

## ⚠️ IMPORTANTE: Segurança das API Keys

O arquivo `firebase_options.dart` **NÃO deve ser commitado** com as API keys reais. Este arquivo foi removido do repositório e adicionado ao `.gitignore` por segurança.

## 📋 Pré-requisitos

1. Conta no [Firebase Console](https://console.firebase.google.com/)
2. Flutter SDK instalado
3. FlutterFire CLI instalado (instale com: `dart pub global activate flutterfire_cli`)
4. Projeto Firebase criado (rollflix-6640f)

## 🚀 Passo a Passo para Configuração

### 1️⃣ Instale o FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Certifique-se de que o FlutterFire CLI está no seu PATH.

### 2️⃣ Faça Login no Firebase

```bash
firebase login
```

Ou, se estiver usando o FlutterFire CLI:

```bash
flutterfire configure
```

### 3️⃣ Configure o Projeto

Execute o comando de configuração na raiz do projeto:

```bash
flutterfire configure
```

Este comando irá:
1. Listar seus projetos Firebase
2. Permitir selecionar ou criar um projeto
3. Selecionar as plataformas (Android, iOS, Web, etc.)
4. **Gerar automaticamente o arquivo `lib/firebase_options.dart`**

**Selecione o projeto:** `rollflix-6640f`

**Selecione as plataformas:**
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows

### 4️⃣ Adicione Restrições nas API Keys (CRÍTICO)

Após gerar o `firebase_options.dart`, você **DEVE** adicionar restrições nas API Keys no Google Cloud Console:

**Acesse:** https://console.cloud.google.com/apis/credentials?project=rollflix-6640f

Para cada API Key gerada:

#### 📱 Android API Key
```
Application restrictions:
  → Android apps
  
Package name: com.gipsy7.rollflix
SHA-1: [Obtenha com: cd android && ./gradlew signingReport]

API restrictions:
  → Restrict key
  → Cloud Firestore API
  → Firebase Installations API
  → Identity Toolkit API
  → Token Service API
```

#### 🍎 iOS API Key
```
Application restrictions:
  → iOS apps
  
Bundle ID: com.example.testeapp

API restrictions:
  → Restrict key
  → Cloud Firestore API
  → Firebase Installations API
  → Identity Toolkit API
  → Token Service API
```

#### 🌐 Web API Key
```
Application restrictions:
  → HTTP referrers (websites)
  
Authorized referrers:
  → https://rollflix-6640f.web.app/*
  → https://rollflix-6640f.firebaseapp.com/*
  → http://localhost:*

API restrictions:
  → Restrict key
  → Cloud Firestore API
  → Firebase Installations API
  → Identity Toolkit API
  → Token Service API
```

### 5️⃣ Configure os Arquivos de Configuração Nativos

#### Android (`android/app/google-services.json`)

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto `rollflix-6640f`
3. Vá em **Project Settings** (ícone de engrenagem)
4. Na aba **General**, role até **Your apps**
5. Selecione o app Android
6. Clique em **Download google-services.json**
7. Coloque o arquivo em: `android/app/google-services.json`

**Importante:** Este arquivo também está no `.gitignore` e NÃO deve ser commitado.

#### iOS (`ios/Runner/GoogleService-Info.plist`)

1. No mesmo local do Firebase Console
2. Selecione o app iOS
3. Clique em **Download GoogleService-Info.plist**
4. Coloque o arquivo em: `ios/Runner/GoogleService-Info.plist`

**Importante:** Este arquivo também está no `.gitignore` e NÃO deve ser commitado.

### 6️⃣ Verifique a Configuração

Execute o app e teste as funcionalidades do Firebase:

```bash
flutter run
```

Teste:
- ✅ Login com Google funciona
- ✅ Firestore lê/escreve dados
- ✅ Notificações push funcionam
- ✅ Sincronização entre dispositivos

## 📁 Estrutura de Arquivos Firebase

Após a configuração, você deve ter:

```
lib/
  └── firebase_options.dart          # ⚠️ NÃO COMMITAR (no .gitignore)

android/
  └── app/
      └── google-services.json       # ⚠️ NÃO COMMITAR (no .gitignore)

ios/
  └── Runner/
      └── GoogleService-Info.plist   # ⚠️ NÃO COMMITAR (no .gitignore)
```

## 🔒 Segurança

### ❌ O que NÃO commitar:
- `lib/firebase_options.dart` (contém API keys)
- `android/app/google-services.json` (contém configurações sensíveis)
- `ios/Runner/GoogleService-Info.plist` (contém configurações sensíveis)

### ✅ O que commitar:
- `lib/firebase_options.dart.example` (template sem keys)
- Documentação de setup
- Código da aplicação

## 📝 Arquivo de Exemplo

Criamos um arquivo `lib/firebase_options.dart.example` que serve como template. Para usar:

1. Copie o exemplo:
   ```bash
   cp lib/firebase_options.dart.example lib/firebase_options.dart
   ```

2. Execute o FlutterFire CLI para popular com suas keys:
   ```bash
   flutterfire configure
   ```

## 🔧 Configuração de CI/CD

Para builds automatizados, use Firebase Secrets no GitHub Actions:

```yaml
- name: Configure Firebase
  env:
    FIREBASE_OPTIONS: ${{ secrets.FIREBASE_OPTIONS_DART }}
  run: echo "$FIREBASE_OPTIONS" > lib/firebase_options.dart
```

## ❓ Troubleshooting

### Erro: "No Firebase App has been created"
**Solução:** Certifique-se de que chamou `await Firebase.initializeApp()` no `main.dart`

### Erro: "API key not valid"
**Solução:** Verifique se adicionou as restrições corretas no Google Cloud Console

### Erro: "SHA-1 fingerprint mismatch" (Android)
**Solução:** 
1. Execute: `cd android && ./gradlew signingReport`
2. Copie o SHA-1 do certificado correto (debug ou release)
3. Adicione no Firebase Console e no Google Cloud Console

### Firebase CLI não encontrado
**Solução:**
```bash
npm install -g firebase-tools
firebase login
```

## 📚 Referências

- [FlutterFire CLI Documentation](https://firebase.flutter.dev/docs/cli/)
- [Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)
- [API Key Best Practices](https://firebase.google.com/docs/projects/api-keys)
- [Google Cloud - API Restrictions](https://cloud.google.com/docs/authentication/api-keys#adding_restrictions)

## 🎯 Checklist de Configuração

Marque cada item ao completar:

- [ ] FlutterFire CLI instalado
- [ ] Executado `flutterfire configure`
- [ ] `firebase_options.dart` gerado
- [ ] Restrições adicionadas nas API Keys (Google Cloud Console)
- [ ] `google-services.json` baixado e colocado em `android/app/`
- [ ] `GoogleService-Info.plist` baixado e colocado em `ios/Runner/`
- [ ] Arquivos adicionados ao `.gitignore`
- [ ] App testado em todas as plataformas
- [ ] Login com Google funcionando
- [ ] Firestore lendo/escrevendo dados
- [ ] Notificações push testadas

**Quando todos os itens estiverem marcados, sua configuração está completa! 🎉**
