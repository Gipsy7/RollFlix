# 🎬 Integração AdMob - Rollflix

## ✅ Implementação Completa

A integração do Google AdMob foi implementada com sucesso no aplicativo Rollflix. Agora, quando os usuários esgotarem seus recursos (rolagens, favoritos ou assistidos), eles podem assistir a anúncios recompensados para ganhar recursos extras.

## 📋 Arquivos Criados/Modificados

### Novos Arquivos

1. **`lib/config/admob_config.dart`**
   - Configuração centralizada dos IDs do AdMob
   - IDs de teste pré-configurados
   - Documentação sobre como obter IDs de produção

2. **`lib/services/ad_service.dart`**
   - Serviço singleton para gerenciar anúncios
   - Carregamento e exibição de anúncios recompensados
   - Sistema de retry automático em caso de falha
   - Callbacks para recompensas

### Arquivos Modificados

1. **`pubspec.yaml`**
   - Adicionada dependência: `google_mobile_ads: ^5.1.0`

2. **`lib/main.dart`**
   - Inicialização do AdMob no startup
   - Atualizada rolagem para usar `tryUseResourceWithAd()`

3. **`lib/controllers/user_preferences_controller.dart`**
   - Novo método: `tryUseResourceWithAd()` - tenta usar recurso ou oferece anúncio
   - Diálogo customizado oferecendo anúncios
   - Sistema de recompensas após assistir anúncios
   - Integração com AdService

4. **`lib/screens/movie_details_screen.dart`**
   - Atualizado botão de "Favorito" para usar anúncios
   - Atualizado botão de "Assistido" para usar anúncios

5. **`lib/screens/tv_show_details_screen.dart`**
   - Atualizado botão de "Favorito" para usar anúncios
   - Atualizado botão de "Assistido" para usar anúncios

6. **`android/app/src/main/AndroidManifest.xml`**
   - Adicionado App ID do AdMob
   - Configuração necessária para Android

7. **`ios/Runner/Info.plist`**
   - Adicionado App ID do AdMob
   - Permissão de rastreamento (ATT) para iOS 14+
   - Descrição amigável ao usuário

## 🎯 Como Funciona

### Fluxo do Usuário

1. **Usuário tenta usar recurso** (rolar, favoritar, marcar assistido)
2. **Sistema verifica disponibilidade**:
   - ✅ Tem recurso → Consome normalmente
   - ❌ Sem recurso → Mostra diálogo oferecendo anúncio

3. **Diálogo de Oferta**:
   - Informa quanto tempo falta para recarga automática
   - Oferece assistir anúncio para ganhar +1 recurso imediatamente
   - Usuário pode aceitar ou cancelar

4. **Se aceitar**:
   - Loading aparece enquanto carrega anúncio
   - Anúncio é exibido em tela cheia
   - Usuário DEVE assistir completamente
   - Após assistir: ganha +1 recurso extra
   - Pode usar a funcionalidade imediatamente

5. **Feedback**:
   - SnackBar confirmando recompensa recebida
   - Recurso disponível para uso

### Tipos de Anúncios

- **Tipo**: Anúncios Recompensados (Rewarded Ads)
- **Duração**: 15-30 segundos (típico)
- **Frequência**: Sob demanda (quando usuário quer)
- **Recompensa**: +1 recurso específico

### Recursos que Usam Anúncios

1. **Rolagens** - Sortear filmes/séries
2. **Favoritos** - Adicionar aos favoritos
3. **Assistidos** - Marcar como assistido

## 🔧 Configuração para Produção

### ⚠️ IMPORTANTE: IDs de Teste Atuais

Os IDs configurados são **IDs DE TESTE** do Google. Eles funcionam apenas em modo de desenvolvimento.

### 📝 Passos para Produção

#### 1. Criar Conta no AdMob

1. Acesse: https://admob.google.com
2. Faça login com sua conta Google
3. Aceite os termos de serviço

#### 2. Adicionar seu Aplicativo

1. No console, clique em "Apps" → "Add App"
2. Selecione a plataforma (Android/iOS)
3. Informe o nome do app: **Rollflix**
4. Anote o **App ID** gerado

#### 3. Criar Unidade de Anúncio

1. Vá em "Ad units" → "Get started"
2. Selecione **"Rewarded"** (Recompensado)
3. Nome: "Rollflix - Recursos Extras"
4. Configurações:
   - Orientação: Vertical e Horizontal
   - Formato: Vídeo recompensado
5. Anote o **Ad Unit ID** gerado

#### 4. Atualizar Código

Edite: `lib/config/admob_config.dart`

```dart
class AdMobConfig {
  // ==================== PRODUÇÃO ====================
  
  // Android
  static const String androidAppId = 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
  static const String androidRewardedAdId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  
  // iOS
  static const String iosAppId = 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
  static const String iosRewardedAdId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  
  // Desabilitar modo teste
  static const bool testMode = false;
}
```

