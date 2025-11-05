# 🚀 Guia Rápido de Build Release

## Como compilar APK/AAB assinado com todas as configurações

### Pré-requisitos
- [x] Arquivo `.env` configurado na raiz do projeto
- [x] Arquivo `android/key.properties` com informações do keystore
- [x] Keystore (`.jks`) criado e acessível

### Comando Rápido

```powershell
# Build App Bundle (recomendado para Play Store)
.\build-release.ps1 -BuildType appbundle

# Build APK (para testes locais)
.\build-release.ps1 -BuildType apk

# Com clean antes do build
.\build-release.ps1 -BuildType appbundle -Clean
```

### O que o script faz automaticamente:

1. ✅ Lê todas as variáveis do arquivo `.env`
2. ✅ Valida se as variáveis obrigatórias existem
3. ✅ Verifica se o keystore está configurado
4. ✅ Gera um VERSION_CODE único (baseado em timestamp)
5. ✅ Passa todas as variáveis via `--dart-define`
6. ✅ Compila o build assinado com seu keystore
7. ✅ Mostra o tamanho e localização do arquivo final

### Arquivos gerados:

**App Bundle (AAB):**
```
build\app\outputs\bundle\release\app-release.aab
```

**APK:**
```
build\app\outputs\flutter-apk\app-release.apk
```

### Variáveis obrigatórias no .env:

```properties
TMDB_API_KEY=sua_chave_tmdb
ADMOB_ANDROID_APP_ID=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
ADMOB_ANDROID_REWARDED_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
```

### Troubleshooting:

**Erro: "Arquivo .env não encontrado"**
- Crie o arquivo `.env` na raiz do projeto
- Copie o `.env.example` como base

**Erro: "key.properties não encontrado"**
- Verifique se existe `android/key.properties`
- Deve conter: storeFile, storePassword, keyAlias, keyPassword

**Erro: "VERSION_CODE já usado"**
- O script gera automaticamente um código único
- Se ainda der erro, aguarde 1 minuto e tente novamente

**Erro de login Google no AAB:**
- Adicione o SHA-1 do Play App Signing no Firebase
- Play Console → Setup → App Integrity → copie SHA-1
- Firebase → Project Settings → Add fingerprint

### Verificar assinatura do APK/AAB:

```powershell
# Windows (use o apksigner do Android SDK)
& "C:\Users\SeuUsuario\AppData\Local\Android\Sdk\build-tools\34.0.0\apksigner.bat" verify --print-certs build\app\outputs\bundle\release\app-release.aab
```

### Upload para Play Store:

1. Vá em Play Console → seu app
2. Release → Production (ou Testing)
3. Create new release
4. Upload o arquivo `app-release.aab`
5. Complete release notes e publique

---

**💡 Dica:** Sempre teste o AAB via Internal Testing antes de publicar em produção!
