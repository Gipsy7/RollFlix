import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/roll_preferences.dart';
import '../models/date_night_preferences.dart';
import '../services/user_data_service.dart';
import '../services/auth_service.dart';

/// Controller para gerenciar preferências do usuário
/// Singleton pattern para garantir instância única
class UserPreferencesController extends ChangeNotifier {
  static final UserPreferencesController _instance = UserPreferencesController._internal();
  static UserPreferencesController get instance => _instance;

  factory UserPreferencesController() => _instance;

  UserPreferencesController._internal() {
    _loadPreferences();
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
      } else {
        // Senão, carrega do SharedPreferences
        await Future.wait([
          _loadRollPreferencesFromLocal(),
          _loadDateNightPreferencesFromLocal(),
          _loadRollStatsFromLocal(),
          _loadUserResourcesFromLocal(),
        ]);
        debugPrint('✅ Preferências carregadas do SharedPreferences');
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

      // Carrega dados da nuvem
      await Future.wait([
        _loadRollPreferencesFromCloud(),
        _loadDateNightPreferencesFromCloud(),
        _loadRollStatsFromCloud(),
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
      return false;
    }

    final newResources = _userResources.consumeResource(type);
    await updateUserResources(newResources);
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

  /// Tenta recarregar recursos se o cooldown expirou
  Future<void> tryReloadResources() async {
    final newResources = _userResources.tryReloadExpired();
    if (newResources != _userResources) {
      await updateUserResources(newResources);
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

  static const int maxUses = 5;
  static const Duration cooldownDuration = Duration(hours: 24);

  const UserResources({
    this.rollUses = maxUses,
    this.favoriteUses = maxUses,
    this.watchedUses = maxUses,
    this.rollCooldownEnd,
    this.favoriteCooldownEnd,
    this.watchedCooldownEnd,
  });

  UserResources copyWith({
    int? rollUses,
    int? favoriteUses,
    int? watchedUses,
    DateTime? rollCooldownEnd,
    DateTime? favoriteCooldownEnd,
    DateTime? watchedCooldownEnd,
  }) {
    return UserResources(
      rollUses: rollUses ?? this.rollUses,
      favoriteUses: favoriteUses ?? this.favoriteUses,
      watchedUses: watchedUses ?? this.watchedUses,
      rollCooldownEnd: rollCooldownEnd ?? this.rollCooldownEnd,
      favoriteCooldownEnd: favoriteCooldownEnd ?? this.favoriteCooldownEnd,
      watchedCooldownEnd: watchedCooldownEnd ?? this.watchedCooldownEnd,
    );
  }

  /// Verifica se um recurso pode ser usado
  bool canUseResource(ResourceType type) {
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
    switch (type) {
      case ResourceType.roll:
        if (rollUses <= 0) return this;
        final newUses = rollUses - 1;
        return copyWith(
          rollUses: newUses,
          rollCooldownEnd: newUses == 0 ? DateTime.now().add(cooldownDuration) : null,
        );
      case ResourceType.favorite:
        if (favoriteUses <= 0) return this;
        final newUses = favoriteUses - 1;
        return copyWith(
          favoriteUses: newUses,
          favoriteCooldownEnd: newUses == 0 ? DateTime.now().add(cooldownDuration) : null,
        );
      case ResourceType.watched:
        if (watchedUses <= 0) return this;
        final newUses = watchedUses - 1;
        return copyWith(
          watchedUses: newUses,
          watchedCooldownEnd: newUses == 0 ? DateTime.now().add(cooldownDuration) : null,
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

    if (rollCooldownEnd != null && rollCooldownEnd!.isBefore(now)) {
      updated = updated.copyWith(rollUses: maxUses, rollCooldownEnd: null);
    }
    if (favoriteCooldownEnd != null && favoriteCooldownEnd!.isBefore(now)) {
      updated = updated.copyWith(favoriteUses: maxUses, favoriteCooldownEnd: null);
    }
    if (watchedCooldownEnd != null && watchedCooldownEnd!.isBefore(now)) {
      updated = updated.copyWith(watchedUses: maxUses, watchedCooldownEnd: null);
    }

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