#### 5. Atualizar AndroidManifest.xml

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
```

#### 6. Atualizar Info.plist (iOS)

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
```

## 🧪 Como Testar

### Ambiente de Desenvolvimento

```bash
# Instalar dependências
flutter pub get

# Executar em device/emulador
flutter run

# Testar anúncios de teste
# 1. Esgote seus recursos (use 5 vezes)
# 2. Tente usar novamente
# 3. Aceite assistir anúncio
# 4. Anúncio de TESTE será exibido
# 5. Assista completamente
# 6. Verifique se ganhou +1 recurso
```

### ⚠️ Limitações em Emuladores

- **Android Emulator**: ✅ Funciona com IDs de teste
- **iOS Simulator**: ❌ Não funciona (use device físico)

### Dispositivos Reais

1. Use IDs de teste durante desenvolvimento
2. Adicione seu device como "Teste" no AdMob
3. Teste antes de publicar

## 📊 Monitoramento

### No Console do AdMob

Após publicar, você pode ver:
- Número de impressões
- Taxa de cliques (CTR)
- Receita estimada
- Desempenho por país
- Métricas de usuário

### Relatórios Recomendados

1. **Impressões diárias**: Quantos anúncios foram vistos
2. **Taxa de conclusão**: Quantos % assistem até o fim
3. **eCPM**: Ganho médio por 1000 impressões
4. **Receita**: Quanto você está ganhando

## 💡 Boas Práticas

### ✅ FAZER

- ✅ Oferecer anúncios como OPÇÃO (não forçar)
- ✅ Dar valor claro (recurso extra imediato)
- ✅ Explicar benefício antes de mostrar
- ✅ Limitar frequência (não spam)
- ✅ Testar em devices reais
- ✅ Monitorar métricas regularmente
- ✅ Respeitar privacidade do usuário

### ❌ EVITAR

- ❌ Forçar anúncios sem contexto
- ❌ Mostrar muitos anúncios seguidos
- ❌ Anúncios intrusivos
- ❌ Não dar opção de cancelar
- ❌ Prometer recompensa e não entregar
- ❌ Usar em produção sem testar

## 🔒 Privacidade

### GDPR & Consentimento

Se seu app será usado na Europa, você precisa:

1. Solicitar consentimento do usuário
2. Usar o UMP SDK (User Messaging Platform)
3. Implementar gestão de consentimento

```dart
// Exemplo (implementação futura)
import 'package:google_mobile_ads/google_mobile_ads.dart';

final params = ConsentRequestParameters();
ConsentInformation.instance.requestConsentInfoUpdate(
  params,
  () async {
    // Carregar form de consentimento se necessário
  },
  (error) {
    // Tratar erro
  },
);
```

### iOS App Tracking Transparency (ATT)

Já implementado em `Info.plist`:
- Usuários do iOS 14+ verão popup de permissão
- Descrição amigável explicando uso de anúncios
- Respeita escolha do usuário

## 📱 Recursos Adicionais

### Documentação Oficial

- [AdMob Flutter](https://developers.google.com/admob/flutter)
- [Anúncios Recompensados](https://developers.google.com/admob/flutter/rewarded)
- [Políticas do AdMob](https://support.google.com/admob/answer/6128543)

### Suporte

- [Stack Overflow - AdMob Flutter](https://stackoverflow.com/questions/tagged/google-mobile-ads+flutter)
- [GitHub Issues](https://github.com/googleads/googleads-mobile-flutter/issues)
- [Comunidade Flutter](https://flutter.dev/community)

## ✨ Melhorias Futuras

### Possíveis Expansões

1. **Múltiplos tipos de anúncio**:
   - Banner ads (menos intrusivos)
   - Interstitial (entre telas)
   - Native ads (integrados ao design)

2. **Estratégias de monetização**:
   - Recompensas maiores (assistir = 3 recursos)
   - Combo de recompensas
   - Tempo premium (sem anúncios por 24h)

3. **Analytics**:
   - Tracking de conversão
   - A/B testing de formatos
   - Otimização de frequência

4. **Gamificação**:
   - Streak de anúncios (bônus por assistir diariamente)
   - Achievements (badges por assistir X anúncios)
   - Levels de recompensa

## 🎉 Conclusão

A integração do AdMob está **100% funcional** e pronta para uso!

- ✅ Código limpo e documentado
- ✅ UX não intrusiva
- ✅ Fácil de configurar para produção
- ✅ Pronto para monetizar

**Próximo passo**: Criar conta no AdMob e substituir IDs de teste pelos de produção antes de publicar na Play Store / App Store.

---

**Desenvolvido com ❤️ para Rollflix**
*Última atualização: Outubro 2025*
