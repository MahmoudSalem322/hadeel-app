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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  /// In ar, this message translates to:
  /// **'هديل'**
  String get appName;

  /// No description provided for @appNameLatin.
  ///
  /// In ar, this message translates to:
  /// **'Hadeel'**
  String get appNameLatin;

  /// No description provided for @appTagline.
  ///
  /// In ar, this message translates to:
  /// **'رفيقك اليومي للقرآن والذكر'**
  String get appTagline;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In ar, this message translates to:
  /// **'أهلًا بك في هديل'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In ar, this message translates to:
  /// **'رفيقك اليومي للقرآن والذكر والعبادة.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingQuranTitle.
  ///
  /// In ar, this message translates to:
  /// **'القرآن معك دائمًا'**
  String get onboardingQuranTitle;

  /// No description provided for @onboardingQuranBody.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ القرآن وتابع وردك حتى بدون اتصال بالإنترنت.'**
  String get onboardingQuranBody;

  /// No description provided for @onboardingPrayerTitle.
  ///
  /// In ar, this message translates to:
  /// **'صلاتك في وقتها'**
  String get onboardingPrayerTitle;

  /// No description provided for @onboardingPrayerBody.
  ///
  /// In ar, this message translates to:
  /// **'احسب مواقيت الصلاة حسب موقعك أو مدينتك.'**
  String get onboardingPrayerBody;

  /// No description provided for @onboardingStartTitle.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ رحلتك'**
  String get onboardingStartTitle;

  /// No description provided for @onboardingStartBody.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك لحساب مواقيت الصلاة بدقة. يمكنك تغييره لاحقًا من الإعدادات.'**
  String get onboardingStartBody;

  /// No description provided for @onboardingPageIndicator.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة {current} من {total}'**
  String onboardingPageIndicator(int current, int total);

  /// No description provided for @actionSkip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get actionSkip;

  /// No description provided for @actionNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get actionNext;

  /// No description provided for @actionStartNow.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get actionStartNow;

  /// No description provided for @actionContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get actionContinue;

  /// No description provided for @actionRetry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get actionRetry;

  /// No description provided for @actionChange.
  ///
  /// In ar, this message translates to:
  /// **'تغيير'**
  String get actionChange;

  /// No description provided for @actionClose.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get actionClose;

  /// No description provided for @actionExplore.
  ///
  /// In ar, this message translates to:
  /// **'استكشف المحتوى'**
  String get actionExplore;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navQuran.
  ///
  /// In ar, this message translates to:
  /// **'القرآن'**
  String get navQuran;

  /// No description provided for @navAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار'**
  String get navAdhkar;

  /// No description provided for @navPrayer.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة'**
  String get navPrayer;

  /// No description provided for @navMore.
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get navMore;

  /// No description provided for @homeGreeting.
  ///
  /// In ar, this message translates to:
  /// **'السلام عليكم'**
  String get homeGreeting;

  /// No description provided for @homeNextPrayer.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة القادمة'**
  String get homeNextPrayer;

  /// No description provided for @homeRemaining.
  ///
  /// In ar, this message translates to:
  /// **'متبقي'**
  String get homeRemaining;

  /// No description provided for @homeTodayPrayerTimes.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت اليوم'**
  String get homeTodayPrayerTimes;

  /// No description provided for @homeQuickAccess.
  ///
  /// In ar, this message translates to:
  /// **'وصول سريع'**
  String get homeQuickAccess;

  /// No description provided for @homeContinueReading.
  ///
  /// In ar, this message translates to:
  /// **'متابعة القراءة'**
  String get homeContinueReading;

  /// No description provided for @homeStartReading.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ القراءة'**
  String get homeStartReading;

  /// No description provided for @homeStartReadingBody.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ وردك من القرآن الكريم، وسنحفظ موضعك تلقائيًا.'**
  String get homeStartReadingBody;

  /// No description provided for @homeReadingPosition.
  ///
  /// In ar, this message translates to:
  /// **'سورة {surah} · آية {ayah}'**
  String homeReadingPosition(String surah, String ayah);

  /// No description provided for @nextPrayerSemantics.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة القادمة {prayer} الساعة {time}، متبقي {remaining}'**
  String nextPrayerSemantics(String prayer, String time, String remaining);

  /// No description provided for @featureQuran.
  ///
  /// In ar, this message translates to:
  /// **'القرآن الكريم'**
  String get featureQuran;

  /// No description provided for @featureAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار'**
  String get featureAdhkar;

  /// No description provided for @featureTasbeeh.
  ///
  /// In ar, this message translates to:
  /// **'التسبيح'**
  String get featureTasbeeh;

  /// No description provided for @featureQibla.
  ///
  /// In ar, this message translates to:
  /// **'القبلة'**
  String get featureQibla;

  /// No description provided for @featureDuas.
  ///
  /// In ar, this message translates to:
  /// **'الأدعية'**
  String get featureDuas;

  /// No description provided for @featureHadith.
  ///
  /// In ar, this message translates to:
  /// **'الأحاديث'**
  String get featureHadith;

  /// No description provided for @featurePrayerTimes.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت الصلاة'**
  String get featurePrayerTimes;

  /// No description provided for @featureHijriCalendar.
  ///
  /// In ar, this message translates to:
  /// **'التقويم الهجري'**
  String get featureHijriCalendar;

  /// No description provided for @featureFavorites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get featureFavorites;

  /// No description provided for @featureSearch.
  ///
  /// In ar, this message translates to:
  /// **'البحث'**
  String get featureSearch;

  /// No description provided for @featureSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get featureSettings;

  /// No description provided for @featureAbout.
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get featureAbout;

  /// No description provided for @featureSources.
  ///
  /// In ar, this message translates to:
  /// **'المصادر'**
  String get featureSources;

  /// No description provided for @featureMore.
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get featureMore;

  /// No description provided for @prayerName.
  ///
  /// In ar, this message translates to:
  /// **'{prayer, select, fajr{الفجر} sunrise{الشروق} dhuhr{الظهر} asr{العصر} maghrib{المغرب} isha{العشاء} other{}}'**
  String prayerName(String prayer);

  /// No description provided for @hijriMonth.
  ///
  /// In ar, this message translates to:
  /// **'{month, select, m1{محرم} m2{صفر} m3{ربيع الأول} m4{ربيع الآخر} m5{جمادى الأولى} m6{جمادى الآخرة} m7{رجب} m8{شعبان} m9{رمضان} m10{شوال} m11{ذو القعدة} m12{ذو الحجة} other{}}'**
  String hijriMonth(String month);

  /// No description provided for @hijriDate.
  ///
  /// In ar, this message translates to:
  /// **'{day} {month} {year} هـ'**
  String hijriDate(String day, String month, String year);

  /// No description provided for @locationUseMine.
  ///
  /// In ar, this message translates to:
  /// **'استخدم موقعي'**
  String get locationUseMine;

  /// No description provided for @locationChooseCity.
  ///
  /// In ar, this message translates to:
  /// **'اختر المدينة'**
  String get locationChooseCity;

  /// No description provided for @locationChooseCityManually.
  ///
  /// In ar, this message translates to:
  /// **'اختيار المدينة يدويًا'**
  String get locationChooseCityManually;

  /// No description provided for @locationLocating.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحديد موقعك…'**
  String get locationLocating;

  /// No description provided for @locationCurrent.
  ///
  /// In ar, this message translates to:
  /// **'موقعي الحالي'**
  String get locationCurrent;

  /// No description provided for @locationSelectedCity.
  ///
  /// In ar, this message translates to:
  /// **'المدينة: {city}'**
  String locationSelectedCity(String city);

  /// No description provided for @locationSelectedGps.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديد موقعك بنجاح'**
  String get locationSelectedGps;

  /// No description provided for @locationMissingTitle.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك'**
  String get locationMissingTitle;

  /// No description provided for @locationMissingBody.
  ///
  /// In ar, this message translates to:
  /// **'اختر مدينتك أو استخدم موقعك لعرض مواقيت الصلاة.'**
  String get locationMissingBody;

  /// No description provided for @locationErrorTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الحصول على الموقع'**
  String get locationErrorTitle;

  /// No description provided for @locationErrorServiceDisabled.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع متوقفة على جهازك.'**
  String get locationErrorServiceDisabled;

  /// No description provided for @locationErrorDenied.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم منح إذن الوصول إلى الموقع.'**
  String get locationErrorDenied;

  /// No description provided for @locationErrorDeniedForever.
  ///
  /// In ar, this message translates to:
  /// **'إذن الموقع مرفوض. يمكنك تفعيله من إعدادات الجهاز.'**
  String get locationErrorDeniedForever;

  /// No description provided for @locationErrorTimeout.
  ///
  /// In ar, this message translates to:
  /// **'استغرق تحديد الموقع وقتًا أطول من المتوقع.'**
  String get locationErrorTimeout;

  /// No description provided for @locationErrorUnknown.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع أثناء تحديد الموقع.'**
  String get locationErrorUnknown;

  /// No description provided for @cityPickerTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر مدينتك'**
  String get cityPickerTitle;

  /// No description provided for @citySearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن مدينة'**
  String get citySearchHint;

  /// No description provided for @cityNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مدينة بهذا الاسم'**
  String get cityNoResults;

  /// No description provided for @cityRegion.
  ///
  /// In ar, this message translates to:
  /// **'{region, select, west_bank{الضفة الغربية} gaza_strip{قطاع غزة} interior{الداخل الفلسطيني} other{أخرى}}'**
  String cityRegion(String region);

  /// No description provided for @comingSoonTitle.
  ///
  /// In ar, this message translates to:
  /// **'قريبًا بإذن الله'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonBody.
  ///
  /// In ar, this message translates to:
  /// **'نعمل على تجهيز هذا القسم ليعمل بالكامل دون اتصال بالإنترنت.'**
  String get comingSoonBody;

  /// No description provided for @themeModeLabel.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get themeModeLabel;

  /// No description provided for @themeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In ar, this message translates to:
  /// **'حسب النظام'**
  String get themeSystem;

  /// No description provided for @galleryTitle.
  ///
  /// In ar, this message translates to:
  /// **'نظام التصميم'**
  String get galleryTitle;

  /// No description provided for @gallerySampleAyahLabel.
  ///
  /// In ar, this message translates to:
  /// **'نموذج خط القرآن'**
  String get gallerySampleAyahLabel;

  /// No description provided for @galleryColors.
  ///
  /// In ar, this message translates to:
  /// **'الألوان'**
  String get galleryColors;

  /// No description provided for @galleryTypography.
  ///
  /// In ar, this message translates to:
  /// **'الخطوط'**
  String get galleryTypography;

  /// No description provided for @galleryComponents.
  ///
  /// In ar, this message translates to:
  /// **'المكونات'**
  String get galleryComponents;

  /// No description provided for @galleryStates.
  ///
  /// In ar, this message translates to:
  /// **'الحالات'**
  String get galleryStates;

  /// No description provided for @gallerySampleText.
  ///
  /// In ar, this message translates to:
  /// **'نص تجريبي لعرض الخط العربي بوضوح وراحة في القراءة.'**
  String get gallerySampleText;

  /// No description provided for @gallerySearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في القرآن والأذكار'**
  String get gallerySearchHint;

  /// No description provided for @emptyFavoritesTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عناصر محفوظة'**
  String get emptyFavoritesTitle;

  /// No description provided for @emptyFavoritesBody.
  ///
  /// In ar, this message translates to:
  /// **'لم تضف شيئًا للمفضلة بعد.'**
  String get emptyFavoritesBody;

  /// No description provided for @quranTabSurahs.
  ///
  /// In ar, this message translates to:
  /// **'السور'**
  String get quranTabSurahs;

  /// No description provided for @quranTabJuz.
  ///
  /// In ar, this message translates to:
  /// **'الأجزاء'**
  String get quranTabJuz;

  /// No description provided for @quranTabFavorites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get quranTabFavorites;

  /// No description provided for @surahTitle.
  ///
  /// In ar, this message translates to:
  /// **'سورة {name}'**
  String surahTitle(String name);

  /// No description provided for @revelationType.
  ///
  /// In ar, this message translates to:
  /// **'{type, select, meccan{مكية} medinan{مدنية} other{}}'**
  String revelationType(String type);

  /// No description provided for @ayahCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{آية واحدة} =2{آيتان} few{{count} آيات} other{{count} آية}}'**
  String ayahCount(int count);

  /// No description provided for @juzTitle.
  ///
  /// In ar, this message translates to:
  /// **'الجزء {number}'**
  String juzTitle(String number);

  /// No description provided for @ayahPosition.
  ///
  /// In ar, this message translates to:
  /// **'{surah} · آية {ayah}'**
  String ayahPosition(String surah, String ayah);

  /// No description provided for @ayahNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'آية {number}'**
  String ayahNumberLabel(String number);

  /// No description provided for @ayahCitation.
  ///
  /// In ar, this message translates to:
  /// **'﴿{text}﴾ [{surah}: {ayah}]'**
  String ayahCitation(String text, String surah, String ayah);

  /// No description provided for @sajdaMark.
  ///
  /// In ar, this message translates to:
  /// **'موضع سجدة'**
  String get sajdaMark;

  /// No description provided for @quranLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل نص القرآن'**
  String get quranLoadError;

  /// No description provided for @ayahActionBookmark.
  ///
  /// In ar, this message translates to:
  /// **'علامة'**
  String get ayahActionBookmark;

  /// No description provided for @ayahActionFavorite.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get ayahActionFavorite;

  /// No description provided for @ayahActionCopy.
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get ayahActionCopy;

  /// No description provided for @ayahActionShare.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get ayahActionShare;

  /// No description provided for @toastCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ الآية'**
  String get toastCopied;

  /// No description provided for @toastBookmarkAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ العلامة'**
  String get toastBookmarkAdded;

  /// No description provided for @toastBookmarkRemoved.
  ///
  /// In ar, this message translates to:
  /// **'أزيلت العلامة'**
  String get toastBookmarkRemoved;

  /// No description provided for @toastFavoriteAdded.
  ///
  /// In ar, this message translates to:
  /// **'أضيفت إلى المفضلة'**
  String get toastFavoriteAdded;

  /// No description provided for @toastFavoriteRemoved.
  ///
  /// In ar, this message translates to:
  /// **'أزيلت من المفضلة'**
  String get toastFavoriteRemoved;

  /// No description provided for @readingSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات القراءة'**
  String get readingSettingsTitle;

  /// No description provided for @readingFontSize.
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط'**
  String get readingFontSize;

  /// No description provided for @readingLineHeight.
  ///
  /// In ar, this message translates to:
  /// **'تباعد الأسطر'**
  String get readingLineHeight;

  /// No description provided for @readingFont.
  ///
  /// In ar, this message translates to:
  /// **'نوع الخط'**
  String get readingFont;

  /// No description provided for @readingFontAmiri.
  ///
  /// In ar, this message translates to:
  /// **'أميري قرآن'**
  String get readingFontAmiri;

  /// No description provided for @readingFontScheherazade.
  ///
  /// In ar, this message translates to:
  /// **'شهرزاد'**
  String get readingFontScheherazade;

  /// No description provided for @readingMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع القراءة'**
  String get readingMode;

  /// No description provided for @readingModeVerses.
  ///
  /// In ar, this message translates to:
  /// **'آية آية'**
  String get readingModeVerses;

  /// No description provided for @readingModeContinuous.
  ///
  /// In ar, this message translates to:
  /// **'متصل'**
  String get readingModeContinuous;

  /// No description provided for @nextSurah.
  ///
  /// In ar, this message translates to:
  /// **'السورة التالية'**
  String get nextSurah;

  /// No description provided for @quranSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث بكلمة من القرآن الكريم'**
  String get quranSearchHint;

  /// No description provided for @searchMinChars.
  ///
  /// In ar, this message translates to:
  /// **'اكتب حرفين على الأقل للبحث'**
  String get searchMinChars;

  /// No description provided for @searchNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج مطابقة'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsBody.
  ///
  /// In ar, this message translates to:
  /// **'جرّب كلمة أخرى أو تأكد من الإملاء.'**
  String get searchNoResultsBody;

  /// No description provided for @searchSurahsSection.
  ///
  /// In ar, this message translates to:
  /// **'السور'**
  String get searchSurahsSection;

  /// No description provided for @searchAyatSection.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{الآيات} =1{الآيات · نتيجة واحدة} =2{الآيات · نتيجتان} few{الآيات · {count} نتائج} other{الآيات · {count} نتيجة}}'**
  String searchAyatSection(int count);

  /// No description provided for @searchCapped.
  ///
  /// In ar, this message translates to:
  /// **'تُعرض أول {shown} نتيجة. حدّد البحث بكلمات أكثر.'**
  String searchCapped(String shown);

  /// No description provided for @quranBookmarksSection.
  ///
  /// In ar, this message translates to:
  /// **'العلامات'**
  String get quranBookmarksSection;

  /// No description provided for @quranFavoritesSection.
  ///
  /// In ar, this message translates to:
  /// **'الآيات المفضلة'**
  String get quranFavoritesSection;

  /// No description provided for @quranFavoritesEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد آيات محفوظة'**
  String get quranFavoritesEmptyTitle;

  /// No description provided for @quranFavoritesEmptyBody.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على أي آية أثناء القراءة لإضافتها إلى المفضلة أو وضع علامة عليها.'**
  String get quranFavoritesEmptyBody;

  /// No description provided for @actionStartReading.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ القراءة'**
  String get actionStartReading;

  /// No description provided for @sourcesIntro.
  ///
  /// In ar, this message translates to:
  /// **'يحرص هديل على أن يكون كل محتوى ديني فيه من مصدر موثوق ومعلن، دون أي تعديل أو توليد آلي.'**
  String get sourcesIntro;

  /// No description provided for @sourceQuranTitle.
  ///
  /// In ar, this message translates to:
  /// **'نص القرآن الكريم'**
  String get sourceQuranTitle;

  /// No description provided for @sourceQuranBody.
  ///
  /// In ar, this message translates to:
  /// **'مشروع تنزيل (Tanzil) — النص العثماني والنص الإملائي المبسّط، الإصدار 1.1. يُنقل النص كما هو دون أي تغيير، وفق شروط الاستخدام وترخيص المشاع الإبداعي (نسب المصنف 3.0).'**
  String get sourceQuranBody;

  /// No description provided for @sourceQuranMetaTitle.
  ///
  /// In ar, this message translates to:
  /// **'بيانات السور والأجزاء'**
  String get sourceQuranMetaTitle;

  /// No description provided for @sourceQuranMetaBody.
  ///
  /// In ar, this message translates to:
  /// **'مشروع تنزيل — ملف بيانات المصحف (أسماء السور، عدد الآيات، مواضع الأجزاء والأحزاب والسجدات).'**
  String get sourceQuranMetaBody;

  /// No description provided for @sourceFontsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخطوط'**
  String get sourceFontsTitle;

  /// No description provided for @sourceFontsBody.
  ///
  /// In ar, this message translates to:
  /// **'أميري قرآن، شهرزاد الجديد، وIBM Plex Sans Arabic — جميعها برخصة SIL Open Font License.'**
  String get sourceFontsBody;

  /// No description provided for @sourcePrayerTitle.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت الصلاة'**
  String get sourcePrayerTitle;

  /// No description provided for @sourcePrayerBody.
  ///
  /// In ar, this message translates to:
  /// **'تُحسب على جهازك باستخدام خوارزمية Adhan، وفق طريقة الحساب والمذهب المختارين.'**
  String get sourcePrayerBody;

  /// No description provided for @sourceHijriTitle.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ الهجري'**
  String get sourceHijriTitle;

  /// No description provided for @sourceHijriBody.
  ///
  /// In ar, this message translates to:
  /// **'تقويم أم القرى.'**
  String get sourceHijriBody;
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
