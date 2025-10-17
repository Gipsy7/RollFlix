import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'RollFlix'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @watchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watchAd;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @watchAdConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to get a resource?'**
  String get watchAdConfirmTitle;

  /// No description provided for @watchAdConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Watching an ad will grant you a resource recharge.'**
  String get watchAdConfirmBody;

  /// No description provided for @resourceCount.
  ///
  /// In en, this message translates to:
  /// **'You have {uses}/{maxUses} {resource} available.'**
  String resourceCount(Object uses, Object maxUses, Object resource);

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// No description provided for @rollAndChill.
  ///
  /// In en, this message translates to:
  /// **'Roll and Chill'**
  String get rollAndChill;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @loginToAccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access the app'**
  String get loginToAccess;

  /// No description provided for @connectingGoogle.
  ///
  /// In en, this message translates to:
  /// **'Connecting with Google...'**
  String get connectingGoogle;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @loginTerms.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our\nTerms of Use and Privacy Policy'**
  String get loginTerms;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Error signing in with Google: {error}'**
  String loginError(Object error);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNotifications;

  /// No description provided for @receiveReleaseNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about releases'**
  String get receiveReleaseNotifications;

  /// No description provided for @movieReleases.
  ///
  /// In en, this message translates to:
  /// **'Movie releases'**
  String get movieReleases;

  /// No description provided for @notifyFavoriteMovieReleases.
  ///
  /// In en, this message translates to:
  /// **'Notify when favorite movies are released'**
  String get notifyFavoriteMovieReleases;

  /// No description provided for @newEpisodes.
  ///
  /// In en, this message translates to:
  /// **'New episodes'**
  String get newEpisodes;

  /// No description provided for @notifyFavoriteShowEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Notify about episodes of favorite shows'**
  String get notifyFavoriteShowEpisodes;

  /// No description provided for @backgroundExecution.
  ///
  /// In en, this message translates to:
  /// **'Background Execution'**
  String get backgroundExecution;

  /// No description provided for @automaticChecks.
  ///
  /// In en, this message translates to:
  /// **'Automatic checks'**
  String get automaticChecks;

  /// No description provided for @every6HoursEvenClosed.
  ///
  /// In en, this message translates to:
  /// **'Every 6 hours, even with app closed'**
  String get every6HoursEvenClosed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @testsMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Tests & Maintenance'**
  String get testsMaintenance;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get sendTestNotification;

  /// No description provided for @clearSendHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear send history'**
  String get clearSendHistory;

  /// No description provided for @allowResendNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow resending notifications'**
  String get allowResendNotifications;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to clear all notification history? This action cannot be undone.'**
  String get clearHistoryConfirm;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSaved;

  /// No description provided for @settingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving settings: {error}'**
  String settingsSaveError(Object error);

  /// No description provided for @sendHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Send history cleared successfully'**
  String get sendHistoryCleared;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent!'**
  String get testNotificationSent;

  /// No description provided for @notificationTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Test'**
  String get notificationTestTitle;

  /// No description provided for @notificationTestBody.
  ///
  /// In en, this message translates to:
  /// **'If you\'re seeing this, notifications are working! 🎉'**
  String get notificationTestBody;

  /// No description provided for @backgroundInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works:'**
  String get backgroundInfoTitle;

  /// No description provided for @backgroundInfoContent.
  ///
  /// In en, this message translates to:
  /// **'• Automatic checks every 6 hours\n• Works even with app closed\n• Requires internet connection\n• Does not run on low battery\n• Android managed system'**
  String get backgroundInfoContent;

  /// No description provided for @performanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance:'**
  String get performanceTitle;

  /// No description provided for @performanceContent.
  ///
  /// In en, this message translates to:
  /// **'• Maximum 4 checks per day\n• Only checks new favorites\n• 90% battery savings\n• 96% fewer API calls'**
  String get performanceContent;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @restartApp.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app for changes to take effect'**
  String get restartApp;

  /// No description provided for @cannotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to open link'**
  String get cannotOpenLink;

  /// No description provided for @errorOpeningLink.
  ///
  /// In en, this message translates to:
  /// **'Error opening link'**
  String get errorOpeningLink;

  /// No description provided for @watchTrailer.
  ///
  /// In en, this message translates to:
  /// **'Watch Trailer'**
  String get watchTrailer;

  /// No description provided for @synopsis.
  ///
  /// In en, this message translates to:
  /// **'Synopsis'**
  String get synopsis;

  /// No description provided for @synopsisNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Synopsis not available.'**
  String get synopsisNotAvailable;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction:'**
  String get direction;

  /// No description provided for @mainCast.
  ///
  /// In en, this message translates to:
  /// **'Main Cast'**
  String get mainCast;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @whereToWatch.
  ///
  /// In en, this message translates to:
  /// **'Where to Watch'**
  String get whereToWatch;

  /// No description provided for @streamingIncluded.
  ///
  /// In en, this message translates to:
  /// **'Streaming (Included in subscription):'**
  String get streamingIncluded;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent:'**
  String get rent;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy:'**
  String get buy;

  /// No description provided for @streamingInfoNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Streaming information not available at the moment.'**
  String get streamingInfoNotAvailable;

  /// No description provided for @soundtrack.
  ///
  /// In en, this message translates to:
  /// **'Soundtrack'**
  String get soundtrack;

  /// No description provided for @themeSong.
  ///
  /// In en, this message translates to:
  /// **'Theme Song'**
  String get themeSong;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @spotify.
  ///
  /// In en, this message translates to:
  /// **'Spotify'**
  String get spotify;

  /// No description provided for @youtube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get youtube;

  /// No description provided for @completePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Complete Playlist'**
  String get completePlaylist;

  /// No description provided for @spotifyPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Playlist on Spotify'**
  String get spotifyPlaylist;

  /// No description provided for @youtubePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Playlist on YouTube'**
  String get youtubePlaylist;

  /// No description provided for @genresLabel.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genresLabel;

  /// No description provided for @discoverMore.
  ///
  /// In en, this message translates to:
  /// **'Discover more great movies on RollFlix!'**
  String get discoverMore;

  /// No description provided for @trailerNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Trailer not available'**
  String get trailerNotAvailable;

  /// No description provided for @shareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share movie'**
  String get shareTooltip;

  /// No description provided for @markAsWatched.
  ///
  /// In en, this message translates to:
  /// **'Mark as watched'**
  String get markAsWatched;

  /// No description provided for @markAsUnwatched.
  ///
  /// In en, this message translates to:
  /// **'Mark as not watched'**
  String get markAsUnwatched;

  /// No description provided for @removedFromWatched.
  ///
  /// In en, this message translates to:
  /// **'Removed from watched'**
  String get removedFromWatched;

  /// No description provided for @markedAsWatched.
  ///
  /// In en, this message translates to:
  /// **'Marked as watched'**
  String get markedAsWatched;

  /// No description provided for @errorLoadingDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading movie details'**
  String get errorLoadingDetails;

  /// No description provided for @errorLoadingTVShowDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading TV show details'**
  String get errorLoadingTVShowDetails;

  /// No description provided for @errorLoadingInitialData.
  ///
  /// In en, this message translates to:
  /// **'Error loading initial data'**
  String get errorLoadingInitialData;

  /// No description provided for @selectGenreFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a genre first'**
  String get selectGenreFirst;

  /// No description provided for @rollError.
  ///
  /// In en, this message translates to:
  /// **'Unable to perform roll. Please try again.'**
  String get rollError;

  /// No description provided for @noSeriesFound.
  ///
  /// In en, this message translates to:
  /// **'No series found for this filter. Please try again.'**
  String get noSeriesFound;

  /// No description provided for @noMovieFound.
  ///
  /// In en, this message translates to:
  /// **'No movie found for this filter. Please try again.'**
  String get noMovieFound;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'❤️ {title} added to favorites'**
  String addedToFavorites(Object title);

  /// No description provided for @allItemsRemoved.
  ///
  /// In en, this message translates to:
  /// **'All {contentType} have been removed'**
  String allItemsRemoved(Object contentType);

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Error searching series'**
  String get searchError;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @watched.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get watched;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @seriesUpper.
  ///
  /// In en, this message translates to:
  /// **'SERIES'**
  String get seriesUpper;

  /// No description provided for @moviesUpper.
  ///
  /// In en, this message translates to:
  /// **'MOVIES'**
  String get moviesUpper;

  /// No description provided for @seriesLower.
  ///
  /// In en, this message translates to:
  /// **'series'**
  String get seriesLower;

  /// No description provided for @moviesLower.
  ///
  /// In en, this message translates to:
  /// **'movies'**
  String get moviesLower;

  /// No description provided for @removeFromWatched.
  ///
  /// In en, this message translates to:
  /// **'Remove from watched'**
  String get removeFromWatched;

  /// No description provided for @removeFromWatchedQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove from watched?'**
  String get removeFromWatchedQuestion;

  /// No description provided for @confirmRemoveWatched.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{title}\" from the watched list?'**
  String confirmRemoveWatched(Object title);

  /// No description provided for @clearAllWatched.
  ///
  /// In en, this message translates to:
  /// **'Clear all watched?'**
  String get clearAllWatched;

  /// No description provided for @confirmClearAllWatched.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all {count} watched {contentType}?'**
  String confirmClearAllWatched(Object contentType, Object count);

  /// No description provided for @prioritizeHighRated.
  ///
  /// In en, this message translates to:
  /// **'Prioritize movies with higher rating'**
  String get prioritizeHighRated;

  /// No description provided for @prioritizePopular.
  ///
  /// In en, this message translates to:
  /// **'Prioritize more popular movies'**
  String get prioritizePopular;

  /// No description provided for @excludeWatched.
  ///
  /// In en, this message translates to:
  /// **'Exclude already watched'**
  String get excludeWatched;

  /// No description provided for @excludeWatchedDescription.
  ///
  /// In en, this message translates to:
  /// **'Does not show content already marked as watched'**
  String get excludeWatchedDescription;

  /// No description provided for @notificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure when you want to receive notifications about your favorite movies and series.'**
  String get notificationDescription;

  /// No description provided for @movieReleasesTitle.
  ///
  /// In en, this message translates to:
  /// **'🎬 Movie Releases'**
  String get movieReleasesTitle;

  /// No description provided for @movieReleasesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify when favorite movies are released'**
  String get movieReleasesSubtitle;

  /// No description provided for @newEpisodesTitle.
  ///
  /// In en, this message translates to:
  /// **'📺 New Episodes'**
  String get newEpisodesTitle;

  /// No description provided for @newEpisodesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify about new episodes of favorite shows'**
  String get newEpisodesSubtitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @searchSeries.
  ///
  /// In en, this message translates to:
  /// **'Search Series'**
  String get searchSeries;

  /// No description provided for @seriesMode.
  ///
  /// In en, this message translates to:
  /// **'SERIES'**
  String get seriesMode;

  /// No description provided for @movieMode.
  ///
  /// In en, this message translates to:
  /// **'Mode: Movies'**
  String get movieMode;

  /// No description provided for @switchToSeries.
  ///
  /// In en, this message translates to:
  /// **'Switch to Series'**
  String get switchToSeries;

  /// No description provided for @switchToMovies.
  ///
  /// In en, this message translates to:
  /// **'Switch to Movies'**
  String get switchToMovies;

  /// No description provided for @loadingMovies.
  ///
  /// In en, this message translates to:
  /// **'Loading movies...'**
  String get loadingMovies;

  /// No description provided for @shareSeriesText.
  ///
  /// In en, this message translates to:
  /// **'🍿 Discover more amazing series on RollFlix!'**
  String get shareSeriesText;

  /// No description provided for @typeToSearchSeries.
  ///
  /// In en, this message translates to:
  /// **'Type something to search series'**
  String get typeToSearchSeries;

  /// No description provided for @initialGenreSelected.
  ///
  /// In en, this message translates to:
  /// **'Initial genre selected: {genre}'**
  String initialGenreSelected(Object genre);

  /// No description provided for @errorInitializingApp.
  ///
  /// In en, this message translates to:
  /// **'Error initializing app: {error}'**
  String errorInitializingApp(Object error);

  /// No description provided for @modeChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Mode changed to: {mode}'**
  String modeChangedTo(Object mode);

  /// No description provided for @modeSetTo.
  ///
  /// In en, this message translates to:
  /// **'Mode set to: {mode}'**
  String modeSetTo(Object mode);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @markAsNotWatched.
  ///
  /// In en, this message translates to:
  /// **'Mark as not watched'**
  String get markAsNotWatched;

  /// No description provided for @addToFavoritesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavoritesTooltip;

  /// No description provided for @removeFromFavoritesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavoritesTooltip;

  /// No description provided for @clearAllTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllTooltip;

  /// No description provided for @rollPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Roll Preferences'**
  String get rollPreferencesTitle;

  /// No description provided for @chooseGenre.
  ///
  /// In en, this message translates to:
  /// **'Choose a Genre of {contentType}'**
  String chooseGenre(Object contentType);

  /// No description provided for @rolling.
  ///
  /// In en, this message translates to:
  /// **'Rolling...'**
  String get rolling;

  /// No description provided for @rollNewSeries.
  ///
  /// In en, this message translates to:
  /// **'Roll New Series'**
  String get rollNewSeries;

  /// No description provided for @rollNewMovie.
  ///
  /// In en, this message translates to:
  /// **'Roll New Movie'**
  String get rollNewMovie;

  /// No description provided for @rollSeries.
  ///
  /// In en, this message translates to:
  /// **'Roll Series'**
  String get rollSeries;

  /// No description provided for @rollMovie.
  ///
  /// In en, this message translates to:
  /// **'Roll Movie'**
  String get rollMovie;

  /// No description provided for @releasePeriod.
  ///
  /// In en, this message translates to:
  /// **'Release Period'**
  String get releasePeriod;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @contentRating.
  ///
  /// In en, this message translates to:
  /// **'Content Rating'**
  String get contentRating;

  /// No description provided for @otherOptions.
  ///
  /// In en, this message translates to:
  /// **'Other Options'**
  String get otherOptions;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @clearPeriod.
  ///
  /// In en, this message translates to:
  /// **'Clear period'**
  String get clearPeriod;

  /// No description provided for @selectInitialYear.
  ///
  /// In en, this message translates to:
  /// **'Select Initial Year'**
  String get selectInitialYear;

  /// No description provided for @selectFinalYear.
  ///
  /// In en, this message translates to:
  /// **'Select Final Year'**
  String get selectFinalYear;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// No description provided for @randomDescription.
  ///
  /// In en, this message translates to:
  /// **'Completely random order'**
  String get randomDescription;

  /// No description provided for @bestRated.
  ///
  /// In en, this message translates to:
  /// **'Best Rated'**
  String get bestRated;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @allowAdultContent.
  ///
  /// In en, this message translates to:
  /// **'Allow +18 content'**
  String get allowAdultContent;

  /// No description provided for @showAllContent.
  ///
  /// In en, this message translates to:
  /// **'Show all types of content'**
  String get showAllContent;

  /// No description provided for @onlyNonAdultContent.
  ///
  /// In en, this message translates to:
  /// **'Only non-adult content'**
  String get onlyNonAdultContent;

  /// No description provided for @activeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Active Notifications'**
  String get activeNotifications;

  /// No description provided for @activeNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable/disable all notifications'**
  String get activeNotificationsDescription;

  /// No description provided for @testNotificationHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to send a test notification'**
  String get testNotificationHint;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @searchMovies.
  ///
  /// In en, this message translates to:
  /// **'Search Movies'**
  String get searchMovies;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @discoverAmazingSeries.
  ///
  /// In en, this message translates to:
  /// **'Discover amazing series'**
  String get discoverAmazingSeries;

  /// No description provided for @dateNight.
  ///
  /// In en, this message translates to:
  /// **'Date Night'**
  String get dateNight;

  /// No description provided for @dateNightComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Date Night in development!\nComing soon 🚀'**
  String get dateNightComingSoon;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Movies and recipes cache cleared!'**
  String get cacheCleared;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// No description provided for @notificationHistory.
  ///
  /// In en, this message translates to:
  /// **'Notification History'**
  String get notificationHistory;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @whatIsRollflix.
  ///
  /// In en, this message translates to:
  /// **'What is Rollflix?'**
  String get whatIsRollflix;

  /// No description provided for @whatIsRollflixDescription.
  ///
  /// In en, this message translates to:
  /// **'App to discover random movies and series by genre. Choose from more than 18 different genres and find your next entertainment!'**
  String get whatIsRollflixDescription;

  /// No description provided for @availableFeatures.
  ///
  /// In en, this message translates to:
  /// **'Available Features'**
  String get availableFeatures;

  /// No description provided for @movieSeriesRoller.
  ///
  /// In en, this message translates to:
  /// **'Movie & Series Roller'**
  String get movieSeriesRoller;

  /// No description provided for @movieSeriesRollerDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover your next entertainment randomly'**
  String get movieSeriesRollerDescription;

  /// No description provided for @genresAvailable.
  ///
  /// In en, this message translates to:
  /// **'18+ Genres Available'**
  String get genresAvailable;

  /// No description provided for @genresAvailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Action, comedy, horror, romance, science fiction and much more'**
  String get genresAvailableDescription;

  /// No description provided for @smartNotifications.
  ///
  /// In en, this message translates to:
  /// **'Smart Notifications'**
  String get smartNotifications;

  /// No description provided for @smartNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay up to date with releases of your favorites'**
  String get smartNotificationsDescription;

  /// No description provided for @favoritesSystem.
  ///
  /// In en, this message translates to:
  /// **'Favorites System'**
  String get favoritesSystem;

  /// No description provided for @favoritesSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Save and track your favorite movies and series'**
  String get favoritesSystemDescription;

  /// No description provided for @movieSeriesMode.
  ///
  /// In en, this message translates to:
  /// **'Movies & Series Mode'**
  String get movieSeriesMode;

  /// No description provided for @movieSeriesModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Easily switch between movies and series'**
  String get movieSeriesModeDescription;

  /// No description provided for @inDevelopment.
  ///
  /// In en, this message translates to:
  /// **'🚀 In Development'**
  String get inDevelopment;

  /// No description provided for @newFeaturesComing.
  ///
  /// In en, this message translates to:
  /// **'New features that are being developed and will be available soon:'**
  String get newFeaturesComing;

  /// No description provided for @movieQuiz.
  ///
  /// In en, this message translates to:
  /// **'Movie Quiz'**
  String get movieQuiz;

  /// No description provided for @movieQuizDescription.
  ///
  /// In en, this message translates to:
  /// **'Test your cinema knowledge with challenging questions'**
  String get movieQuizDescription;

  /// No description provided for @dateNightDescription.
  ///
  /// In en, this message translates to:
  /// **'Find the perfect movie or series to watch together'**
  String get dateNightDescription;

  /// No description provided for @soundtrackQuiz.
  ///
  /// In en, this message translates to:
  /// **'Soundtrack Quiz'**
  String get soundtrackQuiz;

  /// No description provided for @soundtrackQuizDescription.
  ///
  /// In en, this message translates to:
  /// **'Guess the movie or series by the music'**
  String get soundtrackQuizDescription;

  /// No description provided for @technologies.
  ///
  /// In en, this message translates to:
  /// **'Technologies'**
  String get technologies;

  /// No description provided for @developedWithFlutter.
  ///
  /// In en, this message translates to:
  /// **'Developed with Flutter'**
  String get developedWithFlutter;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'2025 Rollflix'**
  String get copyright;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved'**
  String get allRightsReserved;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'COMING SOON'**
  String get comingSoon;

  /// No description provided for @noWatchedItems.
  ///
  /// In en, this message translates to:
  /// **'No watched items'**
  String get noWatchedItems;

  /// No description provided for @markWatchedHint.
  ///
  /// In en, this message translates to:
  /// **'Mark the {contentType} you\'ve already watched to see them here'**
  String markWatchedHint(Object contentType);

  /// No description provided for @seriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get seriesLabel;

  /// No description provided for @movieLabel.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movieLabel;

  /// No description provided for @watchedToday.
  ///
  /// In en, this message translates to:
  /// **'Watched today'**
  String get watchedToday;

  /// No description provided for @watchedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Watched yesterday'**
  String get watchedYesterday;

  /// No description provided for @watchedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Watched {days} days ago'**
  String watchedDaysAgo(Object days);

  /// No description provided for @watchedWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'Watched {weeks} {weekWord} ago'**
  String watchedWeeksAgo(Object weeks, Object weekWord);

  /// No description provided for @watchedMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'Watched {months} {monthWord} ago'**
  String watchedMonthsAgo(Object months, Object monthWord);

  /// No description provided for @watchedYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'Watched {years} {yearWord} ago'**
  String watchedYearsAgo(Object years, Object yearWord);

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeks;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @loadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Loading favorites...'**
  String get loadingFavorites;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @addToFavoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Add {contentType} to favorites\nto see them here!'**
  String addToFavoritesHint(Object contentType);

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove favorite?'**
  String get removeFavorite;

  /// No description provided for @confirmRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove \"{title}\" from favorites?'**
  String confirmRemoveFavorite(Object title);

  /// No description provided for @noFavoritesToClear.
  ///
  /// In en, this message translates to:
  /// **'There are no {contentType} favorites to clear'**
  String noFavoritesToClear(Object contentType);

  /// No description provided for @clearAllFavorites.
  ///
  /// In en, this message translates to:
  /// **'Clear all favorites?'**
  String get clearAllFavorites;

  /// No description provided for @confirmClearAllFavorites.
  ///
  /// In en, this message translates to:
  /// **'All {count} {contentType} favorites will be removed. This action cannot be undone.'**
  String confirmClearAllFavorites(Object contentType, Object count);

  /// No description provided for @allFavoritesCleared.
  ///
  /// In en, this message translates to:
  /// **'All {contentType} favorites have been removed'**
  String allFavoritesCleared(Object contentType);

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of account?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will be signed out and will need to log in again.'**
  String get logoutConfirmMessage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Error signing out: {error}'**
  String logoutError(Object error);

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Out of Account'**
  String get logoutButton;

  /// No description provided for @rolls.
  ///
  /// In en, this message translates to:
  /// **'Rolls'**
  String get rolls;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Type the name of the movie or series...'**
  String get searchHint;

  /// No description provided for @searchMoviesError.
  ///
  /// In en, this message translates to:
  /// **'Error searching movies'**
  String get searchMoviesError;

  /// No description provided for @searchingMovies.
  ///
  /// In en, this message translates to:
  /// **'Searching movies...'**
  String get searchingMovies;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try searching with other keywords'**
  String get tryDifferentKeywords;

  /// No description provided for @noMoviesFound.
  ///
  /// In en, this message translates to:
  /// **'No movies found'**
  String get noMoviesFound;

  /// No description provided for @loadingMoreResults.
  ///
  /// In en, this message translates to:
  /// **'Loading more results...'**
  String get loadingMoreResults;

  /// No description provided for @tapPlusOne.
  ///
  /// In en, this message translates to:
  /// **'Tap +1'**
  String get tapPlusOne;

  /// No description provided for @watchAdForExtraResource.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad and get +1 extra resource!'**
  String get watchAdForExtraResource;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 4.0.0'**
  String get appVersion;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @filmography.
  ///
  /// In en, this message translates to:
  /// **'Filmography'**
  String get filmography;

  /// No description provided for @filmographyAsDirector.
  ///
  /// In en, this message translates to:
  /// **'Filmography as Director'**
  String get filmographyAsDirector;

  /// No description provided for @errorLoadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Error loading history'**
  String errorLoadingHistory(Object error);

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared successfully'**
  String get historyCleared;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @notificationHint.
  ///
  /// In en, this message translates to:
  /// **'You will be notified when there are new releases of your favorites'**
  String get notificationHint;

  /// No description provided for @firstAirDate.
  ///
  /// In en, this message translates to:
  /// **'First air date:'**
  String get firstAirDate;

  /// No description provided for @cast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// No description provided for @crew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get crew;

  /// No description provided for @screenplay.
  ///
  /// In en, this message translates to:
  /// **'Screenplay:'**
  String get screenplay;

  /// No description provided for @trailers.
  ///
  /// In en, this message translates to:
  /// **'Trailers'**
  String get trailers;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @findYourNextFavoriteMovie.
  ///
  /// In en, this message translates to:
  /// **'Find your next favorite movie'**
  String get findYourNextFavoriteMovie;

  /// No description provided for @heroes.
  ///
  /// In en, this message translates to:
  /// **'Heroes'**
  String get heroes;

  /// No description provided for @chooseGenreOf.
  ///
  /// In en, this message translates to:
  /// **'Choose a Genre of'**
  String get chooseGenreOf;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @dateNightPreferences.
  ///
  /// In en, this message translates to:
  /// **'Date Night Preferences'**
  String get dateNightPreferences;

  /// No description provided for @customizeYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Customize Your Experience'**
  String get customizeYourExperience;

  /// No description provided for @configurePreferencesForPersonalizedSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Configure your preferences for personalized suggestions'**
  String get configurePreferencesForPersonalizedSuggestions;

  /// No description provided for @dietaryRestrictions.
  ///
  /// In en, this message translates to:
  /// **'Dietary Restrictions'**
  String get dietaryRestrictions;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @preparationTime.
  ///
  /// In en, this message translates to:
  /// **'Preparation Time'**
  String get preparationTime;

  /// No description provided for @culinaryLevel.
  ///
  /// In en, this message translates to:
  /// **'Culinary Level'**
  String get culinaryLevel;

  /// No description provided for @drinkPreferences.
  ///
  /// In en, this message translates to:
  /// **'Drink Preferences'**
  String get drinkPreferences;

  /// No description provided for @ingredientsToAvoid.
  ///
  /// In en, this message translates to:
  /// **'Ingredients to Avoid'**
  String get ingredientsToAvoid;

  /// No description provided for @restoreDefault.
  ///
  /// In en, this message translates to:
  /// **'Restore Default'**
  String get restoreDefault;

  /// No description provided for @savePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get savePreferences;

  /// No description provided for @includeAlcoholicBeverages.
  ///
  /// In en, this message translates to:
  /// **'Include alcoholic beverages'**
  String get includeAlcoholicBeverages;

  /// No description provided for @suggestionsWillIncludeWinesAndDrinks.
  ///
  /// In en, this message translates to:
  /// **'Suggestions will include wines and drinks'**
  String get suggestionsWillIncludeWinesAndDrinks;

  /// No description provided for @onlyNonAlcoholicBeverages.
  ///
  /// In en, this message translates to:
  /// **'Only non-alcoholic beverages'**
  String get onlyNonAlcoholicBeverages;

  /// No description provided for @selectIngredientsToAvoid.
  ///
  /// In en, this message translates to:
  /// **'Select ingredients you want to avoid:'**
  String get selectIngredientsToAvoid;

  /// No description provided for @preferencesRestoredToDefault.
  ///
  /// In en, this message translates to:
  /// **'Preferences restored to default'**
  String get preferencesRestoredToDefault;

  /// No description provided for @preferencesSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved successfully!'**
  String get preferencesSavedSuccessfully;

  /// No description provided for @recipeReady.
  ///
  /// In en, this message translates to:
  /// **'⏰ {title} is ready!'**
  String recipeReady(Object title);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @recipeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load recipe. Please try again.'**
  String get recipeLoadError;

  /// No description provided for @adNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Ad not available at the moment. Please try again in a few moments.'**
  String get adNotAvailable;

  /// No description provided for @preferencesCleared.
  ///
  /// In en, this message translates to:
  /// **'Preferences cleared'**
  String get preferencesCleared;

  /// No description provided for @shareSeries.
  ///
  /// In en, this message translates to:
  /// **'Share series'**
  String get shareSeries;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @changeMeal.
  ///
  /// In en, this message translates to:
  /// **'Change meal'**
  String get changeMeal;

  /// No description provided for @movieTab.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movieTab;

  /// No description provided for @mealTab.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get mealTab;

  /// No description provided for @checklistTab.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get checklistTab;

  /// No description provided for @romanticDate.
  ///
  /// In en, this message translates to:
  /// **'💕 Romantic Date'**
  String get romanticDate;

  /// No description provided for @casualDate.
  ///
  /// In en, this message translates to:
  /// **'🍿 Casual Date'**
  String get casualDate;

  /// No description provided for @elegantDate.
  ///
  /// In en, this message translates to:
  /// **'🥂 Elegant Date'**
  String get elegantDate;

  /// No description provided for @funDate.
  ///
  /// In en, this message translates to:
  /// **'🎉 Fun Date'**
  String get funDate;

  /// No description provided for @cozyDate.
  ///
  /// In en, this message translates to:
  /// **'🏠 Cozy Date'**
  String get cozyDate;

  /// No description provided for @dateDetails.
  ///
  /// In en, this message translates to:
  /// **'🌟 Date Details'**
  String get dateDetails;

  /// No description provided for @releaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Release:'**
  String get releaseLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration:'**
  String get durationLabel;

  /// No description provided for @defaultMovieOverview.
  ///
  /// In en, this message translates to:
  /// **'An exciting romantic story that will make your night even more special.'**
  String get defaultMovieOverview;

  /// No description provided for @technicalInfo.
  ///
  /// In en, this message translates to:
  /// **'Technical Information'**
  String get technicalInfo;

  /// No description provided for @productionLabel.
  ///
  /// In en, this message translates to:
  /// **'Production:'**
  String get productionLabel;

  /// No description provided for @checklistHint.
  ///
  /// In en, this message translates to:
  /// **'Check items as you add them to your cart!'**
  String get checklistHint;

  /// No description provided for @intimateQuestionsGame.
  ///
  /// In en, this message translates to:
  /// **'20 Intimate Questions'**
  String get intimateQuestionsGame;

  /// No description provided for @intimateQuestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get to know each other better with deep and fun questions'**
  String get intimateQuestionsDesc;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @romanticTruthOrDare.
  ///
  /// In en, this message translates to:
  /// **'Romantic Truth or Dare'**
  String get romanticTruthOrDare;

  /// No description provided for @romanticTruthOrDareDesc.
  ///
  /// In en, this message translates to:
  /// **'Romantic version of the classic game'**
  String get romanticTruthOrDareDesc;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @cookingBattle.
  ///
  /// In en, this message translates to:
  /// **'Cooking Battle'**
  String get cookingBattle;

  /// No description provided for @cookingBattleDesc.
  ///
  /// In en, this message translates to:
  /// **'Friendly competition to prepare a dish'**
  String get cookingBattleDesc;

  /// No description provided for @loserDoesDishes.
  ///
  /// In en, this message translates to:
  /// **'Loser does the dishes!'**
  String get loserDoesDishes;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @coupleQuizDesc.
  ///
  /// In en, this message translates to:
  /// **'Test how well you know each other'**
  String get coupleQuizDesc;

  /// No description provided for @dreamsAndAspirations.
  ///
  /// In en, this message translates to:
  /// **'Dreams and Aspirations'**
  String get dreamsAndAspirations;

  /// No description provided for @dreamLocationQuestion.
  ///
  /// In en, this message translates to:
  /// **'If you could live anywhere in the world, where would it be?'**
  String get dreamLocationQuestion;

  /// No description provided for @professionalDreamQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your biggest professional dream?'**
  String get professionalDreamQuestion;

  /// No description provided for @servingsUnit.
  ///
  /// In en, this message translates to:
  /// **'servings'**
  String get servingsUnit;

  /// No description provided for @nutritionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Nutritional Information'**
  String get nutritionalInfo;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @adultFilter.
  ///
  /// In en, this message translates to:
  /// **'🔞 Non-adult only'**
  String get adultFilter;

  /// No description provided for @preferencesApplied.
  ///
  /// In en, this message translates to:
  /// **'Preferences applied!'**
  String get preferencesApplied;

  /// No description provided for @moviesMode.
  ///
  /// In en, this message translates to:
  /// **'MOVIES'**
  String get moviesMode;

  /// No description provided for @rollGenre.
  ///
  /// In en, this message translates to:
  /// **'Roll Genre'**
  String get rollGenre;

  /// No description provided for @seriesRolled.
  ///
  /// In en, this message translates to:
  /// **'Series {count} rolled'**
  String seriesRolled(Object count);

  /// No description provided for @movieRolled.
  ///
  /// In en, this message translates to:
  /// **'Movie {count} rolled'**
  String movieRolled(Object count);

  /// No description provided for @tryDifferentGenre.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different genre or reload the page.'**
  String get tryDifferentGenre;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'players'**
  String get players;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'questions'**
  String get questions;

  /// No description provided for @interestingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Interesting questions to get to know each other better'**
  String get interestingQuestions;

  /// No description provided for @conversationStarters.
  ///
  /// In en, this message translates to:
  /// **'Conversation Starters'**
  String get conversationStarters;

  /// No description provided for @dateNightGames.
  ///
  /// In en, this message translates to:
  /// **'Date Night Games'**
  String get dateNightGames;

  /// No description provided for @makeNightFun.
  ///
  /// In en, this message translates to:
  /// **'Make the night more fun and memorable'**
  String get makeNightFun;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
