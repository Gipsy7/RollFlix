# 🔔 CORREÇÕES NECESSÁRIAS NO SISTEMA DE NOTIFICAÇÕES

## 📊 STATUS ATUAL

### ✅ Funcionando:
- Estrutura básica de notificações
- Firebase Messaging configurado
- Notificações locais funcionais
- Verificação manual de lançamentos

### ❌ Problemas Críticos:

## 🔴 PROBLEMA 1: FALTA DE EXECUÇÃO EM BACKGROUND

### Descrição:
O sistema só verifica lançamentos quando o app está aberto.

### Impacto:
- Usuário não recebe notificações se não abrir o app
- Propósito das notificações é perdido

### Solução:
Implementar **WorkManager** para Android e **Background Fetch** para iOS.

```dart
// Adicionar ao pubspec.yaml:
dependencies:
  workmanager: ^0.5.2

// Criar novo arquivo: lib/services/background_service.dart
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  static const String releaseCheckTask = 'release_check_task';
  
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    
    // Agendar verificação diária
    await Workmanager().registerPeriodicTask(
      'release_check',
      releaseCheckTask,
      frequency: const Duration(hours: 12), // Verificar 2x por dia
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Inicializar serviços necessários
      final favController = FavoritesController.instance;
      final releaseService = ReleaseCheckService.instance;
      
      await releaseService.checkAllReleases(favController.favorites);
      
      return Future.value(true);
    } catch (e) {
      debugPrint('Erro no background task: $e');
      return Future.value(false);
    }
  });
}
```

## 🔴 PROBLEMA 2: LISTENER DE FAVORITOS INEFICIENTE

### Descrição:
Verifica TODOS os favoritos toda vez que a lista muda.

### Solução:
Modificar para verificar apenas novos itens adicionados.

```dart
// No FavoritesController, adicionar:
final List<FavoriteItem> _recentlyAdded = [];

void addToFavorites(FavoriteItem item) {
  _favorites.add(item);
  _recentlyAdded.add(item);
  notifyListeners();
}

List<FavoriteItem> getAndClearRecentlyAdded() {
  final items = List<FavoriteItem>.from(_recentlyAdded);
  _recentlyAdded.clear();
  return items;
}

// No NotificationController:
void _onFavoritesChanged() {
  final newItems = _favoritesController.getAndClearRecentlyAdded();
  if (newItems.isNotEmpty) {
    _checkSpecificReleases(newItems);
  }
}

Future<void> _checkSpecificReleases(List<FavoriteItem> items) async {
  await _releaseCheckService.checkAllReleases(items);
}
```

## 🟡 PROBLEMA 3: TIMEZONE INCORRETO

### Solução:
Usar UTC consistentemente.

```dart
// Em release_check_service.dart:
bool _isToday(DateTime date) {
  final now = DateTime.now().toUtc();
  final dateUtc = date.toUtc();
  
  return dateUtc.year == now.year &&
         dateUtc.month == now.month &&
         dateUtc.day == now.day;
}

bool _isTomorrow(DateTime date) {
  final tomorrow = DateTime.now().toUtc().add(const Duration(days: 1));
  final dateUtc = date.toUtc();
  
  return dateUtc.year == tomorrow.year &&
         dateUtc.month == tomorrow.month &&
         dateUtc.day == tomorrow.day;
}
```

## 🟡 PROBLEMA 4: NOTIFICAÇÕES DUPLICADAS

### Solução:
Adicionar controle de notificações enviadas.

```dart
// Adicionar ao NotificationService:
static const String _sentNotificationsKey = 'sent_notifications';

Future<bool> wasNotificationSent(String uniqueId) async {
  final prefs = await SharedPreferences.getInstance();
  final sentList = prefs.getStringList(_sentNotificationsKey) ?? [];
  return sentList.contains(uniqueId);
}

Future<void> markNotificationAsSent(String uniqueId) async {
  final prefs = await SharedPreferences.getInstance();
  final sentList = prefs.getStringList(_sentNotificationsKey) ?? [];
  if (!sentList.contains(uniqueId)) {
    sentList.add(uniqueId);
    await prefs.setStringList(_sentNotificationsKey, sentList);
  }
}

// Modificar notifyMovieRelease:
Future<void> notifyMovieRelease(String movieId, String movieTitle, DateTime releaseDate) async {
  if (!_notificationsEnabled || !_movieReleasesEnabled) return;

  final uniqueId = 'movie_${movieId}_${releaseDate.toIso8601String().split('T')[0]}';
  
  if (await wasNotificationSent(uniqueId)) {
    debugPrint('⏭️ Notificação já enviada para $movieTitle');
    return;
  }

  final title = '🎬 Filme Favorito Lançado!';
  final body = '$movieTitle foi lançado hoje!';

  await _showLocalNotification(
    title: title,
    body: body,
    payload: jsonEncode({
      'type': 'movie_release',
      'movieId': movieId,
      'title': movieTitle,
      'releaseDate': releaseDate.toIso8601String(),
    }),
  );
  
  await markNotificationAsSent(uniqueId);
  debugPrint('🎬 Notificação enviada: $movieTitle');
}
```

