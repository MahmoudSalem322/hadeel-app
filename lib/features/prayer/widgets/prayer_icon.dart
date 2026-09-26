import 'package:flutter/material.dart';

import '../../../domain/entities/prayer.dart';

IconData prayerIcon(Prayer prayer) => switch (prayer) {
      Prayer.fajr => Icons.wb_twilight_rounded,
      Prayer.sunrise => Icons.wb_sunny_outlined,
      Prayer.dhuhr => Icons.light_mode_outlined,
      Prayer.asr => Icons.wb_cloudy_outlined,
      Prayer.maghrib => Icons.nights_stay_outlined,
      Prayer.isha => Icons.dark_mode_outlined,
    };
