// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'RollFlix';

  @override
  String get cancel => 'Cancelar';

  @override
  String get watchAd => 'Assistir Anúncio';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get clear => 'Limpar';

  @override
  String get watchAdConfirmTitle => 'Assistir um anúncio para ganhar um recurso?';

  @override
  String get watchAdConfirmBody => 'Assistir a um anúncio concederá uma recarga de recurso.';

  @override
  String resourceCount(Object uses, Object maxUses, Object resource) {
    return 'Você tem $uses/$maxUses $resource disponíveis.';
  }

  @override
  String get testNotification => 'Testar notificação';

  @override
  String get rollAndChill => 'Roll and Chill';

  @override
  String get welcome => 'Bem-vindo!';

  @override
  String get loginToAccess => 'Faça login para acessar o aplicativo';

  @override
  String get connectingGoogle => 'Conectando com Google...';

  @override
  String get continueWithGoogle => 'Continuar com Google';

  @override
  String get loginTerms => 'Ao fazer login, você concorda com nossos\nTermos de Uso e Política de Privacidade';

  @override
  String loginError(Object error) {
    return 'Erro ao fazer login com Google: $error';
  }

  @override
  String get settings => 'Configurações';

  @override
  String get notifications => 'Notificações';

  @override
  String get enableNotifications => 'Ativar notificações';

  @override
  String get receiveReleaseNotifications => 'Receber notificações sobre lançamentos';

  @override
  String get movieReleases => 'Lançamentos de filmes';

  @override
  String get notifyFavoriteMovieReleases => 'Notificar quando filmes favoritos forem lançados';

  @override
  String get newEpisodes => 'Novos episódios';

  @override
  String get notifyFavoriteShowEpisodes => 'Notificar sobre episódios de séries favoritas';

  @override
  String get backgroundExecution => 'Execução em Background';

  @override
  String get automaticChecks => 'Verificações automáticas';

  @override
  String get every6HoursEvenClosed => 'A cada 6 horas, mesmo com app fechado';

  @override
  String get active => 'ATIVO';

  @override
  String get testsMaintenance => 'Testes e Manutenção';

  @override
  String get sendTestNotification => 'Enviar notificação de teste';

  @override
  String get clearSendHistory => 'Limpar histórico de envios';

  @override
  String get allowResendNotifications => 'Permite reenvio de notificações';

  @override
  String get clearHistory => 'Limpar Histórico';

  @override
  String get clearHistoryConfirm => 'Deseja limpar o histórico de notificações enviadas? Isso permite que notificações sejam enviadas novamente.';

  @override
  String get understood => 'Entendi';

  @override
  String get settingsSaved => 'Configurações salvas com sucesso';

  @override
  String settingsSaveError(Object error) {
    return 'Erro ao salvar configurações: $error';
  }

  @override
  String get sendHistoryCleared => 'Histórico de envios limpo com sucesso';

  @override
  String get testNotificationSent => 'Notificação de teste enviada';

  @override
  String get notificationTestTitle => 'Teste de Notificação';

  @override
  String get notificationTestBody => 'Se você está vendo isso, as notificações estão funcionando! 🎉';

  @override
  String get backgroundInfoTitle => 'Como funciona:';

  @override
  String get backgroundInfoContent => '• Verificações automáticas a cada 6 horas\n• Funciona mesmo com app fechado\n• Requer conexão com internet\n• Não executa com bateria baixa\n• Sistema gerenciado pelo Android';

  @override
  String get performanceTitle => 'Performance:';

  @override
  String get performanceContent => '• Máximo 4 verificações por dia\n• Verifica apenas favoritos novos\n• Economia de 90% de bateria\n• 96% menos chamadas à API';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get english => 'Inglês';

  @override
  String get portuguese => 'Português';

  @override
  String get spanish => 'Espanhol';

  @override
  String get french => 'Francês';

  @override
  String get languageChanged => 'Idioma alterado com sucesso';

  @override
  String get restartApp => 'Reinicie o aplicativo para que as alterações tenham efeito';

  @override
  String get cannotOpenLink => 'Não foi possível abrir o link';

  @override
  String get errorOpeningLink => 'Erro ao abrir o link';

  @override
  String get watchTrailer => 'Assistir Trailer';

  @override
  String get synopsis => 'Sinopse';

  @override
  String get synopsisNotAvailable => 'Sinopse não disponível.';

  @override
  String get direction => 'Direção';

  @override
  String get mainCast => 'Elenco Principal';

  @override
  String get videos => 'Vídeos';

  @override
  String get whereToWatch => 'Onde Assistir';

  @override
  String get streamingIncluded => 'Streaming (Incluído na assinatura):';

  @override
  String get rent => 'Aluguel:';

  @override
  String get buy => 'Compra:';

  @override
  String get streamingInfoNotAvailable => 'Informações de streaming não disponíveis no momento.';

  @override
  String get soundtrack => 'Trilha Sonora';

  @override
  String get themeSong => 'Música Tema';

  @override
  String get by => 'por';

  @override
  String get spotify => 'Spotify';

  @override
  String get youtube => 'YouTube';

  @override
  String get completePlaylist => 'Playlist Completa';

  @override
  String get spotifyPlaylist => 'Playlist no Spotify';

  @override
  String get youtubePlaylist => 'Playlist no YouTube';

  @override
  String get genresLabel => 'Gêneros';

  @override
  String get discoverMore => 'Descubra mais filmes incríveis no RollFlix!';

  @override
  String get trailerNotAvailable => 'Trailer não disponível';

  @override
  String get shareTooltip => 'Compartilhar filme';

  @override
  String get markAsWatched => 'Marcar como assistido';

  @override
  String get markAsUnwatched => 'Marcar como não assistido';

  @override
  String get removedFromWatched => 'Removido de assistidos';

  @override
  String get markedAsWatched => 'Marcado como assistido';

  @override
  String get removedFromFavorites => 'Removido dos favoritos';

  @override
  String get addedToFavorites => 'Adicionado aos favoritos';

  @override
  String get errorLoadingDetails => 'Erro ao carregar detalhes do filme';
}
