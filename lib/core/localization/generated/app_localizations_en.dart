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
