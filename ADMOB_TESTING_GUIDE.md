# 🧪 Guia de Teste - Integração AdMob

## Como Testar a Integração de Anúncios

### 📱 Pré-requisitos

1. **Device ou Emulador**:
   - Android: Emulador ou device real
   - iOS: APENAS device real (Simulator não suporta anúncios)

2. **App instalado**:
   ```bash
   flutter run --debug
   ```

## 🎯 Cenários de Teste

### Teste 1: Rolagem de Filmes/Séries

**Objetivo**: Verificar anúncio ao esgotar rolagens

**Passos**:
1. Abra o app
2. Selecione um gênero
3. Clique no botão "Rolar" **5 vezes**
   - Cada vez consumirá 1 recurso
   - Você verá o contador diminuir
4. Na **6ª tentativa**:
   - ✅ Diálogo deve aparecer oferecendo anúncio
   - ✅ Deve mostrar tempo de recarga (24h)
   - ✅ Botão "Assistir Anúncio" visível

5. Clique em "Assistir Anúncio"
6. **Resultado Esperado**:
   - Loading aparece
   - Anúncio de TESTE é exibido
   - Após assistir completamente: SnackBar "🎁 Você ganhou 1 rolagem extra!"
   - Contador de recursos aumenta em +1
   - Pode rolar novamente

**Estados Possíveis**:
- ✅ Anúncio carrega e exibe corretamente
- ⚠️ "Anúncio não disponível" - Aguarde 30s e tente novamente
- ❌ Erro - Verifique logs

---

### Teste 2: Favoritar Filme/Série

**Objetivo**: Verificar anúncio ao esgotar favoritos

**Passos**:
1. Navegue para tela de detalhes de um filme/série
2. Clique no ícone de ❤️ (coração) **5 vezes** em diferentes filmes
3. Na **6ª tentativa**:
   - ✅ Diálogo de anúncio deve aparecer

4. Assista ao anúncio
5. **Resultado Esperado**:
   - Ganha +1 favorito
   - Pode adicionar aos favoritos

---

### Teste 3: Marcar como Assistido

**Objetivo**: Verificar anúncio ao esgotar assistidos

**Passos**:
1. Navegue para tela de detalhes de um filme/série
2. Clique no ícone ✓ (check) **5 vezes** em diferentes filmes
3. Na **6ª tentativa**:
   - ✅ Diálogo de anúncio deve aparecer

4. Assista ao anúncio
5. **Resultado Esperado**:
   - Ganha +1 assistido
   - Pode marcar como assistido

---

### Teste 4: Cancelar Anúncio

**Objetivo**: Verificar comportamento ao cancelar

**Passos**:
1. Esgote qualquer recurso (5 usos)
2. Tente usar novamente
3. Diálogo aparece
4. Clique em **"Cancelar"**

**Resultado Esperado**:
- ✅ Diálogo fecha
- ✅ Nenhum recurso é ganho
- ✅ Funcionalidade não é executada
- ✅ App continua normal

---

### Teste 5: Anúncio não Completo

**Objetivo**: Verificar se recompensa só é dada após assistir completamente

**Passos**:
1. Esgote um recurso
2. Aceite assistir anúncio
3. **FECHE** o anúncio antes do fim (botão X ou voltar)

**Resultado Esperado**:
- ❌ Nenhuma recompensa concedida
- ⚠️ Anúncio fecha
- ℹ️ Novo anúncio é pré-carregado
- Pode tentar novamente

---

### Teste 6: Múltiplos Anúncios Seguidos

**Objetivo**: Verificar se pode assistir múltiplos anúncios

**Passos**:
1. Esgote um recurso (5 usos)
2. Assista anúncio → Ganha +1 (total: 1)
3. Use esse recurso
4. Tente usar novamente
5. Assista outro anúncio → Ganha +1

**Resultado Esperado**:
- ✅ Pode assistir múltiplos anúncios
- ✅ Cada anúncio concede +1 recurso
- ✅ Sem limite de quantos anúncios pode assistir
- ⚠️ Mas deve haver intervalo entre carregamentos

---

## 🔍 Verificações de Logs

### Logs Esperados (Android Studio / VSCode)

#### Inicialização
```
✅ AdMob inicializado com sucesso
📥 Carregando anúncio recompensado...
✅ Anúncio recompensado carregado com sucesso
```

#### Quando Usuário Aceita Assistir
```
🎬 Mostrando anúncio recompensado (Tipo: roll)
📺 Anúncio sendo exibido em tela cheia
```

#### Após Assistir Completamente
```
🎁 Recompensa ganha!
   Tipo: Reward
   Quantidade: 1
🎁 Recompensa concedida: +1 roll (Total: 1)
```

#### Após Fechar Anúncio
```
📱 Anúncio fechado pelo usuário
📥 Carregando anúncio recompensado... (pré-carrega próximo)
```

### Logs de Erro Comuns

