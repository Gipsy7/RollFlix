import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'background_service.dart';
import '../models/notification_history_item.dart';

/// Serviço para gerenciar notificações locais e push
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  NotificationService._internal();

  // Strings de notificação (por enquanto em português - TODO: implementar localização)
  static const String _newEpisodeTitle = 'Novo Episódio Disponível!';
  static const String _newEpisodeBodyPrefix = 'Novo episódio de';

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static const String _notificationSettingsKey = 'notification_settings';
  static const String _lastCheckKey = 'last_release_check';
  static const String _sentNotificationsKey = 'sent_notifications';
  static const String _notificationHistoryKey = 'notification_history';
  static const int _maxHistoryItems = 100; // Máximo de itens no histórico

  bool _notificationsEnabled = true;
  bool _movieReleasesEnabled = true;
  bool _tvShowEpisodesEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get movieReleasesEnabled => _movieReleasesEnabled;
  bool get tvShowEpisodesEnabled => _tvShowEpisodesEnabled;

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    try {
      // Inicializar timezone
      tz.initializeTimeZones();

      // Carregar configurações salvas
      await _loadSettings();

      // Configurar notificações locais
      await _initializeLocalNotifications();

      // Configurar Firebase Messaging
      await _initializeFirebaseMessaging();

      // Garantir que a verificação periódica em background esteja registrada
      // se as notificações estiverem habilitadas.
      if (_notificationsEnabled) {
        try {
          await BackgroundService.registerPeriodicTask();
          debugPrint('✅ Background periodic task registered from NotificationService.initialize');
        } catch (e) {
          debugPrint('⚠️ Could not register background periodic task: $e');
        }
      }

      debugPrint('✅ Serviço de notificações inicializado');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar notificações: $e');
    }
  }

  /// Inicializa notificações locais
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Criar canal de notificações para Android
    const androidChannel = AndroidNotificationChannel(
      'rollflix_releases',
      'Lançamentos Rollflix',
      description: 'Notificações sobre lançamentos de filmes e séries favoritas',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Inicializa Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Solicitar permissão para notificações push
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Firebase Messaging permission: ${settings.authorizationStatus}');

    // Obter token do dispositivo
    final token = await _firebaseMessaging.getToken();
    debugPrint('Firebase Messaging Token: $token');

    // Configurar handlers
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Handler para mensagens em foreground
  void _onMessageReceived(RemoteMessage message) {
    debugPrint('📱 Mensagem recebida: ${message.notification?.title}');

    if (message.notification != null) {
      _showLocalNotification(
        title: message.notification!.title ?? 'Notificação',
        body: message.notification!.body ?? '',
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Handler para quando o app é aberto por notificação
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('📱 App aberto por notificação: ${message.data}');
    // TODO: Navegar para a tela apropriada baseada nos dados da mensagem
  }

  /// Handler para notificações locais
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Notificação tocada: ${response.payload}');

    if (response.payload != null) {
      try {
        // TODO: Implementar navegação baseada no payload
        // final data = jsonDecode(response.payload!);
        // Navegar para a tela apropriada baseada nos dados
        jsonDecode(response.payload!); // Parse para validar JSON
      } catch (e) {
        debugPrint('Erro ao processar payload da notificação: $e');
      }
    }
  }

  /// Mostra uma notificação local (público para testes)
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      payload: payload,
      id: id,
    );
  }
  
  /// Envia uma notificação de teste
  Future<void> showTestNotification({
    required String title,
    required String body,
  }) async {
    await showLocalNotification(
      title: title,
      body: body,
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  /// Mostra uma notificação local
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    if (!_notificationsEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      'rollflix_releases',
      'Lançamentos Rollflix',
      channelDescription: 'Notificações sobre lançamentos de filmes e séries favoritas',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
    
    // Adicionar ao histórico
    await _addToHistory(
      title: title,
      body: body,
      type: _getNotificationTypeFromTitle(title),
      payload: payload,
    );
  }
  
  /// Adiciona uma notificação ao histórico
  Future<void> _addToHistory({
    required String title,
    required String body,
    required NotificationType type,
    String? payload,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_notificationHistoryKey);
      
      List<NotificationHistoryItem> history = [];
      if (historyJson != null) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        history = decoded
            .map((json) => NotificationHistoryItem.fromJson(json))
            .toList();
      }
      
      // Extrair IDs do payload se disponível
      String? movieId;
      String? showId;
      if (payload != null) {
        try {
          final data = jsonDecode(payload);
          movieId = data['movieId'] as String?;
          showId = data['showId'] as String?;
        } catch (e) {
          debugPrint('Erro ao parsear payload: $e');
        }
      }
      
      // Criar novo item
      final item = NotificationHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        timestamp: DateTime.now(),
        type: type,
        movieId: movieId,
        showId: showId,
      );
      
      // Adicionar no início da lista
      history.insert(0, item);
      
      // Manter apenas os últimos _maxHistoryItems itens
      if (history.length > _maxHistoryItems) {
        history = history.sublist(0, _maxHistoryItems);
      }
      
      // Salvar
      final encoded = jsonEncode(history.map((h) => h.toJson()).toList());
      await prefs.setString(_notificationHistoryKey, encoded);
      
      debugPrint('✅ Notificação adicionada ao histórico');
    } catch (e) {
      debugPrint('❌ Erro ao adicionar notificação ao histórico: $e');
    }
  }
  
  /// Obtém o histórico de notificações
  Future<List<NotificationHistoryItem>> getNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_notificationHistoryKey);
      
      if (historyJson == null) return [];
      
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded
          .map((json) => NotificationHistoryItem.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ Erro ao carregar histórico: $e');
      return [];
    }
  }
  
  /// Limpa o histórico de notificações
  Future<void> clearNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationHistoryKey);
      debugPrint('🧹 Histórico de notificações limpo');
    } catch (e) {
      debugPrint('❌ Erro ao limpar histórico: $e');
    }
  }
  
  /// Determina o tipo de notificação baseado no título
  NotificationType _getNotificationTypeFromTitle(String title) {
    if (title.contains('lançado') || title.contains('estreia')) {
      return NotificationType.movieRelease;
    } else if (title.contains('episódio') || title.contains('EP')) {
      return NotificationType.tvShowEpisode;
    } else if (title.contains('lembrete')) {
      return NotificationType.reminder;
    }
    return NotificationType.other;
  }

  /// Agenda uma notificação para uma data específica
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    int? id,
  }) async {
    if (!_notificationsEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      'rollflix_releases',
      'Lançamentos Rollflix',
      channelDescription: 'Notificações sobre lançamentos de filmes e séries favoritas',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Cancela uma notificação agendada
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancela todas as notificações
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Limpa o histórico de notificações enviadas
  Future<void> clearSentNotificationsHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sentNotificationsKey);
    debugPrint('🧹 Histórico de notificações enviadas limpo');
  }

  /// Obtém a quantidade de notificações no histórico (para debug)
  Future<int> getSentNotificationsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final sentList = prefs.getStringList(_sentNotificationsKey) ?? [];
    return sentList.length;
  }

  /// Atualiza configurações de notificação
  Future<void> updateSettings({
    bool? notificationsEnabled,
    bool? movieReleasesEnabled,
    bool? tvShowEpisodesEnabled,
  }) async {
    _notificationsEnabled = notificationsEnabled ?? _notificationsEnabled;
    _movieReleasesEnabled = movieReleasesEnabled ?? _movieReleasesEnabled;
    _tvShowEpisodesEnabled = tvShowEpisodesEnabled ?? _tvShowEpisodesEnabled;

    await _saveSettings();

    if (!_notificationsEnabled) {
      await cancelAllNotifications();
      await clearSentNotificationsHistory(); // Limpa histórico ao desabilitar
      await BackgroundService.cancelReleaseCheckTask(); // Cancela verificações em background
    } else {
      await BackgroundService.registerPeriodicTask(); // Re-registra verificações
    }

    debugPrint('⚙️ Configurações de notificação atualizadas');
  }

  /// Carrega configurações salvas
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_notificationSettingsKey);

      if (settingsJson != null) {
        final settings = jsonDecode(settingsJson);
        _notificationsEnabled = settings['notificationsEnabled'] ?? true;
        _movieReleasesEnabled = settings['movieReleasesEnabled'] ?? true;
        _tvShowEpisodesEnabled = settings['tvShowEpisodesEnabled'] ?? true;
      }
    } catch (e) {
      debugPrint('Erro ao carregar configurações de notificação: $e');
    }
  }

  /// Salva configurações
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settings = {
        'notificationsEnabled': _notificationsEnabled,
        'movieReleasesEnabled': _movieReleasesEnabled,
        'tvShowEpisodesEnabled': _tvShowEpisodesEnabled,
      };
      await prefs.setString(_notificationSettingsKey, jsonEncode(settings));
    } catch (e) {
      debugPrint('Erro ao salvar configurações de notificação: $e');
    }
  }

  /// Obtém a data da última verificação de lançamentos
  Future<DateTime?> getLastReleaseCheck() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheckStr = prefs.getString(_lastCheckKey);
      return lastCheckStr != null ? DateTime.parse(lastCheckStr) : null;
    } catch (e) {
      debugPrint('Erro ao obter última verificação: $e');
      return null;
    }
  }

  /// Define a data da última verificação de lançamentos
  Future<void> setLastReleaseCheck(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastCheckKey, date.toIso8601String());
    } catch (e) {
      debugPrint('Erro ao salvar última verificação: $e');
    }
  }

  /// Verifica se uma notificação já foi enviada
  Future<bool> wasNotificationSent(String uniqueId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sentList = prefs.getStringList(_sentNotificationsKey) ?? [];
      return sentList.contains(uniqueId);
    } catch (e) {
      debugPrint('Erro ao verificar notificação enviada: $e');
      return false;
    }
  }

  /// Marca uma notificação como enviada
  Future<void> markNotificationAsSent(String uniqueId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sentList = prefs.getStringList(_sentNotificationsKey) ?? [];
      if (!sentList.contains(uniqueId)) {
        sentList.add(uniqueId);
        // Manter apenas últimos 100 registros para não crescer infinitamente
        if (sentList.length > 100) {
          sentList.removeRange(0, sentList.length - 100);
        }
        await prefs.setStringList(_sentNotificationsKey, sentList);
      }
    } catch (e) {
      debugPrint('Erro ao marcar notificação como enviada: $e');
    }
  }

  /// Notifica sobre lançamento de filme favorito
  Future<void> notifyMovieRelease(String movieId, String movieTitle, DateTime releaseDate) async {
    if (!_notificationsEnabled || !_movieReleasesEnabled) return;

    final uniqueId = 'movie_${movieId}_${releaseDate.toUtc().toIso8601String().split('T')[0]}';
    
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
    debugPrint('🎬 Notificação de lançamento de filme enviada: $movieTitle');
  }

  /// Notifica sobre novo episódio de série favorita
  Future<void> notifyTVShowEpisode(String showId, String showTitle, String episodeInfo, DateTime airDate) async {
    if (!_notificationsEnabled || !_tvShowEpisodesEnabled) return;

    final uniqueId = 'tv_${showId}_${episodeInfo}_${airDate.toUtc().toIso8601String().split('T')[0]}';
    
    if (await wasNotificationSent(uniqueId)) {
      debugPrint('⏭️ Notificação já enviada para $showTitle - $episodeInfo');
      return;
    }

    final title = '📺 $_newEpisodeTitle';
    final body = '$_newEpisodeBodyPrefix $showTitle: $episodeInfo';

    await _showLocalNotification(
      title: title,
      body: body,
      payload: jsonEncode({
        'type': 'tv_episode',
        'showId': showId,
        'showTitle': showTitle,
        'episodeInfo': episodeInfo,
      }),
    );
    
    await markNotificationAsSent(uniqueId);
    debugPrint('📺 Notificação de novo episódio enviada: $showTitle - $episodeInfo');
  }

  /// Agenda notificação para lançamento futuro
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

    debugPrint('📅 Notificação agendada para ${notificationDate.toLocal()}: $movieTitle');
  }
}

/// Handler global para mensagens em background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📱 Mensagem recebida em background: ${message.notification?.title}');
}