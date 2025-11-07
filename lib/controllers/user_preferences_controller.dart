import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/roll_preferences.dart';
import '../models/date_night_preferences.dart';
import '../services/user_data_service.dart';
import '../services/auth_service.dart';
import '../services/ad_service.dart';
import '../services/subscription_service.dart';
import '../theme/app_theme.dart';
import 'app_mode_controller.dart';
import 'locale_controller.dart';
import 'package:rollflix/l10n/app_localizations.dart';

/// Controller para gerenciar preferências do usuário
/// Singleton pattern para garantir instância única
class UserPreferencesController extends ChangeNotifier {
  static final UserPreferencesController _instance = UserPreferencesController._internal();
  static UserPreferencesController get instance => _instance;

  factory UserPreferencesController() => _instance;

  UserPreferencesController._internal() {
    _loadPreferences();
    _initializeAdService();
  }

  // Instância do serviço de anúncios
  final AdService _adService = AdService();

  /// Inicializa o serviço de anúncios e pré-carrega anúncio
  void _initializeAdService() {
    if (_adService.isInitialized) {
      _adService.loadRewardedAd();
    }
  }

  @override
  void dispose() {
    _adService.dispose();
    super.dispose();
  }

  // Chaves para SharedPreferences
  static const String _rollPreferencesKey = 'rollflix_roll_preferences';
  static const String _dateNightPreferencesKey = 'rollflix_date_night_preferences';
  static const String _rollStatsKey = 'rollflix_roll_stats';
  static const String _userResourcesKey = 'rollflix_user_resources';

  // Preferências
  RollPreferences _rollPreferences = const RollPreferences();
  DateNightPreferences _dateNightPreferences = const DateNightPreferences();
  RollStats _rollStats = const RollStats();
  UserResources _userResources = const UserResources();

  // Getters
  RollPreferences get rollPreferences => _rollPreferences;
  DateNightPreferences get dateNightPreferences => _dateNightPreferences;
  RollStats get rollStats => _rollStats;
  UserResources get userResources => _userResources;

  /// Carrega preferências do armazenamento (Firebase se logado, senão SharedPreferences)
  Future<void> _loadPreferences() async {
    try {
      // Se usuário está logado, carrega do Firebase
      if (AuthService.isUserLoggedIn()) {
        await Future.wait([
          _loadRollPreferencesFromCloud(),
          _loadDateNightPreferencesFromCloud(),
          _loadRollStatsFromCloud(),
          _loadUserResourcesFromCloud(),
        ]);
        debugPrint('✅ Preferências carregadas do Firebase');
          // Após carregar recursos, tenta recarregar recursos expirados (caso passaram 24h)
          await tryReloadResources();
      } else {
        // Senão, carrega do SharedPreferences
        await Future.wait([
          _loadRollPreferencesFromLocal(),
          _loadDateNightPreferencesFromLocal(),
          _loadRollStatsFromLocal(),
          _loadUserResourcesFromLocal(),
        ]);
        debugPrint('✅ Preferências carregadas do SharedPreferences');
        // Após carregar recursos locais, tenta recarregar recursos expirados
        await tryReloadResources();
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar preferências: $e');
    }
  }

  // ==================== ROLL PREFERENCES ====================

  Future<void> _loadRollPreferencesFromCloud() async {
    try {
      final prefs = await UserDataService.loadRollPreferences();
      _rollPreferences = prefs ?? const RollPreferences();
    } catch (e) {
      debugPrint('❌ Erro ao carregar roll preferences do Firebase: $e');
      _rollPreferences = const RollPreferences();
    }
  }

  Future<void> _loadRollPreferencesFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rollPrefsJson = prefs.getString(_rollPreferencesKey);

      if (rollPrefsJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(rollPrefsJson);
        _rollPreferences = RollPreferences.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar roll preferences locais: $e');
      _rollPreferences = const RollPreferences();
    }
  }

