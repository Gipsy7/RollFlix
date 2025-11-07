# 🔐 Guia de Configuração Segura - Rollflix

## 📋 Visão Geral

Este documento explica como configurar as chaves de API de forma segura para desenvolvimento e produção.

---

## 🔑 Chaves de API Necessárias

### 1. **TMDb API Key**
- **Onde obter**: https://www.themoviedb.org/settings/api
- **Uso**: Buscar informações de filmes e séries
- **Ambiente**: `TMDB_API_KEY`

### 2. **RevenueCat API Key**
- **Onde obter**: https://app.revenuecat.com/settings/api-keys
- **Uso**: Gerenciar assinaturas in-app
- **Ambiente**: `REVENUECAT_API_KEY`

### 3. **AdMob IDs**
- **Onde obter**: https://admob.google.com/
- **Uso**: Exibir anúncios recompensados
- **Ambientes**:
  - `ADMOB_ANDROID_APP_ID`
  - `ADMOB_IOS_APP_ID`
  - `ADMOB_ANDROID_REWARDED_ID`
  - `ADMOB_IOS_REWARDED_ID`

---

## 🛠️ Configuração para Desenvolvimento

### Opção 1: Via Linha de Comando (Recomendado)

```bash
# Executar app com todas as chaves
flutter run \
  --dart-define=TMDB_API_KEY=sua_chave_tmdb \
  --dart-define=REVENUECAT_API_KEY=sua_chave_revenuecat \
  --dart-define=ADMOB_ANDROID_APP_ID=ca-app-pub-xxx \
  --dart-define=ADMOB_ANDROID_REWARDED_ID=ca-app-pub-xxx/rewarded
```

### Opção 2: Via IDE (VS Code)

Crie `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Rollflix (Development)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=TMDB_API_KEY=sua_chave_tmdb",
        "--dart-define=REVENUECAT_API_KEY=sua_chave_revenuecat",
        "--dart-define=ADMOB_ANDROID_APP_ID=ca-app-pub-xxx",
        "--dart-define=ADMOB_ANDROID_REWARDED_ID=ca-app-pub-xxx/rewarded"
      ]
    }
  ]
}
```

### Opção 3: Via Arquivo .env (NÃO COMMITAR)

1. Crie arquivo `.env` na raiz do projeto:

```env
TMDB_API_KEY=sua_chave_tmdb
REVENUECAT_API_KEY=sua_chave_revenuecat
ADMOB_ANDROID_APP_ID=ca-app-pub-xxx
ADMOB_ANDROID_REWARDED_ID=ca-app-pub-xxx/rewarded
```

2. Adicione ao `.gitignore`:

```
.env
```

3. Use script para carregar (PowerShell):

```powershell
# build_with_env.ps1
Get-Content .env | ForEach-Object {
    if ($_ -match '^(.+?)=(.+)$') {
        $key = $matches[1]
        $value = $matches[2]
        $args += "--dart-define=$key=$value"
    }
}

flutter run $args
```

---

## 🏭 Configuração para Produção

### CI/CD (GitHub Actions)

1. **Adicionar Secrets no GitHub**:
   - Vá em: `Settings` → `Secrets and variables` → `Actions`
   - Adicione:
     - `TMDB_API_KEY`
     - `REVENUECAT_API_KEY`
     - `ADMOB_ANDROID_APP_ID`
     - `ADMOB_ANDROID_REWARDED_ID`
     - etc.

2. **Configurar Workflow** (`.github/workflows/build.yml`):

