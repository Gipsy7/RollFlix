# 🧪 Guia de Testes - Sistema de Notificações

## 📋 Visão Geral

Este documento fornece instruções detalhadas para testar todas as melhorias implementadas no sistema de notificações.

---

## ✅ Testes de Funcionalidades

### 1. **Teste de Prevenção de Duplicatas**

**Objetivo:** Verificar que notificações não são enviadas mais de uma vez para o mesmo lançamento.

**Passos:**
1. Adicione um filme aos favoritos que será lançado hoje ou amanhã
2. Force uma verificação de lançamentos (pull-to-refresh ou reinicie o app)
3. Verifique os logs do console: 
   ```
   ✅ Esperado: "✅ Notificação enviada: [Nome do Filme]"
   ```
4. Force outra verificação imediatamente
5. Verifique os logs do console:
   ```
   ✅ Esperado: "⏭️ Notificação já enviada para [Nome do Filme]"
   ```

**Resultado Esperado:**
- Primeira verificação: notificação enviada
- Segunda verificação: notificação pulada (já enviada)
- Histórico salvo em SharedPreferences

---

### 2. **Teste de Timezone (UTC)**

**Objetivo:** Garantir que notificações são enviadas no dia correto independente do fuso horário.

**Passos:**
1. Configure um filme favorito com data de lançamento "amanhã" (use a data UTC)
2. Verifique os logs para ver se `_isToday()` e `_isTomorrow()` funcionam corretamente
3. Observe se a notificação é agendada corretamente

**Logs Esperados:**
```
🔍 Verificando lançamentos de X filmes...
📅 Filme será lançado amanhã, agendando notificação
✅ Notificação agendada para: [Nome do Filme]
```

**Resultado Esperado:**
- Datas comparadas em UTC, sem erro de "um dia a mais/menos"
- Notificação agendada para o horário correto

---

### 3. **Teste de Rate Limiting**

**Objetivo:** Verificar que verificações respeitam o intervalo mínimo de 6 horas.

**Passos:**
1. Force uma verificação de lançamentos
2. Observe o log:
   ```
   🔍 Iniciando verificação de X favoritos...
   ✅ Verificação completa finalizada em Xs
   ```
3. Tente forçar outra verificação imediatamente
4. Observe o log:
   ```
   ⏭️ Verificação muito recente. Aguarde Xh Xm (última: [timestamp])
   ```

**Resultado Esperado:**
- Primeira verificação: executa normalmente
- Verificações subsequentes em <6h: puladas com mensagem informativa
- Após 6 horas: executa novamente

---

### 4. **Teste de Validação de Datas**

**Objetivo:** Garantir que notificações não são agendadas para datas passadas.

**Passos:**
1. Adicione um filme com data de lançamento no passado aos favoritos
2. Force verificação de lançamentos
3. Observe os logs:
   ```
   ⏭️ Data de lançamento no passado: [Nome do Filme]
   ```

**Resultado Esperado:**
- Não agenda notificação para datas passadas
- Log claro indicando o motivo

---

### 5. **Teste de Listener Eficiente**

**Objetivo:** Verificar que apenas favoritos novos são verificados, não todos.

**Cenário A - Adicionar Favorito:**

**Passos:**
1. Tenha uma lista com 10+ favoritos
2. Adicione 1 novo favorito
3. Observe os logs:
   ```
   🔍 Verificando 1 favoritos novos...
   ✅ Verificação concluída para favoritos novos
   ```

**Resultado Esperado:**
- Verifica apenas o 1 item adicionado
- NÃO verifica os outros 10 favoritos existentes

**Cenário B - Remover Favorito:**

**Passos:**
1. Tenha um favorito com notificação agendada
2. Remova esse favorito da lista
3. Observe os logs:
   ```
   🗑️ Notificação cancelada para: [Nome do Item]
   ```

**Resultado Esperado:**
- Notificação cancelada quando favorito removido
- Não executa verificação completa de todos os favoritos

---

### 6. **Teste de Histórico de Notificações**

**Objetivo:** Testar métodos de gerenciamento do histórico.

**Teste via Console (Debug):**

```dart
// No código de debug ou test file:
final notificationService = NotificationService.instance;

// Verificar quantidade no histórico
final count = await notificationService.getSentNotificationsCount();
print('📊 Notificações no histórico: $count');

// Limpar histórico
await notificationService.clearSentNotificationsHistory();
print('🧹 Histórico limpo');

// Verificar novamente
final newCount = await notificationService.getSentNotificationsCount();
print('📊 Notificações no histórico: $newCount'); // Deve ser 0
```

**Resultado Esperado:**
- `getSentNotificationsCount()` retorna número correto
- `clearSentNotificationsHistory()` limpa o histórico
- Contagem após limpar = 0

---

### 7. **Teste de Desabilitar Notificações**

**Objetivo:** Verificar que desabilitar notificações limpa tudo.

**Passos:**
1. Tenha notificações ativas e histórico com itens
2. Acesse configurações e desabilite notificações
3. Observe os logs:
   ```
   🗑️ Todas as notificações canceladas
   🧹 Histórico de notificações enviadas limpo
   ⚙️ Configurações de notificação atualizadas
   ```

**Resultado Esperado:**
- Todas as notificações agendadas são canceladas
- Histórico de notificações enviadas é limpo
- SharedPreferences atualizado

---

## 🎯 Cenários de Teste Completos

### Cenário 1: Usuário Adiciona Primeiro Favorito

**Fluxo:**
1. App instalado, sem favoritos
2. Usuário adiciona filme que estreia amanhã
3. Sistema deve:
   - ✅ Agendar notificação para D-1
   - ✅ Log: "🔍 Verificando 1 favoritos novos..."
   - ✅ Log: "📅 Filme será lançado amanhã, agendando notificação"

