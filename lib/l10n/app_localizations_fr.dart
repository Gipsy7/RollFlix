// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'RollFlix';

  @override
  String get cancel => 'Annuler';

  @override
  String get watchAd => 'Regarder la pub';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get clear => 'Effacer';

  @override
  String get watchAdConfirmTitle => 'Regarder une pub pour obtenir une ressource ?';

  @override
  String get watchAdConfirmBody => 'Regarder une pub vous accordera une recharge de ressource.';

  @override
  String resourceCount(Object uses, Object maxUses, Object resource) {
    return 'Vous avez $uses/$maxUses $resource disponibles.';
  }

  @override
  String get testNotification => 'Tester la notification';

  @override
  String get rollAndChill => 'Roll and Chill';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get loginToAccess => 'Connectez-vous pour accéder à l\'application';

  @override
  String get connectingGoogle => 'Connexion avec Google...';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get loginTerms => 'En vous connectant, vous acceptez nos\nConditions d\'utilisation et Politique de confidentialité';

  @override
  String loginError(Object error) {
    return 'Erreur lors de la connexion avec Google : $error';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get receiveReleaseNotifications => 'Recevoir des notifications sur les sorties';

  @override
  String get movieReleases => 'Sorties de films';

  @override
  String get notifyFavoriteMovieReleases => 'Notifier quand les films favoris sortent';

  @override
  String get newEpisodes => 'Nouveaux épisodes';

  @override
  String get notifyFavoriteShowEpisodes => 'Notifier des épisodes des séries favorites';

  @override
  String get backgroundExecution => 'Exécution en arrière-plan';

  @override
  String get automaticChecks => 'Vérifications automatiques';

  @override
  String get every6HoursEvenClosed => 'Toutes les 6 heures, même app fermée';

  @override
  String get active => 'ACTIF';

  @override
  String get testsMaintenance => 'Tests et Maintenance';

  @override
  String get sendTestNotification => 'Envoyer une notification de test';

  @override
  String get clearSendHistory => 'Effacer l\'historique d\'envoi';

  @override
  String get allowResendNotifications => 'Permettre le renvoi des notifications';

  @override
  String get clearHistory => 'Effacer l\'Historique';

  @override
  String get clearHistoryConfirm => 'Voulez-vous effacer l\'historique des notifications envoyées ? Cela permet de renvoyer les notifications.';

  @override
  String get understood => 'Compris';

  @override
  String get settingsSaved => 'Paramètres sauvegardés avec succès';

  @override
  String settingsSaveError(Object error) {
    return 'Erreur lors de la sauvegarde des paramètres : $error';
  }

  @override
  String get sendHistoryCleared => 'Historique d\'envoi effacé avec succès';

  @override
  String get testNotificationSent => 'Notification de test envoyée';

  @override
  String get notificationTestTitle => 'Test de Notification';

  @override
  String get notificationTestBody => 'Si vous voyez ceci, les notifications fonctionnent ! 🎉';

  @override
  String get backgroundInfoTitle => 'Comment ça marche :';

  @override
  String get backgroundInfoContent => '• Vérifications automatiques toutes les 6 heures\n• Fonctionne même app fermée\n• Nécessite une connexion internet\n• Ne s\'exécute pas avec batterie faible\n• Système géré par Android';

  @override
  String get performanceTitle => 'Performance :';

  @override
  String get performanceContent => '• Maximum 4 vérifications par jour\n• Vérifie seulement les nouveaux favoris\n• Économie de 90% de batterie\n• 96% d\'appels API en moins';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get english => 'Anglais';

  @override
  String get portuguese => 'Portugais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Français';

  @override
  String get languageChanged => 'Langue changée avec succès';

  @override
  String get restartApp => 'Redémarrez l\'application pour que les changements prennent effet';

  @override
  String get cannotOpenLink => 'Impossible d\'ouvrir le lien';

  @override
  String get errorOpeningLink => 'Erreur lors de l\'ouverture du lien';

  @override
  String get watchTrailer => 'Voir la Bande-Annonce';

  @override
  String get synopsis => 'Synopsis';

  @override
  String get synopsisNotAvailable => 'Synopsis non disponible.';

  @override
  String get direction => 'Réalisation';

  @override
  String get mainCast => 'Distribution Principale';

  @override
  String get videos => 'Vidéos';

  @override
  String get whereToWatch => 'Où Regarder';

  @override
  String get streamingIncluded => 'Streaming (Inclus dans l\'abonnement):';

  @override
  String get rent => 'Location:';

  @override
  String get buy => 'Achat:';

  @override
  String get streamingInfoNotAvailable => 'Informations de streaming non disponibles pour le moment.';

  @override
  String get soundtrack => 'Bande Originale';

  @override
  String get themeSong => 'Chanson Thème';

  @override
  String get by => 'par';

  @override
  String get spotify => 'Spotify';

  @override
  String get youtube => 'YouTube';

  @override
  String get completePlaylist => 'Playlist Complète';

  @override
  String get spotifyPlaylist => 'Playlist sur Spotify';

  @override
  String get youtubePlaylist => 'Playlist sur YouTube';

  @override
  String get genresLabel => 'Genres';

  @override
  String get discoverMore => 'Découvrez plus de films sur RollFlix !';

  @override
  String get trailerNotAvailable => 'Bande-annonce non disponible';

  @override
  String get shareTooltip => 'Partager le film';

  @override
  String get markAsWatched => 'Marquer comme vu';

  @override
  String get markAsUnwatched => 'Marquer comme non vu';

  @override
  String get removedFromWatched => 'Retiré des vus';

  @override
  String get markedAsWatched => 'Marqué comme vu';

  @override
  String get removedFromFavorites => 'Retiré des favoris';

  @override
  String get addedToFavorites => 'Ajouté aux favoris';

  @override
  String get errorLoadingDetails => 'Erreur lors du chargement des détails du film';
}
