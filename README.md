# هديل | Hadeel

رفيقك اليومي للقرآن والذكر — an offline-first, Arabic/RTL-first Islamic companion app built with Flutter.

**Offline by default.** Every feature runs on-device: the Quran, tafsir, adhkar, duas and hadith ship in `assets/`; prayer times and the qibla are calculated locally; notifications are scheduled locally. The release Android build declares **no `INTERNET` permission**.

## Features

| Area | What's included |
|---|---|
| Home | Greeting, Hijri + Gregorian date, next prayer with live countdown (auto-advances), continue reading, today's times, quick access, daily ayah/dhikr/hadith/dua |
| Quran | 114 surahs (Tanzil Uthmani), surah/juz' lists, ayah-by-ayah and continuous reading, bookmarks, favorites, copy/share, reading progress, offline search with highlights, font/size/spacing/mode settings |
| Tafsir | التفسير الميسر per ayah (sheet or inline) |
| Adhkar | حصن المسلم — all 132 chapters; daily categories; counter reader with auto-advance and daily progress |
| Duas | Quranic and prophets' duas (rendered from the mushaf text), plus Hisn categories |
| Hadith | الأربعون النووية and رياض الصالحين with search and chapter filter |
| Prayer | Local calculation (Adhan), 26 Palestinian cities + GPS, 11 methods, Shafi/Hanafi Asr, timeline, per-prayer notifications |
| Qibla | Great-circle bearing and distance, live compass, calibration help |
| Tasbeeh | Big counter, targets 33/99/100/∞, 8 phrases, lifetime totals, vibration/sound |
| Hijri calendar | Month grid with Gregorian dates, moon-sighting adjustment (±2 days) |
| Favorites & search | All saved items by kind; one search box across Quran, adhkar and hadith |
| Settings | Light/dark/system, Arabic/English, Quran, prayer, notifications, tasbeeh, Hijri, About, Sources, Privacy |

## Run

```bash
flutter pub get
flutter run                                   # device / emulator
flutter run -d web-server --web-port 8080     # quick UI preview in a browser
```

### Install on an Android phone

```bash
flutter build apk --release
```

Then copy `build/app/outputs/flutter-apk/app-release.apk` to the phone and open it (allow "install unknown apps" when asked). The release build is currently signed with the debug key — fine for testing, but set up your own signing key before publishing to Google Play.

## Test

```bash
flutter analyze
flutter test                                        # unit + widget (170+ tests)
flutter test integration_test -d <device-id>        # on a device, ideally in Airplane Mode
```

Highlights:
- **Content integrity** — every ayah, tafsir entry, dhikr and hadith is compared with its raw source, character for character; every Quranic dua reference is checked to contain its expected phrase.
- **Prayer times** — compared with an independent reference (Aladhan, Egyptian method) for Jerusalem and Gaza, including the Palestinian DST switch dates. Qibla bearings are compared with the Adhan library.
- **Layout** — every screen is checked at 320 px wide with 200 % text in both themes.

## Data pipeline

Raw sources live in `tool/*/raw/` (committed, byte-for-byte). Generated assets are rebuilt with:

```bash
dart run tool/quran/build_quran_assets.dart
dart run tool/content/build_content_assets.dart
```

Category mapping (which Hisn chapters and Quran references appear in each adhkar/dua category) is in `tool/content/categories.json`.

## Architecture

```
lib/
  core/       theme, routing, localization (ARB), providers, database (drift), utils
  domain/     entities, repository interfaces, use cases — pure Dart, unit-tested
  data/       preferences store, JSON models, repository implementations
  services/   prayer (adhan), location, notifications, compass, hijri, timezone
  features/   home, quran, tafsir, adhkar, duas, hadith, prayer, qibla, tasbeeh,
              hijri_calendar, favorites, search, settings, onboarding, splash, more
  shared/     reusable widgets and extensions
```

- State: Riverpod 3 (no codegen, auto-retry off — local data never fixes itself by retrying). Routing: go_router.
- User data (favorites, bookmarks, reading progress, tasbeeh, adhkar progress) in SQLite via drift; settings in SharedPreferences.
- All user-facing strings live in `lib/core/localization/arb/`.
- A debug-only **Design Gallery** (More → نظام التصميم) shows every token and component in both themes.

## Data sources

| Data | Source | License / terms |
|---|---|---|
| Quran text | [Tanzil](https://tanzil.net) Uthmani + Simple Clean v1.1 | CC BY 3.0, verbatim only |
| Surah/juz' metadata | Tanzil quran-data.xml | CC BY |
| Tafsir | التفسير الميسر — King Fahd Complex, via Tanzil | As published by Tanzil |
| Adhkar & duas | حصن المسلم — [hisnmuslim.com](https://www.hisnmuslim.com) | As published |
| Hadith | an-Nawawi's Forty, Riyad as-Salihin — [Sunnah.com](https://sunnah.com) text via hadith-json | As published |
| Prayer times | `adhan` package, computed on-device | MIT |
| Hijri dates | `hijri` package (Umm al-Qura) | MIT |
| Fonts | IBM Plex Sans Arabic, Amiri Quran, Scheherazade New | SIL OFL 1.1 |

No religious text in this app is AI-generated. Check the terms of each source before any commercial release.
