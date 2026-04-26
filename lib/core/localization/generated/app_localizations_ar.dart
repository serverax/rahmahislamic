// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'رحمة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get selectLanguageSubtitle => 'اختر لغتك المفضلة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get continueAction => 'متابعة';

  @override
  String get skip => 'تخطي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get next => 'التالي';

  @override
  String get onboarding1Title => 'اقرأ القرآن';

  @override
  String get onboarding1Body =>
      'الوصول إلى القرآن الكريم كاملاً مع الترجمة وفهم كلام الله';

  @override
  String get onboarding2Title => 'مواقيت الصلاة';

  @override
  String get onboarding2Body => 'لا تفوت صلاة مع مواقيت دقيقة لموقعك';

  @override
  String get onboarding3Title => 'الأذكار اليومية';

  @override
  String get onboarding3Body =>
      'تذكر الله بأذكار الصباح والمساء من مصادر موثوقة';

  @override
  String get home => 'الرئيسية';

  @override
  String get quran => 'القرآن';

  @override
  String get adhkar => 'الأذكار';

  @override
  String get more => 'المزيد';

  @override
  String get quranComingSoon => 'قارئ القرآن — قريباً في الشريحة التالية';

  @override
  String get adhkarComingSoon => 'الأذكار — قريباً في الشريحة التالية';

  @override
  String get duaComingSoon => 'الدعاء — قريباً في الشريحة التالية';

  @override
  String get moreComingSoon => 'المزيد — قريباً في الشريحة التالية';

  @override
  String get books => 'الكتب';

  @override
  String get quickAccess => 'الوصول السريع';

  @override
  String get dua => 'الدعاء';

  @override
  String get qibla => 'القبلة';

  @override
  String get namesOfAllah => 'أسماء الله الحسنى';

  @override
  String get comingInNextSlice => 'قريباً في الشريحة التالية';

  @override
  String get dailyInspiration => 'إلهام اليوم';

  @override
  String get prayerTimes => 'مواقيت الصلاة';

  @override
  String get todaysPrayers => 'صلوات اليوم';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String get nextPrayerIn => 'الصلاة القادمة بعد';

  @override
  String get fajr => 'الفجر';

  @override
  String get sunrise => 'الشروق';

  @override
  String get dhuhr => 'الظهر';

  @override
  String get asr => 'العصر';

  @override
  String get maghrib => 'المغرب';

  @override
  String get isha => 'العشاء';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get prayerSettings => 'إعدادات الصلاة';

  @override
  String get calculationMethod => 'طريقة الحساب';

  @override
  String get asrSchool => 'مذهب العصر';

  @override
  String get asrShafi => 'الجمهور (الشافعي)';

  @override
  String get asrHanafi => 'الحنفي';

  @override
  String get locationMode => 'الموقع';

  @override
  String get locationAuto => 'استخدام موقعي';

  @override
  String get locationManual => 'اختيار المدينة يدوياً';

  @override
  String get manualCity => 'المدينة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get prayerNotifications => 'إشعارات الصلاة';

  @override
  String get minutesBefore => 'الدقائق قبل الصلاة';

  @override
  String minutesValue(int n) {
    return '$n دقيقة';
  }

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorGeneric => 'حدث خطأ ما';

  @override
  String get errorLocationDisabled =>
      'خدمات الموقع غير مفعّلة. فعّلها أو اختر مدينة يدوياً.';

  @override
  String get errorLocationDenied =>
      'تم رفض إذن الموقع. اختر مدينة يدوياً في إعدادات الصلاة.';

  @override
  String get errorLocationDeniedForever =>
      'تم رفض إذن الموقع نهائياً. افتح إعدادات النظام للسماح، أو اختر مدينة يدوياً.';

  @override
  String get switchToManual => 'اختر مدينة يدوياً';

  @override
  String get openSettings => 'افتح إعدادات الصلاة';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get sourceNetwork => 'مباشر';

  @override
  String get sourceCache => 'محفوظ';

  @override
  String get sourceOffline => 'حساب بدون إنترنت';

  @override
  String get notificationsNoticeTitle => 'تنويه';

  @override
  String get notificationsNoticeBody =>
      'جدولة الإشعارات ستُضاف في الشريحة التالية. تم حفظ تفضيلك.';

  @override
  String get method_muslimWorldLeague => 'رابطة العالم الإسلامي';

  @override
  String get method_egyptian => 'الهيئة المصرية العامة للمساحة';

  @override
  String get method_karachi => 'جامعة العلوم الإسلامية بكراتشي';

  @override
  String get method_ummAlQura => 'أم القرى (مكة)';

  @override
  String get method_dubai => 'دبي';

  @override
  String get method_northAmerica => 'ISNA (أمريكا الشمالية)';
}
