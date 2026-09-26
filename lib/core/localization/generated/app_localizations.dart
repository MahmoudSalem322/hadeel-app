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

  /// No description provided for @sourceTafsirTitle.
  ///
  /// In ar, this message translates to:
  /// **'التفسير'**
  String get sourceTafsirTitle;

  /// No description provided for @sourceTafsirBody.
  ///
  /// In ar, this message translates to:
  /// **'التفسير الميسر — مجمع الملك فهد لطباعة المصحف الشريف، عبر مشروع تنزيل. يُعرض كما هو دون تعديل.'**
  String get sourceTafsirBody;

  /// No description provided for @sourceAdhkarTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار والأدعية'**
  String get sourceAdhkarTitle;

  /// No description provided for @sourceAdhkarBody.
  ///
  /// In ar, this message translates to:
  /// **'حصن المسلم من أذكار الكتاب والسنة — سعيد بن علي بن وهف القحطاني (hisnmuslim.com). الأدعية القرآنية تُعرض من نص المصحف مباشرة.'**
  String get sourceAdhkarBody;

  /// No description provided for @sourceHadithTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأحاديث'**
  String get sourceHadithTitle;

  /// No description provided for @sourceHadithBody.
  ///
  /// In ar, this message translates to:
  /// **'الأربعون النووية ورياض الصالحين للإمام النووي — النص العربي كما نشره موقع Sunnah.com، ويتضمن التخريج كما ورد في الكتاب.'**
  String get sourceHadithBody;

  /// No description provided for @ayahActionTafsir.
  ///
  /// In ar, this message translates to:
  /// **'التفسير'**
  String get ayahActionTafsir;

  /// No description provided for @tafsirTitle.
  ///
  /// In ar, this message translates to:
  /// **'التفسير الميسر'**
  String get tafsirTitle;

  /// No description provided for @tafsirSource.
  ///
  /// In ar, this message translates to:
  /// **'المصدر: التفسير الميسر — مجمع الملك فهد لطباعة المصحف الشريف'**
  String get tafsirSource;

  /// No description provided for @readingShowTafsir.
  ///
  /// In ar, this message translates to:
  /// **'إظهار التفسير تحت الآيات'**
  String get readingShowTafsir;

  /// No description provided for @tafsirLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل التفسير'**
  String get tafsirLoadError;

  /// No description provided for @adhkarCategory.
  ///
  /// In ar, this message translates to:
  /// **'{key, select, morning_evening{أذكار الصباح والمساء} after_prayer{أذكار بعد الصلاة} sleep{أذكار النوم} waking{أذكار الاستيقاظ} home_leave{الخروج من المنزل} home_enter{دخول المنزل} mosque{أذكار المسجد} adhan{أذكار الأذان} wudu{أذكار الوضوء} food{أذكار الطعام} travel{أذكار السفر} tasbih{التسبيح والتحميد} other{الأذكار}}'**
  String adhkarCategory(String key);

  /// No description provided for @adhkarDaily.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار اليومية'**
  String get adhkarDaily;

  /// No description provided for @adhkarAllChapters.
  ///
  /// In ar, this message translates to:
  /// **'جميع أبواب حصن المسلم'**
  String get adhkarAllChapters;

  /// No description provided for @adhkarSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في أبواب الأذكار'**
  String get adhkarSearchHint;

  /// No description provided for @dhikrPosition.
  ///
  /// In ar, this message translates to:
  /// **'{current} / {total}'**
  String dhikrPosition(String current, String total);

  /// No description provided for @dhikrRepeat.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{مرة واحدة} =2{مرتان} few{{count} مرات} other{{count} مرة}}'**
  String dhikrRepeat(int count);

  /// No description provided for @dhikrCounterButton.
  ///
  /// In ar, this message translates to:
  /// **'تسبيح'**
  String get dhikrCounterButton;

  /// No description provided for @dhikrCountSemantics.
  ///
  /// In ar, this message translates to:
  /// **'العدد {count} من {target}'**
  String dhikrCountSemantics(String count, String target);

  /// No description provided for @actionReset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة'**
  String get actionReset;

  /// No description provided for @actionPrevious.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get actionPrevious;

  /// No description provided for @adhkarCompletedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تقبّل الله منك'**
  String get adhkarCompletedTitle;

  /// No description provided for @adhkarCompletedBody.
  ///
  /// In ar, this message translates to:
  /// **'أتممت أذكار هذا الباب.'**
  String get adhkarCompletedBody;

  /// No description provided for @actionRestart.
  ///
  /// In ar, this message translates to:
  /// **'البدء من جديد'**
  String get actionRestart;

  /// No description provided for @adhkarSource.
  ///
  /// In ar, this message translates to:
  /// **'المصدر: حصن المسلم'**
  String get adhkarSource;

  /// No description provided for @itemsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{ذكر واحد} =2{ذكران} few{{count} أذكار} other{{count} ذكرًا}}'**
  String itemsCount(int count);

  /// No description provided for @contentLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل المحتوى'**
  String get contentLoadError;

  /// No description provided for @duaCategory.
  ///
  /// In ar, this message translates to:
  /// **'{key, select, quranic{أدعية قرآنية} prophets{أدعية الأنبياء} rizq{الرزق وقضاء الدين} tawbah{التوبة والاستغفار} travel{السفر} healing{الشفاء والمرض} distress{الهم والحزن والكرب} morning_evening{الصباح والمساء} general{أدعية جامعة} other{الأدعية}}'**
  String duaCategory(String key);

  /// No description provided for @prophetName.
  ///
  /// In ar, this message translates to:
  /// **'{key, select, adam{آدم عليه السلام} nuh{نوح عليه السلام} ibrahim{إبراهيم عليه السلام} shuayb{شعيب عليه السلام} lut{لوط عليه السلام} yusuf{يوسف عليه السلام} musa{موسى عليه السلام} ayyub{أيوب عليه السلام} yunus{يونس عليه السلام} sulayman{سليمان عليه السلام} zakariya{زكريا عليه السلام} other{}}'**
  String prophetName(String key);

  /// No description provided for @quranReference.
  ///
  /// In ar, this message translates to:
  /// **'[{surah}: {ayat}]'**
  String quranReference(String surah, String ayat);

  /// No description provided for @duasCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{دعاء واحد} =2{دعاءان} few{{count} أدعية} other{{count} دعاءً}}'**
  String duasCount(int count);

  /// No description provided for @toastCopiedText.
  ///
  /// In ar, this message translates to:
  /// **'تم النسخ'**
  String get toastCopiedText;

  /// No description provided for @hadithBooks.
  ///
  /// In ar, this message translates to:
  /// **'كتب الحديث'**
  String get hadithBooks;

  /// No description provided for @hadithNumber.
  ///
  /// In ar, this message translates to:
  /// **'الحديث {number}'**
  String hadithNumber(String number);

  /// No description provided for @hadithCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{حديث واحد} =2{حديثان} few{{count} أحاديث} other{{count} حديثًا}}'**
  String hadithCount(int count);

  /// No description provided for @hadithAllChapters.
  ///
  /// In ar, this message translates to:
  /// **'كل الكتب'**
  String get hadithAllChapters;

  /// No description provided for @hadithSourceLine.
  ///
  /// In ar, this message translates to:
  /// **'{book} — {author}'**
  String hadithSourceLine(String book, String author);

  /// No description provided for @hadithSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في الأحاديث'**
  String get hadithSearchHint;

  /// No description provided for @prayerMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الحساب'**
  String get prayerMethod;

  /// No description provided for @prayerMadhab.
  ///
  /// In ar, this message translates to:
  /// **'مذهب صلاة العصر'**
  String get prayerMadhab;

  /// No description provided for @calcMethodName.
  ///
  /// In ar, this message translates to:
  /// **'{key, select, egyptian{الهيئة المصرية العامة للمساحة} muslimWorldLeague{رابطة العالم الإسلامي} ummAlQura{أم القرى} karachi{جامعة العلوم الإسلامية بكراتشي} northAmerica{أمريكا الشمالية} dubai{دبي} kuwait{الكويت} qatar{قطر} turkey{تركيا} singapore{سنغافورة} moonSightingCommittee{لجنة رؤية الهلال} other{}}'**
  String calcMethodName(String key);

  /// No description provided for @madhabName.
  ///
  /// In ar, this message translates to:
  /// **'{key, select, shafi{الجمهور (شافعي، مالكي، حنبلي)} hanafi{الحنفي} other{}}'**
  String madhabName(String key);

  /// No description provided for @locationGpsLabel.
  ///
  /// In ar, this message translates to:
  /// **'موقعي الحالي (GPS)'**
  String get locationGpsLabel;

  /// No description provided for @locationUpdate.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الموقع'**
  String get locationUpdate;

  /// No description provided for @locationChangeCity.
  ///
  /// In ar, this message translates to:
  /// **'تغيير المدينة'**
  String get locationChangeCity;

  /// No description provided for @prayerCalcNote.
  ///
  /// In ar, this message translates to:
  /// **'تُحسب المواقيت على جهازك دون اتصال بالإنترنت.'**
  String get prayerCalcNote;

  /// No description provided for @notificationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات الصلاة'**
  String get notificationsTitle;

  /// No description provided for @notificationsEnableAll.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل تنبيهات الصلوات'**
  String get notificationsEnableAll;

  /// No description provided for @notificationForPrayer.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه {prayer}'**
  String notificationForPrayer(String prayer);

  /// No description provided for @notificationsDenied.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات غير مسموحة. يمكنك السماح بها من إعدادات الجهاز.'**
  String get notificationsDenied;

  /// No description provided for @notificationTitle.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن موعد صلاة {prayer}'**
  String notificationTitle(String prayer);

  /// No description provided for @notificationBody.
  ///
  /// In ar, this message translates to:
  /// **'{place} · {time}'**
  String notificationBody(String place, String time);

  /// No description provided for @notificationChannelName.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت الصلاة'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه عند دخول وقت كل صلاة'**
  String get notificationChannelDescription;

  /// No description provided for @qiblaDirectionLabel.
  ///
  /// In ar, this message translates to:
  /// **'اتجاه القبلة'**
  String get qiblaDirectionLabel;

  /// No description provided for @qiblaBearing.
  ///
  /// In ar, this message translates to:
  /// **'{degrees}° من الشمال'**
  String qiblaBearing(String degrees);

  /// No description provided for @qiblaDistance.
  ///
  /// In ar, this message translates to:
  /// **'المسافة إلى الكعبة المشرفة: {km} كم'**
  String qiblaDistance(String km);

  /// No description provided for @qiblaAligned.
  ///
  /// In ar, this message translates to:
  /// **'أنت متجه نحو القبلة'**
  String get qiblaAligned;

  /// No description provided for @qiblaTurnRight.
  ///
  /// In ar, this message translates to:
  /// **'استدر يمينًا'**
  String get qiblaTurnRight;

  /// No description provided for @qiblaTurnLeft.
  ///
  /// In ar, this message translates to:
  /// **'استدر يسارًا'**
  String get qiblaTurnLeft;

  /// No description provided for @qiblaCalibrationTitle.
  ///
  /// In ar, this message translates to:
  /// **'معايرة البوصلة'**
  String get qiblaCalibrationTitle;

  /// No description provided for @qiblaCalibrationBody.
  ///
  /// In ar, this message translates to:
  /// **'حرّك الهاتف في الهواء على شكل الرقم 8 عدة مرات، وأبعده عن المعادن والمغناطيس والأجهزة الإلكترونية، وضعه بشكل أفقي.'**
  String get qiblaCalibrationBody;

  /// No description provided for @qiblaNoSensor.
  ///
  /// In ar, this message translates to:
  /// **'لا يتوفر مستشعر بوصلة في هذا الجهاز. استخدم الزاوية الموضحة مع بوصلة أخرى.'**
  String get qiblaNoSensor;

  /// No description provided for @qiblaNeedsLocation.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك لحساب اتجاه القبلة.'**
  String get qiblaNeedsLocation;

  /// No description provided for @qiblaHeading.
  ///
  /// In ar, this message translates to:
  /// **'اتجاه الهاتف: {degrees}°'**
  String qiblaHeading(String degrees);

  /// No description provided for @tasbeehTarget.
  ///
  /// In ar, this message translates to:
  /// **'الهدف'**
  String get tasbeehTarget;

  /// No description provided for @tasbeehUnlimited.
  ///
  /// In ar, this message translates to:
  /// **'بلا حد'**
  String get tasbeehUnlimited;

  /// No description provided for @tasbeehChangeDhikr.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الذكر'**
  String get tasbeehChangeDhikr;

  /// No description provided for @tasbeehReset.
  ///
  /// In ar, this message translates to:
  /// **'تصفير'**
  String get tasbeehReset;

  /// No description provided for @tasbeehTotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع: {count}'**
  String tasbeehTotal(String count);

  /// No description provided for @tasbeehRounds.
  ///
  /// In ar, this message translates to:
  /// **'الدورات: {count}'**
  String tasbeehRounds(String count);

  /// No description provided for @tasbeehTapHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط للتسبيح'**
  String get tasbeehTapHint;

  /// No description provided for @tasbeehVibration.
  ///
  /// In ar, this message translates to:
  /// **'الاهتزاز عند كل تسبيحة'**
  String get tasbeehVibration;

  /// No description provided for @tasbeehSound.
  ///
  /// In ar, this message translates to:
  /// **'صوت عند كل تسبيحة'**
  String get tasbeehSound;

  /// No description provided for @tasbeehPhrase.
  ///
  /// In ar, this message translates to:
  /// **'{key, select, subhanallah{سبحان الله} alhamdulillah{الحمد لله} allahuakbar{الله أكبر} tahlil{لا إله إلا الله} istighfar{أستغفر الله} hawqala{لا حول ولا قوة إلا بالله} subhanallah_wabihamdihi{سبحان الله وبحمده} salawat{اللهم صلِّ على محمد} other{}}'**
  String tasbeehPhrase(String key);

  /// No description provided for @hijriToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get hijriToday;

  /// No description provided for @hijriMonthTitle.
  ///
  /// In ar, this message translates to:
  /// **'{month} {year} هـ'**
  String hijriMonthTitle(String month, String year);

  /// No description provided for @hijriAdjustment.
  ///
  /// In ar, this message translates to:
  /// **'تعديل التاريخ الهجري'**
  String get hijriAdjustment;

  /// No description provided for @hijriAdjustmentValue.
  ///
  /// In ar, this message translates to:
  /// **'{days} يوم'**
  String hijriAdjustmentValue(String days);

  /// No description provided for @hijriNoAdjustment.
  ///
  /// In ar, this message translates to:
  /// **'بدون تعديل'**
  String get hijriNoAdjustment;

  /// No description provided for @hijriAdjustmentHint.
  ///
  /// In ar, this message translates to:
  /// **'لموافقة رؤية الهلال في بلدك.'**
  String get hijriAdjustmentHint;

  /// No description provided for @previousMonth.
  ///
  /// In ar, this message translates to:
  /// **'الشهر السابق'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In ar, this message translates to:
  /// **'الشهر التالي'**
  String get nextMonth;

  /// No description provided for @favoritesTabQuran.
  ///
  /// In ar, this message translates to:
  /// **'القرآن'**
  String get favoritesTabQuran;

  /// No description provided for @favoritesTabAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار'**
  String get favoritesTabAdhkar;

  /// No description provided for @favoritesTabDuas.
  ///
  /// In ar, this message translates to:
  /// **'الأدعية'**
  String get favoritesTabDuas;

  /// No description provided for @favoritesTabHadith.
  ///
  /// In ar, this message translates to:
  /// **'الأحاديث'**
  String get favoritesTabHadith;

  /// No description provided for @globalSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في القرآن والأذكار والأدعية والأحاديث'**
  String get globalSearchHint;

  /// No description provided for @searchSectionQuran.
  ///
  /// In ar, this message translates to:
  /// **'القرآن الكريم'**
  String get searchSectionQuran;

  /// No description provided for @searchSectionAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار'**
  String get searchSectionAdhkar;

  /// No description provided for @searchSectionHadith.
  ///
  /// In ar, this message translates to:
  /// **'الأحاديث'**
  String get searchSectionHadith;

  /// No description provided for @searchShowAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض كل النتائج'**
  String get searchShowAll;

  /// No description provided for @settingsAppearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLanguage;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsQuran.
  ///
  /// In ar, this message translates to:
  /// **'القرآن الكريم'**
  String get settingsQuran;

  /// No description provided for @settingsPrayer.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة'**
  String get settingsPrayer;

  /// No description provided for @settingsTasbeeh.
  ///
  /// In ar, this message translates to:
  /// **'التسبيح'**
  String get settingsTasbeeh;

  /// No description provided for @settingsGeneral.
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get settingsGeneral;

  /// No description provided for @settingsLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get settingsLocation;

  /// No description provided for @settingsPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية'**
  String get settingsPrivacy;

  /// No description provided for @settingsVersion.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار'**
  String get settingsVersion;

  /// No description provided for @privacyBody.
  ///
  /// In ar, this message translates to:
  /// **'لا يجمع هديل أي بيانات شخصية، ولا يرسل أي بيانات إلى أي خادم، ولا يحتاج إلى حساب. يُستخدم موقعك على جهازك فقط لحساب مواقيت الصلاة واتجاه القبلة، وتُحفظ المفضلة والعلامات والإعدادات محليًا على جهازك.'**
  String get privacyBody;

  /// No description provided for @aboutBody.
  ///
  /// In ar, this message translates to:
  /// **'هديل رفيقك اليومي للقرآن والذكر: القرآن الكريم وتفسيره، الأذكار والأدعية، الأحاديث، مواقيت الصلاة، القبلة، التسبيح، والتقويم الهجري — ويعمل بالكامل دون اتصال بالإنترنت.'**
  String get aboutBody;

  /// No description provided for @aboutVersion.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار {version}'**
  String aboutVersion(String version);

  /// No description provided for @dailyContent.
  ///
  /// In ar, this message translates to:
  /// **'زاد اليوم'**
  String get dailyContent;

  /// No description provided for @dailyAyah.
  ///
  /// In ar, this message translates to:
  /// **'آية اليوم'**
  String get dailyAyah;

  /// No description provided for @dailyDhikr.
  ///
  /// In ar, this message translates to:
  /// **'ذكر اليوم'**
  String get dailyDhikr;

  /// No description provided for @dailyHadith.
  ///
  /// In ar, this message translates to:
  /// **'حديث اليوم'**
  String get dailyHadith;

  /// No description provided for @dailyDua.
  ///
  /// In ar, this message translates to:
  /// **'دعاء اليوم'**
  String get dailyDua;
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
