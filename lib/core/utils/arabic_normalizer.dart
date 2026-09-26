final RegExp _marks = RegExp(r'[ؐ-ًؚ-ٰٟۖ-ۭـ]');

/// Normalizes Arabic text for matching (not for display): unifies hamza
/// forms of alef, taa marbuta, alef maqsura, and drops tashkeel and tatweel.
/// Latin text is lower-cased so the same function serves English names.
String normalizeArabic(String input) => normalizeArabicWithMap(input.trim()).text;

/// [normalizeArabic] plus a map from each normalized character back to its
/// index in the original string, so matches can be highlighted in place.
NormalizedText normalizeArabicWithMap(String input) {
  final out = StringBuffer();
  final map = <int>[];
  for (var i = 0; i < input.length; i++) {
    final ch = input[i];
    if (_marks.hasMatch(ch)) continue;
    out.write(_fold(ch));
    map.add(i);
  }
  return NormalizedText(out.toString(), map);
}

String _fold(String ch) => switch (ch) {
      'أ' || 'إ' || 'آ' || 'ٱ' => 'ا',
      'ة' => 'ه',
      'ى' => 'ي',
      _ => ch.toLowerCase(),
    };

class NormalizedText {
  const NormalizedText(this.text, this.originalIndex);

  final String text;

  /// `originalIndex[i]` is the index in the source of normalized char `i`.
  final List<int> originalIndex;

  /// Converts a match `[start, end)` in [text] to a range in the source.
  (int, int) toOriginalRange(int start, int end) =>
      (originalIndex[start], originalIndex[end - 1] + 1);
}