#### Anúncio Não Carregou
```
❌ Erro ao carregar anúncio: No fill
⏰ Reagendando carregamento de anúncio em 30s
```
**Solução**: Aguarde 30s, novo anúncio será carregado automaticamente

#### Falha ao Exibir
```
❌ Erro ao exibir anúncio: Ad not ready
⚠️ Anúncio não está pronto para exibição
```
**Solução**: Aguarde o pré-carregamento

---

## 🎨 Verificações Visuais

### Diálogo de Oferta

**Deve conter**:
- ✅ Ícone de vídeo (📹)
- ✅ Título: "Sem Recursos!"
- ✅ Texto explicativo sobre falta de recursos
- ✅ Tempo de recarga (ex: "Recarga em 23:45h")
- ✅ Card destacado com ícone de presente
- ✅ Texto: "Assista a um anúncio curto e ganhe 1 [recurso] extra!"
- ✅ Botão "Cancelar" (cinza)
- ✅ Botão "Assistir Anúncio" (amarelo/primary color)

### Loading

**Deve conter**:
- ✅ Fundo semi-transparente escuro
- ✅ Card centralizado
- ✅ CircularProgressIndicator (amarelo)
- ✅ Texto: "Carregando anúncio..."

### SnackBar de Sucesso

**Deve conter**:
- ✅ Ícone verde de check (✓)
- ✅ Texto: "🎁 Você ganhou 1 [recurso] extra!"
- ✅ Fundo escuro
- ✅ Bordas arredondadas
- ✅ Posição: floating (não encosta nas bordas)

---

## 📊 Checklist de Testes

### Funcionalidade Básica
- [ ] Anúncio carrega sem erros
- [ ] Anúncio exibe corretamente
- [ ] Recompensa é concedida após assistir
- [ ] Contador de recursos atualiza
- [ ] Pode usar funcionalidade após ganhar recurso

### Edge Cases
- [ ] Cancelar diálogo não dá recompensa
- [ ] Fechar anúncio antes do fim não dá recompensa
- [ ] Pode assistir múltiplos anúncios seguidos
- [ ] App não trava se anúncio falhar
- [ ] Retry automático funciona (30s)

### UX
- [ ] Diálogo é claro e compreensível
- [ ] Loading aparece durante carregamento
- [ ] SnackBar confirma sucesso
- [ ] Pode cancelar a qualquer momento
- [ ] Não é intrusivo/forçado

### Performance
- [ ] App não trava durante anúncio
- [ ] Transições são suaves
- [ ] Pré-carregamento não impacta performance
- [ ] Memória não vaza após múltiplos anúncios

---

## 🐛 Troubleshooting

### Problema: "Anúncio não disponível no momento"

**Possíveis Causas**:
1. Anúncio ainda está carregando
2. Sem conexão com internet
3. Servidor do AdMob temporariamente indisponível

**Solução**:
- Aguarde 30s
- Verifique conexão
- Tente novamente

---

### Problema: Anúncio não carrega nunca

**Possíveis Causas**:
1. IDs do AdMob incorretos
2. App não inicializou AdMob
3. Plataforma não suportada (iOS Simulator)

**Solução**:
1. Verifique `admob_config.dart` - deve ter IDs de teste
2. Verifique logs: "✅ AdMob inicializado"
3. Use device real no iOS

---

### Problema: Recompensa não é concedida

**Possíveis Causas**:
1. Anúncio não foi assistido completamente
2. Callback não configurado corretamente

**Solução**:
1. Assista o anúncio ATÉ O FIM
2. Verifique logs: "🎁 Recompensa ganha!"

---

### Problema: App trava ao mostrar anúncio

**Possíveis Causas**:
1. Memória insuficiente
2. Conflito de plugins
3. Bug no SDK do AdMob

**Solução**:
1. Teste em device mais potente
2. Limpe cache: `flutter clean`
3. Atualize dependências: `flutter pub upgrade`

---

## ✅ Critérios de Aceitação

Para considerar a integração **100% funcional**:

1. ✅ Todos os 6 cenários de teste passam
2. ✅ Logs corretos aparecem
3. ✅ Interface visual correta
4. ✅ Nenhum crash/erro
5. ✅ Performance aceitável
6. ✅ UX satisfatória

---

## 📝 Relatório de Teste (Template)

```
Data: __/__/____
Testador: _____________
Device: _______________
OS Version: ___________

RESULTADOS:

[ ] Teste 1: Rolagem - PASSOU / FALHOU
[ ] Teste 2: Favoritos - PASSOU / FALHOU
[ ] Teste 3: Assistidos - PASSOU / FALHOU
[ ] Teste 4: Cancelar - PASSOU / FALHOU
[ ] Teste 5: Não Completo - PASSOU / FALHOU
[ ] Teste 6: Múltiplos - PASSOU / FALHOU

OBSERVAÇÕES:
_________________________________
_________________________________
_________________________________

BUGS ENCONTRADOS:
_________________________________
_________________________________
_________________________________

APROVADO: SIM / NÃO
```

---

**Boa sorte nos testes! 🚀**