  Future<void> updateRollPreferences(RollPreferences newPreferences) async {
    _rollPreferences = newPreferences;
    notifyListeners();

    try {
      if (AuthService.isUserLoggedIn()) {
        await UserDataService.saveRollPreferences(newPreferences);
        debugPrint('✅ Roll preferences salvas no Firebase');
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_rollPreferencesKey, jsonEncode(newPreferences.toJson()));
        debugPrint('✅ Roll preferences salvas localmente');
      }
    } catch (e) {
      debugPrint('❌ Erro ao salvar roll preferences: $e');
      rethrow;
    }
  }

  // ==================== DATE NIGHT PREFERENCES ====================

  Future<void> _loadDateNightPreferencesFromCloud() async {
    try {
      final prefs = await UserDataService.loadDateNightPreferences();
      _dateNightPreferences = prefs ?? const DateNightPreferences();
    } catch (e) {
      debugPrint('❌ Erro ao carregar date night preferences do Firebase: $e');
      _dateNightPreferences = const DateNightPreferences();
    }
  }

  Future<void> _loadDateNightPreferencesFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateNightPrefsJson = prefs.getString(_dateNightPreferencesKey);

      if (dateNightPrefsJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(dateNightPrefsJson);
        _dateNightPreferences = DateNightPreferences.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar date night preferences locais: $e');
      _dateNightPreferences = const DateNightPreferences();
    }
  }

  Future<void> updateDateNightPreferences(DateNightPreferences newPreferences) async {
    _dateNightPreferences = newPreferences;
    notifyListeners();

    try {
      if (AuthService.isUserLoggedIn()) {
        await UserDataService.saveDateNightPreferences(newPreferences);
        debugPrint('✅ Date night preferences salvas no Firebase');
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_dateNightPreferencesKey, jsonEncode(newPreferences.toJson()));
        debugPrint('✅ Date night preferences salvas localmente');
      }
    } catch (e) {
      debugPrint('❌ Erro ao salvar date night preferences: $e');
      rethrow;
    }
  }

  // ==================== ROLL STATS ====================

  Future<void> _loadRollStatsFromCloud() async {
    try {
      final stats = await UserDataService.loadRollStats();
      _rollStats = stats ?? const RollStats();
    } catch (e) {
      debugPrint('❌ Erro ao carregar roll stats do Firebase: $e');
      _rollStats = const RollStats();
    }
  }

  Future<void> _loadRollStatsFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rollStatsJson = prefs.getString(_rollStatsKey);

      if (rollStatsJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(rollStatsJson);
        _rollStats = RollStats.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar roll stats locais: $e');
      _rollStats = const RollStats();
    }
  }

  Future<void> updateRollStats(RollStats newStats) async {
    _rollStats = newStats;
    notifyListeners();

    try {
      if (AuthService.isUserLoggedIn()) {
        await UserDataService.saveRollStats(newStats);
        debugPrint('✅ Roll stats salvas no Firebase');
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_rollStatsKey, jsonEncode(newStats.toJson()));
        debugPrint('✅ Roll stats salvas localmente');
      }
    } catch (e) {
      debugPrint('❌ Erro ao salvar roll stats: $e');
      rethrow;
    }
  }

  /// Incrementa contador de sorteios
  Future<void> incrementRollCount(bool isSeries) async {
    final newStats = _rollStats.copyWith(
      totalRolls: _rollStats.totalRolls + 1,
      movieRolls: isSeries ? _rollStats.movieRolls : _rollStats.movieRolls + 1,
      seriesRolls: isSeries ? _rollStats.seriesRolls + 1 : _rollStats.seriesRolls,
    );
    await updateRollStats(newStats);
  }

  /// Incrementa contador de date nights
  Future<void> incrementDateNightCount() async {
    final newStats = _rollStats.copyWith(
      dateNightCount: _rollStats.dateNightCount + 1,
    );
    await updateRollStats(newStats);
  }

  /// Sincroniza preferências após login (similar aos favoritos)
  Future<void> syncAfterLogin() async {
    try {
      debugPrint('🔄 Sincronizando preferências após login...');

      // Carrega dados da nuvem (incluindo recursos!)
      await Future.wait([
        _loadRollPreferencesFromCloud(),
        _loadDateNightPreferencesFromCloud(),
        _loadRollStatsFromCloud(),
        _loadUserResourcesFromCloud(), // ← FIX: Adiciona reload de recursos
        _loadAppSettingsFromCloud(), // ← Adiciona carregamento das configurações do app
      ]);

      notifyListeners();
      debugPrint('✅ Preferências sincronizadas após login');
    } catch (e) {
      debugPrint('❌ Erro ao sincronizar preferências: $e');
    }
  }

  /// Limpa dados locais (usado no logout)
  Future<void> clearLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_rollPreferencesKey),
        prefs.remove(_dateNightPreferencesKey),
        prefs.remove(_rollStatsKey),
        prefs.remove(_userResourcesKey), // ← Adiciona remoção de recursos
      ]);

      // Reseta para valores padrão
      _rollPreferences = const RollPreferences();
      _dateNightPreferences = const DateNightPreferences();
      _rollStats = const RollStats();
      _userResources = const UserResources();

      notifyListeners();
      debugPrint('✅ Dados locais de preferências limpos');
    } catch (e) {
      debugPrint('❌ Erro ao limpar dados locais de preferências: $e');
    }
  }

  /// Reseta o controller para estado inicial (sem dispose - para singletons)
  void reset() {
    _rollPreferences = const RollPreferences();
    _dateNightPreferences = const DateNightPreferences();
    _rollStats = const RollStats();
    _userResources = const UserResources();
    notifyListeners();
    debugPrint('♻️ UserPreferencesController resetado para estado inicial');
  }

  // ==================== USER RESOURCES ====================

  Future<void> _loadUserResourcesFromCloud() async {
    try {
      final resources = await UserDataService.loadUserResources();
      _userResources = resources ?? const UserResources();
    } catch (e) {
      debugPrint('❌ Erro ao carregar user resources do Firebase: $e');
      _userResources = const UserResources();
    }
  }

  Future<void> _loadUserResourcesFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resourcesJson = prefs.getString(_userResourcesKey);

      if (resourcesJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(resourcesJson);
        _userResources = UserResources.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar user resources locais: $e');
      _userResources = const UserResources();
    }
  }

  Future<void> updateUserResources(UserResources newResources) async {
    debugPrint('📝 updateUserResources - Antes: roll=${_userResources.rollUses}, favorite=${_userResources.favoriteUses}, watched=${_userResources.watchedUses}');
    debugPrint('📝 updateUserResources - Depois: roll=${newResources.rollUses}, favorite=${newResources.favoriteUses}, watched=${newResources.watchedUses}');
    
    _userResources = newResources;
    notifyListeners();

    try {
      if (AuthService.isUserLoggedIn()) {
        await UserDataService.saveUserResources(newResources);
        debugPrint('✅ User resources salvas no Firebase');
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userResourcesKey, jsonEncode(newResources.toJson()));
        debugPrint('✅ User resources salvas localmente');
      }
    } catch (e) {
      debugPrint('❌ Erro ao salvar user resources: $e');
      rethrow;
    }
  }

  /// Consome um recurso específico e retorna se foi bem-sucedido
  Future<bool> consumeResource(ResourceType type) async {
    if (!_userResources.canUseResource(type)) {
      debugPrint('⚠️ consumeResource: Não pode usar ${type.name} - recursos: ${_userResources.getUses(type)}');
      return false;
    }

    debugPrint('🔽 consumeResource: Consumindo ${type.name} - antes: ${_userResources.getUses(type)}');
    final newResources = _userResources.consumeResource(type);
    await updateUserResources(newResources);
    debugPrint('✅ consumeResource: ${type.name} consumido - depois: ${_userResources.getUses(type)}');
    return true;
  }

  /// Verifica se um recurso pode ser usado
  bool canUseResource(ResourceType type) {
    return _userResources.canUseResource(type);
  }

  /// Obtém o tempo restante para recarga de um recurso (em segundos)
  Duration? getResourceCooldown(ResourceType type) {
    return _userResources.getCooldownTime(type);
  }

  // ==================== APP SETTINGS ====================

  Future<void> _loadAppSettingsFromCloud() async {
    try {
      final settings = await UserDataService.loadAppSettings();
      if (settings != null) {
        // Aplica as configurações carregadas nos controllers respectivos
        final localeCode = settings['localeCode'] as String?;
        final isSeriesMode = settings['isSeriesMode'] as bool? ?? false;
        final selectedGenre = settings['selectedGenre'] as String?;

        if (localeCode != null) {
          // Atualiza o LocaleController, mas NÃO re-salva no Firebase para
          // evitar sobrescrever outras configurações carregadas nesta mesma
          // operação de sincronização.
          await LocaleController.instance.setLocale(localeCode, saveToCloud: false);
        }

        // Atualiza o AppModeController
        AppModeController.instance.setSeriesMode(isSeriesMode);
        if (selectedGenre != null) {
          AppModeController.instance.selectGenre(selectedGenre);
        }

        debugPrint('✅ App settings aplicadas do Firebase: locale=$localeCode, isSeriesMode=$isSeriesMode, selectedGenre=$selectedGenre');
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar app settings do Firebase: $e');
    }
  }

  /// Salva configurações do app (chamado pelos controllers específicos)
  Future<void> saveAppSettings({
    String? localeCode,
    bool? isSeriesMode,
    String? selectedGenre,
  }) async {
    try {
      if (AuthService.isUserLoggedIn()) {
        await UserDataService.saveAppSettings(
          localeCode: localeCode,
          isSeriesMode: isSeriesMode ?? false,
          selectedGenre: selectedGenre,
        );
        debugPrint('✅ App settings salvas no Firebase');
      } else {
        // Se não estiver logado, as configurações são salvas localmente pelos controllers individuais
        debugPrint('ℹ️ Usuário não logado - app settings serão salvas localmente pelos controllers');
      }
    } catch (e) {
      debugPrint('❌ Erro ao salvar app settings: $e');
      rethrow;
    }
  }

  /// Tenta recarregar recursos se o cooldown expirou
  Future<void> tryReloadResources() async {
    debugPrint('🔄 tryReloadResources - Recursos atuais: roll=${_userResources.rollUses}, favorite=${_userResources.favoriteUses}, watched=${_userResources.watchedUses}');
    debugPrint('   Cooldowns: roll=${_userResources.rollCooldownEnd}, favorite=${_userResources.favoriteCooldownEnd}, watched=${_userResources.watchedCooldownEnd}');
    // Apenas recarregar recursos para contas FREE. Usuários assinantes têm recursos ilimitados.
    if (SubscriptionService.isSubscribedCached) {
      debugPrint('🔒 tryReloadResources - Usuário assinante; pulando recarga de recursos');
      return;
    }

    final newResources = _userResources.tryReloadExpired();
    if (newResources != _userResources) {
      debugPrint('⚡ Cooldown expirado! Recarregando recursos...');
      await updateUserResources(newResources);
    } else {
      debugPrint('✓ Nenhum recurso para recarregar (cooldown ativo ou recursos disponíveis)');
    }
  }

  // ==================== INTEGRAÇÃO COM ANÚNCIOS ====================

  /// Tenta usar recurso - se não tiver disponível, oferece assistir anúncio
  /// Tenta usar recurso - se não tiver disponível, oferece assistir anúncio.
  ///
  /// Se [onSuccessAfterAd] for fornecido, ele será executado automaticamente
  /// após o usuário assistir o anúncio e o recurso ser concedido/consumido.
  Future<bool> tryUseResourceWithAd(
    ResourceType type,
    BuildContext context, {
    Future<void> Function()? onSuccessAfterAd,
  }) async {
    debugPrint('🎯 tryUseResourceWithAd: ${type.name} - Recursos atuais: ${_userResources.getUses(type)}');
    
    // Primeiro tenta recarregar recursos expirados
    await tryReloadResources();

    // Because we awaited above, ensure the passed BuildContext is still
    // valid before using it (prevents use_build_context_synchronously lints).
    if (!context.mounted) {
      debugPrint('⚠️ Context no longer mounted after tryReloadResources - aborting ad flow');
      return false;
    }

    // Verifica se pode usar o recurso normalmente
    if (canUseResource(type)) {
      debugPrint('✅ Recurso disponível - consumindo...');
      final consumed = await consumeResource(type);
      debugPrint('📊 Após consumo: ${_userResources.getUses(type)} recursos restantes');
      return consumed;
    }

    debugPrint('❌ Sem recursos - oferecendo anúncio...');
    
    // Sem recursos - oferece assistir anúncio
    final adWatched = await _showAdOfferDialog(context, type);
    
    // Se assistiu o anúncio e ganhou o recurso, consome ele para a ação
    if (adWatched && canUseResource(type)) {
      debugPrint('🎁 Anúncio assistido - consumindo recurso ganho...');
      final consumed = await consumeResource(type);
      debugPrint('📊 Após consumo do recurso ganho: ${_userResources.getUses(type)} recursos restantes');

      // Se um callback foi fornecido para executar a ação imediatamente
      if (consumed && onSuccessAfterAd != null) {
        try {
          await onSuccessAfterAd();
        } catch (e) {
          debugPrint('❌ Erro ao executar ação pós-anúncio: $e');
        }
      }

      return consumed;
    }
    
    debugPrint('⛔ Anúncio não assistido ou recurso não disponível');
    return false;
  }

  /// Assiste anúncio para ganhar recurso (usado quando clica no contador)
  Future<bool> watchAdForResource(
    ResourceType type,
    BuildContext context,
  ) async {
    // Mostra anúncio diretamente e concede recompensa
    return await _showAdAndReward(context, type);
  }

  /// Mostra diálogo oferecendo assistir anúncio para ganhar recurso
  Future<bool> _showAdOfferDialog(
    BuildContext context,
    ResourceType type,
  ) async {
    final resourceName = _getResourceName(type);
    final cooldown = getResourceCooldown(type);
    
    // Detecta o modo atual (série ou filme)
    final appModeController = AppModeController.instance;
    final isSeriesMode = appModeController.isSeriesMode;
    
    // Define cores baseadas no modo
    final accentColor = isSeriesMode 
        ? const Color.fromARGB(255, 240, 43, 109) // Roxo/Rosa vibrante para séries
        : AppColors.primary; // Dourado para filmes
    
    // cooldown handled below in the content section

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.videocam, color: accentColor, size: 28),
            const SizedBox(width: 12),
            // Protege título longo com Expanded para evitar overflow
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.earnExtraResource,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 120, maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main message - usa Flexible para truncar corretamente em telas pequenas
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.noResourceAvailable(resourceName),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Mostra cooldown em linha separada, se houver
              if (cooldown != null) ...[
                const SizedBox(height: 8),
                Text(
                  '⏱️ ${cooldown.inHours.toString().padLeft(2, '0')}:${cooldown.inMinutes.remainder(60).toString().padLeft(2, '0')}h ${AppLocalizations.of(context)!.reloading}',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard, color: accentColor, size: 24),
                    const SizedBox(width: 12),
                    // Usa Flexible para evitar overflow do texto localizado
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.watchAdForExtraResource(resourceName),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.play_circle_filled),
            label: Text(AppLocalizations.of(context)!.watchAd),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: isSeriesMode ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );

    if (result != true) return false;

    // Check if context is still valid before using it
    if (!context.mounted) return false;

    // Usuário aceitou - mostra o anúncio
    return await _showAdAndReward(context, type);
  }

  /// Mostra anúncio e concede recompensa se assistir completamente
  Future<bool> _showAdAndReward(
    BuildContext context,
    ResourceType type,
  ) async {
    bool rewardGranted = false;

    // Detecta o modo atual para cores
    final appModeController = AppModeController.instance;
    final isSeriesMode = appModeController.isSeriesMode;
    final accentColor = isSeriesMode 
        ? const Color.fromARGB(255, 240, 43, 109) 
        : AppColors.primary;

    // Configura callback para quando o anúncio for assistido
    _adService.onAdWatched = (rewardType) {
      if (rewardType == _mapResourceTypeToAdReward(type)) {
        _grantAdReward(type);
        rewardGranted = true;
      }
    };

    // Se o usuário tem assinatura ativa, conceda a recompensa sem mostrar anúncios
    if (SubscriptionService.isSubscribedCached) {
      debugPrint('🔁 Usuário assinante - concedendo recompensa sem ad');
      _grantAdReward(type);
      return true;
    }

    // Mostra loading personalizado
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            minWidth: 120,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    color: accentColor,
                    strokeWidth: 3,
                  ),
                ),
                Icon(
                  Icons.play_circle_filled,
                  color: accentColor,
                  size: 36,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Mostra o anúncio
    final adRewardType = _mapResourceTypeToAdReward(type);
    final shown = await _adService.showRewardedAd(adRewardType);

    // Remove loading
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (!shown) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(AppLocalizations.of(context)!.adNotAvailable),
                ),
              ],
            ),
            backgroundColor: AppColors.backgroundDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      return false;
    }

    // The AdService now completes only after the reward/dismiss events,
    // so when this line runs the rewardGranted flag is already accurate.
    if (rewardGranted && context.mounted) {
      final resourceName = _getResourceName(type);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '🎁 Você ganhou 1 $resourceName extra!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.backgroundDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return rewardGranted;
  }

  /// Concede recompensa do anúncio (adiciona 1 recurso extra)
  void _grantAdReward(ResourceType type) {
    final current = _userResources.getUses(type);
    debugPrint('🎁 _grantAdReward CHAMADO - Tipo: ${type.name}, Recursos antes: $current');
    
    // Adiciona 1 recurso extra e LIMPA o cooldown (já que tem recurso disponível)
    UserResources newResources;
    switch (type) {
      case ResourceType.roll:
        newResources = _userResources.copyWith(
          rollUses: current + 1,
          clearRollCooldown: true, // ← FIX: Usa flag para limpar cooldown
        );
        break;
      case ResourceType.favorite:
        newResources = _userResources.copyWith(
          favoriteUses: current + 1,
          clearFavoriteCooldown: true, // ← FIX: Usa flag para limpar cooldown
        );
        break;
      case ResourceType.watched:
        newResources = _userResources.copyWith(
          watchedUses: current + 1,
          clearWatchedCooldown: true, // ← FIX: Usa flag para limpar cooldown
        );
        break;
    }

    _userResources = newResources;
    _saveResources();
    notifyListeners();

    debugPrint('🎁 Recompensa concedida: +1 ${type.name} (Total: ${_userResources.getUses(type)}, Cooldown limpo)');
  }

  /// Salva recursos (helper method)
  Future<void> _saveResources() async {
    try {
      if (AuthService.isUserLoggedIn()) {
        await UserDataService.saveUserResources(_userResources);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userResourcesKey, jsonEncode(_userResources.toJson()));
      }
    } catch (e) {
      debugPrint('❌ Erro ao salvar recursos: $e');
    }
  }

  /// Mapeia ResourceType para AdRewardType
  AdRewardType _mapResourceTypeToAdReward(ResourceType type) {
    switch (type) {
      case ResourceType.roll:
        return AdRewardType.roll;
      case ResourceType.favorite:
        return AdRewardType.favorite;
      case ResourceType.watched:
        return AdRewardType.watched;
    }
  }

  /// Retorna o nome do recurso em português
  String _getResourceName(ResourceType type) {
    switch (type) {
      case ResourceType.roll:
        return 'rolagem';
      case ResourceType.favorite:
        return 'favorito';
      case ResourceType.watched:
        return 'assistido';
    }
  }
}