```yaml
name: Build Release APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build APK
        env:
          TMDB_API_KEY: ${{ secrets.TMDB_API_KEY }}
          REVENUECAT_API_KEY: ${{ secrets.REVENUECAT_API_KEY }}
          ADMOB_ANDROID_APP_ID: ${{ secrets.ADMOB_ANDROID_APP_ID }}
          ADMOB_ANDROID_REWARDED_ID: ${{ secrets.ADMOB_ANDROID_REWARDED_ID }}
        run: |
          flutter build apk --release \
            --dart-define=TMDB_API_KEY=$TMDB_API_KEY \
            --dart-define=REVENUECAT_API_KEY=$REVENUECAT_API_KEY \
            --dart-define=ADMOB_ANDROID_APP_ID=$ADMOB_ANDROID_APP_ID \
            --dart-define=ADMOB_ANDROID_REWARDED_ID=$ADMOB_ANDROID_REWARDED_ID
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

### Build Manual para Release

#### Android APK:

```bash
flutter build apk --release \
  --dart-define=TMDB_API_KEY=sua_chave_tmdb \
  --dart-define=REVENUECAT_API_KEY=sua_chave_revenuecat \
  --dart-define=ADMOB_ANDROID_APP_ID=ca-app-pub-xxx \
  --dart-define=ADMOB_ANDROID_REWARDED_ID=ca-app-pub-xxx/rewarded
```

#### Android App Bundle (Play Store):

```bash
flutter build appbundle --release \
  --dart-define=TMDB_API_KEY=sua_chave_tmdb \
  --dart-define=REVENUECAT_API_KEY=sua_chave_revenuecat \
  --dart-define=ADMOB_ANDROID_APP_ID=ca-app-pub-xxx \
  --dart-define=ADMOB_ANDROID_REWARDED_ID=ca-app-pub-xxx/rewarded
```

#### iOS (Xcode):

```bash
flutter build ios --release \
  --dart-define=TMDB_API_KEY=sua_chave_tmdb \
  --dart-define=REVENUECAT_API_KEY=sua_chave_revenuecat \
  --dart-define=ADMOB_IOS_APP_ID=ca-app-pub-xxx \
  --dart-define=ADMOB_IOS_REWARDED_ID=ca-app-pub-xxx/rewarded
```

---

## 🧪 Verificação de Configuração

### Executar Validação

O app valida automaticamente no startup. Você verá no console:

```
✅ SecureConfig carregada:
  TMDb API: ✅ Configurada
  AdMob Android: ✅ Configurada
  AdMob iOS: ✅ Configurada

✅ RevenueCatConfig carregada:
  API Key: ✅ Configurada
  Monthly Product: rollflix_monthly
  Annual Product: rollflix_annual
  Premium Entitlement: premium
```

### Erros Comuns

#### ❌ Erro: "TMDB_API_KEY não configurada"

**Causa**: Chave não foi fornecida via `--dart-define`

**Solução**:
```bash
flutter run --dart-define=TMDB_API_KEY=sua_chave_aqui
```

#### ❌ Erro: "REVENUECAT_API_KEY usando chave de desenvolvimento"

**Causa**: Em modo release, ainda está usando o defaultValue

**Solução**:
```bash
flutter build apk --release --dart-define=REVENUECAT_API_KEY=sua_chave_producao
```

---

## 🔒 Boas Práticas de Segurança

### ✅ **FAÇA**:
1. ✅ Use `--dart-define` para todas as builds de produção
2. ✅ Adicione `.env` ao `.gitignore`
3. ✅ Use GitHub Secrets para CI/CD
4. ✅ Rotacione chaves comprometidas imediatamente
5. ✅ Use chaves diferentes para desenvolvimento e produção
6. ✅ Revise regularmente acessos às chaves

### ❌ **NÃO FAÇA**:
1. ❌ Commitar chaves no código
2. ❌ Compartilhar chaves via chat/email
3. ❌ Usar mesma chave para dev e prod
4. ❌ Expor chaves em logs públicos
5. ❌ Deixar chaves em screenshots
6. ❌ Hardcodar chaves no código-fonte

---

## 📚 Referências

- **Flutter Environment Variables**: https://dart.dev/guides/environment-declarations
- **TMDb API Docs**: https://developers.themoviedb.org/3
- **RevenueCat Docs**: https://www.revenuecat.com/docs
- **AdMob Setup**: https://developers.google.com/admob/flutter/quick-start
- **GitHub Secrets**: https://docs.github.com/en/actions/security-guides/encrypted-secrets

---

## 🆘 Suporte

Se encontrar problemas:
1. Verifique se todas as chaves estão configuradas
2. Execute `flutter clean && flutter pub get`
3. Verifique os logs de validação no console
4. Consulte a documentação oficial dos serviços

---

**Última atualização**: Novembro 2025
