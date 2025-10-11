import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/app_logger.dart';

/// Client HTTP otimizado com cache, timeout e retry logic
/// 
/// Features:
/// - ✅ Timeout configurável
/// - ✅ Retry automático com backoff exponencial
/// - ✅ Cache de respostas
/// - ✅ Singleton para reutilização de conexões
/// - ✅ Logging de erros
class OptimizedHttpClient {
  // Singleton instance
  static final OptimizedHttpClient _instance = OptimizedHttpClient._internal();
  factory OptimizedHttpClient() => _instance;
  OptimizedHttpClient._internal();

  // HTTP client reutilizável (melhora performance de conexões)
  final http.Client _client = http.Client();

  // ==================== CONFIGURAÇÕES ====================

  /// Timeout padrão para requests (10 segundos)
  static const Duration defaultTimeout = Duration(seconds: 10);

  /// Número máximo de tentativas em caso de falha
  static const int maxRetries = 3;

  /// Delay inicial para retry (backoff exponencial)
  static const Duration initialRetryDelay = Duration(milliseconds: 500);

  /// Cache em memória (simples - para produção use package:cached_network_image)
  final Map<String, _CachedResponse> _cache = {};

  /// Tempo de expiração do cache (5 minutos)
  static const Duration cacheExpiration = Duration(minutes: 5);

  /// Tamanho máximo do cache (100 entradas)
  static const int maxCacheSize = 100;

  // ==================== MÉTODOS PÚBLICOS ====================

  /// GET request com cache, timeout e retry
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    Duration? timeout,
    bool useCache = true,
    int? maxRetries,
  }) async {
    // Verifica cache primeiro
    if (useCache) {
      final cached = _getFromCache(url.toString());
      if (cached != null) {
        AppLogger.debug('📦 Cache hit: $url');
        return cached;
      }
    }

    // Faz request com retry
    final response = await _retryRequest(
      () => _client.get(url, headers: headers).timeout(
            timeout ?? defaultTimeout,
            onTimeout: () {
              throw TimeoutException('Request timeout após ${timeout ?? defaultTimeout}');
            },
          ),
      url: url.toString(),
      maxRetries: maxRetries ?? OptimizedHttpClient.maxRetries,
    );

    // Salva no cache se sucesso
    if (useCache && response.statusCode == 200) {
      _saveToCache(url.toString(), response);
    }

    return response;
  }

  /// POST request com timeout e retry
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
    int? maxRetries,
  }) async {
    return await _retryRequest(
      () => _client.post(url, headers: headers, body: body).timeout(
            timeout ?? defaultTimeout,
            onTimeout: () {
              throw TimeoutException('Request timeout após ${timeout ?? defaultTimeout}');
            },
          ),
      url: url.toString(),
      maxRetries: maxRetries ?? OptimizedHttpClient.maxRetries,
    );
  }

  // ==================== CACHE ====================

  /// Recupera resposta do cache se não expirada
  http.Response? _getFromCache(String key) {
    final cached = _cache[key];
    if (cached == null) return null;

    // Verifica se expirou
    if (DateTime.now().difference(cached.timestamp) > cacheExpiration) {
      _cache.remove(key);
      return null;
    }

    return cached.response;
  }

  /// Salva resposta no cache
  void _saveToCache(String key, http.Response response) {
    // Limpa cache se estiver cheio (FIFO simples)
    if (_cache.length >= maxCacheSize) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
      AppLogger.debug('🗑️ Cache cheio, removendo: $oldestKey');
    }

    _cache[key] = _CachedResponse(
      response: response,
      timestamp: DateTime.now(),
    );
  }

  /// Limpa todo o cache
  void clearCache() {
    _cache.clear();
    AppLogger.debug('🗑️ Cache limpo completamente');
  }

  /// Remove entrada específica do cache
  void removeFromCache(String url) {
    _cache.remove(url);
  }

  // ==================== RETRY LOGIC ====================

  /// Executa request com retry automático e backoff exponencial
  Future<http.Response> _retryRequest(
    Future<http.Response> Function() requestFn, {
    required String url,
    required int maxRetries,
  }) async {
    int attempt = 0;
    Duration delay = initialRetryDelay;

    while (true) {
      try {
        attempt++;
        AppLogger.debug('🌐 Request #$attempt: $url');

        final response = await requestFn();

        // Sucesso
        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (attempt > 1) {
            AppLogger.debug('✅ Sucesso após $attempt tentativas');
          }
          return response;
        }

        // Erro HTTP - não retry em erros de cliente (4xx)
        if (response.statusCode >= 400 && response.statusCode < 500) {
          AppLogger.error('❌ Erro HTTP ${response.statusCode}: $url');
          return response; // Não retry em erros de cliente
        }

        // Erro de servidor (5xx) - retry
        if (attempt >= maxRetries) {
          AppLogger.error('❌ Falha após $maxRetries tentativas: HTTP ${response.statusCode}');
          return response;
        }

        AppLogger.debug('⚠️ Erro ${response.statusCode}, tentando novamente em ${delay.inMilliseconds}ms...');
        await Future.delayed(delay);
        delay *= 2; // Backoff exponencial

      } on TimeoutException catch (e) {
        if (attempt >= maxRetries) {
          AppLogger.error('❌ Timeout após $maxRetries tentativas: $url', error: e);
          rethrow;
        }

        AppLogger.debug('⏱️ Timeout, tentando novamente em ${delay.inMilliseconds}ms...');
        await Future.delayed(delay);
        delay *= 2;

      } catch (e, stack) {
        if (attempt >= maxRetries) {
          AppLogger.error('❌ Erro após $maxRetries tentativas: $url', 
            error: e, stackTrace: stack);
          rethrow;
        }

        AppLogger.debug('⚠️ Erro: $e, tentando novamente em ${delay.inMilliseconds}ms...');
        await Future.delayed(delay);
        delay *= 2;
      }
    }
  }

  // ==================== CLEANUP ====================

  /// Fecha o client e libera recursos
  void dispose() {
    _client.close();
    _cache.clear();
    AppLogger.debug('🔌 OptimizedHttpClient fechado');
  }
}

/// Classe interna para armazenar respostas em cache
class _CachedResponse {
  final http.Response response;
  final DateTime timestamp;

  _CachedResponse({
    required this.response,
    required this.timestamp,
  });
}