/// Tipos de recursos disponíveis
enum ResourceType {
  roll,
  favorite,
  watched,
}

/// Modelo para recursos do usuário com sistema de recarga
class UserResources {
  final int rollUses;
  final int favoriteUses;
  final int watchedUses;
  final DateTime? rollCooldownEnd;
  final DateTime? favoriteCooldownEnd;
  final DateTime? watchedCooldownEnd;
  final DateTime? lastUsedRoll;
  final DateTime? lastUsedFavorite;
  final DateTime? lastUsedWatched;

  static const int maxUses = 5;
  static const Duration cooldownDuration = Duration(hours: 24);

  const UserResources({
    this.rollUses = maxUses,
    this.favoriteUses = maxUses,
    this.watchedUses = maxUses,
    this.rollCooldownEnd,
    this.favoriteCooldownEnd,
    this.watchedCooldownEnd,
    this.lastUsedRoll,
    this.lastUsedFavorite,
    this.lastUsedWatched,
  });

  UserResources copyWith({
    int? rollUses,
    int? favoriteUses,
    int? watchedUses,
    DateTime? rollCooldownEnd,
    DateTime? favoriteCooldownEnd,
    DateTime? watchedCooldownEnd,
    DateTime? lastUsedRoll,
    DateTime? lastUsedFavorite,
    DateTime? lastUsedWatched,
    bool clearRollCooldown = false,      // ← FIX: Flag para limpar cooldown explicitamente
    bool clearFavoriteCooldown = false,  // ← FIX: Flag para limpar cooldown explicitamente
    bool clearWatchedCooldown = false,   // ← FIX: Flag para limpar cooldown explicitamente
  }) {
    return UserResources(
      rollUses: rollUses ?? this.rollUses,
      favoriteUses: favoriteUses ?? this.favoriteUses,
      watchedUses: watchedUses ?? this.watchedUses,
      rollCooldownEnd: clearRollCooldown ? null : (rollCooldownEnd ?? this.rollCooldownEnd),
      favoriteCooldownEnd: clearFavoriteCooldown ? null : (favoriteCooldownEnd ?? this.favoriteCooldownEnd),
      watchedCooldownEnd: clearWatchedCooldown ? null : (watchedCooldownEnd ?? this.watchedCooldownEnd),
      lastUsedRoll: lastUsedRoll ?? this.lastUsedRoll,
      lastUsedFavorite: lastUsedFavorite ?? this.lastUsedFavorite,
      lastUsedWatched: lastUsedWatched ?? this.lastUsedWatched,
    );
  }

