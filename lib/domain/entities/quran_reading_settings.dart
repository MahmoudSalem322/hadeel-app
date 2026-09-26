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
  });

  static const double minFontSize = 20;
  static const double maxFontSize = 44;
  static const double minLineHeight = 1.6;
  static const double maxLineHeight = 2.8;

  final double fontSize;
  final double lineHeight;
  final QuranFont font;
  final QuranReadingMode mode;

  QuranReadingSettings copyWith({
    double? fontSize,
    double? lineHeight,
    QuranFont? font,
    QuranReadingMode? mode,
  }) {
    return QuranReadingSettings(
      fontSize: (fontSize ?? this.fontSize).clamp(minFontSize, maxFontSize),
      lineHeight: (lineHeight ?? this.lineHeight).clamp(minLineHeight, maxLineHeight),
      font: font ?? this.font,
      mode: mode ?? this.mode,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is QuranReadingSettings &&
      other.fontSize == fontSize &&
      other.lineHeight == lineHeight &&
      other.font == font &&
      other.mode == mode;

  @override
  int get hashCode => Object.hash(fontSize, lineHeight, font, mode);
}