### Cenário 2: Usuário com 50 Favoritos Adiciona Mais 1

**Fluxo:**
1. Lista com 50 favoritos existentes
2. Usuário adiciona 1 novo filme
3. Sistema deve:
   - ✅ Verificar APENAS o novo item (não os 50)
   - ✅ Log: "🔍 Verificando 1 favoritos novos..."
   - ❌ NÃO deve logar verificação de 50 itens

### Cenário 3: Usuário Remove Favorito

**Fluxo:**
1. Favorito tem notificação agendada
2. Usuário remove favorito
3. Sistema deve:
   - ✅ Cancelar notificação agendada
   - ✅ Log: "🗑️ Notificação cancelada para: [Nome]"
   - ❌ NÃO deve verificar outros favoritos

### Cenário 4: Verificação Periódica (Rate Limiting)

**Fluxo:**
1. Sistema faz verificação às 10:00
2. Usuário tenta forçar às 10:30 (30 min depois)
3. Sistema deve:
   - ✅ Pular verificação
   - ✅ Log: "⏭️ Verificação muito recente. Aguarde 5h 30m"
4. Usuário tenta às 16:01 (6h 1min depois)
5. Sistema deve:
   - ✅ Executar verificação
   - ✅ Log: "🔍 Iniciando verificação de X favoritos..."

### Cenário 5: Filme Lançado Hoje

**Fluxo:**
1. Filme favorito com data de lançamento = hoje (UTC)
2. Sistema faz verificação
3. Sistema deve:
   - ✅ Enviar notificação imediata
   - ✅ Log: "🎬 Notificação enviada: [Filme] foi lançado hoje!"
   - ✅ Marcar como enviada (não repetir)

---

## 🐛 Testes de Casos Extremos

### Caso 1: Histórico Atinge 100 Itens

**Teste:**
```dart
// Simular 105 notificações
for (int i = 0; i < 105; i++) {
  await notificationService.markNotificationAsSent('test_$i');
}

// Verificar que mantém apenas 100
final count = await notificationService.getSentNotificationsCount();
assert(count == 100);
```

**Resultado Esperado:** Mantém apenas as 100 mais recentes

### Caso 2: Data no Passado

**Teste:**
- Filme com data de lançamento: 2023-01-01
- Sistema deve NÃO agendar notificação
- Log: "⏭️ Data de lançamento no passado"

### Caso 3: Lista Vazia de Favoritos

**Teste:**
- Remover todos os favoritos
- Forçar verificação
- Log esperado:
  ```
  ⏭️ Nenhum favorito para verificar
  ⏭️ Nenhum filme favorito para verificar
  ⏭️ Nenhuma série favorita para verificar
  ```

---

## 📊 Métricas de Performance

### Medição de Tempo

Todos os logs agora incluem duração:

```
🔍 Iniciando verificação de 50 favoritos...
🔍 Verificando lançamentos de 30 filmes...
🔍 Verificando episódios de 20 séries...
✅ Verificação completa finalizada em 3s
```

### Comparação Antes vs Depois

| Ação | Antes | Depois |
|------|-------|--------|
| Adicionar 1 favorito (lista com 100) | Verifica 101 itens | Verifica 1 item |
| Remover 1 favorito | Verifica 99 itens | Cancela 1 notificação |
| Verificação em <6h | Executa sempre | Pula com log |
| Notificação duplicada | Possível | Impossível |

---

## 🔍 Logs para Debugging

### Logs Importantes a Observar

**Prevenção de Duplicatas:**
```
✅ Notificação enviada: [Filme]
⏭️ Notificação já enviada para [Filme]
```

**Rate Limiting:**
```
⏭️ Verificação muito recente. Aguarde 5h 30m (última: 2025-10-10 10:00:00)
```

**Listener Eficiente:**
```
🔍 Verificando 3 favoritos novos...
✅ Verificação concluída para favoritos novos
🗑️ Notificação cancelada para: [Item]
```

**Timezone:**
```
📅 Filme será lançado amanhã, agendando notificação
🎬 Notificação enviada: [Filme] foi lançado hoje!
```

**Validação:**
```
⏭️ Data de lançamento no passado: [Filme]
⏭️ Data de notificação no passado: [Filme]
```

---

## ✅ Checklist de Testes

Antes de considerar os testes completos, verifique:

- [ ] Notificações duplicadas são prevenidas
- [ ] Datas comparadas em UTC funcionam corretamente
- [ ] Rate limiting de 6h funciona
- [ ] Datas passadas não agendam notificações
- [ ] Adicionar favorito verifica apenas o novo
- [ ] Remover favorito cancela notificação
- [ ] Histórico mantém máximo de 100 itens
- [ ] Desabilitar notificações limpa tudo
- [ ] Logs são claros e informativos
- [ ] Performance melhorada (menos verificações)

---

## 🎓 Conclusão

Este sistema de testes garante que todas as 5 correções implementadas funcionam corretamente:

1. ✅ **Prevenção de Duplicatas** - Testável via verificação múltipla
2. ✅ **Timezone UTC** - Testável via filmes com datas específicas
3. ✅ **Rate Limiting** - Testável via verificações consecutivas
4. ✅ **Validação de Datas** - Testável via filmes com datas passadas
5. ✅ **Listener Eficiente** - Testável via logs de quantidade verificada

**Próximos Passos:**
- Executar todos os testes neste guia
- Validar logs no console
- Verificar comportamento em produção
- Considerar adicionar WorkManager para execução em background (documentado em NOTIFICATION_FIXES.md)