  /// Verifica se um recurso pode ser usado
  bool canUseResource(ResourceType type) {
    // Se o usuário é assinante, sempre pode usar recursos (ilimitado)
    if (SubscriptionService.isSubscribedCached) return true;

    switch (type) {
      case ResourceType.roll:
        return rollUses > 0;
      case ResourceType.favorite:
        return favoriteUses > 0;
      case ResourceType.watched:
        return watchedUses > 0;
    }
  }

  /// Consome um recurso e inicia cooldown se necessário
  UserResources consumeResource(ResourceType type) {
    // Se o usuário é assinante, não consome recursos (ilimitado)
    if (SubscriptionService.isSubscribedCached) return this;

    switch (type) {
      case ResourceType.roll:
        if (rollUses <= 0) return this;
        final newUses = rollUses - 1;
        return copyWith(
          rollUses: newUses,
          rollCooldownEnd: newUses == 0 ? DateTime.now().add(cooldownDuration) : null,
          clearRollCooldown: newUses > 0, // ← FIX: Limpa cooldown quando ainda tem recursos
          lastUsedRoll: DateTime.now(),
        );
      case ResourceType.favorite:
        if (favoriteUses <= 0) return this;
        final newUses = favoriteUses - 1;
        return copyWith(
          favoriteUses: newUses,
          favoriteCooldownEnd: newUses == 0 ? DateTime.now().add(cooldownDuration) : null,
          clearFavoriteCooldown: newUses > 0, // ← FIX: Limpa cooldown quando ainda tem recursos
          lastUsedFavorite: DateTime.now(),
        );
      case ResourceType.watched:
        if (watchedUses <= 0) return this;
        final newUses = watchedUses - 1;
        return copyWith(
          watchedUses: newUses,
          watchedCooldownEnd: newUses == 0 ? DateTime.now().add(cooldownDuration) : null,
          clearWatchedCooldown: newUses > 0, // ← FIX: Limpa cooldown quando ainda tem recursos
          lastUsedWatched: DateTime.now(),
        );
    }
  }

