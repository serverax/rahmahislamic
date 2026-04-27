import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rahma'**
  String get appName;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get selectLanguageSubtitle;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Read the Quran'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Access the complete Quran with translations and understand the words of Allah'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Never miss a prayer with accurate timings for your location'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Daily Adhkar'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Remember Allah with morning and evening adhkar from authentic sources'**
  String get onboarding3Body;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quran;

  /// No description provided for @adhkar.
  ///
  /// In en, this message translates to:
  /// **'Adhkar'**
  String get adhkar;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @quranComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Quran reader — coming next slice'**
  String get quranComingSoon;

  /// No description provided for @adhkarComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Adhkar — coming next slice'**
  String get adhkarComingSoon;

  /// No description provided for @duaComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Dua — coming next slice'**
  String get duaComingSoon;

  /// No description provided for @moreComingSoon.
  ///
  /// In en, this message translates to:
  /// **'More — coming next slice'**
  String get moreComingSoon;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @askSheikh.
  ///
  /// In en, this message translates to:
  /// **'Ask Sheikh'**
  String get askSheikh;

  /// No description provided for @askSheikhSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Islamic guidance'**
  String get askSheikhSubtitle;

  /// No description provided for @askSheikhDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This feature provides general Islamic guidance based on selected sources. It is not a final fatwa. For personal, family, financial, legal, medical, or urgent matters, please consult a qualified scholar.'**
  String get askSheikhDisclaimer;

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newBadge;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @bookmarksTab.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksTab;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// No description provided for @surahLabel.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get surahLabel;

  /// No description provided for @juz.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get juz;

  /// No description provided for @verse.
  ///
  /// In en, this message translates to:
  /// **'Verse'**
  String get verse;

  /// No description provided for @verses.
  ///
  /// In en, this message translates to:
  /// **'verses'**
  String get verses;

  /// No description provided for @meccan.
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get meccan;

  /// No description provided for @medinan.
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get medinan;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchQuran.
  ///
  /// In en, this message translates to:
  /// **'Search the Quran'**
  String get searchQuran;

  /// No description provided for @popularSearches.
  ///
  /// In en, this message translates to:
  /// **'Popular searches'**
  String get popularSearches;

  /// No description provided for @searchTooShort.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 letters'**
  String get searchTooShort;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet. Tap the bookmark icon on any verse.'**
  String get noBookmarks;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @audioComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Audio recitation coming in a future slice'**
  String get audioComingSoon;

  /// No description provided for @showTranslation.
  ///
  /// In en, this message translates to:
  /// **'Show translation'**
  String get showTranslation;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @bookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get bookmarkRemoved;

  /// No description provided for @openSurah.
  ///
  /// In en, this message translates to:
  /// **'Open surah'**
  String get openSurah;

  /// No description provided for @verseN.
  ///
  /// In en, this message translates to:
  /// **'Verse {n}'**
  String verseN(int n);

  /// No description provided for @ofTotal.
  ///
  /// In en, this message translates to:
  /// **'of {total}'**
  String ofTotal(int total);

  /// No description provided for @tasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbih;

  /// No description provided for @tasbihCounter.
  ///
  /// In en, this message translates to:
  /// **'Tasbih Counter'**
  String get tasbihCounter;

  /// No description provided for @tapToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap to count'**
  String get tapToCount;

  /// No description provided for @tapAnywhereToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to count'**
  String get tapAnywhereToCount;

  /// No description provided for @selectPhrase.
  ///
  /// In en, this message translates to:
  /// **'Select phrase'**
  String get selectPhrase;

  /// No description provided for @totalCount.
  ///
  /// In en, this message translates to:
  /// **'Total count'**
  String get totalCount;

  /// No description provided for @resetCounter.
  ///
  /// In en, this message translates to:
  /// **'Reset counter'**
  String get resetCounter;

  /// No description provided for @category_morning.
  ///
  /// In en, this message translates to:
  /// **'Morning Adhkar'**
  String get category_morning;

  /// No description provided for @category_evening.
  ///
  /// In en, this message translates to:
  /// **'Evening Adhkar'**
  String get category_evening;

  /// No description provided for @category_after_salah.
  ///
  /// In en, this message translates to:
  /// **'After Prayer'**
  String get category_after_salah;

  /// No description provided for @category_sleep.
  ///
  /// In en, this message translates to:
  /// **'Before Sleep'**
  String get category_sleep;

  /// No description provided for @category_wake.
  ///
  /// In en, this message translates to:
  /// **'Upon Waking'**
  String get category_wake;

  /// No description provided for @category_protection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get category_protection;

  /// No description provided for @category_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily Remembrance'**
  String get category_daily;

  /// No description provided for @dhikrOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{n} of {total}'**
  String dhikrOfTotal(int n, int total);

  /// No description provided for @repeatN.
  ///
  /// In en, this message translates to:
  /// **'Repeat {n} times'**
  String repeatN(int n);

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @asmaUlHusna.
  ///
  /// In en, this message translates to:
  /// **'99 Names of Allah'**
  String get asmaUlHusna;

  /// No description provided for @asmaUlHusnaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Most Beautiful Names'**
  String get asmaUlHusnaSubtitle;

  /// No description provided for @duaCategories.
  ///
  /// In en, this message translates to:
  /// **'Dua Categories'**
  String get duaCategories;

  /// No description provided for @duaCount.
  ///
  /// In en, this message translates to:
  /// **'{n} duas'**
  String duaCount(int n);

  /// No description provided for @duaCategory_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily Life'**
  String get duaCategory_daily;

  /// No description provided for @duaCategory_distress.
  ///
  /// In en, this message translates to:
  /// **'Distress & Anxiety'**
  String get duaCategory_distress;

  /// No description provided for @duaCategory_travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get duaCategory_travel;

  /// No description provided for @duaCategory_food.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get duaCategory_food;

  /// No description provided for @duaCategory_knowledge.
  ///
  /// In en, this message translates to:
  /// **'Seeking Knowledge'**
  String get duaCategory_knowledge;

  /// No description provided for @duaCategory_forgiveness.
  ///
  /// In en, this message translates to:
  /// **'Repentance'**
  String get duaCategory_forgiveness;

  /// No description provided for @duaCategory_guidance.
  ///
  /// In en, this message translates to:
  /// **'Guidance'**
  String get duaCategory_guidance;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareContent.
  ///
  /// In en, this message translates to:
  /// **'Share content'**
  String get shareContent;

  /// No description provided for @shareVia.
  ///
  /// In en, this message translates to:
  /// **'Share via…'**
  String get shareVia;

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy text'**
  String get copyText;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @soonState.
  ///
  /// In en, this message translates to:
  /// **'in {minutes} min'**
  String soonState(int minutes);

  /// No description provided for @activeState.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for {prayer}'**
  String activeState(String prayer);

  /// No description provided for @noLocationYet.
  ///
  /// In en, this message translates to:
  /// **'Pick a city in Prayer Settings'**
  String get noLocationYet;

  /// No description provided for @dreamInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Dream Interpretation'**
  String get dreamInterpretation;

  /// No description provided for @dreamInterpretationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Experimental — awaiting scholar review'**
  String get dreamInterpretationSubtitle;

  /// No description provided for @dreamWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Important Notice'**
  String get dreamWarningTitle;

  /// No description provided for @dreamWarningBodyEn.
  ///
  /// In en, this message translates to:
  /// **'Dream interpretation is not a definitive science. Do not rely on it for decisions about marriage, divorce, finance, medical treatment, or accusing others. If a dream is recurrently distressing, please consult a qualified scholar or specialist.'**
  String get dreamWarningBodyEn;

  /// No description provided for @dreamAgree.
  ///
  /// In en, this message translates to:
  /// **'I understand and accept'**
  String get dreamAgree;

  /// No description provided for @dreamInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Describe your dream'**
  String get dreamInputTitle;

  /// No description provided for @dreamInputHint.
  ///
  /// In en, this message translates to:
  /// **'Write your dream in detail in Arabic…'**
  String get dreamInputHint;

  /// No description provided for @dreamSubmit.
  ///
  /// In en, this message translates to:
  /// **'Interpret'**
  String get dreamSubmit;

  /// No description provided for @dreamEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please write your dream first'**
  String get dreamEmpty;

  /// No description provided for @dreamBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot interpret'**
  String get dreamBlockedTitle;

  /// No description provided for @dreamBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'This dream contains content we cannot safely interpret. Please consult a qualified scholar or specialist.'**
  String get dreamBlockedBody;

  /// No description provided for @dreamLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached'**
  String get dreamLimitTitle;

  /// No description provided for @dreamLimitBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached today\'s interpretation limit (3). Please come back tomorrow.'**
  String get dreamLimitBody;

  /// No description provided for @dreamResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Interpretation'**
  String get dreamResultTitle;

  /// No description provided for @dreamPossibleMeanings.
  ///
  /// In en, this message translates to:
  /// **'Possible meanings'**
  String get dreamPossibleMeanings;

  /// No description provided for @dreamNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No matching symbols found in our small starter set. Try mentioning common elements (water, light, tree, garden, bird, mountain, house, milk, honey, rain).'**
  String get dreamNoMatch;

  /// No description provided for @dreamHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Past dreams'**
  String get dreamHistoryTitle;

  /// No description provided for @dreamHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No past dreams yet.'**
  String get dreamHistoryEmpty;

  /// No description provided for @dreamClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get dreamClearHistory;

  /// No description provided for @dreamReviewBanner.
  ///
  /// In en, this message translates to:
  /// **'Experimental content awaiting scholar review. Do not act on these interpretations.'**
  String get dreamReviewBanner;

  /// No description provided for @newDream.
  ///
  /// In en, this message translates to:
  /// **'New dream'**
  String get newDream;

  /// No description provided for @bearing.
  ///
  /// In en, this message translates to:
  /// **'Bearing'**
  String get bearing;

  /// No description provided for @distanceToMecca.
  ///
  /// In en, this message translates to:
  /// **'Distance to Mecca'**
  String get distanceToMecca;

  /// No description provided for @kmAbbrev.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmAbbrev;

  /// No description provided for @facingQibla.
  ///
  /// In en, this message translates to:
  /// **'You are facing the Qibla'**
  String get facingQibla;

  /// No description provided for @rotateRight.
  ///
  /// In en, this message translates to:
  /// **'Rotate right {deg}°'**
  String rotateRight(String deg);

  /// No description provided for @rotateLeft.
  ///
  /// In en, this message translates to:
  /// **'Rotate left {deg}°'**
  String rotateLeft(String deg);

  /// No description provided for @compassUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Compass sensor unavailable on this device. Use the bearing degrees above as a reference.'**
  String get compassUnavailable;

  /// No description provided for @compassNeedsCalibration.
  ///
  /// In en, this message translates to:
  /// **'Move your device in a figure-eight to calibrate the compass.'**
  String get compassNeedsCalibration;

  /// No description provided for @qiblaApproximateNote.
  ///
  /// In en, this message translates to:
  /// **'Approximate direction. Magnetic declination is not corrected.'**
  String get qiblaApproximateNote;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @dua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get dua;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @namesOfAllah.
  ///
  /// In en, this message translates to:
  /// **'99 Names of Allah'**
  String get namesOfAllah;

  /// No description provided for @comingInNextSlice.
  ///
  /// In en, this message translates to:
  /// **'Coming in the next slice'**
  String get comingInNextSlice;

  /// No description provided for @dailyInspiration.
  ///
  /// In en, this message translates to:
  /// **'Daily Inspiration'**
  String get dailyInspiration;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @todaysPrayers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Prayers'**
  String get todaysPrayers;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// No description provided for @nextPrayerIn.
  ///
  /// In en, this message translates to:
  /// **'Next prayer in'**
  String get nextPrayerIn;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @prayerSettings.
  ///
  /// In en, this message translates to:
  /// **'Prayer Settings'**
  String get prayerSettings;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get calculationMethod;

  /// No description provided for @asrSchool.
  ///
  /// In en, this message translates to:
  /// **'Asr School'**
  String get asrSchool;

  /// No description provided for @asrShafi.
  ///
  /// In en, this message translates to:
  /// **'Standard (Shafi)'**
  String get asrShafi;

  /// No description provided for @asrHanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get asrHanafi;

  /// No description provided for @locationMode.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationMode;

  /// No description provided for @locationAuto.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get locationAuto;

  /// No description provided for @locationManual.
  ///
  /// In en, this message translates to:
  /// **'Choose city manually'**
  String get locationManual;

  /// No description provided for @manualCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get manualCity;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @prayerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Prayer notifications'**
  String get prayerNotifications;

  /// No description provided for @minutesBefore.
  ///
  /// In en, this message translates to:
  /// **'Minutes before prayer'**
  String get minutesBefore;

  /// No description provided for @minutesValue.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String minutesValue(int n);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @errorLocationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Enable them or pick a city manually.'**
  String get errorLocationDisabled;

  /// No description provided for @errorLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Choose a city manually in Prayer Settings.'**
  String get errorLocationDenied;

  /// No description provided for @errorLocationDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Open system settings to grant access, or pick a city manually.'**
  String get errorLocationDeniedForever;

  /// No description provided for @switchToManual.
  ///
  /// In en, this message translates to:
  /// **'Pick a city manually'**
  String get switchToManual;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Prayer Settings'**
  String get openSettings;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get currentLocation;

  /// No description provided for @sourceNetwork.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get sourceNetwork;

  /// No description provided for @sourceCache.
  ///
  /// In en, this message translates to:
  /// **'Cached'**
  String get sourceCache;

  /// No description provided for @sourceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline calculation'**
  String get sourceOffline;

  /// No description provided for @notificationsNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Heads up'**
  String get notificationsNoticeTitle;

  /// No description provided for @notificationsNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Notifications scheduling is wired in the next slice. Your toggle is saved.'**
  String get notificationsNoticeBody;

  /// No description provided for @method_muslimWorldLeague.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get method_muslimWorldLeague;

  /// No description provided for @method_egyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority'**
  String get method_egyptian;

  /// No description provided for @method_karachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi (University of Islamic Sciences)'**
  String get method_karachi;

  /// No description provided for @method_ummAlQura.
  ///
  /// In en, this message translates to:
  /// **'Umm al-Qura (Mecca)'**
  String get method_ummAlQura;

  /// No description provided for @method_dubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get method_dubai;

  /// No description provided for @method_northAmerica.
  ///
  /// In en, this message translates to:
  /// **'ISNA (North America)'**
  String get method_northAmerica;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
