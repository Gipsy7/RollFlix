# Configuração da Splash Screen - RollFlix

## 📱 O que foi implementado

Foi configurada uma **splash screen** (tela inicial) que aparece quando o aplicativo é aberto, exibindo a logo do RollFlix.

## 🎨 Características

- **Imagem**: Logo do RollFlix (app_icon.png)
- **Cor de fundo**: Preto (#000000)
- **Suporte**: Android e iOS
- **Modo escuro**: Configurado com as mesmas cores
- **Android 12+**: Otimizado para o novo sistema de splash screen

## 📦 Pacotes utilizados

### flutter_native_splash: ^2.4.0
Pacote responsável por gerar automaticamente a splash screen nativa para Android e iOS.

### flutter_launcher_icons: ^0.13.1
Pacote responsável por gerar os ícones do aplicativo em todas as resoluções necessárias.

## ⚙️ Configuração (pubspec.yaml)

```yaml
flutter_native_splash:
  color: "#000000"
  image: assets/images/app_icon.png
  color_dark: "#000000"
  image_dark: assets/images/app_icon.png
  android_12:
    image: assets/images/app_icon.png
    color: "#000000"
  web: false

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#000000"
  adaptive_icon_foreground: "assets/images/app_icon.png"
  remove_alpha_ios: true
```

## 📁 Arquivos gerados

### Android
- `android/app/src/main/res/drawable*/launch_background.xml`
- `android/app/src/main/res/values*/styles.xml`
- `android/app/src/main/res/mipmap-*/ic_launcher.png` (ícones)

### iOS
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (ícones)
- `ios/Runner/Info.plist` (atualizado)

## 🚀 Como funciona

1. **Ao abrir o app**: A splash screen com o logo RollFlix aparece em fundo preto
2. **Durante o carregamento**: A tela permanece visível enquanto o Flutter inicializa
3. **Após inicialização**: Transição suave para a tela inicial do app

## 📱 Compatibilidade

- ✅ Android 5.0+ (API 21+)
- ✅ Android 12+ (com otimizações específicas)
- ✅ iOS 12+
- ✅ Modo claro e escuro

## 🎯 Benefícios

1. **Profissionalismo**: Apresentação da marca desde o primeiro momento
2. **Experiência nativa**: Splash screen nativa (não é uma tela Flutter)
3. **Performance**: Carrega instantaneamente, sem atrasos
4. **Consistência**: Mesma experiência em todos os dispositivos

## 🔄 Para atualizar a imagem

Se você quiser alterar a splash screen futuramente:

1. Substitua a imagem em `assets/images/app_icon.png`
2. Execute: `flutter pub run flutter_native_splash:create`
3. Execute: `flutter pub run flutter_launcher_icons` (se também quiser atualizar o ícone)

## ✅ Status

- [x] Pacotes instalados
- [x] Configuração adicionada ao pubspec.yaml
- [x] Splash screen gerada para Android
- [x] Splash screen gerada para iOS
- [x] Ícones do app gerados
- [x] Suporte ao modo escuro
- [x] Android 12+ otimizado

---

**Data de implementação**: 10 de outubro de 2025
**Versão do app**: 4.0.0
