/// Normalizes Arabic text for matching (not for display): unifies hamza
/// forms of alef, taa marbuta, alef maqsura, and drops tashkeel and tatweel.
/// Latin text is lower-cased so the same function serves English names.
String normalizeArabic(String input) {
  return input
      .trim()
      .toLowerCase()
      .replaceAll(RegExp('[أإآٱ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp(r'[ؐ-ًؚ-ٰٟۖ-ۭـ]'), '');
}