## 🟡 PROBLEMA 5: AGENDAMENTO SEGURO

### Solução:
Validar datas antes de agendar.

```dart
Future<void> scheduleMovieReleaseNotification(String movieId, String movieTitle, DateTime releaseDate) async {
  if (!_notificationsEnabled || !_movieReleasesEnabled) return;

  // Validar se a data é futura
  final now = DateTime.now();
  if (releaseDate.isBefore(now)) {
    debugPrint('⏭️ Data de lançamento no passado, não agendando: $movieTitle');
    return;
  }

  final notificationDate = releaseDate.subtract(const Duration(days: 1));
  
  // Verificar se a notificação já passou
  if (notificationDate.isBefore(now)) {
    debugPrint('⏭️ Data de notificação no passado, não agendando: $movieTitle');
    return;
  }

  final notificationId = 'movie_upcoming_$movieId'.hashCode;
  final title = '🎬 Filme Favorito Lançando Amanhã!';
  final body = '$movieTitle será lançado amanhã!';

  await scheduleNotification(
    title: title,
    body: body,
    scheduledDate: notificationDate,
    id: notificationId,
    payload: jsonEncode({
      'type': 'movie_release_upcoming',
      'movieId': movieId,
      'title': movieTitle,
      'releaseDate': releaseDate.toIso8601String(),
    }),
  );

  debugPrint('📅 Notificação agendada para $notificationDate: $movieTitle');
}
```

## 🟡 PROBLEMA 6: LIMPEZA DE NOTIFICAÇÕES

### Solução:
Cancelar notificações quando item é removido dos favoritos.

```dart
// No FavoritesController:
final List<FavoriteItem> _recentlyRemoved = [];

void removeFromFavorites(FavoriteItem item) {
  _favorites.remove(item);
  _recentlyRemoved.add(item);
  notifyListeners();
}

List<FavoriteItem> getAndClearRecentlyRemoved() {
  final items = List<FavoriteItem>.from(_recentlyRemoved);
  _recentlyRemoved.clear();
  return items;
}

// No NotificationController:
void _onFavoritesChanged() {
  // Cancelar notificações de items removidos
  final removedItems = _favoritesController.getAndClearRecentlyRemoved();
  for (final item in removedItems) {
    _cancelItemNotifications(item);
  }
  
  // Verificar novos items
  final newItems = _favoritesController.getAndClearRecentlyAdded();
  if (newItems.isNotEmpty) {
    _checkSpecificReleases(newItems);
  }
}

void _cancelItemNotifications(FavoriteItem item) {
  final notificationId = 'movie_upcoming_${item.id}'.hashCode;
  _notificationService.cancelNotification(notificationId);
}
```

## 🟡 PROBLEMA 7: RATE LIMITING

### Solução:
Adicionar controle de frequência.

```dart
// No ReleaseCheckService:
DateTime? _lastCheckTime;
static const Duration minCheckInterval = Duration(hours: 6);

Future<void> checkAllReleases(List<FavoriteItem> favorites) async {
  // Verificar se já verificou recentemente
  if (_lastCheckTime != null) {
    final timeSinceLastCheck = DateTime.now().difference(_lastCheckTime!);
    if (timeSinceLastCheck < minCheckInterval) {
      debugPrint('⏭️ Verificação muito recente, pulando (última: $_lastCheckTime)');
      return;
    }
  }

  debugPrint('🔍 Iniciando verificação de lançamentos...');
  _lastCheckTime = DateTime.now();

  await Future.wait([
    checkMovieReleases(favorites),
    checkTVShowEpisodes(favorites),
  ]);

  debugPrint('✅ Verificação completa finalizada');
}
```

## 📝 RESUMO DAS ALTERAÇÕES PRIORITÁRIAS

### 🔴 Crítico (Implementar Primeiro):
1. ✅ Adicionar WorkManager para verificações em background
2. ✅ Implementar controle de notificações duplicadas
3. ✅ Otimizar listener de favoritos

### 🟡 Importante (Implementar em Seguida):
4. ✅ Corrigir timezone para UTC
5. ✅ Validar datas antes de agendar
6. ✅ Adicionar rate limiting
7. ✅ Implementar limpeza de notificações

### 🟢 Melhorias Adicionais:
- Adicionar analytics para tracking de notificações
- Implementar retry logic para falhas de API
- Adicionar configuração de horário preferido para notificações
- Cache de dados de lançamentos para reduzir chamadas API
