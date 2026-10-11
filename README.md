# هديل | Hadeel

رفيقك اليومي للقرآن والذكر — an offline-first, Arabic/RTL-first Islamic companion app built with Flutter.

**Offline by default.** Every feature runs on-device: the Quran, tafsir, adhkar, duas and hadith ship in `assets/`; prayer times and the qibla are calculated locally; notifications are scheduled locally. The release Android build declares **no `INTERNET` permission**.

## Features

### Update 0.3.1

Quran bookmarks now have their own **العلامات / Bookmarks** tab, separate from favorites. Each saved ayah shows the local date and time when the bookmark was created and opens directly in the reader. The launcher and in-app identity now use the simpler crescent-and-ripple artwork in `assets/branding/icon_v4.png`.

### Update 0.3.0

The visual refresh combines solid reading cards with glass navigation and sheets, a teal/blue/violet prayer hero, and individually colored quick actions. Light and dark palettes use cool backgrounds and lavender controls. The app, launcher, splash, and web surfaces share one current brand asset; `tool/generate_brand_assets_test.dart` renders the platform-safe variants.

Performance safeguards remain: ordinary cards have no backdrop sampling, and inactive navigation branches neither paint nor tick. Targeted layout tests cover Arabic at 200% text scaling on 320px and 390px phones in both themes, alongside the existing blur-budget, navigation and reminder tests. Physical-device frame-rate measurements are still needed for device-specific performance claims.

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

### Update 0.2.0

Performance follow-up **0.2.1**: scrolling cards and icon lenses retain their
translucent gradients and reflective edges without independent live backdrop
filters. Live blur is limited to the navigation bar and modal sheet. Tabs keep
their state while only the selected branch paints and ticks; whole-page fades
and slides are removed. Regression tests measured 13 → 1 backdrop layers for
the same grid and verified that the outgoing tab no longer paints on a switch.
This verifies rendering work, not frame rate on a physical phone.

- A shared liquid-glass visual system: luminous backdrop, frosted cards and search,
  reflective rounded edges, floating navigation, glass headers, reader surfaces,
  tasbeeh counter and modal sheets, in light and dark modes.
- Dhikr and salawat at every hour from **07:00 through midnight** (18 daily repeating
  reminders), using the device timezone even before a prayer city is selected.
- Three daily reminders selected from bundled, complete Arabic dhikr and hadith,
  with different choices on successive dates and times away from the hourly reminders.
- Settings → Notifications → **Allow Hadeel notifications** requests OS permission
  and precise alarms. Hourly and daily content have separate persistent switches.
- Hourly and morning/evening reminders repeat daily. Variable content is scheduled
  30 days ahead on Android and five days on iOS; opening/resuming the app refreshes
  the window. An open app also refreshes after midnight. Prayer reminders retain
  their five-day window. This is local scheduling, so open the app periodically
  to replenish changing content; it does not use a server or a background worker.
- The iOS plan contains at most 60 pending entries, within the plugin's documented
  [64-entry limit](https://pub.dev/packages/flutter_local_notifications#ios-pending-notifications-limit).
  Exact delivery requires OS permission; without it Android uses inexact scheduling.

Validation: `flutter analyze` reported no issues; the focused reminder, persistence,
service and content tests passed (33 tests). Browser previews were checked at
320 and 390 pixels, in both themes, including Quran navigation and modal sheets.
The full native suite could not finish on this Windows host because Application
Control blocked `sqlite3.dll` (4551), affecting the database tests and preventing
the app widget tests from progressing. Device delivery of notifications still
needs a real Android/iOS device test.

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
