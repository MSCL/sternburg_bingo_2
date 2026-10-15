# Implementation Plan - Sternburg Bingo Architecture & Core Foundation

Establish a production-ready, clean architecture foundation for the Sternburg Bingo application in
Flutter. This foundation prepares the app for feature development (5x5 game board, crown cap
collection, persistent state) and future backend synchronization.

## Architecture Summary

| Component                      | Selected Technology / Design Pattern                        | Purpose                                                                  |
|:-------------------------------|:------------------------------------------------------------|:-------------------------------------------------------------------------|
| **State Management & DI**      | **Riverpod v2** (`flutter_riverpod` + `riverpod_generator`) | Reactive state management & native compile-time dependency injection     |
| **Data Models & Immutability** | **Freezed** (`@freezed` + `json_serializable`)              | Type-safe immutable data models & automatic JSON mapping                 |
| **Localization**               | **`slang`** (`slang_flutter` + `strings.i18n.json`)         | Nested JSON trees, type-safe `t.bingo.title`, `TranslationProvider`      |
| **Navigation**                 | **AutoRoute** (`auto_route` + `auto_route_generator`)       | Compile-time type-safe routes, deep-linking & `AutoTabsScaffold`         |
| **Local Storage Facade**       | **`LocalStorage` Interface** over `SharedPreferences`       | Decoupled key-value persistence layer (easy to swap for Hive later)      |
| **Logging Facade**             | **`AppLogger` Interface**                                   | `ConsoleAppLogger` (debug) vs `FakeSentryAppLogger` (non-local)          |
| **Audio & Haptics Facades**    | **`AudioService` & `HapticsService` Interfaces**            | Decoupled sound effects and vibration feedback (supports no-op in tests) |
| **Error Catcher & Feedback**   | **`AppErrorBoundary`** + **`UserFeedbackService`**          | Global widget error boundary & context-free toast notifications          |
| **Theming & System UI**        | Material 3 + Sternburg Red (`#E30613`) / Gold (`#FFB800`)   | Light/Dark theme, portrait lock & transparent system overlays            |

---

## User Review Required

> [!NOTE]
> All core infrastructure components (Storage, Logging, Audio, Haptics, Error Catcher, User
Feedback) use abstract interfaces (Facade/Strategy patterns). This ensures that adding Sentry,
switching from SharedPreferences to Hive, swapping sound players, or connecting a backend requires
zero changes to UI or domain code.

---

## Proposed Changes

### Step 0: Workspace Cleanup

Reverts temporary workspace changes (`pubspec.yaml`, `l10n.yaml`, `assets/`) to start from a clean
git state before applying foundation files.

---

### Documentation

#### [NEW] [docs/architecture_plan.md](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/docs/architecture_plan.md)

Persists this complete architecture blueprint & implementation plan into the project repository so
it is tracked in git.

---

### Package Configuration

#### [MODIFY] [pubspec.yaml](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/pubspec.yaml)

Configure core dependencies:

- `flutter_riverpod` & `riverpod_annotation`
- `freezed_annotation` & `json_annotation`
- `slang` & `slang_flutter`
- `auto_route`
- `logger`
- `shared_preferences`
- `flutter_localizations` & `intl`
  Dev dependencies:
- `slang_build_runner`, `riverpod_generator`, `freezed`, `json_serializable`,
  `auto_route_generator`, `build_runner`, `flutter_gen_runner`

#### [NEW] [slang.json](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/slang.json)

Configure `slang` code generator (base locale: `de`, fallback: `en`).

---

### Core Infrastructure Components

#### [NEW] Constants & Domain Errors

* [app_constants.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/constants/app_constants.dart) —
  Bingo grid dimensions (`5x5`), tile count (`25`), cap number limits (`1` to `99`).
* [failures.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/error/failures.dart) —
  Domain `Failure` sealed class hierarchy (`StorageFailure`, `InvalidCapFailure`).

#### [NEW] Local Storage Facade

* [local_storage.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/storage/local_storage.dart) —
  Abstract `LocalStorage` interface.
* [shared_preferences_local_storage.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/storage/shared_preferences_local_storage.dart) —
  Concrete `SharedPreferences` implementation.
* [local_storage_provider.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/storage/provider/local_storage_provider.dart) —
  Riverpod provider supplying `LocalStorage`.

