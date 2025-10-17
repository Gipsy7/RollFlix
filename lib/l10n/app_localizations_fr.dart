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
  String get watchAd => 'Regarder la Pub';

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
  String get testNotification => 'Tester la Notification';

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
  String get clearHistoryConfirm => 'Voulez-vous vraiment effacer tout l\'historique des notifications ? Cette action ne peut pas être annulée.';

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
  String get testNotificationSent => 'Notification de test envoyée !';

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
  String get direction => 'Réalisation :';

  @override
  String get mainCast => 'Distribution Principale';

  @override
  String get videos => 'Vidéos';

  @override
  String get whereToWatch => 'Où Regarder';

  @override
  String get streamingIncluded => 'Streaming (Inclus dans l\'abonnement) :';

  @override
  String get rent => 'Location :';

  @override
  String get buy => 'Acheter :';

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
  String get errorLoadingDetails => 'Erreur lors du chargement des détails du film';

  @override
  String get errorLoadingTVShowDetails => 'Erreur lors du chargement des détails de la série';

  @override
  String get errorLoadingInitialData => 'Erreur lors du chargement des données initiales';

  @override
  String get selectGenreFirst => 'Sélectionnez d\'abord un genre';

  @override
  String get rollError => 'Impossible d\'effectuer le tirage. Veuillez réessayer.';

  @override
  String get noSeriesFound => 'Aucune série trouvée pour ce filtre. Veuillez réessayer.';

  @override
  String get noMovieFound => 'Aucun film trouvé pour ce filtre. Veuillez réessayer.';

  @override
  String get removedFromFavorites => 'Retiré des favoris';

  @override
  String addedToFavorites(Object title) {
    return '❤️ $title ajouté aux favoris';
  }

  @override
  String allItemsRemoved(Object contentType) {
    return 'Tous les $contentType ont été supprimés';
  }

  @override
  String get searchError => 'Erreur lors de la recherche de séries';

  @override
  String get favorites => 'Favoris';

  @override
  String get watched => 'Regardé';

  @override
  String get movies => 'Films';

  @override
  String get series => 'Séries';

  @override
  String get seriesUpper => 'SÉRIES';

  @override
  String get moviesUpper => 'FILMS';

  @override
  String get seriesLower => 'séries';

  @override
  String get moviesLower => 'films';

  @override
  String get removeFromWatched => 'Retirer des vus';

  @override
  String get removeFromWatchedQuestion => 'Retirer des vus ?';

  @override
  String confirmRemoveWatched(Object title) {
    return 'Êtes-vous sûr de vouloir retirer \"$title\" de la liste des vus ?';
  }

  @override
  String get clearAllWatched => 'Effacer tous les vus ?';

  @override
  String confirmClearAllWatched(Object contentType, Object count) {
    return 'Êtes-vous sûr de vouloir supprimer tous les $count $contentType vus ?';
  }

  @override
  String get prioritizeHighRated => 'Priorise les films avec une meilleure note';

  @override
  String get prioritizePopular => 'Priorise les films les plus connus';

  @override
  String get excludeWatched => 'Exclure déjà vus';

  @override
  String get excludeWatchedDescription => 'N\'affiche pas le contenu déjà marqué comme vu';

  @override
  String get notificationDescription => 'Configurez quand vous souhaitez recevoir des notifications sur vos films et séries préférés.';

  @override
  String get movieReleasesTitle => '🎬 Sorties de Films';

  @override
  String get movieReleasesSubtitle => 'Notifier quand les films favoris sont sortis';

  @override
  String get newEpisodesTitle => '📺 Nouveaux Épisodes';

  @override
  String get newEpisodesSubtitle => 'Notifier à propos des nouveaux épisodes des séries favorites';

  @override
  String get close => 'Fermer';

  @override
  String get searchSeries => 'Rechercher Séries';

  @override
  String get seriesMode => 'Mode : Séries';

  @override
  String get movieMode => 'Mode : Films';

  @override
  String get switchToSeries => 'Basculer vers Séries';

  @override
  String get switchToMovies => 'Passer aux Films';

  @override
  String get loadingMovies => 'Chargement des films...';

  @override
  String get shareSeriesText => '🍿 Découvrez plus de séries incroyables sur RollFlix !';

  @override
  String get typeToSearchSeries => 'Tapez quelque chose pour rechercher des séries';

  @override
  String initialGenreSelected(Object genre) {
    return 'Genre initial sélectionné : $genre';
  }

  @override
  String errorInitializingApp(Object error) {
    return 'Erreur lors de l\'initialisation de l\'app : $error';
  }

  @override
  String modeChangedTo(Object mode) {
    return 'Mode changé pour : $mode';
  }

  @override
  String modeSetTo(Object mode) {
    return 'Mode défini pour : $mode';
  }

  @override
  String get remove => 'Retirer';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get markAsNotWatched => 'Marquer comme non vu';

  @override
  String get addToFavoritesTooltip => 'Ajouter aux favoris';

  @override
  String get removeFromFavoritesTooltip => 'Retirer des favoris';

  @override
  String get clearAllTooltip => 'Effacer tout';

  @override
  String get rollPreferencesTitle => 'Préférences de Roulement';

  @override
  String chooseGenre(Object contentType) {
    return 'Choisissez un Genre de $contentType';
  }

  @override
  String get rolling => 'Tirage au sort...';

  @override
  String get rollNewSeries => 'Tirer Nouvelle Série';

  @override
  String get rollNewMovie => 'Tirer Nouveau Film';

  @override
  String get rollSeries => 'Tirer Série';

  @override
  String get rollMovie => 'Tirer Film';

  @override
  String get releasePeriod => 'Période de Sortie';

  @override
  String get sortBy => 'Trier Par';

  @override
  String get contentRating => 'Classification de Contenu';

  @override
  String get otherOptions => 'Autres Options';

  @override
  String get apply => 'Appliquer';

  @override
  String get from => 'De';

  @override
  String get to => 'À';

  @override
  String get any => 'N\'importe';

  @override
  String get clearPeriod => 'Effacer la période';

  @override
  String get selectInitialYear => 'Sélectionner Année Initiale';

  @override
  String get selectFinalYear => 'Sélectionner Année Finale';

  @override
  String get random => 'Aléatoire';

  @override
  String get randomDescription => 'Ordre complètement aléatoire';

  @override
  String get bestRated => 'Mieux Notés';

  @override
  String get mostPopular => 'Plus Populaires';

  @override
  String get allowAdultContent => 'Permettre contenu +18';

  @override
  String get showAllContent => 'Afficher tout type de contenu';

  @override
  String get onlyNonAdultContent => 'Contenu non adulte seulement';

  @override
  String get activeNotifications => 'Notifications Actives';

  @override
  String get activeNotificationsDescription => 'Activer/désactiver toutes les notifications';

  @override
  String get testNotificationHint => 'Appuyez pour envoyer une notification de test';

  @override
  String get home => 'Accueil';

  @override
  String get searchMovies => 'Rechercher Films';

  @override
  String get myProfile => 'Mon Profil';

  @override
  String get login => 'Connexion';

  @override
  String get discoverAmazingSeries => 'Découvrez des séries incroyables';

  @override
  String get dateNight => 'Soirée en Amoureux';

  @override
  String get dateNightComingSoon => 'Date Night en développement!\nBientôt disponible 🚀';

  @override
  String get clearCache => 'Vider le Cache';

  @override
  String get cacheCleared => 'Cache des films et recettes vidé!';

  @override
  String get aboutApp => 'À Propos de l\'App';

  @override
  String get notificationHistory => 'Historique des Notifications';

  @override
  String get version => 'Version';

  @override
  String get whatIsRollflix => 'Qu\'est-ce que Rollflix?';

  @override
  String get whatIsRollflixDescription => 'Application pour découvrir des films et séries aléatoires par genre. Choisissez parmi plus de 18 genres différents et trouvez votre prochain divertissement!';

  @override
  String get availableFeatures => 'Fonctionnalités Disponibles';

  @override
  String get movieSeriesRoller => 'Tireur de Films et Séries';

  @override
  String get movieSeriesRollerDescription => 'Découvrez votre prochain divertissement de manière aléatoire';

  @override
  String get genresAvailable => '18+ Genres Disponibles';

  @override
  String get genresAvailableDescription => 'Action, comédie, horreur, romance, science-fiction et bien plus';

  @override
  String get smartNotifications => 'Notifications Intelligentes';

  @override
  String get smartNotificationsDescription => 'Restez informé des sorties de vos favoris';

  @override
  String get favoritesSystem => 'Système de Favoris';

  @override
  String get favoritesSystemDescription => 'Sauvegardez et suivez vos films et séries préférés';

  @override
  String get movieSeriesMode => 'Mode Films et Séries';

  @override
  String get movieSeriesModeDescription => 'Basculez facilement entre films et séries';

  @override
  String get inDevelopment => '🚀 En Développement';

  @override
  String get newFeaturesComing => 'Nouvelles fonctionnalités en cours de développement et bientôt disponibles:';

  @override
  String get movieQuiz => 'Quiz de Films';

  @override
  String get movieQuizDescription => 'Testez vos connaissances cinématographiques avec des questions difficiles';

  @override
  String get dateNightDescription => 'Trouvez le film ou la série parfaite à regarder ensemble';

  @override
  String get soundtrackQuiz => 'Quiz de Bande Originale';

  @override
  String get soundtrackQuizDescription => 'Devinez le film ou la série par la musique';

  @override
  String get technologies => 'Technologies';

  @override
  String get developedWithFlutter => 'Développé avec Flutter';

  @override
  String get copyright => '2025 Rollflix';

  @override
  String get allRightsReserved => 'Tous droits réservés';

  @override
  String get comingSoon => 'BIENTÔT';

  @override
  String get noWatchedItems => 'Aucun élément regardé';

  @override
  String markWatchedHint(Object contentType) {
    return 'Marquez les $contentType que vous avez déjà regardés pour les voir ici';
  }

  @override
  String get seriesLabel => 'Série';

  @override
  String get movieLabel => 'Film';

  @override
  String get watchedToday => 'Regardé aujourd\'hui';

  @override
  String get watchedYesterday => 'Regardé hier';

  @override
  String watchedDaysAgo(Object days) {
    return 'Regardé il y a $days jours';
  }

  @override
  String watchedWeeksAgo(Object weeks, Object weekWord) {
    return 'Regardé il y a $weeks $weekWord';
  }

  @override
  String watchedMonthsAgo(Object months, Object monthWord) {
    return 'Regardé il y a $months $monthWord';
  }

  @override
  String watchedYearsAgo(Object years, Object yearWord) {
    return 'Regardé il y a $years $yearWord';
  }

  @override
  String get week => 'semaine';

  @override
  String get weeks => 'semaines';

  @override
  String get month => 'mois';

  @override
  String get months => 'mois';

  @override
  String get year => 'an';

  @override
  String get years => 'ans';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get myFavorites => 'Mes Favoris';

  @override
  String get loadingFavorites => 'Chargement des favoris...';

  @override
  String get noFavoritesYet => 'Aucun favori encore';

  @override
  String addToFavoritesHint(Object contentType) {
    return 'Ajoutez $contentType aux favoris\npour les voir ici !';
  }

  @override
  String get removeFavorite => 'Retirer le favori ?';

  @override
  String confirmRemoveFavorite(Object title) {
    return 'Voulez-vous retirer \"$title\" des favoris ?';
  }

  @override
  String noFavoritesToClear(Object contentType) {
    return 'Il n\'y a pas de $contentType favoris à effacer';
  }

  @override
  String get clearAllFavorites => 'Effacer tous les favoris ?';

  @override
  String confirmClearAllFavorites(Object contentType, Object count) {
    return 'Tous les $count $contentType favoris seront supprimés. Cette action ne peut pas être annulée.';
  }

  @override
  String allFavoritesCleared(Object contentType) {
    return 'Tous les $contentType favoris ont été supprimés';
  }

  @override
  String get logoutConfirmTitle => 'Se déconnecter du compte ?';

  @override
  String get logoutConfirmMessage => 'Vous serez déconnecté et devrez vous reconnecter.';

  @override
  String get logout => 'Se déconnecter';

  @override
  String logoutError(Object error) {
    return 'Erreur lors de la déconnexion : $error';
  }

  @override
  String get loadingProfile => 'Chargement du profil...';

  @override
  String get logoutButton => 'Se Déconnecter du Compte';

  @override
  String get rolls => 'Tirages';

  @override
  String get searchHint => 'Tapez le nom du film ou de la série...';

  @override
  String get searchMoviesError => 'Erreur lors de la recherche de films';

  @override
  String get searchingMovies => 'Recherche de films...';

  @override
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String get tryDifferentKeywords => 'Essayez de rechercher avec d\'autres mots-clés';

  @override
  String get noMoviesFound => 'Aucun film trouvé';

  @override
  String get loadingMoreResults => 'Chargement de plus de résultats...';

  @override
  String get tapPlusOne => 'Appuyez +1';

  @override
  String get watchAdForExtraResource => 'Regardez une courte publicité et obtenez +1 ressource supplémentaire !';

  @override
  String get appVersion => 'Version 4.0.0';

  @override
  String get basicInfo => 'Informations de Base';

  @override
  String get biography => 'Biographie';

  @override
  String get filmography => 'Filmographie';

  @override
  String get filmographyAsDirector => 'Filmographie en tant que Réalisateur';

  @override
  String errorLoadingHistory(Object error) {
    return 'Erreur lors du chargement de l\'historique';
  }

  @override
  String get historyCleared => 'Historique effacé avec succès';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get notificationHint => 'Vous serez notifié lorsqu\'il y aura de nouvelles sorties de vos favoris';

  @override
  String get firstAirDate => 'Première diffusion :';

  @override
  String get cast => 'Distribution';

  @override
  String get crew => 'Équipe';

  @override
  String get screenplay => 'Scénario :';

  @override
  String get trailers => 'Bandes-annonces';

  @override
  String get user => 'Utilisateur';

  @override
  String get accountInfo => 'Informations du Compte';

  @override
  String get userId => 'ID Utilisateur';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get statistics => 'Statistiques';

  @override
  String get findYourNextFavoriteMovie => 'Trouvez votre prochain film préféré';

  @override
  String get heroes => 'Héros';

  @override
  String get chooseGenreOf => 'Choisissez un Genre de';

  @override
  String get available => 'Disponible';

  @override
  String get unavailable => 'Indisponible';

  @override
  String get dateNightPreferences => 'Préférences Soirée Romantique';

  @override
  String get customizeYourExperience => 'Personnalisez Votre Expérience';

  @override
  String get configurePreferencesForPersonalizedSuggestions => 'Configurez vos préférences pour des suggestions personnalisées';

  @override
  String get dietaryRestrictions => 'Restrictions Alimentaires';

  @override
  String get budget => 'Budget';

  @override
  String get preparationTime => 'Temps de Préparation';

  @override
  String get culinaryLevel => 'Niveau Culinaire';

  @override
  String get drinkPreferences => 'Préférences de Boissons';

  @override
  String get ingredientsToAvoid => 'Ingrédients à Éviter';

  @override
  String get restoreDefault => 'Restaurer Par Défaut';

  @override
  String get savePreferences => 'Enregistrer les Préférences';

  @override
  String get includeAlcoholicBeverages => 'Inclure les boissons alcoolisées';

  @override
  String get suggestionsWillIncludeWinesAndDrinks => 'Les suggestions incluront vins et boissons';

  @override
  String get onlyNonAlcoholicBeverages => 'Boissons non alcoolisées uniquement';

  @override
  String get selectIngredientsToAvoid => 'Sélectionnez les ingrédients à éviter :';

  @override
  String get preferencesRestoredToDefault => 'Préférences restaurées par défaut';

  @override
  String get preferencesSavedSuccessfully => 'Préférences enregistrées avec succès !';
}
