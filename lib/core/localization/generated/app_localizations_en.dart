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
}
