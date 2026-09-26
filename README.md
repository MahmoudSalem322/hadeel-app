# هديل | Hadeel

رفيقك اليومي للقرآن والذكر — an offline-first, Arabic/RTL-first Islamic companion app built with Flutter.

**Offline by default.** Every core feature runs on-device: prayer times are calculated locally, content ships in `assets/`, and the release Android build declares no `INTERNET` permission.

## Status

| Phase | Scope | State |
|---|---|---|
| 1 | Project setup, architecture | ✅ |
| 2 | Design system, theme (light/dark), icon, splash | ✅ |
| 3 | Onboarding, navigation, Home (live next-prayer countdown) | ✅ |
| 4+ | Quran, Tafsir, Adhkar, Duas, Hadith, Prayer screen, Notifications, Qibla, Tasbeeh, Hijri calendar, Favorites, Search, Settings | Planned |

## Run

```bash
flutter pub get
flutter run                     # device / emulator
flutter run -d web-server --web-port 8080   # quick UI preview in a browser
```

## Test

```bash
flutter analyze
flutter test                    # unit + widget
flutter test integration_test -d <device-id>   # on a device, ideally in Airplane Mode
```

Prayer-time tests compare against `test/fixtures/prayer_reference.json`, an independent reference (Aladhan, Egyptian method) for Jerusalem and Gaza, including the Palestinian DST switch dates.

## Regenerating brand assets

The logo is drawn in code (`lib/shared/widgets/hadeel_logo.dart`). After changing it:

```bash
flutter test tool/generate_brand_assets_test.dart
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Architecture

```
lib/
  core/       theme, routing, localization (ARB), providers, utils, errors
  domain/     entities, repository interfaces, use cases — pure Dart
  data/       preferences store, JSON models, repository implementations
  services/   prayer (adhan), location (geolocator), hijri, timezone
  features/   splash, onboarding, home, prayer, settings, more, design_gallery
  shared/     reusable widgets and extensions
```

- State: Riverpod (no codegen). Routing: go_router with a `StatefulShellRoute` for the five tabs.
- Only `services/prayer/adhan_prayer_calculator.dart` imports `adhan`, so the engine can be swapped.
- All user-facing strings live in `lib/core/localization/arb/`.
- A debug-only **Design Gallery** (More → نظام التصميم) shows every token and component in both themes.

## Data sources

| Data | Source | License |
|---|---|---|
| UI font | IBM Plex Sans Arabic | SIL OFL 1.1 |
| Quran font | Amiri Quran | SIL OFL 1.1 |
| Prayer times | `adhan` package (Batoul Apps algorithm), computed on-device | MIT |
| Hijri dates | `hijri` package (Umm al-Qura tables) | MIT |
| City coordinates | `assets/data/cities_ps.json` | Geographic facts |

Religious texts (Quran, tafsir, adhkar, hadith) are added from verified, attributed sources in their own phases. None of this text is AI-generated.
