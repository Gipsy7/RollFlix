# 🔐 Configuração de Autenticação Firebase - RollFlix

## ⚠️ IMPORTANTE: Configuração Necessária

Para que o sistema de autenticação funcione, você precisa configurar o Firebase em seu projeto. Siga os passos abaixo:

---

## 📋 Passo 1: Criar Projeto no Firebase ✅ CONCLUÍDO

1. ✅ Projeto Firebase criado: **rollflix-6640f**
2. ✅ Apps registrados em todas as plataformas (Android, iOS, macOS, Web, Windows)
3. ✅ Arquivo `firebase_options.dart` gerado automaticamente

---

## 🔧 Passo 2: Configurar Firebase no Flutter ✅ CONCLUÍDO

### **Todas as Plataformas** ✅

O FlutterFire CLI configurou automaticamente:
- ✅ Android app: `com.rollflix.app`
- ✅ iOS app: `com.example.testeapp` (Bundle ID do Xcode)
- ✅ macOS app: `com.example.testeapp`
- ✅ Web app: rollflix (web)
- ✅ Windows app: rollflix (windows)

**Arquivo gerado**: `lib/firebase_options.dart`

### ~~**Android**~~ (Não é mais necessário com FlutterFire CLI)

~~1. No Firebase Console, adicione um app Android~~
~~2. Package name: `com.rollflix.app` (ou seu package name do `android/app/build.gradle.kts`)~~
~~3. Baixe o arquivo `google-services.json`~~
~~4. Coloque o arquivo em: `android/app/google-services.json`~~

### **iOS**

1. No Firebase Console, adicione um app iOS
2. Bundle ID: `com.example.testeapp` (ou seu bundle ID do Xcode)
3. Baixe o arquivo `GoogleService-Info.plist`
4. Coloque o arquivo em: `ios/Runner/GoogleService-Info.plist`

### **Web**

1. No Firebase Console, adicione um app Web
2. Copie a configuração do Firebase
3. Cole em: `web/index.html` (antes do `</body>`)

```html
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-auth.js"></script>
<script>
  const firebaseConfig = {
    apiKey: "SUA_API_KEY",
    authDomain: "seu-projeto.firebaseapp.com",
    projectId: "seu-projeto-id",
    storageBucket: "seu-projeto.appspot.com",
    messagingSenderId: "123456789",
    appId: "1:123456789:web:abcdef"
  };
  firebase.initializeApp(firebaseConfig);
</script>
```

---

## 🔑 Passo 3: Ativar Métodos de Autenticação no Firebase ⚠️ PENDENTE

**IMPORTANTE**: Você precisa ativar manualmente no Firebase Console:

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto **rollflix-6640f**
3. Vá em **Authentication** → **Sign-in method**
4. Ative os seguintes provedores:

### **Google Sign-In** ⚠️ REQUER CONFIGURAÇÃO
- Clique em "Google"
- Ative o provedor
- Configure o email de suporte do projeto: seu-email@gmail.com
- Salve

### **Facebook Login** ⚠️ REQUER CONFIGURAÇÃO
- Clique em "Facebook"
- Ative o provedor
- Você precisará de:
  - **App ID** do Facebook
  - **App Secret** do Facebook

#### Como obter credenciais do Facebook:

1. Acesse [Facebook Developers](https://developers.facebook.com/)
2. Crie um novo app ou use um existente
3. Adicione o produto "Facebook Login"
4. Copie o **App ID** e **App Secret**
5. Cole no Firebase Console
6. Configure o **OAuth redirect URI** (fornecido pelo Firebase)

---

## 🛠️ Passo 4: Configurar Google Sign-In

### **Android**

1. Obtenha o SHA-1 do seu app:
```bash
cd android
./gradlew signingReport
```

2. Copie o SHA-1 fingerprint
3. No Firebase Console, adicione o SHA-1 em:
   - **Project Settings** → **Your apps** → **Android app** → **Add fingerprint**

### **iOS**

1. Abra `ios/Runner.xcworkspace` no Xcode
2. Adicione o **URL Scheme** do GoogleService-Info.plist:
   - Targets → Runner → Info → URL Types
   - Adicione um novo URL Type
   - URL Schemes: `REVERSED_CLIENT_ID` (do GoogleService-Info.plist)

### **Web**

1. No Firebase Console, adicione os domínios autorizados:
   - **Authentication** → **Settings** → **Authorized domains**
   - Adicione: `localhost` e seu domínio de produção

---

## 📱 Passo 5: Configurar Facebook Login

### **Android**

1. Edite `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <!-- Adicione antes de </application> -->
    <meta-data 
        android:name="com.facebook.sdk.ApplicationId" 
        android:value="@string/facebook_app_id"/>
    
    <meta-data 
        android:name="com.facebook.sdk.ClientToken" 
        android:value="@string/facebook_client_token"/>
    
    <activity 
        android:name="com.facebook.FacebookActivity"
        android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
        android:label="@string/app_name" />
</application>
```

2. Crie `android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">RollFlix</string>
    <string name="facebook_app_id">SEU_FACEBOOK_APP_ID</string>
    <string name="facebook_client_token">SEU_FACEBOOK_CLIENT_TOKEN</string>
</resources>
```

### **iOS**

1. Edite `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbSEU_FACEBOOK_APP_ID</string>
    </array>
  </dict>
</array>

<key>FacebookAppID</key>
<string>SEU_FACEBOOK_APP_ID</string>

<key>FacebookClientToken</key>
<string>SEU_FACEBOOK_CLIENT_TOKEN</string>

<key>FacebookDisplayName</key>
<string>RollFlix</string>

<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-share-api</string>
</array>
```

---

## 🚀 Passo 6: Inicializar Firebase no App ✅ CONCLUÍDO

O arquivo `main.dart` foi atualizado para inicializar o Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

✅ Firebase inicializado em todas as plataformas!

---

## ✅ Passo 7: Testar a Autenticação

1. Execute o app: `flutter run`
2. Tente fazer login com Google
3. Tente fazer login com Facebook
4. Verifique no Firebase Console se os usuários aparecem em **Authentication** → **Users**

---

## 🔍 Troubleshooting

### **Erro: "google-services.json not found"**
- Certifique-se de que o arquivo está em `android/app/google-services.json`
- Verifique se o `package name` está correto

### **Erro: "SHA-1 fingerprint not found"**
- Execute `./gradlew signingReport` novamente
- Adicione o SHA-1 no Firebase Console

### **Erro de Facebook: "Invalid hash key"**
- Gere o hash correto:
```bash
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
```
- Adicione no Facebook Developers

### **Erro: "FirebaseApp not initialized"**
- Certifique-se de que `await Firebase.initializeApp()` é chamado antes de `runApp()`

---

## 📚 Documentação Oficial

- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Google Sign-In](https://pub.dev/packages/google_sign_in)
- [Facebook Login](https://pub.dev/packages/flutter_facebook_auth)
- [Firebase Authentication](https://firebase.google.com/docs/auth)

---

## 🎯 Próximos Passos

Após configurar a autenticação, você pode:

1. ✅ Sincronizar favoritos na nuvem (Firestore)
2. ✅ Salvar preferências do usuário
3. ✅ Implementar watchlist compartilhada
4. ✅ Analytics de uso do app
5. ✅ Notificações push

---

**NOTA**: Por questões de segurança, **NUNCA** faça commit dos arquivos:
- `google-services.json`
- `GoogleService-Info.plist`
- Chaves de API no código

Adicione-os ao `.gitignore`:
```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```
