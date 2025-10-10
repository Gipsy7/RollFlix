import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';
import '../services/release_check_service.dart';
import '../controllers/favorites_controller.dart';

/// Controller para gerenciar notificações de lançamentos
class NotificationController extends ChangeNotifier {
  static final NotificationController _instance = NotificationController._internal();
  static NotificationController get instance => _instance;

  NotificationController._internal() {
    _initialize();
  }

  final NotificationService _notificationService = NotificationService.instance;
  final ReleaseCheckService _releaseCheckService = ReleaseCheckService.instance;
  final FavoritesController _favoritesController = FavoritesController.instance;

  bool _isInitialized = false;
  bool _isCheckingReleases = false;

  bool get isInitialized => _isInitialized;
  bool get isCheckingReleases => _isCheckingReleases;

  /// Inicializa o controller de notificações
  Future<void> _initialize() async {
    try {
      await _notificationService.initialize();
      _setupFavoritesListener();
      _isInitialized = true;
      notifyListeners();

      debugPrint('✅ NotificationController inicializado');

      // Executar primeira verificação após inicialização
      await checkReleases();

    } catch (e) {
      debugPrint('❌ Erro ao inicializar NotificationController: $e');
    }
  }

  /// Configura listener para mudanças nos favoritos
  void _setupFavoritesListener() {
    _favoritesController.addListener(_onFavoritesChanged);
  }

  /// Handler para quando os favoritos mudam
  void _onFavoritesChanged() {
    // Cancelar notificações dos itens removidos
    _cancelRemovedNotifications();
    
    // Verificar lançamentos apenas dos itens adicionados recentemente
    _checkNewFavoritesReleases();
  }
  
  /// Cancela notificações de favoritos removidos
  void _cancelRemovedNotifications() {
    final removedItems = _favoritesController.getAndClearRecentlyRemoved();
    
    for (final item in removedItems) {
      // Gera o mesmo ID usado ao agendar a notificação
      final notificationId = 'movie_upcoming_${item.id}'.hashCode;
      _notificationService.cancelNotification(notificationId);
      debugPrint('🗑️ Notificação cancelada para: ${item.title}');
    }
  }
  
  /// Verifica lançamentos apenas dos favoritos adicionados recentemente
  Future<void> _checkNewFavoritesReleases() async {
    if (!_isInitialized) return;
    
    final newItems = _favoritesController.getAndClearRecentlyAdded();
    
    if (newItems.isEmpty) {
      debugPrint('⏭️ Nenhum favorito novo para verificar');
      return;
    }
    
    try {
      debugPrint('🔍 Verificando ${newItems.length} favoritos novos...');
      await _releaseCheckService.checkAllReleases(newItems);
      debugPrint('✅ Verificação concluída para favoritos novos');
    } catch (e) {
      debugPrint('❌ Erro ao verificar favoritos novos: $e');
    }
  }

  /// Verifica lançamentos de todos os favoritos
  Future<void> checkReleases() async {
    if (!_isInitialized || _isCheckingReleases) return;

    try {
      _isCheckingReleases = true;
      notifyListeners();

      final favorites = _favoritesController.favorites;
      await _releaseCheckService.checkAllReleases(favorites);

      debugPrint('🔍 Verificação de lançamentos executada com sucesso');

    } catch (e) {
      debugPrint('❌ Erro ao verificar lançamentos: $e');
    } finally {
      _isCheckingReleases = false;
      notifyListeners();
    }
  }

  /// Atualiza configurações de notificação
  Future<void> updateNotificationSettings({
    bool? notificationsEnabled,
    bool? movieReleasesEnabled,
    bool? tvShowEpisodesEnabled,
  }) async {
    await _notificationService.updateSettings(
      notificationsEnabled: notificationsEnabled,
      movieReleasesEnabled: movieReleasesEnabled,
      tvShowEpisodesEnabled: tvShowEpisodesEnabled,
    );

    notifyListeners();
    debugPrint('⚙️ Configurações de notificação atualizadas');
  }

  /// Obtém configurações atuais
  bool get notificationsEnabled => _notificationService.notificationsEnabled;
  bool get movieReleasesEnabled => _notificationService.movieReleasesEnabled;
  bool get tvShowEpisodesEnabled => _notificationService.tvShowEpisodesEnabled;

  /// Cancela todas as notificações agendadas
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    debugPrint('🗑️ Todas as notificações canceladas');
  }

  /// Agenda verificação periódica de lançamentos
  Future<void> schedulePeriodicReleaseCheck() async {
    // Esta função pode ser chamada por um timer ou WorkManager
    // Por enquanto, apenas executa uma verificação
    await checkReleases();
  }

  /// Testa notificação (para debug)
  Future<void> testNotification() async {
    await _notificationService.showLocalNotification(
      title: '🧪 Teste de Notificação',
      body: 'Esta é uma notificação de teste do Rollflix!',
      payload: jsonEncode({'type': 'test'}),
    );
    debugPrint('🧪 Notificação de teste enviada');
  }

  @override
  void dispose() {
    _favoritesController.removeListener(_onFavoritesChanged);
    super.dispose();
  }
}