  /// Obtém o tempo restante para recarga de um recurso
  Duration? getCooldownTime(ResourceType type) {
    final now = DateTime.now();
    switch (type) {
      case ResourceType.roll:
        if (rollCooldownEnd != null && rollCooldownEnd!.isAfter(now)) {
          return rollCooldownEnd!.difference(now);
        }
        break;
      case ResourceType.favorite:
        if (favoriteCooldownEnd != null && favoriteCooldownEnd!.isAfter(now)) {
          return favoriteCooldownEnd!.difference(now);
        }
        break;
      case ResourceType.watched:
        if (watchedCooldownEnd != null && watchedCooldownEnd!.isAfter(now)) {
          return watchedCooldownEnd!.difference(now);
        }
        break;
    }
    return null;
  }

  /// Tenta recarregar recursos cujos cooldowns expiraram
  UserResources tryReloadExpired() {
    final now = DateTime.now();
    var updated = this;

    debugPrint('🔍 tryReloadExpired - Estado inicial:');
    debugPrint('   roll: $rollUses (cooldown: $rollCooldownEnd)');
    debugPrint('   favorite: $favoriteUses (cooldown: $favoriteCooldownEnd)');
    debugPrint('   watched: $watchedUses (cooldown: $watchedCooldownEnd)');

    // New behavior: For free accounts, if 24h passed since last use of a resource,
    // reload it to maxUses. If the user never used the resource (lastUsed == null),
    // we keep the current value.
    if (lastUsedRoll != null) {
      final diff = now.difference(lastUsedRoll!);
      if (diff >= cooldownDuration) {
        debugPrint('   ⚡ Recarregando ROLL via lastUsed (diff=${diff.inHours}h): $rollUses → $maxUses');
        updated = updated.copyWith(rollUses: maxUses, clearRollCooldown: true, lastUsedRoll: null);
      }
    }

    if (lastUsedFavorite != null) {
      final diff = now.difference(lastUsedFavorite!);
      if (diff >= cooldownDuration) {
        debugPrint('   ⚡ Recarregando FAVORITE via lastUsed (diff=${diff.inHours}h): $favoriteUses → $maxUses');
        updated = updated.copyWith(favoriteUses: maxUses, clearFavoriteCooldown: true, lastUsedFavorite: null);
      }
    }

    if (lastUsedWatched != null) {
      final diff = now.difference(lastUsedWatched!);
      if (diff >= cooldownDuration) {
        debugPrint('   ⚡ Recarregando WATCHED via lastUsed (diff=${diff.inHours}h): $watchedUses → $maxUses');
        updated = updated.copyWith(watchedUses: maxUses, clearWatchedCooldown: true, lastUsedWatched: null);
      }
    }

    debugPrint('🔍 tryReloadExpired - Estado final:');
    debugPrint('   roll: ${updated.rollUses}, favorite: ${updated.favoriteUses}, watched: ${updated.watchedUses}');

    return updated;
  }

