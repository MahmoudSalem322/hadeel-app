// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Hadeel';

  @override
  String get appNameLatin => 'Hadeel';

  @override
  String get appTagline => 'Your daily companion for Quran and dhikr';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Hadeel';

  @override
  String get onboardingWelcomeBody =>
      'Your daily companion for Quran, dhikr and worship.';

  @override
  String get onboardingQuranTitle => 'The Quran, always with you';

  @override
  String get onboardingQuranBody =>
      'Read the Quran and keep up with your wird, even offline.';

  @override
  String get onboardingPrayerTitle => 'Pray on time';

  @override
  String get onboardingPrayerBody =>
      'Prayer times calculated for your location or city.';

  @override
  String get onboardingStartTitle => 'Start your journey';

  @override
  String get onboardingStartBody =>
      'Set your location for accurate prayer times. You can change it later in Settings.';

  @override
  String onboardingPageIndicator(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionNext => 'Next';

  @override
  String get actionStartNow => 'Start now';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionChange => 'Change';

  @override
  String get actionClose => 'Close';

  @override
  String get actionExplore => 'Explore content';

  @override
  String get navHome => 'Home';

  @override
  String get navQuran => 'Quran';

  @override
  String get navAdhkar => 'Adhkar';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navMore => 'More';

  @override
  String get homeGreeting => 'Assalamu alaikum';

  @override
  String get homeNextPrayer => 'Next prayer';

  @override
  String get homeRemaining => 'Remaining';

  @override
  String get homeTodayPrayerTimes => 'Today\'s prayer times';

  @override
  String get homeQuickAccess => 'Quick access';

  @override
  String get homeContinueReading => 'Continue reading';

  @override
  String get homeStartReading => 'Start reading';

  @override
  String get homeStartReadingBody =>
      'Begin your Quran wird and we will remember your place.';

  @override
  String homeReadingPosition(String surah, String ayah) {
    return 'Surah $surah · Ayah $ayah';
  }

  @override
  String nextPrayerSemantics(String prayer, String time, String remaining) {
    return 'Next prayer $prayer at $time, $remaining remaining';
  }

  @override
  String get featureQuran => 'The Holy Quran';

  @override
  String get featureAdhkar => 'Adhkar';

  @override
  String get featureTasbeeh => 'Tasbeeh';

  @override
  String get featureQibla => 'Qibla';

  @override
  String get featureDuas => 'Duas';

  @override
  String get featureHadith => 'Hadith';

  @override
  String get featurePrayerTimes => 'Prayer times';

  @override
  String get featureHijriCalendar => 'Hijri calendar';

  @override
  String get featureFavorites => 'Favorites';

  @override
  String get featureSearch => 'Search';

  @override
  String get featureSettings => 'Settings';

  @override
  String get featureAbout => 'About';

  @override
  String get featureSources => 'Sources';

  @override
  String get featureMore => 'More';

  @override
  String prayerName(String prayer) {
    String _temp0 = intl.Intl.selectLogic(prayer, {
      'fajr': 'Fajr',
      'sunrise': 'Sunrise',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String hijriMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'Muharram',
      'm2': 'Safar',
      'm3': 'Rabi al-Awwal',
      'm4': 'Rabi al-Akhir',
      'm5': 'Jumada al-Ula',
      'm6': 'Jumada al-Akhirah',
      'm7': 'Rajab',
      'm8': 'Shaban',
      'm9': 'Ramadan',
      'm10': 'Shawwal',
      'm11': 'Dhu al-Qadah',
      'm12': 'Dhu al-Hijjah',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String hijriDate(String day, String month, String year) {
    return '$day $month $year AH';
  }

  @override
  String get locationUseMine => 'Use my location';

  @override
  String get locationChooseCity => 'Choose city';

  @override
  String get locationChooseCityManually => 'Choose city manually';

  @override
  String get locationLocating => 'Locating you…';

  @override
  String get locationCurrent => 'My location';

  @override
  String locationSelectedCity(String city) {
    return 'City: $city';
  }

  @override
  String get locationSelectedGps => 'Location set';

  @override
  String get locationMissingTitle => 'Set your location';

  @override
  String get locationMissingBody =>
      'Choose your city or use your location to see prayer times.';

  @override
  String get locationErrorTitle => 'Couldn\'t get your location';

  @override
  String get locationErrorServiceDisabled =>
      'Location services are turned off.';

  @override
  String get locationErrorDenied => 'Location permission was not granted.';

  @override
  String get locationErrorDeniedForever =>
      'Location permission is denied. You can enable it in device settings.';

  @override
  String get locationErrorTimeout => 'Getting your location took too long.';

  @override
  String get locationErrorUnknown =>
      'An unexpected error occurred while locating you.';

  @override
  String get cityPickerTitle => 'Choose your city';

  @override
  String get citySearchHint => 'Search for a city';

  @override
  String get cityNoResults => 'No city matches that name';

  @override
  String cityRegion(String region) {
    String _temp0 = intl.Intl.selectLogic(region, {
      'west_bank': 'West Bank',
      'gaza_strip': 'Gaza Strip',
      'interior': 'Interior',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonBody =>
      'We\'re preparing this section to work fully offline.';

  @override
  String get themeModeLabel => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get galleryTitle => 'Design system';

  @override
  String get gallerySampleAyahLabel => 'Quran font sample';

  @override
  String get galleryColors => 'Colors';

  @override
  String get galleryTypography => 'Typography';

  @override
  String get galleryComponents => 'Components';

  @override
  String get galleryStates => 'States';

  @override
  String get gallerySampleText =>
      'Sample text showing clear, comfortable Arabic type.';

  @override
  String get gallerySearchHint => 'Search the Quran and adhkar';

  @override
  String get emptyFavoritesTitle => 'Nothing saved yet';

  @override
  String get emptyFavoritesBody =>
      'You haven\'t added anything to your favorites.';

  @override
  String get quranTabSurahs => 'Surahs';

  @override
  String get quranTabJuz => 'Juz\'';

  @override
  String get quranTabFavorites => 'Favorites';

  @override
  String get quranTabBookmarks => 'Bookmarks';

  @override
  String surahTitle(String name) {
    return 'Surah $name';
  }

  @override
  String revelationType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'meccan': 'Meccan',
      'medinan': 'Medinan',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ayat',
      one: '1 ayah',
    );
    return '$_temp0';
  }

  @override
  String juzTitle(String number) {
    return 'Juz\' $number';
  }

  @override
  String ayahPosition(String surah, String ayah) {
    return '$surah · Ayah $ayah';
  }

  @override
  String ayahNumberLabel(String number) {
    return 'Ayah $number';
  }

  @override
  String ayahCitation(String text, String surah, String ayah) {
    return '﴿$text﴾ [$surah: $ayah]';
  }

  @override
  String get sajdaMark => 'Prostration';

  @override
  String get quranLoadError => 'Couldn\'t load the Quran text';

  @override
  String get ayahActionBookmark => 'Bookmark';

  @override
  String get ayahActionFavorite => 'Favorite';

  @override
  String get ayahActionCopy => 'Copy';

  @override
  String get ayahActionShare => 'Share';

  @override
  String get toastCopied => 'Ayah copied';

  @override
  String get toastBookmarkAdded => 'Bookmark saved';

  @override
  String get toastBookmarkRemoved => 'Bookmark removed';

  @override
  String get toastFavoriteAdded => 'Added to favorites';

  @override
  String get toastFavoriteRemoved => 'Removed from favorites';

  @override
  String get readingSettingsTitle => 'Reading settings';

  @override
  String get readingFontSize => 'Font size';

  @override
  String get readingLineHeight => 'Line spacing';

  @override
  String get readingFont => 'Font';

  @override
  String get readingFontAmiri => 'Amiri Quran';

  @override
  String get readingFontScheherazade => 'Scheherazade';

  @override
  String get readingMode => 'Reading mode';

  @override
  String get readingModeVerses => 'Ayah by ayah';

  @override
  String get readingModeContinuous => 'Continuous';

  @override
  String get nextSurah => 'Next surah';

  @override
  String get quranSearchHint => 'Search the Quran';

  @override
  String get searchMinChars => 'Type at least two letters';

  @override
  String get searchNoResults => 'No matches';

  @override
  String get searchNoResultsBody => 'Try another word or check the spelling.';

  @override
  String get searchSurahsSection => 'Surahs';

  @override
  String searchAyatSection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ayat · $count results',
      one: 'Ayat · 1 result',
      zero: 'Ayat',
    );
    return '$_temp0';
  }

  @override
  String searchCapped(String shown) {
    return 'Showing the first $shown results. Add more words to narrow down.';
  }

  @override
  String get quranBookmarksSection => 'Bookmarks';

  @override
  String get quranBookmarksEmptyTitle => 'No bookmarks yet';

  @override
  String get quranBookmarksEmptyBody =>
      'Bookmark any ayah to find it here with the time it was saved.';

  @override
  String get quranFavoritesSection => 'Favorite ayat';

  @override
  String get quranFavoritesEmptyTitle => 'No saved ayat';

  @override
  String get quranFavoritesEmptyBody =>
      'Tap any ayah while reading to favorite or bookmark it.';

  @override
  String get actionStartReading => 'Start reading';

  @override
  String get sourcesIntro =>
      'Every piece of religious content in Hadeel comes from a trusted, stated source — never altered or machine-generated.';

  @override
  String get sourceQuranTitle => 'Quran text';

  @override
  String get sourceQuranBody =>
      'Tanzil Project — Uthmani and Simple Clean texts, version 1.1, reproduced verbatim under its terms of use and CC BY 3.0.';

  @override
  String get sourceQuranMetaTitle => 'Surah and juz\' data';

  @override
  String get sourceQuranMetaBody =>
      'Tanzil Project — Quran metadata (surah names, ayah counts, juz\', hizb and sajdah positions).';

  @override
  String get sourceFontsTitle => 'Fonts';

  @override
  String get sourceFontsBody =>
      'Amiri Quran, Scheherazade New and IBM Plex Sans Arabic — all under the SIL Open Font License.';

  @override
  String get sourcePrayerTitle => 'Prayer times';

  @override
  String get sourcePrayerBody =>
      'Calculated on your device with the Adhan algorithm, using your chosen method and madhab.';

  @override
  String get sourceHijriTitle => 'Hijri date';

  @override
  String get sourceHijriBody => 'Umm al-Qura calendar.';

  @override
  String get sourceTafsirTitle => 'Tafsir';

  @override
  String get sourceTafsirBody =>
      'Al-Tafsir al-Muyassar — King Fahd Complex for the Printing of the Holy Quran, via Tanzil. Shown unaltered.';

  @override
  String get sourceAdhkarTitle => 'Adhkar and duas';

  @override
  String get sourceAdhkarBody =>
      'Hisn al-Muslim — Sa\'id ibn Ali ibn Wahf al-Qahtani (hisnmuslim.com). Quranic duas are shown straight from the mushaf text.';

  @override
  String get sourceHadithTitle => 'Hadith';

  @override
  String get sourceHadithBody =>
      'Imam an-Nawawi\'s Forty Hadith and Riyad as-Salihin — Arabic text as published by Sunnah.com, including the takhrij given in the book.';

  @override
  String get ayahActionTafsir => 'Tafsir';

  @override
  String get tafsirTitle => 'Al-Tafsir al-Muyassar';

  @override
  String get tafsirSource =>
      'Source: Al-Tafsir al-Muyassar — King Fahd Complex';

  @override
  String get readingShowTafsir => 'Show tafsir under each ayah';

  @override
  String get tafsirLoadError => 'Couldn\'t load the tafsir';

  @override
  String adhkarCategory(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'morning_evening': 'Morning & evening',
      'after_prayer': 'After prayer',
      'sleep': 'Before sleep',
      'waking': 'On waking',
      'home_leave': 'Leaving home',
      'home_enter': 'Entering home',
      'mosque': 'Mosque',
      'adhan': 'Adhan',
      'wudu': 'Wudu',
      'food': 'Eating',
      'travel': 'Travel',
      'tasbih': 'Tasbih & praise',
      'other': 'Adhkar',
    });
    return '$_temp0';
  }

  @override
  String get adhkarDaily => 'Daily adhkar';

  @override
  String get adhkarAllChapters => 'All chapters of Hisn al-Muslim';

  @override
  String get adhkarSearchHint => 'Search adhkar chapters';

  @override
  String dhikrPosition(String current, String total) {
    return '$current / $total';
  }

  @override
  String dhikrRepeat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: 'Once',
    );
    return '$_temp0';
  }

  @override
  String get dhikrCounterButton => 'Count';

  @override
  String dhikrCountSemantics(String count, String target) {
    return '$count of $target';
  }

  @override
  String get actionReset => 'Reset';

  @override
  String get actionPrevious => 'Previous';

  @override
  String get adhkarCompletedTitle => 'May Allah accept it from you';

  @override
  String get adhkarCompletedBody => 'You\'ve completed this chapter.';

  @override
  String get actionRestart => 'Start again';

  @override
  String get adhkarSource => 'Source: Hisn al-Muslim';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adhkar',
      one: '1 dhikr',
    );
    return '$_temp0';
  }

  @override
  String get contentLoadError => 'Couldn\'t load the content';

  @override
  String duaCategory(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'quranic': 'Quranic duas',
      'prophets': 'Duas of the prophets',
      'rizq': 'Provision & debt',
      'tawbah': 'Repentance',
      'travel': 'Travel',
      'healing': 'Illness & healing',
      'distress': 'Worry & distress',
      'morning_evening': 'Morning & evening',
      'general': 'Comprehensive duas',
      'other': 'Duas',
    });
    return '$_temp0';
  }

  @override
  String prophetName(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'adam': 'Adam (AS)',
      'nuh': 'Nuh (AS)',
      'ibrahim': 'Ibrahim (AS)',
      'shuayb': 'Shu\'ayb (AS)',
      'lut': 'Lut (AS)',
      'yusuf': 'Yusuf (AS)',
      'musa': 'Musa (AS)',
      'ayyub': 'Ayyub (AS)',
      'yunus': 'Yunus (AS)',
      'sulayman': 'Sulayman (AS)',
      'zakariya': 'Zakariya (AS)',
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
      other: '$count duas',
      one: '1 dua',
    );
    return '$_temp0';
  }

  @override
  String get toastCopiedText => 'Copied';

  @override
  String get hadithBooks => 'Hadith books';

  @override
  String hadithNumber(String number) {
    return 'Hadith $number';
  }

  @override
  String hadithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hadith',
      one: '1 hadith',
    );
    return '$_temp0';
  }

  @override
  String get hadithAllChapters => 'All books';

  @override
  String hadithSourceLine(String book, String author) {
    return '$book — $author';
  }

  @override
  String get hadithSearchHint => 'Search hadith';

  @override
  String get prayerMethod => 'Calculation method';

  @override
  String get prayerMadhab => 'Asr juristic method';

  @override
  String calcMethodName(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'egyptian': 'Egyptian General Authority',
      'muslimWorldLeague': 'Muslim World League',
      'ummAlQura': 'Umm al-Qura',
      'karachi': 'University of Islamic Sciences, Karachi',
      'northAmerica': 'North America (ISNA)',
      'dubai': 'Dubai',
      'kuwait': 'Kuwait',
      'qatar': 'Qatar',
      'turkey': 'Turkey',
      'singapore': 'Singapore',
      'moonSightingCommittee': 'Moonsighting Committee',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String madhabName(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'shafi': 'Standard (Shafi\'i, Maliki, Hanbali)',
      'hanafi': 'Hanafi',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get locationGpsLabel => 'My location (GPS)';

  @override
  String get locationUpdate => 'Update location';

  @override
  String get locationChangeCity => 'Change city';

  @override
  String get prayerCalcNote =>
      'Times are calculated on your device, no internet needed.';

  @override
  String get notificationsTitle => 'Prayer notifications';

  @override
  String get notificationsEnableAll => 'Turn on prayer notifications';

  @override
  String notificationForPrayer(String prayer) {
    return '$prayer notification';
  }

  @override
  String get notificationsDenied =>
      'Notifications aren\'t allowed. You can allow them in device settings.';

  @override
  String notificationTitle(String prayer) {
    return 'It\'s time for $prayer';
  }

  @override
  String notificationBody(String place, String time) {
    return '$place · $time';
  }

  @override
  String get notificationChannelName => 'Prayer times';

  @override
  String get notificationChannelDescription =>
      'Alerts when each prayer time begins';

  @override
  String get hourlyDhikrLabel => 'Hourly dhikr reminder';

  @override
  String get hourlyDhikrTitle => 'Dhikr reminder';

  @override
  String get hourlyDhikrBody =>
      'Remember Allah and send blessings upon the Prophet ﷺ';

  @override
  String get qiblaDirectionLabel => 'Qibla direction';

  @override
  String qiblaBearing(String degrees) {
    return '$degrees° from north';
  }

  @override
  String qiblaDistance(String km) {
    return 'Distance to the Kaaba: $km km';
  }

  @override
  String get qiblaAligned => 'You\'re facing the qibla';

  @override
  String get qiblaTurnRight => 'Turn right';

  @override
  String get qiblaTurnLeft => 'Turn left';

  @override
  String get qiblaCalibrationTitle => 'Calibrate the compass';

  @override
  String get qiblaCalibrationBody =>
      'Move your phone in a figure-8 a few times, away from metal, magnets and electronics, and hold it flat.';

  @override
  String get qiblaNoSensor =>
      'This device has no compass sensor. Use the angle shown with another compass.';

  @override
  String get qiblaNeedsLocation => 'Set your location to calculate the qibla.';

  @override
  String qiblaHeading(String degrees) {
    return 'Phone heading: $degrees°';
  }

  @override
  String get tasbeehTarget => 'Target';

  @override
  String get tasbeehUnlimited => 'No limit';

  @override
  String get tasbeehChangeDhikr => 'Change dhikr';

  @override
  String get tasbeehReset => 'Reset';

  @override
  String tasbeehTotal(String count) {
    return 'Total: $count';
  }

  @override
  String tasbeehRounds(String count) {
    return 'Rounds: $count';
  }

  @override
  String get tasbeehTapHint => 'Tap to count';

  @override
  String get tasbeehVibration => 'Vibrate on each count';

  @override
  String get tasbeehSound => 'Sound on each count';

  @override
  String tasbeehPhrase(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'subhanallah': 'SubhanAllah',
      'alhamdulillah': 'Alhamdulillah',
      'allahuakbar': 'Allahu Akbar',
      'tahlil': 'La ilaha illallah',
      'istighfar': 'Astaghfirullah',
      'hawqala': 'La hawla wa la quwwata illa billah',
      'subhanallah_wabihamdihi': 'SubhanAllahi wa bihamdihi',
      'salawat': 'Allahumma salli ala Muhammad',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get hijriToday => 'Today';

  @override
  String hijriMonthTitle(String month, String year) {
    return '$month $year AH';
  }

  @override
  String get hijriAdjustment => 'Hijri date adjustment';

  @override
  String hijriAdjustmentValue(String days) {
    return '$days day(s)';
  }

  @override
  String get hijriNoAdjustment => 'No adjustment';

  @override
  String get hijriAdjustmentHint =>
      'To match the moon sighting in your country.';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get favoritesTabQuran => 'Quran';

  @override
  String get favoritesTabAdhkar => 'Adhkar';

  @override
  String get favoritesTabDuas => 'Duas';

  @override
  String get favoritesTabHadith => 'Hadith';

  @override
  String get globalSearchHint => 'Search the Quran, adhkar, duas and hadith';

  @override
  String get searchSectionQuran => 'The Holy Quran';

  @override
  String get searchSectionAdhkar => 'Adhkar';

  @override
  String get searchSectionHadith => 'Hadith';

  @override
  String get searchShowAll => 'Show all results';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsQuran => 'Quran';

  @override
  String get settingsPrayer => 'Prayer';

  @override
  String get settingsTasbeeh => 'Tasbeeh';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLocation => 'Location';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsVersion => 'Version';

  @override
  String get privacyBody =>
      'Hadeel collects no personal data, sends nothing to any server and needs no account. Your location is used on your device only, to calculate prayer times and the qibla. Favorites, bookmarks and settings are stored locally.';

  @override
  String get aboutBody =>
      'Hadeel is your daily companion for Quran and dhikr: the Holy Quran with tafsir, adhkar and duas, hadith, prayer times, qibla, tasbeeh and the Hijri calendar — all working fully offline.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get dailyContent => 'Today\'s reflection';

  @override
  String get dailyAyah => 'Ayah of the day';

  @override
  String get dailyDhikr => 'Dhikr of the day';

  @override
  String get dailyHadith => 'Hadith of the day';

  @override
  String get dailyDua => 'Dua of the day';

  @override
  String get hourlyDhikrSchedule => 'Every hour from 7 AM through midnight';

  @override
  String get dailyContentReminderLabel => 'Daily dhikr and hadith';

  @override
  String get dailyContentReminderDescription =>
      '3 varied reminders each day, plus morning and evening adhkar';

  @override
  String get notificationPermissionLabel => 'Allow Hadeel notifications';

  @override
  String get notificationPermissionDescription =>
      'Allow notifications and precise alarms on your device';

  @override
  String get notificationPermissionGranted =>
      'Notifications allowed and reminders rescheduled';
}
