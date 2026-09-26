/// Route paths in one place — never hardcode a path in a widget.
abstract final class Routes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Bottom-navigation branches
  static const String home = '/';
  static const String quran = '/quran';
  static const String azkar = '/azkar';
  static const String prayer = '/prayer';
  static const String more = '/more';

  // Nested under branches
  static const String quranSurah = '/quran/surah/:id';
  static const String quranSearch = '/quran/search';
  static String quranSearchFor(String q) => Uri(path: quranSearch, queryParameters: {'q': q}).toString();
  static const String azkarCategory = '/azkar/:category';

  // Full-screen routes (above the navigation bar)
  static const String qibla = '/qibla';
  static const String duas = '/duas';
  static const String hadith = '/hadith';
  static const String tasbeeh = '/tasbeeh';
  static const String hijriCalendar = '/hijri-calendar';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String sources = '/sources';
  static const String privacy = '/privacy';
  static const String designGallery = '/dev/gallery';

  static String surah(int id, {int? ayah}) =>
      ayah == null ? '/quran/surah/$id' : '/quran/surah/$id?ayah=$ayah';
  static String azkarOf(String category) => '/azkar/$category';
  static String duasOf(String category) => '/duas/$category';
  static String hadithBook(String book) => '/hadith/$book';
  static String hadithItem(String book, int number) => '/hadith/$book/$number';
}
