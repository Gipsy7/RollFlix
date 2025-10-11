import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/admob_config.dart';

/// Tipo de recompensa de anúncio
enum AdRewardType {
  roll,      // Ganha 1 rolagem extra
  favorite,  // Ganha 1 favorito extra
  watched,   // Ganha 1 assistido extra
}

/// Serviço para gerenciar anúncios do AdMob
/// Singleton pattern para garantir instância única
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;
  bool _isAdReady = false;
  bool _isInitialized = false;

  /// Callback chamado quando o usuário assiste completamente um anúncio
  Function(AdRewardType)? onAdWatched;

  /// Inicializa o SDK do AdMob
  /// DEVE ser chamado antes de usar qualquer funcionalidade de anúncios
  static Future<void> initialize() async {
    if (_instance._isInitialized) {
      debugPrint('⚠️ AdMob já foi inicializado');
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _instance._isInitialized = true;
      debugPrint('✅ AdMob inicializado com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar AdMob: $e');
    }
  }

  /// Pré-carrega anúncios para uso futuro
  /// Deve ser chamado após initialize() para melhor experiência do usuário
  static Future<void> preloadAds() async {
    if (!_instance._isInitialized) {
      debugPrint('⚠️ AdMob não foi inicializado. Chame initialize() primeiro.');
      return;
    }

    debugPrint('🎬 Pré-carregando anúncios...');
    
    try {
      // Inicia o carregamento do anúncio
      await _instance.loadRewardedAd();
      
      // Aguarda até que o anúncio esteja pronto ou dê timeout
      final startTime = DateTime.now();
      const maxWaitTime = Duration(seconds: 10);
      
      while (!_instance._isAdReady && 
             DateTime.now().difference(startTime) < maxWaitTime) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      if (_instance._isAdReady) {
        debugPrint('✅ Anúncios pré-carregados com sucesso!');
      } else {
        debugPrint('⏱️ Timeout ao pré-carregar anúncios (continuará carregando em background)');
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao pré-carregar anúncios: $e');
      // Não falha - o anúncio continuará tentando carregar
    }
  }

  /// Carrega um anúncio recompensado
  Future<void> loadRewardedAd() async {
    if (!_isInitialized) {
      debugPrint('⚠️ AdMob não foi inicializado. Chame AdService.initialize() primeiro.');
      return;
    }

    if (_isAdLoading || _isAdReady) {
      debugPrint('⏳ Anúncio já está carregado ou carregando');
      return;
    }

    _isAdLoading = true;
    debugPrint('📥 Carregando anúncio recompensado...');

    try {
      await RewardedAd.load(
        adUnitId: AdMobConfig.rewardedAdId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('✅ Anúncio recompensado carregado com sucesso');
            _rewardedAd = ad;
            _isAdReady = true;
            _isAdLoading = false;

            // Configura callbacks do ciclo de vida do anúncio
            _setupAdCallbacks();
          },
          onAdFailedToLoad: (error) {
            debugPrint('❌ Erro ao carregar anúncio: ${error.message}');
            debugPrint('   Código: ${error.code}');
            debugPrint('   Domain: ${error.domain}');
            _isAdLoading = false;
            _isAdReady = false;
            
            // Tenta recarregar após um delay
            _scheduleAdRetry();
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ Exceção ao carregar anúncio: $e');
      _isAdLoading = false;
      _isAdReady = false;
      _scheduleAdRetry();
    }
  }

  /// Configura callbacks do anúncio
  void _setupAdCallbacks() {
    if (_rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('📺 Anúncio sendo exibido em tela cheia');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('📱 Anúncio fechado pelo usuário');
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;
        
        // Pré-carrega o próximo anúncio
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('❌ Erro ao exibir anúncio: ${error.message}');
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;
        
        // Tenta carregar um novo anúncio
        loadRewardedAd();
      },
      onAdImpression: (ad) {
        debugPrint('👁️ Impressão do anúncio registrada');
      },
    );
  }

  /// Agenda nova tentativa de carregar anúncio após falha
  void _scheduleAdRetry() {
    debugPrint('⏰ Reagendando carregamento de anúncio em ${AdMobConfig.retryDelay}s');
    Future.delayed(Duration(seconds: AdMobConfig.retryDelay), () {
      if (!_isAdReady && !_isAdLoading) {
        loadRewardedAd();
      }
    });
  }

  /// Mostra o anúncio recompensado
  /// Retorna true se o usuário assistiu completamente e ganhou a recompensa
  Future<bool> showRewardedAd(AdRewardType rewardType) async {
    if (!_isAdReady || _rewardedAd == null) {
      debugPrint('⚠️ Anúncio não está pronto para exibição');
      
      // Tenta carregar se não estiver carregando
      if (!_isAdLoading) {
        loadRewardedAd();
      }
      
      return false;
    }

    debugPrint('🎬 Mostrando anúncio recompensado (Tipo: ${rewardType.name})');
    
    bool rewardEarned = false;
    final completer = Completer<bool>();

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('🎁 Recompensa ganha!');
          debugPrint('   Tipo: ${reward.type}');
          debugPrint('   Quantidade: ${reward.amount}');
          
          rewardEarned = true;
          
          // Notifica o callback
          onAdWatched?.call(rewardType);
        },
      );
      
      // Aguarda um pouco para garantir que o callback seja chamado
      await Future.delayed(const Duration(milliseconds: 500));
      completer.complete(rewardEarned);
    } catch (e) {
      debugPrint('❌ Erro ao mostrar anúncio: $e');
      completer.complete(false);
    }

    return completer.future;
  }

  /// Verifica se há anúncio pronto para exibir
  bool get isAdReady => _isAdReady;

  /// Verifica se está carregando anúncio
  bool get isLoading => _isAdLoading;

  /// Verifica se o AdMob foi inicializado
  bool get isInitialized => _isInitialized;

  /// Libera recursos do anúncio
  void dispose() {
    debugPrint('🗑️ Liberando recursos do AdService');
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isAdReady = false;
    _isAdLoading = false;
  }
}
