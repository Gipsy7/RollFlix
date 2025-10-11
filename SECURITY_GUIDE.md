# 🔐 Guia de Segurança - RollFlix

## ⚠️ IMPORTANTE: Configuração de Chaves Sensíveis

Este documento explica como configurar adequadamente as chaves de API e credenciais sem expor informações sensíveis no código.

---

## 📋 **Checklist de Segurança**

Antes de fazer commit ou deploy:

- [ ] Arquivo `.env` está no `.gitignore`
- [ ] Chaves de API não estão hardcoded no código
- [ ] `.env.example` não contém chaves reais
- [ ] Firebase google-services.json está no .gitignore
- [ ] Documentação de setup está atualizada

---

## 🚀 **Setup Inicial (Para Novos Desenvolvedores)**

### 1. Clone o Repositório
```bash
git clone <repo-url>
cd testeapp
```

### 2. Copie o Arquivo de Exemplo
```bash
cp .env.example .env
```

### 3. Obtenha Suas Chaves

#### **TMDb API**
1. Acesse: https://www.themoviedb.org/settings/api
2. Crie uma conta (grátis)
3. Solicite uma API Key
4. Copie a chave e cole no `.env`:
```env
TMDB_API_KEY=sua_chave_real_aqui
```

#### **Firebase**
1. Acesse: https://console.firebase.google.com
2. Crie um novo projeto ou use existente
3. Adicione apps para Web, Android e iOS
4. Baixe os arquivos de configuração:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
5. Copie as chaves para o `.env`

#### **AdMob** (Opcional)
1. Acesse: https://admob.google.com
2. Crie uma conta
3. Crie unidades de anúncio
4. Copie os IDs para o `.env`

### 4. Instale Dependências
```bash
flutter pub get
```

### 5. Execute o App
```bash
flutter run
```

---

## 🛡️ **Práticas de Segurança**

### ❌ **NUNCA Faça Isso:**
```dart
// ❌ NÃO hardcode chaves no código
class AppConstants {
  static const String apiKey = 'xxxx';
}
```

### ✅ **SEMPRE Faça Isso:**
```dart
// ✅ Use variáveis de ambiente
class AppConstants {
  static const String apiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'YOUR_API_KEY_HERE', // Para desenvolvimento
  );
}
```

---

## 📦 **Build de Produção**

### Android
```bash
flutter build apk --release \
  --dart-define=TMDB_API_KEY=sua_chave_real
```

### iOS
```bash
flutter build ios --release \
  --dart-define=TMDB_API_KEY=sua_chave_real
```

### Web
```bash
flutter build web --release \
  --dart-define=TMDB_API_KEY=sua_chave_real
```

---

## 🔒 **Obfuscação de Código (Produção)**

Para proteger ainda mais suas chaves em produção:

```bash
flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols \
  --dart-define=TMDB_API_KEY=sua_chave_real
```

---

## 📝 **.gitignore Recomendado**

Adicione ao seu `.gitignore`:
```gitignore
# Chaves sensíveis
.env
*.env

# Firebase
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
firebase-debug.log

# Build
build/
*.apk
*.ipa

# IDE
.idea/
.vscode/
*.iml
```

---

## 🚨 **O Que Fazer Se Você Commitar uma Chave**

Se você acidentalmente commitar uma chave de API:

1. **Revogue a chave imediatamente** no serviço (TMDb/Firebase/AdMob)
2. **Gere uma nova chave**
3. **Remova o commit do histórico**:
```bash
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/file" \
  --prune-empty --tag-name-filter cat -- --all
```
4. **Force push** (cuidado!):
```bash
git push origin --force --all
```

---

## 📚 **Recursos Adicionais**

- [TMDb API Documentation](https://developers.themoviedb.org/3)
- [Firebase Security Best Practices](https://firebase.google.com/docs/rules/best-practices)
- [Flutter Obfuscation](https://docs.flutter.dev/deployment/obfuscate)
- [Git Secrets Prevention](https://git-secret.io/)

---

## 🆘 **Precisa de Ajuda?**

Se encontrar problemas de configuração:
1. Verifique se o `.env` existe e está preenchido
2. Confirme que as chaves estão corretas
3. Revise os logs de erro do Flutter
4. Consulte a documentação oficial de cada serviço

**⚡ Mantenha suas chaves seguras!**
