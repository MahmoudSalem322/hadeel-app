import 'package:meta/meta.dart';

enum RevelationType { meccan, medinan }

/// A position in the mushaf: surah number (1–114) and ayah number (1-based).
@immutable
class AyahRef implements Comparable<AyahRef> {
  const AyahRef(this.surah, this.ayah) : assert(surah >= 1 && surah <= 114), assert(ayah >= 1);

  final int surah;
  final int ayah;

  /// Stable string key, e.g. `2:255` — used for favorites storage.
  String get key => '$surah:$ayah';

  static AyahRef? tryParse(String key) {
    final parts = key.split(':');
    if (parts.length != 2) return null;
    final s = int.tryParse(parts[0]);
    final a = int.tryParse(parts[1]);
    if (s == null || a == null || s < 1 || s > 114 || a < 1) return null;
    return AyahRef(s, a);
  }

  @override
  int compareTo(AyahRef other) =>
      surah != other.surah ? surah.compareTo(other.surah) : ayah.compareTo(other.ayah);

  @override
  bool operator ==(Object other) => other is AyahRef && other.surah == surah && other.ayah == ayah;

  @override
  int get hashCode => Object.hash(surah, ayah);

  @override
  String toString() => key;
}

@immutable
class Surah {
  const Surah({
    required this.number,
    required this.nameAr,
    required this.nameTransliterated,
    required this.nameEn,
    required this.ayahCount,
    required this.startIndex,
    required this.revelationType,
    required this.revelationOrder,
  });

  final int number;
  final String nameAr;
  final String nameTransliterated;
  final String nameEn;
  final int ayahCount;

  /// Zero-based index of this surah's first ayah within the whole mushaf.
  final int startIndex;
  final RevelationType revelationType;
  final int revelationOrder;

  String localizedName(String languageCode) => languageCode == 'ar' ? nameAr : nameTransliterated;

  @override
  bool operator ==(Object other) => other is Surah && other.number == number;

  @override
  int get hashCode => number.hashCode;
}

/// A juz' (1–30) and where it begins.
@immutable
class Juz {
  const Juz(this.number, this.start);

  final int number;
  final AyahRef start;
}

/// Structural metadata for the mushaf (Tanzil `quran-data.xml`).
class QuranMeta {
  QuranMeta({
    required this.surahs,
    required this.juzs,
    required this.quarterStarts,
    required this.sajdas,
  }) : assert(surahs.length == 114);

  final List<Surah> surahs;
  final List<Juz> juzs;

  /// Rub' al-hizb starts (240 quarters).
  final List<AyahRef> quarterStarts;
  final Set<AyahRef> sajdas;

  int get totalAyat => surahs.last.startIndex + surahs.last.ayahCount;

  Surah surah(int number) => surahs[number - 1];

  bool isValid(AyahRef ref) =>
      ref.surah >= 1 && ref.surah <= 114 && ref.ayah <= surah(ref.surah).ayahCount;

  /// Zero-based position of [ref] in the whole mushaf.
  int globalIndex(AyahRef ref) => surah(ref.surah).startIndex + ref.ayah - 1;

  /// The juz' that contains [ref].
  Juz juzOf(AyahRef ref) {
    var result = juzs.first;
    for (final j in juzs) {
      if (j.start.compareTo(ref) <= 0) {
        result = j;
      } else {
        break;
      }
    }
    return result;
  }
}

/// Full Quran text in one script. [suras] is indexed `[surah - 1][ayah - 1]`.
class QuranText {
  QuranText({required this.suras, this.bismillah});

  final List<List<String>> suras;

  /// The Basmala as given by the source, shown above surahs 2–114 except 9.
  final String? bismillah;

  String ayah(AyahRef ref) => suras[ref.surah - 1][ref.ayah - 1];

  List<String> surah(int number) => suras[number - 1];
}

/// Surahs whose opening shows the Basmala as a separate line.
bool showsBasmalaHeader(int surah) => surah != 1 && surah != 9;
