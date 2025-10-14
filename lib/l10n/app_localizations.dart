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
  /// **'Test notification'**
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
  /// **'Do you want to clear the sent notifications history? This allows notifications to be sent again.'**
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
  /// **'Test notification sent'**
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
  /// **'Direction'**
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

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @errorLoadingDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading movie details'**
  String get errorLoadingDetails;
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