#### [NEW] Logger Facade & Observability

* [app_logger.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/logging/app_logger.dart) —
  Abstract `AppLogger` contract (`debug`, `info`, `warning`, `error`).
* [console_app_logger.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/logging/console_app_logger.dart) —
  Formatted console logger for debug builds.
* [fake_sentry_app_logger.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/logging/fake_sentry_app_logger.dart) —
  Release logger with `// TODO: Sentry` placeholders.
* [app_logger_provider.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/logging/provider/app_logger_provider.dart) —
  Automatically switches logger implementation based on `kDebugMode`.
* [app_riverpod_observer.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/provider/app_riverpod_observer.dart) —
  Riverpod `ProviderObserver` delegating state updates & exceptions to `AppLogger`.

#### [NEW] Audio & Haptics Facades (Feedback Infrastructure)

* [audio_service.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/services/audio_service.dart) —
  Abstract `AudioService` contract (`playCapPopSound`, `playWinFanfare`, `setMuted`) and
  `NoOpAudioService` foundation implementation.
* [haptics_service.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/services/haptics_service.dart) —
  Abstract `HapticsService` contract (`lightImpact`, `mediumImpact`, `successNotification`) and
  `FlutterHapticsService` implementation wrapping Flutter's `HapticFeedback`.

#### [NEW] UI Error Catcher & Feedback

* [app_error_boundary.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/widgets/app_error_boundary.dart) —
  Global widget error catcher rendering a friendly Sternburg error view with a retry action.
* [user_feedback_service.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/services/user_feedback_service.dart) —
  Abstract feedback service (`ScaffoldMessengerUserFeedbackService`) for context-free
  toasts/snackbars.

#### [NEW] Localization Trees (`slang`)

* [strings.i18n.json](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/i18n/strings.i18n.json) —
  German default translation tree.
* [strings_en.i18n.json](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/i18n/strings_en.i18n.json) —
  English fallback translation tree.

#### [NEW] Theme & Styling

* [app_colors.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/theme/app_colors.dart) —
  Sternburg Red (`#E30613`), Amber Gold (`#FFB800`), Cream & Dark Slate.
* [app_theme.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/theme/app_theme.dart) —
  Light & Dark Material 3 `ThemeData` with system UI overlay styling.
* [theme_provider.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/theme/provider/theme_provider.dart) —
  Persisted theme switcher Riverpod Notifier backed by `LocalStorage`.

#### [NEW] Declarative Navigation (`auto_route`)

* [route_names.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/router/route_names.dart) —
  Route path constants.
* [app_router.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/router/app_router.dart) —
  Router setup with `AutoTabsScaffold` for bottom navigation shell.
* [main_navigation_shell.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/core/widgets/main_navigation_shell.dart) —
  Bottom navigation bar UI shell.
* Placeholder screens (`GameBoardScreen`, `CapCollectionScreen`, `SettingsScreen`) annotated with
  `@RoutePage()`.

#### [MODIFY] Entry Point & App Shell

* [main.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/main.dart) —
  Initializes `SharedPreferences`, portrait orientation lock, SystemUIOverlayStyle, and
  `AppErrorBoundary`.
* [app.dart](file:///Users/martinschlegel/Documents/Arbeit/sternburg_bingo_2/lib/app/app.dart) —
  Wraps root with `TranslationProvider`, `ProviderScope` (with `localStorageProvider` override and
  `AppRiverpodObserver`), and `MaterialApp.router`.

---

## Verification Plan

### Automated Tests & Code Generation

1. Execute `flutter pub get`.
2. Run code generation: `dart run build_runner build --delete-conflicting-outputs`.
3. Run static analyzer: `flutter analyze` to verify zero lints or compilation warnings.
4. Run unit tests: `flutter test` for `ThemeProvider` and `SharedPreferencesLocalStorage`.

### Manual Verification

1. **App Launch & Theme**: Launch app and verify light theme (Sternburg Red) and dark theme
   switching.
2. **Language Switcher**: Test switching between German (`de`) and English (`en`).
3. **Bottom Navigation**: Verify tab switching between Game Board, Crown Cap Inventory, and Settings
   via `auto_route`.
4. **Console Logs**: Verify clean formatted console logs via `ConsoleAppLogger` during state
   changes.
5. **UI Error Boundary**: Test widget render error handling with `AppErrorBoundary`.
