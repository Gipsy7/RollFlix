# ⚠️ ATENÇÃO: Configuração Firebase Necessária

## 🔐 Sistema de Autenticação Implementado

O sistema de login com **Google** e **Facebook** foi implementado no RollFlix, mas **requer configuração manual do Firebase** para funcionar.

---

## 📋 O que foi implementado:

✅ **Serviço de Autenticação** (`lib/services/auth_service.dart`)
- Login com Google
- Login com Facebook
- Logout
- Gerenciamento de sessão
- Verificação de usuário logado

✅ **Tela de Login** (`lib/screens/login_screen.dart`)
- Interface moderna com botões de login social
- Opção de continuar sem login
- Feedback visual de erros

✅ **Tela de Perfil** (`lib/screens/profile_screen.dart`)
- Informações do usuário (nome, email, foto)
- Provedor de autenticação (Google/Facebook)
- Estatísticas (preparado para futuras implementações)
- Botão de logout

✅ **Integração no Menu**
- Opção "Entrar" ou "Meu Perfil" no drawer
- Navegação automática baseada no estado de login

---

## 🚨 PARA USAR ESTA FUNCIONALIDADE:

### **Você DEVE configurar o Firebase seguindo as instruções em:**

📄 **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)**

---

## 📦 Pacotes Instalados:

```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
google_sign_in: ^6.1.6
flutter_facebook_auth: ^6.0.4
```

---

## 🎯 Passos Resumidos:

1. **Criar projeto no Firebase Console**
2. **Adicionar apps (Android/iOS/Web)**
3. **Baixar e configurar arquivos**:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
   - Firebase config (Web)
4. **Ativar Google Sign-In e Facebook Login no Firebase**
5. **Configurar SHA-1 (Android) e URL Schemes (iOS)**
6. **Criar app no Facebook Developers**
7. **Configurar OAuth redirect URIs**
8. **Inicializar Firebase no `main.dart`**

---

## ⚙️ Inicialização no main.dart:

Adicione ao início do seu `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}
```

---

## 🔒 Segurança:

**IMPORTANTE**: Nunca faça commit dos seguintes arquivos:

```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

Adicione-os ao `.gitignore`:

```gitignore
# Firebase
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

---

## 🎨 Como Funciona:

### **1. Fluxo de Login:**
1. Usuário clica em "Continuar com Google" ou "Continuar com Facebook"
2. Abre o fluxo de autenticação nativo (Google/Facebook)
3. Usuário autoriza o app
4. Firebase autentica e retorna o usuário
5. App salva a sessão
6. Redireciona para a tela principal

### **2. Tela de Perfil:**
- Mostra avatar do usuário
- Nome e email
- Provedor de login (Google/Facebook)
- ID do usuário
- Botão de logout

### **3. Estado de Autenticação:**
- O app detecta automaticamente se o usuário está logado
- Menu mostra "Entrar" ou "Meu Perfil" dinamicamente
- Usuários podem continuar sem login (modo guest)

---

## 🚀 Próximas Funcionalidades (Futuras):

Com a autenticação configurada, será possível:

- ☁️ **Sincronizar favoritos na nuvem** (Firestore)
- 📊 **Salvar estatísticas de uso**
- 🔔 **Notificações personalizadas**
- 👥 **Listas compartilhadas**
- 🎯 **Recomendações baseadas em histórico**

---

## 🆘 Precisa de Ajuda?

Se tiver dúvidas sobre a configuração do Firebase:

1. Consulte o **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** para instruções detalhadas
2. Acesse a [documentação oficial do Firebase](https://firebase.google.com/docs/flutter/setup)
3. Veja os [exemplos de autenticação](https://firebase.google.com/docs/auth/flutter/start)

---

## ✅ Checklist de Configuração:

- [ ] Projeto Firebase criado
- [ ] App Android adicionado no Firebase
- [ ] App iOS adicionado no Firebase
- [ ] App Web adicionado no Firebase
- [ ] `google-services.json` baixado e colocado em `android/app/`
- [ ] `GoogleService-Info.plist` baixado e colocado em `ios/Runner/`
- [ ] Google Sign-In ativado no Firebase Console
- [ ] Facebook Login ativado no Firebase Console
- [ ] App criado no Facebook Developers
- [ ] SHA-1 configurado (Android)
- [ ] URL Schemes configurados (iOS)
- [ ] Firebase inicializado no `main.dart`
- [ ] Testado login com Google
- [ ] Testado login com Facebook

---

**🎬 RollFlix - Roll and Chill**

Sistema de autenticação implementado e pronto para uso após configuração do Firebase! 🚀
