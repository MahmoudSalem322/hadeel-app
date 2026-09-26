// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'هديل';

  @override
  String get appNameLatin => 'Hadeel';

  @override
  String get appTagline => 'رفيقك اليومي للقرآن والذكر';

  @override
  String get onboardingWelcomeTitle => 'أهلًا بك في هديل';

  @override
  String get onboardingWelcomeBody => 'رفيقك اليومي للقرآن والذكر والعبادة.';

  @override
  String get onboardingQuranTitle => 'القرآن معك دائمًا';

  @override
  String get onboardingQuranBody =>
      'اقرأ القرآن وتابع وردك حتى بدون اتصال بالإنترنت.';

  @override
  String get onboardingPrayerTitle => 'صلاتك في وقتها';

  @override
  String get onboardingPrayerBody => 'احسب مواقيت الصلاة حسب موقعك أو مدينتك.';

  @override
  String get onboardingStartTitle => 'ابدأ رحلتك';

  @override
  String get onboardingStartBody =>
      'حدّد موقعك لحساب مواقيت الصلاة بدقة. يمكنك تغييره لاحقًا من الإعدادات.';

  @override
  String onboardingPageIndicator(int current, int total) {
    return 'الصفحة $current من $total';
  }

  @override
  String get actionSkip => 'تخطي';

  @override
  String get actionNext => 'التالي';

  @override
  String get actionStartNow => 'ابدأ الآن';

  @override
  String get actionContinue => 'متابعة';

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get actionChange => 'تغيير';

  @override
  String get actionClose => 'إغلاق';

  @override
  String get actionExplore => 'استكشف المحتوى';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navQuran => 'القرآن';

  @override
  String get navAdhkar => 'الأذكار';

  @override
  String get navPrayer => 'الصلاة';

  @override
  String get navMore => 'المزيد';

  @override
  String get homeGreeting => 'السلام عليكم';

  @override
  String get homeNextPrayer => 'الصلاة القادمة';

  @override
  String get homeRemaining => 'متبقي';

  @override
  String get homeTodayPrayerTimes => 'مواقيت اليوم';

  @override
  String get homeQuickAccess => 'وصول سريع';

  @override
  String get homeContinueReading => 'متابعة القراءة';

  @override
  String get homeStartReading => 'ابدأ القراءة';

  @override
  String get homeStartReadingBody =>
      'ابدأ وردك من القرآن الكريم، وسنحفظ موضعك تلقائيًا.';

  @override
  String homeReadingPosition(String surah, String ayah) {
    return 'سورة $surah · آية $ayah';
  }

  @override
  String nextPrayerSemantics(String prayer, String time, String remaining) {
    return 'الصلاة القادمة $prayer الساعة $time، متبقي $remaining';
  }

  @override
  String get featureQuran => 'القرآن الكريم';

  @override
  String get featureAdhkar => 'الأذكار';

  @override
  String get featureTasbeeh => 'التسبيح';

  @override
  String get featureQibla => 'القبلة';

  @override
  String get featureDuas => 'الأدعية';

  @override
  String get featureHadith => 'الأحاديث';

  @override
  String get featurePrayerTimes => 'مواقيت الصلاة';

  @override
  String get featureHijriCalendar => 'التقويم الهجري';

  @override
  String get featureFavorites => 'المفضلة';

  @override
  String get featureSearch => 'البحث';

  @override
  String get featureSettings => 'الإعدادات';

  @override
  String get featureAbout => 'حول التطبيق';

  @override
  String get featureSources => 'المصادر';

  @override
  String get featureMore => 'المزيد';

  @override
  String prayerName(String prayer) {
    String _temp0 = intl.Intl.selectLogic(prayer, {
      'fajr': 'الفجر',
      'sunrise': 'الشروق',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String hijriMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'محرم',
      'm2': 'صفر',
      'm3': 'ربيع الأول',
      'm4': 'ربيع الآخر',
      'm5': 'جمادى الأولى',
      'm6': 'جمادى الآخرة',
      'm7': 'رجب',
      'm8': 'شعبان',
      'm9': 'رمضان',
      'm10': 'شوال',
      'm11': 'ذو القعدة',
      'm12': 'ذو الحجة',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String hijriDate(String day, String month, String year) {
    return '$day $month $year هـ';
  }

  @override
  String get locationUseMine => 'استخدم موقعي';

  @override
  String get locationChooseCity => 'اختر المدينة';

  @override
  String get locationChooseCityManually => 'اختيار المدينة يدويًا';

  @override
  String get locationLocating => 'جارٍ تحديد موقعك…';

  @override
  String get locationCurrent => 'موقعي الحالي';

  @override
  String locationSelectedCity(String city) {
    return 'المدينة: $city';
  }

  @override
  String get locationSelectedGps => 'تم تحديد موقعك بنجاح';

  @override
  String get locationMissingTitle => 'حدّد موقعك';

  @override
  String get locationMissingBody =>
      'اختر مدينتك أو استخدم موقعك لعرض مواقيت الصلاة.';

  @override
  String get locationErrorTitle => 'تعذر الحصول على الموقع';

  @override
  String get locationErrorServiceDisabled => 'خدمة الموقع متوقفة على جهازك.';

  @override
  String get locationErrorDenied => 'لم يتم منح إذن الوصول إلى الموقع.';

  @override
  String get locationErrorDeniedForever =>
      'إذن الموقع مرفوض. يمكنك تفعيله من إعدادات الجهاز.';

  @override
  String get locationErrorTimeout =>
      'استغرق تحديد الموقع وقتًا أطول من المتوقع.';

  @override
  String get locationErrorUnknown => 'حدث خطأ غير متوقع أثناء تحديد الموقع.';

  @override
  String get cityPickerTitle => 'اختر مدينتك';

  @override
  String get citySearchHint => 'ابحث عن مدينة';

  @override
  String get cityNoResults => 'لا توجد مدينة بهذا الاسم';

  @override
  String cityRegion(String region) {
    String _temp0 = intl.Intl.selectLogic(region, {
      'west_bank': 'الضفة الغربية',
      'gaza_strip': 'قطاع غزة',
      'interior': 'الداخل الفلسطيني',
      'other': 'أخرى',
    });
    return '$_temp0';
  }

  @override
  String get comingSoonTitle => 'قريبًا بإذن الله';

  @override
  String get comingSoonBody =>
      'نعمل على تجهيز هذا القسم ليعمل بالكامل دون اتصال بالإنترنت.';

  @override
  String get themeModeLabel => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get galleryTitle => 'نظام التصميم';

  @override
  String get gallerySampleAyahLabel => 'نموذج خط القرآن';

  @override
  String get galleryColors => 'الألوان';

  @override
  String get galleryTypography => 'الخطوط';

  @override
  String get galleryComponents => 'المكونات';

  @override
  String get galleryStates => 'الحالات';

  @override
  String get gallerySampleText =>
      'نص تجريبي لعرض الخط العربي بوضوح وراحة في القراءة.';

  @override
  String get gallerySearchHint => 'ابحث في القرآن والأذكار';

  @override
  String get emptyFavoritesTitle => 'لا توجد عناصر محفوظة';

  @override
  String get emptyFavoritesBody => 'لم تضف شيئًا للمفضلة بعد.';
}
