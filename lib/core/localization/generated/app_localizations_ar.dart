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

  @override
  String get quranTabSurahs => 'السور';

  @override
  String get quranTabJuz => 'الأجزاء';

  @override
  String get quranTabFavorites => 'المفضلة';

  @override
  String surahTitle(String name) {
    return 'سورة $name';
  }

  @override
  String revelationType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'meccan': 'مكية',
      'medinan': 'مدنية',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آية',
      few: '$count آيات',
      two: 'آيتان',
      one: 'آية واحدة',
    );
    return '$_temp0';
  }

  @override
  String juzTitle(String number) {
    return 'الجزء $number';
  }

  @override
  String ayahPosition(String surah, String ayah) {
    return '$surah · آية $ayah';
  }

  @override
  String ayahNumberLabel(String number) {
    return 'آية $number';
  }

  @override
  String ayahCitation(String text, String surah, String ayah) {
    return '﴿$text﴾ [$surah: $ayah]';
  }

  @override
  String get sajdaMark => 'موضع سجدة';

  @override
  String get quranLoadError => 'تعذر تحميل نص القرآن';

  @override
  String get ayahActionBookmark => 'علامة';

  @override
  String get ayahActionFavorite => 'المفضلة';

  @override
  String get ayahActionCopy => 'نسخ';

  @override
  String get ayahActionShare => 'مشاركة';

  @override
  String get toastCopied => 'تم نسخ الآية';

  @override
  String get toastBookmarkAdded => 'تم حفظ العلامة';

  @override
  String get toastBookmarkRemoved => 'أزيلت العلامة';

  @override
  String get toastFavoriteAdded => 'أضيفت إلى المفضلة';

  @override
  String get toastFavoriteRemoved => 'أزيلت من المفضلة';

  @override
  String get readingSettingsTitle => 'إعدادات القراءة';

  @override
  String get readingFontSize => 'حجم الخط';

  @override
  String get readingLineHeight => 'تباعد الأسطر';

  @override
  String get readingFont => 'نوع الخط';

  @override
  String get readingFontAmiri => 'أميري قرآن';

  @override
  String get readingFontScheherazade => 'شهرزاد';

  @override
  String get readingMode => 'وضع القراءة';

  @override
  String get readingModeVerses => 'آية آية';

  @override
  String get readingModeContinuous => 'متصل';

  @override
  String get nextSurah => 'السورة التالية';

  @override
  String get quranSearchHint => 'ابحث بكلمة من القرآن الكريم';

  @override
  String get searchMinChars => 'اكتب حرفين على الأقل للبحث';

  @override
  String get searchNoResults => 'لا توجد نتائج مطابقة';

  @override
  String get searchNoResultsBody => 'جرّب كلمة أخرى أو تأكد من الإملاء.';

  @override
  String get searchSurahsSection => 'السور';

  @override
  String searchAyatSection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'الآيات · $count نتيجة',
      few: 'الآيات · $count نتائج',
      two: 'الآيات · نتيجتان',
      one: 'الآيات · نتيجة واحدة',
      zero: 'الآيات',
    );
    return '$_temp0';
  }

  @override
  String searchCapped(String shown) {
    return 'تُعرض أول $shown نتيجة. حدّد البحث بكلمات أكثر.';
  }

  @override
  String get quranBookmarksSection => 'العلامات';

  @override
  String get quranFavoritesSection => 'الآيات المفضلة';

  @override
  String get quranFavoritesEmptyTitle => 'لا توجد آيات محفوظة';

  @override
  String get quranFavoritesEmptyBody =>
      'اضغط على أي آية أثناء القراءة لإضافتها إلى المفضلة أو وضع علامة عليها.';

  @override
  String get actionStartReading => 'ابدأ القراءة';

  @override
  String get sourcesIntro =>
      'يحرص هديل على أن يكون كل محتوى ديني فيه من مصدر موثوق ومعلن، دون أي تعديل أو توليد آلي.';

  @override
  String get sourceQuranTitle => 'نص القرآن الكريم';

  @override
  String get sourceQuranBody =>
      'مشروع تنزيل (Tanzil) — النص العثماني والنص الإملائي المبسّط، الإصدار 1.1. يُنقل النص كما هو دون أي تغيير، وفق شروط الاستخدام وترخيص المشاع الإبداعي (نسب المصنف 3.0).';

  @override
  String get sourceQuranMetaTitle => 'بيانات السور والأجزاء';

  @override
  String get sourceQuranMetaBody =>
      'مشروع تنزيل — ملف بيانات المصحف (أسماء السور، عدد الآيات، مواضع الأجزاء والأحزاب والسجدات).';

  @override
  String get sourceFontsTitle => 'الخطوط';

  @override
  String get sourceFontsBody =>
      'أميري قرآن، شهرزاد الجديد، وIBM Plex Sans Arabic — جميعها برخصة SIL Open Font License.';

  @override
  String get sourcePrayerTitle => 'مواقيت الصلاة';

  @override
  String get sourcePrayerBody =>
      'تُحسب على جهازك باستخدام خوارزمية Adhan، وفق طريقة الحساب والمذهب المختارين.';

  @override
  String get sourceHijriTitle => 'التاريخ الهجري';

  @override
  String get sourceHijriBody => 'تقويم أم القرى.';
}
