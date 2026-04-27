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
  String get askSheikh => 'اسأل الشيخ';

  @override
  String get askSheikhSubtitle => 'إرشاد إسلامي آمن';

  @override
  String get askSheikhDisclaimer =>
      'هذه الخدمة تقدم إرشاداً إسلامياً عاماً بناءً على مصادر مختارة، وليست فتوى نهائية. في المسائل الشخصية أو الأسرية أو المالية أو القانونية أو الطبية أو العاجلة، يرجى الرجوع إلى عالم مؤهل.';

  @override
  String get newBadge => 'جديد';

  @override
  String get read => 'قراءة';

  @override
  String get listen => 'استماع';

  @override
  String get bookmarksTab => 'المرجعيات';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String get surahLabel => 'سورة';

  @override
  String get juz => 'الجزء';

  @override
  String get verse => 'آية';

  @override
  String get verses => 'آية';

  @override
  String get meccan => 'مكية';

  @override
  String get medinan => 'مدنية';

  @override
  String get search => 'بحث';

  @override
  String get searchQuran => 'ابحث في القرآن';

  @override
  String get popularSearches => 'عمليات بحث شائعة';

  @override
  String get searchTooShort => 'اكتب حرفين على الأقل';

  @override
  String get noBookmarks =>
      'لا توجد مرجعيات بعد. اضغط على أيقونة المرجعية لأي آية.';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get audioComingSoon => 'التلاوة الصوتية ستضاف لاحقاً';

  @override
  String get showTranslation => 'عرض الترجمة';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get bookmarkAdded => 'تمت الإضافة إلى المرجعيات';

  @override
  String get bookmarkRemoved => 'تمت إزالة المرجعية';

  @override
  String get openSurah => 'افتح السورة';

  @override
  String verseN(int n) {
    return 'آية $n';
  }

  @override
  String ofTotal(int total) {
    return 'من $total';
  }

  @override
  String get tasbih => 'تسبيح';

  @override
  String get tasbihCounter => 'عداد التسبيح';

  @override
  String get tapToCount => 'اضغط للعد';

  @override
  String get tapAnywhereToCount => 'اضغط في أي مكان للعد';

  @override
  String get selectPhrase => 'اختر العبارة';

  @override
  String get totalCount => 'العدد الإجمالي';

  @override
  String get resetCounter => 'إعادة العداد';

  @override
  String get category_morning => 'أذكار الصباح';

  @override
  String get category_evening => 'أذكار المساء';

  @override
  String get category_after_salah => 'أذكار بعد الصلاة';

  @override
  String get category_sleep => 'أذكار النوم';

  @override
  String get category_wake => 'أذكار الاستيقاظ';

  @override
  String get category_protection => 'أذكار الحماية';

  @override
  String get category_daily => 'ذكر يومي';

  @override
  String dhikrOfTotal(int n, int total) {
    return '$n من $total';
  }

  @override
  String repeatN(int n) {
    return 'كرر $n مرات';
  }

  @override
  String get complete => 'تم';

  @override
  String get previous => 'السابق';

  @override
  String get source => 'المصدر';

  @override
  String get asmaUlHusna => 'أسماء الله الحسنى';

  @override
  String get asmaUlHusnaSubtitle => 'الأسماء الحسنى';

  @override
  String get duaCategories => 'أقسام الأدعية';

  @override
  String duaCount(int n) {
    return '$n دعاء';
  }

  @override
  String get duaCategory_daily => 'الحياة اليومية';

  @override
  String get duaCategory_distress => 'الكرب والقلق';

  @override
  String get duaCategory_travel => 'السفر';

  @override
  String get duaCategory_food => 'الطعام والشراب';

  @override
  String get duaCategory_knowledge => 'طلب العلم';

  @override
  String get duaCategory_forgiveness => 'التوبة والاستغفار';

  @override
  String get duaCategory_guidance => 'الهداية';

  @override
  String get share => 'مشاركة';

  @override
  String get shareContent => 'مشاركة المحتوى';

  @override
  String get shareVia => 'مشاركة عبر…';

  @override
  String get copyText => 'نسخ النص';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String soonState(int minutes) {
    return 'بعد $minutes دقيقة';
  }

  @override
  String activeState(String prayer) {
    return 'حان وقت صلاة $prayer';
  }

  @override
  String get noLocationYet => 'اختر مدينة من إعدادات الصلاة';

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
