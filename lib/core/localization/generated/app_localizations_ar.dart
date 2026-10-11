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
  String get sidebarWorkspace => 'المساحة';

  @override
  String get sidebarDeviceBody => 'بياناتك محفوظة على جهازك وتعمل دون اتصال.';

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
  String get quranTabBookmarks => 'العلامات';

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
  String get quranBookmarksEmptyTitle => 'لا توجد علامات بعد';

  @override
  String get quranBookmarksEmptyBody =>
      'ضع علامة على أي آية لتجدها هنا مع وقت إضافتها.';

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

  @override
  String get sourceTafsirTitle => 'التفسير';

  @override
  String get sourceTafsirBody =>
      'التفسير الميسر — مجمع الملك فهد لطباعة المصحف الشريف، عبر مشروع تنزيل. يُعرض كما هو دون تعديل.';

  @override
  String get sourceAdhkarTitle => 'الأذكار والأدعية';

  @override
  String get sourceAdhkarBody =>
      'حصن المسلم من أذكار الكتاب والسنة — سعيد بن علي بن وهف القحطاني (hisnmuslim.com). الأدعية القرآنية تُعرض من نص المصحف مباشرة.';

  @override
  String get sourceHadithTitle => 'الأحاديث';

  @override
  String get sourceHadithBody =>
      'الأربعون النووية ورياض الصالحين للإمام النووي — النص العربي كما نشره موقع Sunnah.com، ويتضمن التخريج كما ورد في الكتاب.';

  @override
  String get ayahActionTafsir => 'التفسير';

  @override
  String get tafsirTitle => 'التفسير الميسر';

  @override
  String get tafsirSource =>
      'المصدر: التفسير الميسر — مجمع الملك فهد لطباعة المصحف الشريف';

  @override
  String get readingShowTafsir => 'إظهار التفسير تحت الآيات';

  @override
  String get tafsirLoadError => 'تعذر تحميل التفسير';

  @override
  String adhkarCategory(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'morning_evening': 'أذكار الصباح والمساء',
      'after_prayer': 'أذكار بعد الصلاة',
      'sleep': 'أذكار النوم',
      'waking': 'أذكار الاستيقاظ',
      'home_leave': 'الخروج من المنزل',
      'home_enter': 'دخول المنزل',
      'mosque': 'أذكار المسجد',
      'adhan': 'أذكار الأذان',
      'wudu': 'أذكار الوضوء',
      'food': 'أذكار الطعام',
      'travel': 'أذكار السفر',
      'tasbih': 'التسبيح والتحميد',
      'other': 'الأذكار',
    });
    return '$_temp0';
  }

  @override
  String get adhkarDaily => 'الأذكار اليومية';

  @override
  String get adhkarAllChapters => 'جميع أبواب حصن المسلم';

  @override
  String get adhkarSearchHint => 'ابحث في أبواب الأذكار';

  @override
  String dhikrPosition(String current, String total) {
    return '$current / $total';
  }

  @override
  String dhikrRepeat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة',
      few: '$count مرات',
      two: 'مرتان',
      one: 'مرة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get dhikrCounterButton => 'تسبيح';

  @override
  String dhikrCountSemantics(String count, String target) {
    return 'العدد $count من $target';
  }

  @override
  String get actionReset => 'إعادة';

  @override
  String get actionPrevious => 'السابق';

  @override
  String get adhkarCompletedTitle => 'تقبّل الله منك';

  @override
  String get adhkarCompletedBody => 'أتممت أذكار هذا الباب.';

  @override
  String get actionRestart => 'البدء من جديد';

  @override
  String get adhkarSource => 'المصدر: حصن المسلم';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ذكرًا',
      few: '$count أذكار',
      two: 'ذكران',
      one: 'ذكر واحد',
    );
    return '$_temp0';
  }

  @override
  String get contentLoadError => 'تعذر تحميل المحتوى';

  @override
  String duaCategory(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'quranic': 'أدعية قرآنية',
      'prophets': 'أدعية الأنبياء',
      'rizq': 'الرزق وقضاء الدين',
      'tawbah': 'التوبة والاستغفار',
      'travel': 'السفر',
      'healing': 'الشفاء والمرض',
      'distress': 'الهم والحزن والكرب',
      'morning_evening': 'الصباح والمساء',
      'general': 'أدعية جامعة',
      'other': 'الأدعية',
    });
    return '$_temp0';
  }

  @override
  String prophetName(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'adam': 'آدم عليه السلام',
      'nuh': 'نوح عليه السلام',
      'ibrahim': 'إبراهيم عليه السلام',
      'shuayb': 'شعيب عليه السلام',
      'lut': 'لوط عليه السلام',
      'yusuf': 'يوسف عليه السلام',
      'musa': 'موسى عليه السلام',
      'ayyub': 'أيوب عليه السلام',
      'yunus': 'يونس عليه السلام',
      'sulayman': 'سليمان عليه السلام',
      'zakariya': 'زكريا عليه السلام',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String quranReference(String surah, String ayat) {
    return '[$surah: $ayat]';
  }

  @override
  String duasCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دعاءً',
      few: '$count أدعية',
      two: 'دعاءان',
      one: 'دعاء واحد',
    );
    return '$_temp0';
  }

  @override
  String get toastCopiedText => 'تم النسخ';

  @override
  String get hadithBooks => 'كتب الحديث';

  @override
  String hadithNumber(String number) {
    return 'الحديث $number';
  }

  @override
  String hadithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حديثًا',
      few: '$count أحاديث',
      two: 'حديثان',
      one: 'حديث واحد',
    );
    return '$_temp0';
  }

  @override
  String get hadithAllChapters => 'كل الكتب';

  @override
  String hadithSourceLine(String book, String author) {
    return '$book — $author';
  }

  @override
  String get hadithSearchHint => 'ابحث في الأحاديث';

  @override
  String get prayerMethod => 'طريقة الحساب';

  @override
  String get prayerMadhab => 'مذهب صلاة العصر';

  @override
  String calcMethodName(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'egyptian': 'الهيئة المصرية العامة للمساحة',
      'muslimWorldLeague': 'رابطة العالم الإسلامي',
      'ummAlQura': 'أم القرى',
      'karachi': 'جامعة العلوم الإسلامية بكراتشي',
      'northAmerica': 'أمريكا الشمالية',
      'dubai': 'دبي',
      'kuwait': 'الكويت',
      'qatar': 'قطر',
      'turkey': 'تركيا',
      'singapore': 'سنغافورة',
      'moonSightingCommittee': 'لجنة رؤية الهلال',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String madhabName(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'shafi': 'الجمهور (شافعي، مالكي، حنبلي)',
      'hanafi': 'الحنفي',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get locationGpsLabel => 'موقعي الحالي (GPS)';

  @override
  String get locationUpdate => 'تحديث الموقع';

  @override
  String get locationChangeCity => 'تغيير المدينة';

  @override
  String get prayerCalcNote => 'تُحسب المواقيت على جهازك دون اتصال بالإنترنت.';

  @override
  String get notificationsTitle => 'تنبيهات الصلاة';

  @override
  String get notificationsEnableAll => 'تفعيل تنبيهات الصلوات';

  @override
  String notificationForPrayer(String prayer) {
    return 'تنبيه $prayer';
  }

  @override
  String get notificationsDenied =>
      'الإشعارات غير مسموحة. يمكنك السماح بها من إعدادات الجهاز.';

  @override
  String notificationTitle(String prayer) {
    return 'حان الآن موعد صلاة $prayer';
  }

  @override
  String notificationBody(String place, String time) {
    return '$place · $time';
  }

  @override
  String get notificationChannelName => 'مواقيت الصلاة';

  @override
  String get notificationChannelDescription => 'تنبيه عند دخول وقت كل صلاة';

  @override
  String get hourlyDhikrLabel => 'تذكير بذكر الله كل ساعة';

  @override
  String get hourlyDhikrTitle => 'تذكير بذكر الله';

  @override
  String get hourlyDhikrBody => 'أَذْكُرِ اللهَ وَصَلِّ عَلَى نَبِيِّهِ محمد ﷺ';

  @override
  String get qiblaDirectionLabel => 'اتجاه القبلة';

  @override
  String qiblaBearing(String degrees) {
    return '$degrees° من الشمال';
  }

  @override
  String qiblaDistance(String km) {
    return 'المسافة إلى الكعبة المشرفة: $km كم';
  }

  @override
  String get qiblaAligned => 'أنت متجه نحو القبلة';

  @override
  String get qiblaTurnRight => 'استدر يمينًا';

  @override
  String get qiblaTurnLeft => 'استدر يسارًا';

  @override
  String get qiblaCalibrationTitle => 'معايرة البوصلة';

  @override
  String get qiblaCalibrationBody =>
      'حرّك الهاتف في الهواء على شكل الرقم 8 عدة مرات، وأبعده عن المعادن والمغناطيس والأجهزة الإلكترونية، وضعه بشكل أفقي.';

  @override
  String get qiblaNoSensor =>
      'لا يتوفر مستشعر بوصلة في هذا الجهاز. استخدم الزاوية الموضحة مع بوصلة أخرى.';

  @override
  String get qiblaNeedsLocation => 'حدّد موقعك لحساب اتجاه القبلة.';

  @override
  String qiblaHeading(String degrees) {
    return 'اتجاه الهاتف: $degrees°';
  }

  @override
  String get tasbeehTarget => 'الهدف';

  @override
  String get tasbeehUnlimited => 'بلا حد';

  @override
  String get tasbeehChangeDhikr => 'تغيير الذكر';

  @override
  String get tasbeehReset => 'تصفير';

  @override
  String tasbeehTotal(String count) {
    return 'المجموع: $count';
  }

  @override
  String tasbeehRounds(String count) {
    return 'الدورات: $count';
  }

  @override
  String get tasbeehTapHint => 'اضغط للتسبيح';

  @override
  String get tasbeehVibration => 'الاهتزاز عند كل تسبيحة';

  @override
  String get tasbeehSound => 'صوت عند كل تسبيحة';

  @override
  String tasbeehPhrase(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'subhanallah': 'سبحان الله',
      'alhamdulillah': 'الحمد لله',
      'allahuakbar': 'الله أكبر',
      'tahlil': 'لا إله إلا الله',
      'istighfar': 'أستغفر الله',
      'hawqala': 'لا حول ولا قوة إلا بالله',
      'subhanallah_wabihamdihi': 'سبحان الله وبحمده',
      'salawat': 'اللهم صلِّ على محمد',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get hijriToday => 'اليوم';

  @override
  String hijriMonthTitle(String month, String year) {
    return '$month $year هـ';
  }

  @override
  String get hijriAdjustment => 'تعديل التاريخ الهجري';

  @override
  String hijriAdjustmentValue(String days) {
    return '$days يوم';
  }

  @override
  String get hijriNoAdjustment => 'بدون تعديل';

  @override
  String get hijriAdjustmentHint => 'لموافقة رؤية الهلال في بلدك.';

  @override
  String get previousMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String get favoritesTabQuran => 'القرآن';

  @override
  String get favoritesTabAdhkar => 'الأذكار';

  @override
  String get favoritesTabDuas => 'الأدعية';

  @override
  String get favoritesTabHadith => 'الأحاديث';

  @override
  String get globalSearchHint => 'ابحث في القرآن والأذكار والأدعية والأحاديث';

  @override
  String get searchSectionQuran => 'القرآن الكريم';

  @override
  String get searchSectionAdhkar => 'الأذكار';

  @override
  String get searchSectionHadith => 'الأحاديث';

  @override
  String get searchShowAll => 'عرض كل النتائج';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsQuran => 'القرآن الكريم';

  @override
  String get settingsPrayer => 'الصلاة';

  @override
  String get settingsTasbeeh => 'التسبيح';

  @override
  String get settingsGeneral => 'عام';

  @override
  String get settingsLocation => 'الموقع';

  @override
  String get settingsPrivacy => 'الخصوصية';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get privacyBody =>
      'لا يجمع هديل أي بيانات شخصية، ولا يرسل أي بيانات إلى أي خادم، ولا يحتاج إلى حساب. يُستخدم موقعك على جهازك فقط لحساب مواقيت الصلاة واتجاه القبلة، وتُحفظ المفضلة والعلامات والإعدادات محليًا على جهازك.';

  @override
  String get aboutBody =>
      'هديل رفيقك اليومي للقرآن والذكر: القرآن الكريم وتفسيره، الأذكار والأدعية، الأحاديث، مواقيت الصلاة، القبلة، التسبيح، والتقويم الهجري — ويعمل بالكامل دون اتصال بالإنترنت.';

  @override
  String aboutVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get dailyContent => 'زاد اليوم';

  @override
  String get dailyAyah => 'آية اليوم';

  @override
  String get dailyDhikr => 'ذكر اليوم';

  @override
  String get dailyHadith => 'حديث اليوم';

  @override
  String get dailyDua => 'دعاء اليوم';

  @override
  String get hourlyDhikrSchedule =>
      'كل رأس ساعة من ٧ صباحاً حتى ١٢ منتصف الليل';

  @override
  String get dailyContentReminderLabel => 'نفحات يومية من الذكر والحديث';

  @override
  String get dailyContentReminderDescription =>
      '٣ تنبيهات متنوّعة يومياً، مع تذكير بأذكار الصباح والمساء';

  @override
  String get notificationPermissionLabel => 'السماح بإشعارات هديل';

  @override
  String get notificationPermissionDescription =>
      'فعّل إذن الإشعارات والتنبيهات الدقيقة من جهازك';

  @override
  String get notificationPermissionGranted =>
      'تم تفعيل الإشعارات وإعادة جدولة التذكيرات';
}
