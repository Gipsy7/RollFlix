import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/watched_controller.dart';
import '../controllers/user_preferences_controller.dart';
import '../controllers/movie_controller.dart';
import '../controllers/tv_show_controller.dart';

/// Serviço para agrupar operações de sessão (logout e limpeza de cache local)
class SessionService {
  /// Flag que indica se a sincronização inicial com a nuvem foi concluída
  /// para a sessão atual. Enquanto for `false`, gravar no Firestore deve
  /// ser evitado para impedir sobrescritas acidentais.
  static bool initialCloudSyncCompleted = false;
  /// Faz logout do usuário (Firebase + Google) e limpa caches locais.
  static Future<void> signOutAndClearCache() async {
    try {
      // Primeiro, faz o logout (desvincula providers)
      await AuthService.signOut();
      debugPrint('🔒 AuthService.signOut concluído');
    } catch (e) {
      debugPrint('⚠️ Erro ao fazer signOut (continuando com limpeza local): $e');
    }

    // Depois que o usuário foi desconectado, limpe caches locais e prefs
    // Reset flag to ensure next login performs central sync
    initialCloudSyncCompleted = false;
    await clearLocalCaches();
  }

  /// Limpa o cache local (SharedPreferences, caches de repositório e singletons).
  /// Uso: ao deslogar ou na finalização do app.
  static Future<void> clearLocalCaches() async {
    try {
      debugPrint('🧹 Limpando caches locais (controllers + shared prefs)');

      // Limpa estados em memória e salva alterações localmente
      try {
        await FavoritesController.instance.clearAll();
      } catch (e) {
        debugPrint('⚠️ Erro ao limpar FavoritesController: $e');
      }

      try {
        await WatchedController.instance.clearAll();
      } catch (e) {
        debugPrint('⚠️ Erro ao limpar WatchedController: $e');
      }

      try {
        await UserPreferencesController.instance.clearLocalData();
      } catch (e) {
        debugPrint('⚠️ Erro ao limpar UserPreferencesController: $e');
      }

      // Limpa caches de repositório/controllers relacionados a filmes/séries
      try {
        MovieController.instance.clearCache();
      } catch (e) {
        debugPrint('⚠️ Erro ao limpar MovieController cache: $e');
      }
      try {
        TVShowController.instance.clearCache();
      } catch (e) {
        debugPrint('⚠️ Erro ao limpar TVShowController cache: $e');
      }

      // Remove chaves conhecidas do SharedPreferences para garantir limpeza
      final prefs = await SharedPreferences.getInstance();
      final keysToRemove = [
        'rollflix_favorites',
        'rollflix_watched',
        'rollflix_roll_preferences',
        'rollflix_date_night_preferences',
        'rollflix_roll_stats',
        'rollflix_user_resources',
      ];

      for (final k in keysToRemove) {
        try {
          await prefs.remove(k);
        } catch (e) {
          debugPrint('⚠️ Erro ao remover chave $k do SharedPreferences: $e');
        }
      }

      debugPrint('✅ Limpeza local concluída');
    } catch (e) {
      debugPrint('❌ Erro ao limpar caches locais: $e');
    }
  }
}
