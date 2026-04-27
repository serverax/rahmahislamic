// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rahma';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectLanguageSubtitle => 'Choose your preferred language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get continueAction => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get onboarding1Title => 'Read the Quran';

  @override
  String get onboarding1Body =>
      'Access the complete Quran with translations and understand the words of Allah';

  @override
  String get onboarding2Title => 'Prayer Times';

  @override
  String get onboarding2Body =>
      'Never miss a prayer with accurate timings for your location';

  @override
  String get onboarding3Title => 'Daily Adhkar';

  @override
  String get onboarding3Body =>
      'Remember Allah with morning and evening adhkar from authentic sources';

  @override
  String get home => 'Home';

  @override
  String get quran => 'Quran';

  @override
  String get adhkar => 'Adhkar';

  @override
  String get more => 'More';

  @override
  String get quranComingSoon => 'Quran reader — coming next slice';

  @override
  String get adhkarComingSoon => 'Adhkar — coming next slice';

  @override
  String get duaComingSoon => 'Dua — coming next slice';

  @override
  String get moreComingSoon => 'More — coming next slice';

  @override
  String get books => 'Books';

  @override
  String get askSheikh => 'Ask Sheikh';

  @override
  String get askSheikhSubtitle => 'Safe Islamic guidance';

  @override
  String get askSheikhDisclaimer =>
      'This feature provides general Islamic guidance based on selected sources. It is not a final fatwa. For personal, family, financial, legal, medical, or urgent matters, please consult a qualified scholar.';

  @override
  String get newBadge => 'NEW';

  @override
  String get read => 'Read';

  @override
  String get listen => 'Listen';

  @override
  String get bookmarksTab => 'Bookmarks';

  @override
  String get continueReading => 'Continue Reading';

  @override
  String get surahLabel => 'Surah';

  @override
  String get juz => 'Juz';

  @override
  String get verse => 'Verse';

  @override
  String get verses => 'verses';

  @override
  String get meccan => 'Meccan';

  @override
  String get medinan => 'Medinan';

  @override
  String get search => 'Search';

  @override
  String get searchQuran => 'Search the Quran';

  @override
  String get popularSearches => 'Popular searches';

  @override
  String get searchTooShort => 'Type at least 2 letters';

  @override
  String get noBookmarks =>
      'No bookmarks yet. Tap the bookmark icon on any verse.';

  @override
  String get noResults => 'No results';

  @override
  String get audioComingSoon => 'Audio recitation coming in a future slice';

  @override
  String get showTranslation => 'Show translation';

  @override
  String get fontSize => 'Font size';

  @override
  String get bookmarkAdded => 'Bookmark added';

  @override
  String get bookmarkRemoved => 'Bookmark removed';

  @override
  String get openSurah => 'Open surah';

  @override
  String verseN(int n) {
    return 'Verse $n';
  }

  @override
  String ofTotal(int total) {
    return 'of $total';
  }

  @override
  String get tasbih => 'Tasbih';

  @override
  String get tasbihCounter => 'Tasbih Counter';

  @override
  String get tapToCount => 'Tap to count';

  @override
  String get tapAnywhereToCount => 'Tap anywhere to count';

  @override
  String get selectPhrase => 'Select phrase';

  @override
  String get totalCount => 'Total count';

  @override
  String get resetCounter => 'Reset counter';

  @override
  String get category_morning => 'Morning Adhkar';

  @override
  String get category_evening => 'Evening Adhkar';

  @override
  String get category_after_salah => 'After Prayer';

  @override
  String get category_sleep => 'Before Sleep';

  @override
  String get category_wake => 'Upon Waking';

  @override
  String get category_protection => 'Protection';

  @override
  String get category_daily => 'Daily Remembrance';

  @override
  String dhikrOfTotal(int n, int total) {
    return '$n of $total';
  }

  @override
  String repeatN(int n) {
    return 'Repeat $n times';
  }

  @override
  String get complete => 'Complete';

  @override
  String get previous => 'Previous';

  @override
  String get source => 'Source';

  @override
  String get asmaUlHusna => '99 Names of Allah';

  @override
  String get asmaUlHusnaSubtitle => 'The Most Beautiful Names';

  @override
  String get duaCategories => 'Dua Categories';

  @override
  String duaCount(int n) {
    return '$n duas';
  }

  @override
  String get duaCategory_daily => 'Daily Life';

  @override
  String get duaCategory_distress => 'Distress & Anxiety';

  @override
  String get duaCategory_travel => 'Travel';

  @override
  String get duaCategory_food => 'Food & Drink';

  @override
  String get duaCategory_knowledge => 'Seeking Knowledge';

  @override
  String get duaCategory_forgiveness => 'Repentance';

  @override
  String get duaCategory_guidance => 'Guidance';

  @override
  String get share => 'Share';

  @override
  String get shareContent => 'Share content';

  @override
  String get shareVia => 'Share via…';

  @override
  String get copyText => 'Copy text';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String soonState(int minutes) {
    return 'in $minutes min';
  }

  @override
  String activeState(String prayer) {
    return 'It\'s time for $prayer';
  }

  @override
  String get noLocationYet => 'Pick a city in Prayer Settings';

  @override
  String get dreamInterpretation => 'Dream Interpretation';

  @override
  String get dreamInterpretationSubtitle =>
      'Experimental — awaiting scholar review';

  @override
  String get dreamWarningTitle => 'Important Notice';

  @override
  String get dreamWarningBodyEn =>
      'Dream interpretation is not a definitive science. Do not rely on it for decisions about marriage, divorce, finance, medical treatment, or accusing others. If a dream is recurrently distressing, please consult a qualified scholar or specialist.';

  @override
  String get dreamAgree => 'I understand and accept';

  @override
  String get dreamInputTitle => 'Describe your dream';

  @override
  String get dreamInputHint => 'Write your dream in detail in Arabic…';

  @override
  String get dreamSubmit => 'Interpret';

  @override
  String get dreamEmpty => 'Please write your dream first';

  @override
  String get dreamBlockedTitle => 'Cannot interpret';

  @override
  String get dreamBlockedBody =>
      'This dream contains content we cannot safely interpret. Please consult a qualified scholar or specialist.';

  @override
  String get dreamLimitTitle => 'Daily limit reached';

  @override
  String get dreamLimitBody =>
      'You\'ve reached today\'s interpretation limit (3). Please come back tomorrow.';

  @override
  String get dreamResultTitle => 'Interpretation';

  @override
  String get dreamPossibleMeanings => 'Possible meanings';

  @override
  String get dreamNoMatch =>
      'No matching symbols found in our small starter set. Try mentioning common elements (water, light, tree, garden, bird, mountain, house, milk, honey, rain).';

  @override
  String get dreamHistoryTitle => 'Past dreams';

  @override
  String get dreamHistoryEmpty => 'No past dreams yet.';

  @override
  String get dreamClearHistory => 'Clear history';

  @override
  String get dreamReviewBanner =>
      'Experimental content awaiting scholar review. Do not act on these interpretations.';

  @override
  String get newDream => 'New dream';

  @override
  String get bearing => 'Bearing';

  @override
  String get distanceToMecca => 'Distance to Mecca';

  @override
  String get kmAbbrev => 'km';

  @override
  String get facingQibla => 'You are facing the Qibla';

  @override
  String rotateRight(String deg) {
    return 'Rotate right $deg°';
  }

  @override
  String rotateLeft(String deg) {
    return 'Rotate left $deg°';
  }

  @override
  String get compassUnavailable =>
      'Compass sensor unavailable on this device. Use the bearing degrees above as a reference.';

  @override
  String get compassNeedsCalibration =>
      'Move your device in a figure-eight to calibrate the compass.';

  @override
  String get qiblaApproximateNote =>
      'Approximate direction. Magnetic declination is not corrected.';

  @override
  String get profile => 'Profile';

  @override
  String get guest => 'Guest';

  @override
  String get guestSubtitle => 'Browsing without an account';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInComingSoon =>
      'Sign-in is coming in the next slice. Your bookmarks and settings will sync to your account.';

  @override
  String get appSettings => 'App Settings';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get theme => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeOnlyDarkNote =>
      'Only dark theme is available right now. Light theme is on the roadmap.';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'Version, sources, and credits';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get scholarReviewNoteTitle => 'Religious content notice';

  @override
  String get scholarReviewNoteBody =>
      'Adhkar, duas, and 99 Names content shipped with this build is sourced from classical references. Tafseer Ahlam content is experimental and awaiting scholar review. Always consult a qualified scholar for personal religious decisions.';

  @override
  String get credits => 'Credits';

  @override
  String get creditsBody =>
      'Quran text and translations from Quran.com (Sahih International). Prayer times from Aladhan API and the offline adhan package. Adhkar curated from Hisn al-Muslim and authentic hadith collections.';

  @override
  String get appSettingsSubtitle => 'Language, theme, notifications';

  @override
  String get prayerSettingsSubtitle =>
      'Calculation method, location, notifications';

  @override
  String get profileFeatureSubtitle => 'Manage your account';

  @override
  String get moreFeatureExperimental => 'Tafseer Ahlam (experimental)';

  @override
  String get signOut => 'Sign out';

  @override
  String get signedInAs => 'Signed in as guest';

  @override
  String signedInId(String id) {
    return 'User ID: $id';
  }

  @override
  String get signInAnonymously => 'Continue as guest';

  @override
  String get signInUnavailable =>
      'Sign-in is unavailable on this platform. Real Firebase Auth requires Android, iOS, or web.';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get dua => 'Dua';

  @override
  String get qibla => 'Qibla';

  @override
  String get namesOfAllah => '99 Names of Allah';

  @override
  String get comingInNextSlice => 'Coming in the next slice';

  @override
  String get dailyInspiration => 'Daily Inspiration';

  @override
  String get prayerTimes => 'Prayer Times';

  @override
  String get todaysPrayers => 'Today\'s Prayers';

  @override
  String get nextPrayer => 'Next Prayer';

  @override
  String get nextPrayerIn => 'Next prayer in';

  @override
  String get fajr => 'Fajr';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get isha => 'Isha';

  @override
  String get viewAll => 'View all';

  @override
  String get settings => 'Settings';

  @override
  String get prayerSettings => 'Prayer Settings';

  @override
  String get calculationMethod => 'Calculation Method';

  @override
  String get asrSchool => 'Asr School';

  @override
  String get asrShafi => 'Standard (Shafi)';

  @override
  String get asrHanafi => 'Hanafi';

  @override
  String get locationMode => 'Location';

  @override
  String get locationAuto => 'Use my location';

  @override
  String get locationManual => 'Choose city manually';

  @override
  String get manualCity => 'City';

  @override
  String get notifications => 'Notifications';

  @override
  String get prayerNotifications => 'Prayer notifications';

  @override
  String get minutesBefore => 'Minutes before prayer';

  @override
  String minutesValue(int n) {
    return '$n min';
  }

  @override
  String get loading => 'Loading…';

  @override
  String get retry => 'Retry';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get errorLocationDisabled =>
      'Location services are disabled. Enable them or pick a city manually.';

  @override
  String get errorLocationDenied =>
      'Location permission denied. Choose a city manually in Prayer Settings.';

  @override
  String get errorLocationDeniedForever =>
      'Location permission permanently denied. Open system settings to grant access, or pick a city manually.';

  @override
  String get switchToManual => 'Pick a city manually';

  @override
  String get openSettings => 'Open Prayer Settings';

  @override
  String get currentLocation => 'Current location';

  @override
  String get sourceNetwork => 'Live';

  @override
  String get sourceCache => 'Cached';

  @override
  String get sourceOffline => 'Offline calculation';

  @override
  String get notificationsNoticeTitle => 'Heads up';

  @override
  String get notificationsNoticeBody =>
      'Notifications scheduling is wired in the next slice. Your toggle is saved.';

  @override
  String get method_muslimWorldLeague => 'Muslim World League';

  @override
  String get method_egyptian => 'Egyptian General Authority';

  @override
  String get method_karachi => 'Karachi (University of Islamic Sciences)';

  @override
  String get method_ummAlQura => 'Umm al-Qura (Mecca)';

  @override
  String get method_dubai => 'Dubai';

  @override
  String get method_northAmerica => 'ISNA (North America)';
}