  /// Obtém o número de usos disponíveis para um recurso
  int getUses(ResourceType type) {
    switch (type) {
      case ResourceType.roll:
        return rollUses;
      case ResourceType.favorite:
        return favoriteUses;
      case ResourceType.watched:
        return watchedUses;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'rollUses': rollUses,
      'favoriteUses': favoriteUses,
      'watchedUses': watchedUses,
      'rollCooldownEnd': rollCooldownEnd?.toIso8601String(),
      'favoriteCooldownEnd': favoriteCooldownEnd?.toIso8601String(),
      'watchedCooldownEnd': watchedCooldownEnd?.toIso8601String(),
      'lastUsedRoll': lastUsedRoll?.toIso8601String(),
      'lastUsedFavorite': lastUsedFavorite?.toIso8601String(),
      'lastUsedWatched': lastUsedWatched?.toIso8601String(),
    };
  }

  factory UserResources.fromJson(Map<String, dynamic> json) {
    return UserResources(
      rollUses: json['rollUses'] ?? maxUses,
      favoriteUses: json['favoriteUses'] ?? maxUses,
      watchedUses: json['watchedUses'] ?? maxUses,
      rollCooldownEnd: json['rollCooldownEnd'] != null
          ? DateTime.parse(json['rollCooldownEnd'])
          : null,
      favoriteCooldownEnd: json['favoriteCooldownEnd'] != null
          ? DateTime.parse(json['favoriteCooldownEnd'])
          : null,
      watchedCooldownEnd: json['watchedCooldownEnd'] != null
          ? DateTime.parse(json['watchedCooldownEnd'])
          : null,
      lastUsedRoll: json['lastUsedRoll'] != null ? DateTime.parse(json['lastUsedRoll']) : null,
      lastUsedFavorite: json['lastUsedFavorite'] != null ? DateTime.parse(json['lastUsedFavorite']) : null,
      lastUsedWatched: json['lastUsedWatched'] != null ? DateTime.parse(json['lastUsedWatched']) : null,
    );
  }
}

/// Modelo para estatísticas de sorteios
class RollStats {
  final int totalRolls;
  final int movieRolls;
  final int seriesRolls;
  final int dateNightCount;

  const RollStats({
    this.totalRolls = 0,
    this.movieRolls = 0,
    this.seriesRolls = 0,
    this.dateNightCount = 0,
  });

  RollStats copyWith({
    int? totalRolls,
    int? movieRolls,
    int? seriesRolls,
    int? dateNightCount,
  }) {
    return RollStats(
      totalRolls: totalRolls ?? this.totalRolls,
      movieRolls: movieRolls ?? this.movieRolls,
      seriesRolls: seriesRolls ?? this.seriesRolls,
      dateNightCount: dateNightCount ?? this.dateNightCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRolls': totalRolls,
      'movieRolls': movieRolls,
      'seriesRolls': seriesRolls,
      'dateNightCount': dateNightCount,
    };
  }

  factory RollStats.fromJson(Map<String, dynamic> json) {
    return RollStats(
      totalRolls: json['totalRolls'] ?? 0,
      movieRolls: json['movieRolls'] ?? 0,
      seriesRolls: json['seriesRolls'] ?? 0,
      dateNightCount: json['dateNightCount'] ?? 0,
    );
  }
}