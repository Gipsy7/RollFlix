// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RollFlix';

  @override
  String get cancel => 'Cancel';

  @override
  String get watchAd => 'Watch Ad';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get clear => 'Clear';

  @override
  String get watchAdConfirmTitle => 'Watch an ad to get a resource?';

  @override
  String get watchAdConfirmBody => 'Watching an ad will grant you a resource recharge.';

  @override
  String resourceCount(Object uses, Object maxUses, Object resource) {
    return 'You have $uses/$maxUses $resource available.';
  }

  @override
  String get testNotification => 'Test Notification';

  @override
  String get rollAndChill => 'Roll and Chill';

  @override
  String get welcome => 'Welcome!';

  @override
  String get loginToAccess => 'Sign in to access the app';

  @override
  String get connectingGoogle => 'Connecting with Google...';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get loginTerms => 'By signing in, you agree to our\nTerms of Use and Privacy Policy';

  @override
  String loginError(Object error) {
    return 'Error signing in with Google: $error';
  }

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable notifications';

  @override
  String get receiveReleaseNotifications => 'Receive notifications about releases';

  @override
  String get movieReleases => 'Movie releases';

  @override
  String get notifyFavoriteMovieReleases => 'Notify when favorite movies are released';

  @override
  String get newEpisodes => 'New episodes';

  @override
  String get notifyFavoriteShowEpisodes => 'Notify about episodes of favorite shows';

  @override
  String get backgroundExecution => 'Background Execution';

  @override
  String get automaticChecks => 'Automatic checks';

  @override
  String get every6HoursEvenClosed => 'Every 6 hours, even with app closed';

  @override
  String get active => 'ACTIVE';

  @override
  String get testsMaintenance => 'Tests & Maintenance';

  @override
  String get sendTestNotification => 'Send test notification';

  @override
  String get clearSendHistory => 'Clear send history';

  @override
  String get allowResendNotifications => 'Allow resending notifications';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearHistoryConfirm => 'Do you want to clear the sent notifications history? This allows notifications to be sent again.';

  @override
  String get understood => 'Understood';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String settingsSaveError(Object error) {
    return 'Error saving settings: $error';
  }

  @override
  String get sendHistoryCleared => 'Send history cleared successfully';

  @override
  String get testNotificationSent => 'Test notification sent!';

  @override
  String get notificationTestTitle => 'Notification Test';

  @override
  String get notificationTestBody => 'If you\'re seeing this, notifications are working! 🎉';

  @override
  String get backgroundInfoTitle => 'How it works:';

  @override
  String get backgroundInfoContent => '• Automatic checks every 6 hours\n• Works even with app closed\n• Requires internet connection\n• Does not run on low battery\n• Android managed system';

  @override
  String get performanceTitle => 'Performance:';

  @override
  String get performanceContent => '• Maximum 4 checks per day\n• Only checks new favorites\n• 90% battery savings\n• 96% fewer API calls';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get restartApp => 'Please restart the app for changes to take effect';

  @override
  String get cannotOpenLink => 'Unable to open link';

  @override
  String get errorOpeningLink => 'Error opening link';

  @override
  String get watchTrailer => 'Watch Trailer';

  @override
  String get synopsis => 'Synopsis';

  @override
  String get synopsisNotAvailable => 'Synopsis not available.';

  @override
  String get direction => 'Direction';

  @override
  String get mainCast => 'Main Cast';

  @override
  String get videos => 'Videos';

  @override
  String get whereToWatch => 'Where to Watch';

  @override
  String get streamingIncluded => 'Streaming (Included in subscription):';

  @override
  String get rent => 'Rent:';

  @override
  String get buy => 'Buy:';

  @override
  String get streamingInfoNotAvailable => 'Streaming information not available at the moment.';

  @override
  String get soundtrack => 'Soundtrack';

  @override
  String get themeSong => 'Theme Song';

  @override
  String get by => 'by';

  @override
  String get spotify => 'Spotify';

  @override
  String get youtube => 'YouTube';

  @override
  String get completePlaylist => 'Complete Playlist';

  @override
  String get spotifyPlaylist => 'Playlist on Spotify';

  @override
  String get youtubePlaylist => 'Playlist on YouTube';

  @override
  String get genresLabel => 'Genres';

  @override
  String get discoverMore => 'Discover more great movies on RollFlix!';

  @override
  String get trailerNotAvailable => 'Trailer not available';

  @override
  String get shareTooltip => 'Share movie';

  @override
  String get markAsWatched => 'Mark as watched';

  @override
  String get markAsUnwatched => 'Mark as not watched';

  @override
  String get removedFromWatched => 'Removed from watched';

  @override
  String get markedAsWatched => 'Marked as watched';

  @override
  String get errorLoadingDetails => 'Error loading movie details';

  @override
  String get errorLoadingTVShowDetails => 'Error loading TV show details';

  @override
  String get errorLoadingInitialData => 'Error loading initial data';

  @override
  String get selectGenreFirst => 'Select a genre first';

  @override
  String get rollError => 'Unable to perform roll. Please try again.';

  @override
  String get noSeriesFound => 'No series found for this filter. Please try again.';

  @override
  String get noMovieFound => 'No movie found for this filter. Please try again.';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String addedToFavorites(Object title) {
    return '❤️ $title added to favorites';
  }

  @override
  String allItemsRemoved(Object contentType) {
    return 'All $contentType have been removed';
  }

  @override
  String get searchError => 'Error searching series';

  @override
  String get favorites => 'Favorites';

  @override
  String get watched => 'Watched';

  @override
  String get movies => 'MOVIES';

  @override
  String get series => 'SERIES';

  @override
  String get seriesUpper => 'SERIES';

  @override
  String get moviesUpper => 'MOVIES';

  @override
  String get seriesLower => 'series';

  @override
  String get moviesLower => 'movies';

  @override
  String get removeFromWatched => 'Remove from watched';

  @override
  String get removeFromWatchedQuestion => 'Remove from watched?';

  @override
  String confirmRemoveWatched(Object title) {
    return 'Are you sure you want to remove \"$title\" from the watched list?';
  }

  @override
  String get clearAllWatched => 'Clear all watched?';

  @override
  String confirmClearAllWatched(Object contentType, Object count) {
    return 'Are you sure you want to remove all $count watched $contentType?';
  }

  @override
  String get prioritizeHighRated => 'Prioritize movies with higher rating';

  @override
  String get prioritizePopular => 'Prioritize more popular movies';

  @override
  String get excludeWatched => 'Exclude already watched';

  @override
  String get excludeWatchedDescription => 'Does not show content already marked as watched';

  @override
  String get notificationDescription => 'Configure when you want to receive notifications about your favorite movies and series.';

  @override
  String get movieReleasesTitle => '🎬 Movie Releases';

  @override
  String get movieReleasesSubtitle => 'Notify when favorite movies are released';

  @override
  String get newEpisodesTitle => '📺 New Episodes';

  @override
  String get newEpisodesSubtitle => 'Notify about new episodes of favorite shows';

  @override
  String get close => 'Close';

  @override
  String get searchSeries => 'Search Series';

  @override
  String get seriesMode => 'Mode: Series';

  @override
  String get movieMode => 'Mode: Movies';

  @override
  String get switchToSeries => 'Switch to Series';

  @override
  String get switchToMovies => 'Switch to Movies';

  @override
  String get loadingMovies => 'Loading movies...';

  @override
  String get shareSeriesText => '🍿 Discover more amazing series on RollFlix!';

  @override
  String get typeToSearchSeries => 'Type something to search series';

  @override
  String initialGenreSelected(Object genre) {
    return 'Initial genre selected: $genre';
  }

  @override
  String errorInitializingApp(Object error) {
    return 'Error initializing app: $error';
  }

  @override
  String modeChangedTo(Object mode) {
    return 'Mode changed to: $mode';
  }

  @override
  String modeSetTo(Object mode) {
    return 'Mode set to: $mode';
  }

  @override
  String get remove => 'Remove';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get markAsNotWatched => 'Mark as not watched';

  @override
  String get addToFavoritesTooltip => 'Add to favorites';

  @override
  String get removeFromFavoritesTooltip => 'Remove from favorites';

  @override
  String get clearAllTooltip => 'Clear all';

  @override
  String get rollPreferencesTitle => 'Roll Preferences';

  @override
  String chooseGenre(Object contentType) {
    return 'Choose a Genre of $contentType';
  }

  @override
  String get rolling => 'Rolling...';

  @override
  String get rollNewSeries => 'Roll New Series';

  @override
  String get rollNewMovie => 'Roll New Movie';

  @override
  String get rollSeries => 'Roll Series';

  @override
  String get rollMovie => 'Roll Movie';

  @override
  String get releasePeriod => 'Release Period';

  @override
  String get sortBy => 'Sort By';

  @override
  String get contentRating => 'Content Rating';

  @override
  String get otherOptions => 'Other Options';

  @override
  String get apply => 'Apply';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get any => 'Any';

  @override
  String get clearPeriod => 'Clear period';

  @override
  String get selectInitialYear => 'Select Initial Year';

  @override
  String get selectFinalYear => 'Select Final Year';

  @override
  String get random => 'Random';

  @override
  String get randomDescription => 'Completely random order';

  @override
  String get bestRated => 'Best Rated';

  @override
  String get mostPopular => 'Most Popular';

  @override
  String get allowAdultContent => 'Allow +18 content';

  @override
  String get showAllContent => 'Show all types of content';

  @override
  String get onlyNonAdultContent => 'Only non-adult content';

  @override
  String get activeNotifications => 'Active Notifications';

  @override
  String get activeNotificationsDescription => 'Enable/disable all notifications';

  @override
  String get testNotificationHint => 'Tap to send a test notification';

  @override
  String get home => 'Home';

  @override
  String get searchMovies => 'Search Movies';

  @override
  String get myProfile => 'My Profile';

  @override
  String get login => 'Login';

  @override
  String get discoverAmazingSeries => 'Discover amazing series';

  @override
  String get dateNight => 'Date Night';

  @override
  String get dateNightComingSoon => 'Date Night in development!\nComing soon 🚀';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get cacheCleared => 'Movies and recipes cache cleared!';

  @override
  String get aboutApp => 'About the App';

  @override
  String get notificationHistory => 'Notification History';

  @override
  String get version => 'Version';

  @override
  String get whatIsRollflix => 'What is Rollflix?';

  @override
  String get whatIsRollflixDescription => 'App to discover random movies and series by genre. Choose from more than 18 different genres and find your next entertainment!';

  @override
  String get availableFeatures => 'Available Features';

  @override
  String get movieSeriesRoller => 'Movie & Series Roller';

  @override
  String get movieSeriesRollerDescription => 'Discover your next entertainment randomly';

  @override
  String get genresAvailable => '18+ Genres Available';

  @override
  String get genresAvailableDescription => 'Action, comedy, horror, romance, science fiction and much more';

  @override
  String get smartNotifications => 'Smart Notifications';

  @override
  String get smartNotificationsDescription => 'Stay up to date with releases of your favorites';

  @override
  String get favoritesSystem => 'Favorites System';

  @override
  String get favoritesSystemDescription => 'Save and track your favorite movies and series';

  @override
  String get movieSeriesMode => 'Movies & Series Mode';

  @override
  String get movieSeriesModeDescription => 'Easily switch between movies and series';

  @override
  String get inDevelopment => '🚀 In Development';

  @override
  String get newFeaturesComing => 'New features that are being developed and will be available soon:';

  @override
  String get movieQuiz => 'Movie Quiz';

  @override
  String get movieQuizDescription => 'Test your cinema knowledge with challenging questions';

  @override
  String get dateNightDescription => 'Find the perfect movie or series to watch together';

  @override
  String get soundtrackQuiz => 'Soundtrack Quiz';

  @override
  String get soundtrackQuizDescription => 'Guess the movie or series by the music';

  @override
  String get technologies => 'Technologies';

  @override
  String get developedWithFlutter => 'Developed with Flutter';

  @override
  String get copyright => '2025 Rollflix';

  @override
  String get allRightsReserved => 'All rights reserved';

  @override
  String get comingSoon => 'COMING SOON';

  @override
  String get noWatchedItems => 'No watched items';

  @override
  String markWatchedHint(Object contentType) {
    return 'Mark the $contentType you\'ve already watched to see them here';
  }

  @override
  String get seriesLabel => 'Series';

  @override
  String get movieLabel => 'Movie';

  @override
  String get watchedToday => 'Watched today';

  @override
  String get watchedYesterday => 'Watched yesterday';

  @override
  String watchedDaysAgo(Object days) {
    return 'Watched $days days ago';
  }

  @override
  String watchedWeeksAgo(Object weeks, Object weekWord) {
    return 'Watched $weeks $weekWord ago';
  }

  @override
  String watchedMonthsAgo(Object months, Object monthWord) {
    return 'Watched $months $monthWord ago';
  }

  @override
  String watchedYearsAgo(Object years, Object yearWord) {
    return 'Watched $years $yearWord ago';
  }

  @override
  String get week => 'week';

  @override
  String get weeks => 'weeks';

  @override
  String get month => 'month';

  @override
  String get months => 'months';

  @override
  String get year => 'year';

  @override
  String get years => 'years';

  @override
  String get clearAll => 'Clear all';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get loadingFavorites => 'Loading favorites...';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String addToFavoritesHint(Object contentType) {
    return 'Add $contentType to favorites\nto see them here!';
  }

  @override
  String get removeFavorite => 'Remove favorite?';

  @override
  String confirmRemoveFavorite(Object title) {
    return 'Do you want to remove \"$title\" from favorites?';
  }

  @override
  String noFavoritesToClear(Object contentType) {
    return 'There are no $contentType favorites to clear';
  }

  @override
  String get clearAllFavorites => 'Clear all favorites?';

  @override
  String confirmClearAllFavorites(Object contentType, Object count) {
    return 'All $count $contentType favorites will be removed. This action cannot be undone.';
  }

  @override
  String allFavoritesCleared(Object contentType) {
    return 'All $contentType favorites have been removed';
  }

  @override
  String get logoutConfirmTitle => 'Sign out of account?';

  @override
  String get logoutConfirmMessage => 'You will be signed out and will need to log in again.';

  @override
  String get logout => 'Sign Out';

  @override
  String logoutError(Object error) {
    return 'Error signing out: $error';
  }

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get logoutButton => 'Sign Out of Account';

  @override
  String get rolls => 'Rolls';
}
