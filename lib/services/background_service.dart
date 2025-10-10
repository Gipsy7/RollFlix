import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/favorites_controller.dart';
import '../services/release_check_service.dart';
import '../services/notification_service.dart';

/// Serviço para execução de tarefas em background
/// Usa WorkManager para verificar lançamentos periodicamente
class BackgroundService {
  static const String _taskName = 'checkReleases';
  static const String _uniqueTaskName = 'periodicReleaseCheck';
  
  /// Inicializa o WorkManager e registra tarefas
  static Future<void> initialize() async {
    try {
      // Inicializar WorkManager
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );
      
      debugPrint('✅ BackgroundService inicializado');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar BackgroundService: $e');
    }
  }
  
  /// Registra tarefa periódica de verificação de lançamentos
  static Future<void> registerPeriodicTask() async {
    try {
      // Cancelar tarefas anteriores para evitar duplicatas
      await Workmanager().cancelByUniqueName(_uniqueTaskName);
      
      // Registrar tarefa periódica (executa a cada 6 horas)
      await Workmanager().registerPeriodicTask(
        _uniqueTaskName,
        _taskName,
        frequency: const Duration(hours: 6), // Mínimo permitido: 15 min
        constraints: Constraints(
          networkType: NetworkType.connected, // Requer internet
          requiresBatteryNotLow: true, // Não executar com bateria baixa
          requiresCharging: false, // Pode executar sem estar carregando
        ),
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: const Duration(minutes: 15),
      );
      
      debugPrint('✅ Tarefa periódica registrada (a cada 6h)');
    } catch (e) {
      debugPrint('❌ Erro ao registrar tarefa periódica: $e');
    }
  }
  
  /// Cancela todas as tarefas em background
  static Future<void> cancelAllTasks() async {
    try {
      await Workmanager().cancelAll();
      debugPrint('🗑️ Todas as tarefas em background canceladas');
    } catch (e) {
      debugPrint('❌ Erro ao cancelar tarefas: $e');
    }
  }
  
  /// Cancela apenas a tarefa de verificação de lançamentos
  static Future<void> cancelReleaseCheckTask() async {
    try {
      await Workmanager().cancelByUniqueName(_uniqueTaskName);
      debugPrint('🗑️ Tarefa de verificação cancelada');
    } catch (e) {
      debugPrint('❌ Erro ao cancelar tarefa: $e');
    }
  }
  
  /// Registra tarefa única (executa uma vez)
  static Future<void> scheduleOneTimeTask() async {
    try {
      await Workmanager().registerOneOffTask(
        'oneTimeCheck',
        _taskName,
        initialDelay: const Duration(minutes: 1),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
      
      debugPrint('✅ Tarefa única agendada');
    } catch (e) {
      debugPrint('❌ Erro ao agendar tarefa única: $e');
    }
  }
}

/// Callback dispatcher executado em background
/// IMPORTANTE: Esta função DEVE ser top-level (não pode estar dentro de uma classe)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('🔄 Executando tarefa em background: $task');
    
    try {
      // Verificar se notificações estão habilitadas
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      
      if (!notificationsEnabled) {
        debugPrint('⏭️ Notificações desabilitadas, pulando verificação');
        return Future.value(true);
      }
      
      // Inicializar serviços necessários
      await _initializeServices();
      
      // Carregar favoritos do controller (já carrega automaticamente no construtor)
      final favoritesController = FavoritesController.instance;
      final favorites = favoritesController.favorites;
      
      if (favorites.isEmpty) {
        debugPrint('⏭️ Nenhum favorito para verificar');
        return Future.value(true);
      }
      
      debugPrint('🔍 Verificando ${favorites.length} favoritos em background...');
      
      // Executar verificação de lançamentos
      final releaseCheckService = ReleaseCheckService.instance;
      await releaseCheckService.checkAllReleases(favorites);
      
      debugPrint('✅ Verificação em background concluída com sucesso');
      return Future.value(true);
      
    } catch (e, stackTrace) {
      debugPrint('❌ Erro na tarefa em background: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Retornar false indica falha, mas não cancela a tarefa periódica
      return Future.value(false);
    }
  });
}

/// Inicializa serviços necessários para execução em background
Future<void> _initializeServices() async {
  try {
    // NotificationService já deve estar inicializado, mas garantir
    final notificationService = NotificationService.instance;
    await notificationService.initialize();
    
    debugPrint('✅ Serviços inicializados para background');
  } catch (e) {
    debugPrint('❌ Erro ao inicializar serviços em background: $e');
  }
}
