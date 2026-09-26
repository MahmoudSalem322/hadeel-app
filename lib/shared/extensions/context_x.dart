import 'package:flutter/material.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/theme/hadeel_colors.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/hijri_date.dart';
import '../../domain/entities/prayer.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  TextTheme get text => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
  HadeelColors get brand => Theme.of(this).extension<HadeelColors>()!;
  String get languageCode => Localizations.localeOf(this).languageCode;
  AppFormatters get formatters => AppFormatters(Localizations.localeOf(this).toLanguageTag());

  /// Space taken by the floating tab bar (plus the system inset) at the
  /// bottom of tab screens. Add it to scroll padding so the last item can
  /// scroll clear of the bar. Zero on screens without the bar.
  double get navBarInset => MediaQuery.paddingOf(this).bottom;
}

extension PrayerL10n on AppLocalizations {
  String prayerLabel(Prayer prayer) => prayerName(prayer.name);

  String hijriLabel(HijriDate date, AppFormatters f) => hijriDate(
        f.number(date.day),
        hijriMonth('m${date.month}'),
        f.number(date.year).replaceAll(RegExp(r'[,٬]'), ''),
      );
}
