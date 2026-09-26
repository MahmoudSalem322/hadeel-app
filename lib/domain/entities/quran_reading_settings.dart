import 'package:meta/meta.dart';

enum QuranFont { amiri, scheherazade }

/// `verses`: one ayah per block with its own actions.
/// `continuous`: flowing text with inline ayah markers, closer to a mushaf.
enum QuranReadingMode { verses, continuous }

@immutable
class QuranReadingSettings {
  const QuranReadingSettings({
    this.fontSize = 28,
    this.lineHeight = 2.1,
    this.font = QuranFont.amiri,
    this.mode = QuranReadingMode.verses,
    this.showTafsir = false,
  });

  static const double minFontSize = 20;
  static const double maxFontSize = 44;
  static const double minLineHeight = 1.6;
  static const double maxLineHeight = 2.8;

  final double fontSize;
  final double lineHeight;
  final QuranFont font;
  final QuranReadingMode mode;

  /// Show التفسير الميسر under each ayah (ayah-by-ayah mode).
  final bool showTafsir;

  QuranReadingSettings copyWith({
    double? fontSize,
    double? lineHeight,
    QuranFont? font,
    QuranReadingMode? mode,
    bool? showTafsir,
  }) {
    return QuranReadingSettings(
      fontSize: (fontSize ?? this.fontSize).clamp(minFontSize, maxFontSize),
      lineHeight: (lineHeight ?? this.lineHeight).clamp(minLineHeight, maxLineHeight),
      font: font ?? this.font,
      mode: mode ?? this.mode,
      showTafsir: showTafsir ?? this.showTafsir,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is QuranReadingSettings &&
      other.fontSize == fontSize &&
      other.lineHeight == lineHeight &&
      other.font == font &&
      other.mode == mode &&
      other.showTafsir == showTafsir;

  @override
  int get hashCode => Object.hash(fontSize, lineHeight, font, mode, showTafsir);
}
