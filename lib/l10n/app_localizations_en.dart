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
  String get testNotification => 'Test notification';

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
  String get testNotificationSent => 'Test notification sent';

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
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get errorLoadingDetails => 'Error loading movie details';
}
