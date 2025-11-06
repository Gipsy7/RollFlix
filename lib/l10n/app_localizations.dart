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

  /// No description provided for @rollAndChillWithMode.
  ///
  /// In en, this message translates to:
  /// **'Roll and Chill • {mode}'**
  String rollAndChillWithMode(Object mode);

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

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

  /// No description provided for @notAvailableShort.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailableShort;

  /// No description provided for @dateNightShareHeader.
  ///
  /// In en, this message translates to:
  /// **'🎬✨ PERFECT DATE PLAN ✨🍽️'**
  String get dateNightShareHeader;

  /// No description provided for @dateNightShareSectionMovie.
  ///
  /// In en, this message translates to:
  /// **'MOVIE'**
  String get dateNightShareSectionMovie;

  /// No description provided for @labelTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get labelTitle;

  /// No description provided for @labelYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get labelYear;

  /// No description provided for @labelRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get labelRating;

  /// No description provided for @labelGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get labelGenres;

  /// No description provided for @labelDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get labelDuration;

  /// No description provided for @labelPoster.
  ///
  /// In en, this message translates to:
  /// **'Poster'**
  String get labelPoster;

  /// No description provided for @labelTrailer.
  ///
  /// In en, this message translates to:
  /// **'Trailer'**
  String get labelTrailer;

  /// No description provided for @dateNightShareSectionMenu.
  ///
  /// In en, this message translates to:
  /// **'MENU'**
  String get dateNightShareSectionMenu;

  /// No description provided for @labelMainDish.
  ///
  /// In en, this message translates to:
  /// **'Main Dish'**
  String get labelMainDish;

  /// No description provided for @labelDessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get labelDessert;

  /// No description provided for @labelDrink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get labelDrink;

  /// No description provided for @labelSnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get labelSnacks;

  /// No description provided for @createdWithRollflix.
  ///
  /// In en, this message translates to:
  /// **'Created with Rollflix 🎬🍿'**
  String get createdWithRollflix;

  /// No description provided for @labelAppetizer.
  ///
  /// In en, this message translates to:
  /// **'Appetizer'**
  String get labelAppetizer;

  /// No description provided for @labelSideDish.
  ///
  /// In en, this message translates to:
  /// **'Side Dish'**
  String get labelSideDish;

  /// No description provided for @viewRecipe.
  ///
  /// In en, this message translates to:
  /// **'View recipe'**
  String get viewRecipe;

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
  /// **'Share'**
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
  /// **'No series found'**
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
  /// **'SERIES'**
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

  /// No description provided for @findYourNextFavoriteSeries.
  ///
  /// In en, this message translates to:
  /// **'Find your next favorite series'**
  String get findYourNextFavoriteSeries;

  /// No description provided for @noPopularSeriesFound.
  ///
  /// In en, this message translates to:
  /// **'No popular series found'**
  String get noPopularSeriesFound;

  /// No description provided for @initialGenreSelected.
  ///
  /// In en, this message translates to:
  /// **'Initial genre selected: {genre}'**
  String initialGenreSelected(Object genre);

  /// No description provided for @newMovieSelected.
  ///
  /// In en, this message translates to:
  /// **'✅ New movie selected!'**
  String get newMovieSelected;

  /// No description provided for @newMenuSelected.
  ///
  /// In en, this message translates to:
  /// **'✅ New menu selected!'**
  String get newMenuSelected;

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
  /// **'Date Night 🚧'**
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

  /// No description provided for @subscriptionOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium!'**
  String get subscriptionOfferTitle;

  /// No description provided for @subscriptionOfferSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoy unlimited features and no ads'**
  String get subscriptionOfferSubtitle;

  /// No description provided for @benefitUnlimitedAccess.
  ///
  /// In en, this message translates to:
  /// **'Unlimited access to movies and series'**
  String get benefitUnlimitedAccess;

  /// No description provided for @benefitNoAds.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get benefitNoAds;

  /// No description provided for @benefitUnlimitedFavorites.
  ///
  /// In en, this message translates to:
  /// **'Unlimited favorites'**
  String get benefitUnlimitedFavorites;

  /// No description provided for @benefitEarlyAccess.
  ///
  /// In en, this message translates to:
  /// **'Early access to new features'**
  String get benefitEarlyAccess;

  /// No description provided for @planMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get planMonthly;

  /// No description provided for @planAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual Plan'**
  String get planAnnual;

  /// No description provided for @economize.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get economize;

  /// No description provided for @cancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get cancelAnytime;

  /// No description provided for @subscriptionActivated.
  ///
  /// In en, this message translates to:
  /// **'Subscription activated: {plan}'**
  String subscriptionActivated(Object plan);

  /// No description provided for @subscriptionError.
  ///
  /// In en, this message translates to:
  /// **'Error processing subscription: {error}'**
  String subscriptionError(Object error);

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
  /// **'Watch a short ad and earn +1 {resource} extra!'**
  String watchAdForExtraResource(Object resource);

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
  /// **'Could not load the recipe. Please try again.'**
  String get recipeLoadError;

  /// No description provided for @aboutTheDish.
  ///
  /// In en, this message translates to:
  /// **'About the Dish'**
  String get aboutTheDish;

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

  /// No description provided for @movieGenreQuestion.
  ///
  /// In en, this message translates to:
  /// **'If your life were a movie, what would be the genre?'**
  String get movieGenreQuestion;

  /// No description provided for @dateNightGames.
  ///
  /// In en, this message translates to:
  /// **'Date Night Games'**
  String get dateNightGames;

  /// No description provided for @gamesAndActivities.
  ///
  /// In en, this message translates to:
  /// **'Games & Activities'**
  String get gamesAndActivities;

  /// No description provided for @makeNightFun.
  ///
  /// In en, this message translates to:
  /// **'Make the night more fun and memorable'**
  String get makeNightFun;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'season'**
  String get season;

  /// No description provided for @seasons.
  ///
  /// In en, this message translates to:
  /// **'seasons'**
  String get seasons;

  /// No description provided for @episode.
  ///
  /// In en, this message translates to:
  /// **'episode'**
  String get episode;

  /// No description provided for @episodes.
  ///
  /// In en, this message translates to:
  /// **'episodes'**
  String get episodes;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @newEpisodeAvailable.
  ///
  /// In en, this message translates to:
  /// **'New Episode Available!'**
  String get newEpisodeAvailable;

  /// No description provided for @newEpisodeOf.
  ///
  /// In en, this message translates to:
  /// **'New episode of'**
  String get newEpisodeOf;

  /// No description provided for @earnExtraResource.
  ///
  /// In en, this message translates to:
  /// **'Earn Extra Resource'**
  String get earnExtraResource;

  /// No description provided for @noResourceAvailable.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have {resource} available.'**
  String noResourceAvailable(Object resource);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @errorChangingMovie.
  ///
  /// In en, this message translates to:
  /// **'Error changing movie: {error}'**
  String errorChangingMovie(Object error);

  /// No description provided for @errorChangingMenu.
  ///
  /// In en, this message translates to:
  /// **'Error changing menu: {error}'**
  String errorChangingMenu(Object error);

  /// No description provided for @errorSharing.
  ///
  /// In en, this message translates to:
  /// **'Error sharing: {error}'**
  String errorSharing(Object error);

  /// No description provided for @errorOpeningDetails.
  ///
  /// In en, this message translates to:
  /// **'Error opening details: {error}'**
  String errorOpeningDetails(Object error);

  /// No description provided for @selectDateNightType.
  ///
  /// In en, this message translates to:
  /// **'Select a date night type first'**
  String get selectDateNightType;

  /// No description provided for @noMoviesForDateNight.
  ///
  /// In en, this message translates to:
  /// **'No movies found for this date night type'**
  String get noMoviesForDateNight;

  /// No description provided for @errorGeneratingDateNight.
  ///
  /// In en, this message translates to:
  /// **'Error generating date night: {error}'**
  String errorGeneratingDateNight(Object error);

  /// No description provided for @seriesType.
  ///
  /// In en, this message translates to:
  /// **'SERIES'**
  String get seriesType;

  /// No description provided for @movieType.
  ///
  /// In en, this message translates to:
  /// **'MOVIE'**
  String get movieType;

  /// No description provided for @reminderType.
  ///
  /// In en, this message translates to:
  /// **'REMINDER'**
  String get reminderType;

  /// No description provided for @otherType.
  ///
  /// In en, this message translates to:
  /// **'OTHER'**
  String get otherType;

  /// No description provided for @coupleQuizRule1.
  ///
  /// In en, this message translates to:
  /// **'Write answers about each other'**
  String get coupleQuizRule1;

  /// No description provided for @coupleQuizRule2.
  ///
  /// In en, this message translates to:
  /// **'Compare your answers'**
  String get coupleQuizRule2;

  /// No description provided for @coupleQuizRule3.
  ///
  /// In en, this message translates to:
  /// **'Score points for correct answers'**
  String get coupleQuizRule3;

  /// No description provided for @coupleQuizRule4.
  ///
  /// In en, this message translates to:
  /// **'Discover new things!'**
  String get coupleQuizRule4;

  /// No description provided for @movieMimicRule1.
  ///
  /// In en, this message translates to:
  /// **'One acts out, the other guesses'**
  String get movieMimicRule1;

  /// No description provided for @movieMimicRule2.
  ///
  /// In en, this message translates to:
  /// **'No words!'**
  String get movieMimicRule2;

  /// No description provided for @movieMimicRule3.
  ///
  /// In en, this message translates to:
  /// **'Time limit: 1 minute per movie'**
  String get movieMimicRule3;

  /// No description provided for @searchSeriesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter series name...'**
  String get searchSeriesHint;

  /// No description provided for @searchSeriesPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type something to search for series'**
  String get searchSeriesPrompt;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @searchTVHint.
  ///
  /// In en, this message translates to:
  /// **'Search series...'**
  String get searchTVHint;

  /// No description provided for @noSeriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No series available'**
  String get noSeriesAvailable;

  /// No description provided for @reloading.
  ///
  /// In en, this message translates to:
  /// **'Reloading'**
  String get reloading;

  /// No description provided for @trendingTab.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trendingTab;

  /// No description provided for @topRatedTab.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRatedTab;

  /// No description provided for @tapForDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap for details'**
  String get tapForDetails;

  /// No description provided for @tapForMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap for more details'**
  String get tapForMoreDetails;

  /// No description provided for @recipeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Recipe Unavailable'**
  String get recipeUnavailable;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @quick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get quick;

  /// No description provided for @mediumTime.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumTime;

  /// No description provided for @elaborate.
  ///
  /// In en, this message translates to:
  /// **'Elaborate'**
  String get elaborate;

  /// No description provided for @gourmet.
  ///
  /// In en, this message translates to:
  /// **'Gourmet'**
  String get gourmet;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advancedSkill.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedSkill;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @beginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Simple and straightforward recipes'**
  String get beginnerDesc;

  /// No description provided for @intermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'Some experience required'**
  String get intermediateDesc;

  /// No description provided for @advancedDesc.
  ///
  /// In en, this message translates to:
  /// **'More complex techniques'**
  String get advancedDesc;

  /// No description provided for @expertDesc.
  ///
  /// In en, this message translates to:
  /// **'High gastronomy'**
  String get expertDesc;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @difficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficultyLabel;

  /// No description provided for @preparationTimePrefix.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Preparation Time:'**
  String get preparationTimePrefix;

  /// No description provided for @difficultyPrefix.
  ///
  /// In en, this message translates to:
  /// **'📊 Difficulty:'**
  String get difficultyPrefix;

  /// No description provided for @genreNovidades.
  ///
  /// In en, this message translates to:
  /// **'New Releases'**
  String get genreNovidades;

  /// No description provided for @genreAcao.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get genreAcao;

  /// No description provided for @genreAventura.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get genreAventura;

  /// No description provided for @genreAnimacao.
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get genreAnimacao;

  /// No description provided for @genreComedia.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get genreComedia;

  /// No description provided for @genreCrime.
  ///
  /// In en, this message translates to:
  /// **'Crime'**
  String get genreCrime;

  /// No description provided for @genreDocumentario.
  ///
  /// In en, this message translates to:
  /// **'Documentary'**
  String get genreDocumentario;

  /// No description provided for @genreDrama.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get genreDrama;

  /// No description provided for @genreFamilia.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get genreFamilia;

  /// No description provided for @genreFantasia.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get genreFantasia;

  /// No description provided for @genreHistoria.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get genreHistoria;

  /// No description provided for @genreTerror.
  ///
  /// In en, this message translates to:
  /// **'Horror'**
  String get genreTerror;

  /// No description provided for @genreMusica.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get genreMusica;

  /// No description provided for @genreMisterio.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get genreMisterio;

  /// No description provided for @genreRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get genreRomance;

  /// No description provided for @genreFiccaoCientifica.
  ///
  /// In en, this message translates to:
  /// **'Science Fiction'**
  String get genreFiccaoCientifica;

  /// No description provided for @genreSuspense.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get genreSuspense;

  /// No description provided for @genreGuerra.
  ///
  /// In en, this message translates to:
  /// **'War'**
  String get genreGuerra;

  /// No description provided for @genreWestern.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get genreWestern;

  /// No description provided for @genreFavoritos.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get genreFavoritos;

  /// No description provided for @genreAssistidos.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get genreAssistidos;

  /// No description provided for @tvGenreNovidades.
  ///
  /// In en, this message translates to:
  /// **'New Releases'**
  String get tvGenreNovidades;

  /// No description provided for @tvGenreAcaoAventura.
  ///
  /// In en, this message translates to:
  /// **'Action & Adventure'**
  String get tvGenreAcaoAventura;

  /// No description provided for @tvGenreAnimacao.
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get tvGenreAnimacao;

  /// No description provided for @tvGenreComedia.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get tvGenreComedia;

  /// No description provided for @tvGenreCrime.
  ///
  /// In en, this message translates to:
  /// **'Crime'**
  String get tvGenreCrime;

  /// No description provided for @tvGenreDocumentario.
  ///
  /// In en, this message translates to:
  /// **'Documentary'**
  String get tvGenreDocumentario;

  /// No description provided for @tvGenreDrama.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get tvGenreDrama;

  /// No description provided for @tvGenreFamilia.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get tvGenreFamilia;

  /// No description provided for @tvGenreInfantil.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get tvGenreInfantil;

  /// No description provided for @tvGenreMisterio.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get tvGenreMisterio;

  /// No description provided for @tvGenreNovela.
  ///
  /// In en, this message translates to:
  /// **'Soap'**
  String get tvGenreNovela;

  /// No description provided for @tvGenreFiccaoCientificaFantasia.
  ///
  /// In en, this message translates to:
  /// **'Sci-Fi & Fantasy'**
  String get tvGenreFiccaoCientificaFantasia;

  /// No description provided for @tvGenreTalkShow.
  ///
  /// In en, this message translates to:
  /// **'Talk Show'**
  String get tvGenreTalkShow;

  /// No description provided for @tvGenreGuerraPolitica.
  ///
  /// In en, this message translates to:
  /// **'War & Politics'**
  String get tvGenreGuerraPolitica;

  /// No description provided for @tvGenreWestern.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get tvGenreWestern;

  /// No description provided for @tvGenreReality.
  ///
  /// In en, this message translates to:
  /// **'Reality'**
  String get tvGenreReality;

  /// No description provided for @tvGenreFavoritos.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tvGenreFavoritos;

  /// No description provided for @tvGenreAssistidos.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get tvGenreAssistidos;

  /// No description provided for @memoriesAndExperiences.
  ///
  /// In en, this message translates to:
  /// **'Memories and Experiences'**
  String get memoriesAndExperiences;

  /// No description provided for @tastesAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'Tastes and Preferences'**
  String get tastesAndPreferences;

  /// No description provided for @funAndImagination.
  ///
  /// In en, this message translates to:
  /// **'Fun and Imagination'**
  String get funAndImagination;

  /// No description provided for @philosophyAndValues.
  ///
  /// In en, this message translates to:
  /// **'Philosophy and Values'**
  String get philosophyAndValues;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @learnIn5YearsQuestion.
  ///
  /// In en, this message translates to:
  /// **'What would you like to learn in the next 5 years?'**
  String get learnIn5YearsQuestion;

  /// No description provided for @superpowerQuestion.
  ///
  /// In en, this message translates to:
  /// **'If you could have any superpower, what would it be?'**
  String get superpowerQuestion;

  /// No description provided for @idealLifeQuestion.
  ///
  /// In en, this message translates to:
  /// **'What would your ideal life look like in 10 years?'**
  String get idealLifeQuestion;

  /// No description provided for @bestChildhoodMemoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your best childhood memory?'**
  String get bestChildhoodMemoryQuestion;

  /// No description provided for @mostMemorableTripQuestion.
  ///
  /// In en, this message translates to:
  /// **'What was the most memorable trip you\'ve ever taken?'**
  String get mostMemorableTripQuestion;

  /// No description provided for @mostEmbarrassingMomentQuestion.
  ///
  /// In en, this message translates to:
  /// **'What was the most embarrassing moment of your life?'**
  String get mostEmbarrassingMomentQuestion;

  /// No description provided for @bestGiftReceivedQuestion.
  ///
  /// In en, this message translates to:
  /// **'What was the best gift you\'ve ever received?'**
  String get bestGiftReceivedQuestion;

  /// No description provided for @happiestDayQuestion.
  ///
  /// In en, this message translates to:
  /// **'What was the happiest day of your life so far?'**
  String get happiestDayQuestion;

  /// No description provided for @favoriteMovieQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your all-time favorite movie?'**
  String get favoriteMovieQuestion;

  /// No description provided for @dinnerWithAnyoneQuestion.
  ///
  /// In en, this message translates to:
  /// **'If you could have dinner with anyone, living or dead, who would it be?'**
  String get dinnerWithAnyoneQuestion;

  /// No description provided for @comfortFoodQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your comfort food?'**
  String get comfortFoodQuestion;

  /// No description provided for @beachOrMountainQuestion.
  ///
  /// In en, this message translates to:
  /// **'Beach or mountain? Why?'**
  String get beachOrMountainQuestion;

  /// No description provided for @musicThatMakesAliveQuestion.
  ///
  /// In en, this message translates to:
  /// **'What music makes you feel most alive?'**
  String get musicThatMakesAliveQuestion;

  /// No description provided for @superpowerNotWantedQuestion.
  ///
  /// In en, this message translates to:
  /// **'What superpower would you NOT want to have?'**
  String get superpowerNotWantedQuestion;

  /// No description provided for @invisibleDayQuestion.
  ///
  /// In en, this message translates to:
  /// **'If you could be invisible for a day, what would you do?'**
  String get invisibleDayQuestion;

  /// No description provided for @movieStarNameQuestion.
  ///
  /// In en, this message translates to:
  /// **'What would your movie star name be?'**
  String get movieStarNameQuestion;

  /// No description provided for @decadeToReturnQuestion.
  ///
  /// In en, this message translates to:
  /// **'If you could go back to any decade, which would it be?'**
  String get decadeToReturnQuestion;

  /// No description provided for @mostImportantInLifeQuestion.
  ///
  /// In en, this message translates to:
  /// **'What do you consider most important in life?'**
  String get mostImportantInLifeQuestion;

  /// No description provided for @adviceToYoungerSelfQuestion.
  ///
  /// In en, this message translates to:
  /// **'What advice would you give to your 10-year-old self?'**
  String get adviceToYoungerSelfQuestion;

  /// No description provided for @whatMakesGratefulQuestion.
  ///
  /// In en, this message translates to:
  /// **'What makes you feel most grateful?'**
  String get whatMakesGratefulQuestion;

  /// No description provided for @biggestFearQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your biggest fear?'**
  String get biggestFearQuestion;

  /// No description provided for @successMeaningQuestion.
  ///
  /// In en, this message translates to:
  /// **'What does success mean to you?'**
  String get successMeaningQuestion;

  /// No description provided for @mostValuedInRelationshipQuestion.
  ///
  /// In en, this message translates to:
  /// **'What do you value most in a relationship?'**
  String get mostValuedInRelationshipQuestion;

  /// No description provided for @bestMemoryTogetherQuestion.
  ///
  /// In en, this message translates to:
  /// **'What was our best memory together?'**
  String get bestMemoryTogetherQuestion;

  /// No description provided for @doMoreFrequentlyQuestion.
  ///
  /// In en, this message translates to:
  /// **'What would you like us to do more frequently?'**
  String get doMoreFrequentlyQuestion;

  /// No description provided for @feelMostLovedQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do you feel most loved?'**
  String get feelMostLovedQuestion;

  /// No description provided for @whereWeSeeIn5YearsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Where do you see us in 5 years?'**
  String get whereWeSeeIn5YearsQuestion;

  /// No description provided for @cookingBattleRule1.
  ///
  /// In en, this message translates to:
  /// **'Same ingredients, different dishes'**
  String get cookingBattleRule1;

  /// No description provided for @cookingBattleRule2.
  ///
  /// In en, this message translates to:
  /// **'Time limit: 30 minutes'**
  String get cookingBattleRule2;

  /// No description provided for @cookingBattleRule3.
  ///
  /// In en, this message translates to:
  /// **'Rate together'**
  String get cookingBattleRule3;

  /// No description provided for @cookingBattleRule4.
  ///
  /// In en, this message translates to:
  /// **'Loser does the dishes!'**
  String get cookingBattleRule4;

  /// No description provided for @guessTheMovie.
  ///
  /// In en, this message translates to:
  /// **'Guess the Movie'**
  String get guessTheMovie;

  /// No description provided for @guessTheMovieDesc.
  ///
  /// In en, this message translates to:
  /// **'Charades of movie scenes'**
  String get guessTheMovieDesc;

  /// No description provided for @buildTheStory.
  ///
  /// In en, this message translates to:
  /// **'Build the Story'**
  String get buildTheStory;

  /// No description provided for @buildTheStoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a story together'**
  String get buildTheStoryDesc;

  /// No description provided for @buildTheStoryRule1.
  ///
  /// In en, this message translates to:
  /// **'One starts the story'**
  String get buildTheStoryRule1;

  /// No description provided for @buildTheStoryRule2.
  ///
  /// In en, this message translates to:
  /// **'The other continues'**
  String get buildTheStoryRule2;

  /// No description provided for @buildTheStoryRule3.
  ///
  /// In en, this message translates to:
  /// **'Alternate every sentence'**
  String get buildTheStoryRule3;

  /// No description provided for @buildTheStoryRule4.
  ///
  /// In en, this message translates to:
  /// **'The more absurd, the better!'**
  String get buildTheStoryRule4;

  /// No description provided for @alternateQuestionsRule.
  ///
  /// In en, this message translates to:
  /// **'Take turns asking questions'**
  String get alternateQuestionsRule;

  /// No description provided for @beHonestOpenRule.
  ///
  /// In en, this message translates to:
  /// **'Be honest and open'**
  String get beHonestOpenRule;

  /// No description provided for @noJudgmentsRule.
  ///
  /// In en, this message translates to:
  /// **'No judgments'**
  String get noJudgmentsRule;

  /// No description provided for @canSkipQuestionRule.
  ///
  /// In en, this message translates to:
  /// **'You can skip a question if you want'**
  String get canSkipQuestionRule;

  /// No description provided for @chooseTruthOrDareRule.
  ///
  /// In en, this message translates to:
  /// **'Choose truth or dare'**
  String get chooseTruthOrDareRule;

  /// No description provided for @truthsMustBeSincereRule.
  ///
  /// In en, this message translates to:
  /// **'Truths must be sincere'**
  String get truthsMustBeSincereRule;

  /// No description provided for @daresMustBeCompletedRule.
  ///
  /// In en, this message translates to:
  /// **'Dares must be completed'**
  String get daresMustBeCompletedRule;

  /// No description provided for @keepLightFunRule.
  ///
  /// In en, this message translates to:
  /// **'Keep the mood light and fun'**
  String get keepLightFunRule;

  /// No description provided for @whoGetsMoreRightWinsRule.
  ///
  /// In en, this message translates to:
  /// **'Whoever gets more right wins'**
  String get whoGetsMoreRightWinsRule;

  /// No description provided for @jazzSmooth.
  ///
  /// In en, this message translates to:
  /// **'Smooth jazz'**
  String get jazzSmooth;

  /// No description provided for @bossaNova.
  ///
  /// In en, this message translates to:
  /// **'Bossa nova'**
  String get bossaNova;

  /// No description provided for @romanticClassics.
  ///
  /// In en, this message translates to:
  /// **'Romantic classics'**
  String get romanticClassics;

  /// No description provided for @romanticPop.
  ///
  /// In en, this message translates to:
  /// **'Romantic pop'**
  String get romanticPop;

  /// No description provided for @indieFolk.
  ///
  /// In en, this message translates to:
  /// **'Indie folk'**
  String get indieFolk;

  /// No description provided for @eightiesHits.
  ///
  /// In en, this message translates to:
  /// **'Eighties hits'**
  String get eightiesHits;

  /// No description provided for @classicalMusic.
  ///
  /// In en, this message translates to:
  /// **'Classical music'**
  String get classicalMusic;

  /// No description provided for @contemporaryJazz.
  ///
  /// In en, this message translates to:
  /// **'Contemporary jazz'**
  String get contemporaryJazz;

  /// No description provided for @instrumental.
  ///
  /// In en, this message translates to:
  /// **'Instrumental'**
  String get instrumental;

  /// No description provided for @spanishMusic.
  ///
  /// In en, this message translates to:
  /// **'Spanish music'**
  String get spanishMusic;

  /// No description provided for @latinJazz.
  ///
  /// In en, this message translates to:
  /// **'Latin jazz'**
  String get latinJazz;

  /// No description provided for @musicalSoundtracks.
  ///
  /// In en, this message translates to:
  /// **'Musical soundtracks'**
  String get musicalSoundtracks;

  /// No description provided for @softRock.
  ///
  /// In en, this message translates to:
  /// **'Soft rock'**
  String get softRock;

  /// No description provided for @romanticCountry.
  ///
  /// In en, this message translates to:
  /// **'Romantic country'**
  String get romanticCountry;

  /// No description provided for @internationalPop.
  ///
  /// In en, this message translates to:
  /// **'International pop'**
  String get internationalPop;

  /// No description provided for @classicRomance.
  ///
  /// In en, this message translates to:
  /// **'Classic Romance'**
  String get classicRomance;

  /// No description provided for @romanticComedy.
  ///
  /// In en, this message translates to:
  /// **'Romantic Comedy'**
  String get romanticComedy;

  /// No description provided for @romanticDrama.
  ///
  /// In en, this message translates to:
  /// **'Romantic Drama'**
  String get romanticDrama;

  /// No description provided for @musicalRomance.
  ///
  /// In en, this message translates to:
  /// **'Musical Romance'**
  String get musicalRomance;

  /// No description provided for @adventureRomance.
  ///
  /// In en, this message translates to:
  /// **'Adventure Romance'**
  String get adventureRomance;

  /// No description provided for @thrillerRomance.
  ///
  /// In en, this message translates to:
  /// **'Thriller Romance'**
  String get thrillerRomance;

  /// No description provided for @romanticFun.
  ///
  /// In en, this message translates to:
  /// **'Romantic Fun'**
  String get romanticFun;

  /// No description provided for @elegantRomance.
  ///
  /// In en, this message translates to:
  /// **'Elegant Romance'**
  String get elegantRomance;

  /// No description provided for @spanishPassion.
  ///
  /// In en, this message translates to:
  /// **'Spanish Passion'**
  String get spanishPassion;

  /// No description provided for @mysteryJazz.
  ///
  /// In en, this message translates to:
  /// **'Mystery Jazz'**
  String get mysteryJazz;

  /// No description provided for @darkAmbient.
  ///
  /// In en, this message translates to:
  /// **'Dark Ambient'**
  String get darkAmbient;

  /// No description provided for @intenseClassical.
  ///
  /// In en, this message translates to:
  /// **'Intense Classical'**
  String get intenseClassical;

  /// No description provided for @romanticMusic.
  ///
  /// In en, this message translates to:
  /// **'Romantic Music'**
  String get romanticMusic;

  /// No description provided for @bluesClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic blues'**
  String get bluesClassic;

  /// No description provided for @soulfulRhythms.
  ///
  /// In en, this message translates to:
  /// **'Soulful rhythms'**
  String get soulfulRhythms;

  /// No description provided for @chooseStyle.
  ///
  /// In en, this message translates to:
  /// **'Choose the Style'**
  String get chooseStyle;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparing;

  /// No description provided for @createPerfectDate.
  ///
  /// In en, this message translates to:
  /// **'💕 Create Perfect Date'**
  String get createPerfectDate;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready!'**
  String get ready;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @add5Min.
  ///
  /// In en, this message translates to:
  /// **'+5 min'**
  String get add5Min;

  /// No description provided for @ingredientsList.
  ///
  /// In en, this message translates to:
  /// **'Ingredients List'**
  String get ingredientsList;

  /// No description provided for @mainCourse.
  ///
  /// In en, this message translates to:
  /// **'Main Course'**
  String get mainCourse;

  /// No description provided for @dessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get dessert;

  /// No description provided for @appetizers.
  ///
  /// In en, this message translates to:
  /// **'Appetizers'**
  String get appetizers;

  /// No description provided for @sideDishes.
  ///
  /// In en, this message translates to:
  /// **'Side Dishes'**
  String get sideDishes;

  /// No description provided for @allIngredientsReady.
  ///
  /// In en, this message translates to:
  /// **'All ingredients ready! 🎉'**
  String get allIngredientsReady;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @dateNightSchedule.
  ///
  /// In en, this message translates to:
  /// **'Date Night Schedule'**
  String get dateNightSchedule;

  /// No description provided for @shrimpRisotto.
  ///
  /// In en, this message translates to:
  /// **'Shrimp risotto'**
  String get shrimpRisotto;

  /// No description provided for @homemadeMargheritaPizza.
  ///
  /// In en, this message translates to:
  /// **'Homemade margherita pizza'**
  String get homemadeMargheritaPizza;

  /// No description provided for @grilledSalmonWithAsparagus.
  ///
  /// In en, this message translates to:
  /// **'Grilled salmon with asparagus'**
  String get grilledSalmonWithAsparagus;

  /// No description provided for @valencianPaella.
  ///
  /// In en, this message translates to:
  /// **'Valencian paella'**
  String get valencianPaella;

  /// No description provided for @gourmetBarbecue.
  ///
  /// In en, this message translates to:
  /// **'Gourmet barbecue'**
  String get gourmetBarbecue;

  /// No description provided for @wildMushroomRisotto.
  ///
  /// In en, this message translates to:
  /// **'Wild mushroom risotto'**
  String get wildMushroomRisotto;

  /// No description provided for @roseWine.
  ///
  /// In en, this message translates to:
  /// **'Rosé wine'**
  String get roseWine;

  /// No description provided for @prosecco.
  ///
  /// In en, this message translates to:
  /// **'Prosecco'**
  String get prosecco;

  /// No description provided for @softRedWine.
  ///
  /// In en, this message translates to:
  /// **'Soft red wine'**
  String get softRedWine;

  /// No description provided for @sangria.
  ///
  /// In en, this message translates to:
  /// **'Sangria'**
  String get sangria;

  /// No description provided for @redBerryCaipirinha.
  ///
  /// In en, this message translates to:
  /// **'Red berry caipirinha'**
  String get redBerryCaipirinha;

  /// No description provided for @fullBodiedRedWine.
  ///
  /// In en, this message translates to:
  /// **'Full-bodied red wine'**
  String get fullBodiedRedWine;

  /// No description provided for @strawberriesWithChocolate.
  ///
  /// In en, this message translates to:
  /// **'Strawberries with chocolate'**
  String get strawberriesWithChocolate;

  /// No description provided for @brownieWithIceCream.
  ///
  /// In en, this message translates to:
  /// **'Brownie with ice cream'**
  String get brownieWithIceCream;

  /// No description provided for @tiramisu.
  ///
  /// In en, this message translates to:
  /// **'Tiramisu'**
  String get tiramisu;

  /// No description provided for @cremeBrulee.
  ///
  /// In en, this message translates to:
  /// **'Crème brûlée'**
  String get cremeBrulee;

  /// No description provided for @fruitPavlova.
  ///
  /// In en, this message translates to:
  /// **'Fruit pavlova'**
  String get fruitPavlova;

  /// No description provided for @darkChocolateCake.
  ///
  /// In en, this message translates to:
  /// **'Dark chocolate cake'**
  String get darkChocolateCake;

  /// No description provided for @specialCheeses.
  ///
  /// In en, this message translates to:
  /// **'Special cheeses'**
  String get specialCheeses;

  /// No description provided for @grapes.
  ///
  /// In en, this message translates to:
  /// **'Grapes'**
  String get grapes;

  /// No description provided for @nuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get nuts;

  /// No description provided for @gourmetPopcorn.
  ///
  /// In en, this message translates to:
  /// **'Gourmet popcorn'**
  String get gourmetPopcorn;

  /// No description provided for @olives.
  ///
  /// In en, this message translates to:
  /// **'Olives'**
  String get olives;

  /// No description provided for @garlicBread.
  ///
  /// In en, this message translates to:
  /// **'Garlic bread'**
  String get garlicBread;

  /// No description provided for @cheeseBoard.
  ///
  /// In en, this message translates to:
  /// **'Cheese board'**
  String get cheeseBoard;

  /// No description provided for @artisanBreads.
  ///
  /// In en, this message translates to:
  /// **'Artisan breads'**
  String get artisanBreads;

  /// No description provided for @varietyTapas.
  ///
  /// In en, this message translates to:
  /// **'Variety tapas'**
  String get varietyTapas;

  /// No description provided for @roastedPeppers.
  ///
  /// In en, this message translates to:
  /// **'Roasted peppers'**
  String get roastedPeppers;

  /// No description provided for @cheeseSkewers.
  ///
  /// In en, this message translates to:
  /// **'Cheese skewers'**
  String get cheeseSkewers;

  /// No description provided for @sweetPotatoChips.
  ///
  /// In en, this message translates to:
  /// **'Sweet potato chips'**
  String get sweetPotatoChips;

  /// No description provided for @guacamole.
  ///
  /// In en, this message translates to:
  /// **'Guacamole'**
  String get guacamole;

  /// No description provided for @agedCheeses.
  ///
  /// In en, this message translates to:
  /// **'Aged cheeses'**
  String get agedCheeses;

  /// No description provided for @rusticBreads.
  ///
  /// In en, this message translates to:
  /// **'Rustic breads'**
  String get rusticBreads;

  /// No description provided for @blackOlives.
  ///
  /// In en, this message translates to:
  /// **'Black olives'**
  String get blackOlives;

  /// No description provided for @lowLightsAromaticCandles.
  ///
  /// In en, this message translates to:
  /// **'Low lights and aromatic candles'**
  String get lowLightsAromaticCandles;

  /// No description provided for @relaxedFunAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'Relaxed and fun atmosphere'**
  String get relaxedFunAtmosphere;

  /// No description provided for @sophisticatedIntimate.
  ///
  /// In en, this message translates to:
  /// **'Sophisticated and intimate'**
  String get sophisticatedIntimate;

  /// No description provided for @vibrantMusical.
  ///
  /// In en, this message translates to:
  /// **'Vibrant and musical'**
  String get vibrantMusical;

  /// No description provided for @adventurousRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Adventurous and relaxed'**
  String get adventurousRelaxed;

  /// No description provided for @mysteriousIntense.
  ///
  /// In en, this message translates to:
  /// **'Mysterious and intense'**
  String get mysteriousIntense;

  /// No description provided for @fortyFiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'45 minutes'**
  String get fortyFiveMinutes;

  /// No description provided for @thirtyMinutes.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get thirtyMinutes;

  /// No description provided for @fiftyMinutes.
  ///
  /// In en, this message translates to:
  /// **'50 minutes'**
  String get fiftyMinutes;

  /// No description provided for @sixtyMinutes.
  ///
  /// In en, this message translates to:
  /// **'60 minutes'**
  String get sixtyMinutes;

  /// No description provided for @fortyMinutes.
  ///
  /// In en, this message translates to:
  /// **'40 minutes'**
  String get fortyMinutes;

  /// No description provided for @fiftyFiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'55 minutes'**
  String get fiftyFiveMinutes;

  /// No description provided for @arborioRice.
  ///
  /// In en, this message translates to:
  /// **'Arborio rice'**
  String get arborioRice;

  /// No description provided for @freshShrimp.
  ///
  /// In en, this message translates to:
  /// **'Fresh shrimp'**
  String get freshShrimp;

  /// No description provided for @whiteWine.
  ///
  /// In en, this message translates to:
  /// **'White wine'**
  String get whiteWine;

  /// No description provided for @fishBroth.
  ///
  /// In en, this message translates to:
  /// **'Fish broth'**
  String get fishBroth;

  /// No description provided for @parmesanCheese.
  ///
  /// In en, this message translates to:
  /// **'Parmesan cheese'**
  String get parmesanCheese;

  /// No description provided for @strawberries.
  ///
  /// In en, this message translates to:
  /// **'Strawberries'**
  String get strawberries;

  /// No description provided for @seventyPercentChocolate.
  ///
  /// In en, this message translates to:
  /// **'70% chocolate'**
  String get seventyPercentChocolate;

  /// No description provided for @pizzaDough.
  ///
  /// In en, this message translates to:
  /// **'Ready pizza dough'**
  String get pizzaDough;

  /// No description provided for @tomatoSauce.
  ///
  /// In en, this message translates to:
  /// **'Tomato sauce'**
  String get tomatoSauce;

  /// No description provided for @buffaloMozzarella.
  ///
  /// In en, this message translates to:
  /// **'Buffalo mozzarella'**
  String get buffaloMozzarella;

  /// No description provided for @freshBasil.
  ///
  /// In en, this message translates to:
  /// **'Fresh basil'**
  String get freshBasil;

  /// No description provided for @brownieMix.
  ///
  /// In en, this message translates to:
  /// **'Brownie mix'**
  String get brownieMix;

  /// No description provided for @vanillaIceCream.
  ///
  /// In en, this message translates to:
  /// **'Vanilla ice cream'**
  String get vanillaIceCream;

  /// No description provided for @salmonFillet.
  ///
  /// In en, this message translates to:
  /// **'Salmon fillet'**
  String get salmonFillet;

  /// No description provided for @freshAsparagus.
  ///
  /// In en, this message translates to:
  /// **'Fresh asparagus'**
  String get freshAsparagus;

  /// No description provided for @sicilianLemon.
  ///
  /// In en, this message translates to:
  /// **'Sicilian lemon'**
  String get sicilianLemon;

  /// No description provided for @extraVirginOliveOil.
  ///
  /// In en, this message translates to:
  /// **'Extra virgin olive oil'**
  String get extraVirginOliveOil;

  /// No description provided for @tiramisuIngredients.
  ///
  /// In en, this message translates to:
  /// **'Tiramisu ingredients'**
  String get tiramisuIngredients;

  /// No description provided for @espressoCoffee.
  ///
  /// In en, this message translates to:
  /// **'Espresso coffee'**
  String get espressoCoffee;

  /// No description provided for @bombaRice.
  ///
  /// In en, this message translates to:
  /// **'Bomba rice'**
  String get bombaRice;

  /// No description provided for @seafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get seafood;

  /// No description provided for @chicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get chicken;

  /// No description provided for @saffron.
  ///
  /// In en, this message translates to:
  /// **'Saffron'**
  String get saffron;

  /// No description provided for @peppers.
  ///
  /// In en, this message translates to:
  /// **'Peppers'**
  String get peppers;

  /// No description provided for @redWine.
  ///
  /// In en, this message translates to:
  /// **'Red wine'**
  String get redWine;

  /// No description provided for @fruitsForSangria.
  ///
  /// In en, this message translates to:
  /// **'Fruits for sangria'**
  String get fruitsForSangria;

  /// No description provided for @nobleMeatForBarbecue.
  ///
  /// In en, this message translates to:
  /// **'Noble meat for barbecue'**
  String get nobleMeatForBarbecue;

  /// No description provided for @specialSeasonings.
  ///
  /// In en, this message translates to:
  /// **'Special seasonings'**
  String get specialSeasonings;

  /// No description provided for @cachaca.
  ///
  /// In en, this message translates to:
  /// **'Cachaça'**
  String get cachaca;

  /// No description provided for @redBerries.
  ///
  /// In en, this message translates to:
  /// **'Red berries'**
  String get redBerries;

  /// No description provided for @readyMeringue.
  ///
  /// In en, this message translates to:
  /// **'Ready meringue'**
  String get readyMeringue;

  /// No description provided for @seasonalFruits.
  ///
  /// In en, this message translates to:
  /// **'Seasonal fruits'**
  String get seasonalFruits;

  /// No description provided for @wildMushrooms.
  ///
  /// In en, this message translates to:
  /// **'Wild mushrooms'**
  String get wildMushrooms;

  /// No description provided for @vegetableBroth.
  ///
  /// In en, this message translates to:
  /// **'Vegetable broth'**
  String get vegetableBroth;

  /// No description provided for @eightyFivePercentChocolate.
  ///
  /// In en, this message translates to:
  /// **'85% chocolate'**
  String get eightyFivePercentChocolate;

  /// No description provided for @heavyCream.
  ///
  /// In en, this message translates to:
  /// **'Heavy cream'**
  String get heavyCream;

  /// No description provided for @stirRisottoConstantly.
  ///
  /// In en, this message translates to:
  /// **'Stir the risotto constantly to make it creamy'**
  String get stirRisottoConstantly;

  /// No description provided for @useFreshIngredients.
  ///
  /// In en, this message translates to:
  /// **'Use fresh ingredients for authentic flavor'**
  String get useFreshIngredients;

  /// No description provided for @dontOvercookSalmon.
  ///
  /// In en, this message translates to:
  /// **'Don\'t overcook the salmon to maintain texture'**
  String get dontOvercookSalmon;

  /// No description provided for @useTraditionalPaellaPan.
  ///
  /// In en, this message translates to:
  /// **'Use traditional paella pan if possible'**
  String get useTraditionalPaellaPan;

  /// No description provided for @marinateMeatForHours.
  ///
  /// In en, this message translates to:
  /// **'Let the meat marinate for several hours'**
  String get marinateMeatForHours;

  /// No description provided for @useFreshMushrooms.
  ///
  /// In en, this message translates to:
  /// **'Use fresh mushrooms for better flavor'**
  String get useFreshMushrooms;

  /// No description provided for @classicRomanceTheme.
  ///
  /// In en, this message translates to:
  /// **'Classic Romance'**
  String get classicRomanceTheme;

  /// No description provided for @romanticFunTheme.
  ///
  /// In en, this message translates to:
  /// **'Romantic Fun'**
  String get romanticFunTheme;

  /// No description provided for @elegantRomanceTheme.
  ///
  /// In en, this message translates to:
  /// **'Elegant Romance'**
  String get elegantRomanceTheme;

  /// No description provided for @spanishPassionTheme.
  ///
  /// In en, this message translates to:
  /// **'Spanish Passion'**
  String get spanishPassionTheme;

  /// No description provided for @adventureRomanceTheme.
  ///
  /// In en, this message translates to:
  /// **'Adventure Romance'**
  String get adventureRomanceTheme;

  /// No description provided for @thrillerRomanceTheme.
  ///
  /// In en, this message translates to:
  /// **'Thriller Romance'**
  String get thrillerRomanceTheme;

  /// No description provided for @candlesWarmLED.
  ///
  /// In en, this message translates to:
  /// **'Candles and warm LED lights'**
  String get candlesWarmLED;

  /// No description provided for @colorfulLightsCheerful.
  ///
  /// In en, this message translates to:
  /// **'Colorful lights and cheerful atmosphere'**
  String get colorfulLightsCheerful;

  /// No description provided for @softLightingElegant.
  ///
  /// In en, this message translates to:
  /// **'Soft lighting and elegant atmosphere'**
  String get softLightingElegant;

  /// No description provided for @warmLightsFestive.
  ///
  /// In en, this message translates to:
  /// **'Warm lights and festive atmosphere'**
  String get warmLightsFestive;

  /// No description provided for @outdoorNaturalLight.
  ///
  /// In en, this message translates to:
  /// **'Outdoor or natural lighting'**
  String get outdoorNaturalLight;

  /// No description provided for @lowLightsDramatic.
  ///
  /// In en, this message translates to:
  /// **'Low lights and dramatic atmosphere'**
  String get lowLightsDramatic;

  /// No description provided for @cost80120.
  ///
  /// In en, this message translates to:
  /// **'\$80-120'**
  String get cost80120;

  /// No description provided for @cost4060.
  ///
  /// In en, this message translates to:
  /// **'\$40-60'**
  String get cost4060;

  /// No description provided for @cost100150.
  ///
  /// In en, this message translates to:
  /// **'\$100-150'**
  String get cost100150;

  /// No description provided for @cost90130.
  ///
  /// In en, this message translates to:
  /// **'\$90-130'**
  String get cost90130;

  /// No description provided for @cost70100.
  ///
  /// In en, this message translates to:
  /// **'\$70-100'**
  String get cost70100;

  /// No description provided for @cost85125.
  ///
  /// In en, this message translates to:
  /// **'\$85-125'**
  String get cost85125;

  /// No description provided for @mushrooms.
  ///
  /// In en, this message translates to:
  /// **'Mushrooms'**
  String get mushrooms;

  /// No description provided for @onion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get onion;

  /// No description provided for @garlic.
  ///
  /// In en, this message translates to:
  /// **'Garlic'**
  String get garlic;

  /// No description provided for @bellPepper.
  ///
  /// In en, this message translates to:
  /// **'Bell pepper'**
  String get bellPepper;

  /// No description provided for @strongCheeses.
  ///
  /// In en, this message translates to:
  /// **'Strong cheeses'**
  String get strongCheeses;

  /// No description provided for @fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// No description provided for @redMeat.
  ///
  /// In en, this message translates to:
  /// **'Red meat'**
  String get redMeat;

  /// No description provided for @milk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get milk;

  /// No description provided for @eggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get eggs;

  /// No description provided for @director.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get director;

  /// No description provided for @actor.
  ///
  /// In en, this message translates to:
  /// **'Actor'**
  String get actor;

  /// No description provided for @selectedMovie.
  ///
  /// In en, this message translates to:
  /// **'🎬 Selected Movie'**
  String get selectedMovie;

  /// No description provided for @changeMovie.
  ///
  /// In en, this message translates to:
  /// **'Change movie'**
  String get changeMovie;

  /// No description provided for @servingsText.
  ///
  /// In en, this message translates to:
  /// **'{count} servings'**
  String servingsText(Object count);
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
