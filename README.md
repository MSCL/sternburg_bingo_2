# Sternburg Bingo 2

An enterprise-grade Flutter demonstration application built to showcase modern architecture,
production-grade software design, clean code principles, and testability for a **Senior Flutter
Developer** technical interview showcase.

The application brings the famous **Sternburg Bingo** game to life on mobile devices with a full
suite of cross-platform features.

---

## 🤖 Development Philosophy & AI "Vibe Coding" Workflow

This project represents my first application developed using a heavy **AI-assisted "Vibe Coding"
approach**, pairing with **Gemini 3.6 Flash**, **Gemini 3.6 Flash Lite**, and **Gemini 3.1 Pro** for
architectural reviews, code generation, and iterative refactoring.

### 📋 Architectural Strategy & Execution Plan:

1. **Initial Planning & Architectural Discussion**:
   Before writing code, the general structure, architecture, and design patterns were thoroughly
   discussed to establish a clear implementation plan.

2. **Scaffold & Production Infrastructure First**:
   Before implementing the core Bingo gameplay, the initial priority was building a robust
   **production-ready scaffold** containing infrastructure features commonly required by Product
   Management (PM) teams in real-world enterprise apps:
   - Structured navigation with deep-linking capability (`AutoRoute`)
   - Compile-time obfuscated environment variable configuration (`Envied`)
   - Push Notifications permission & status handling (`Firebase Messaging`)
   - Dynamic Light / Dark theme switching
   - Legal / About dialog & native OS settings integration (`AppSettings`)
   - Type-safe internationalization (`Slang`)
   - Remote crash & error logging facade (`SentryLogger` - architecture-ready, currently not
     configured with a live DSN)
   - Privacy-compliant analytics with consent toggles (`Firebase Analytics`)
   - Remote feature flags (`Firebase Remote Config`)
   - Fully testable setup via compile-time & runtime Dependency Injection (`Riverpod` overrides &
     test doubles)

   While some of these infrastructure capabilities might seem overly comprehensive for a simple
   Bingo application, establishing this foundation upfront ensures seamless future expansion and
   mimics real-world enterprise product development.

3. **Strict Code Quality & Extensive Linting**:
   The project enforces high code quality through extensive static analysis configuration
   (`analysis_options.yaml`) featuring over 180+ custom linter rules, strict analyzer flags
   (`strict-casts`, `strict-inference`, `strict-raw-types`), custom lint plugins (`riverpod_lint`,
   `freezed_lint`), and architectural coding rules (`AGENTS.md`) prioritizing Dart 3 modifier
   strictness, tear-offs, and immutability.

4. **Domain Feature Implementation & Roadmap**:
   Once the foundation was solid, development shifted to the core **Sternburg Bingo** gameplay
   engine. Key architectural items (such as remote networking data sources and structured error
   handling) are defined in the roadmap for future backend connection.

---

## 📂 Project Architecture & Directory Structure

This project is structured around Clean Architecture principles, leveraging compile-time type
safety, declarative state management, feature-first folder organization, and strict separation of
concerns. Backend infrastructure and services are managed via
the [Firebase Console](https://console.firebase.google.com/project/sternburg-bingo-893e4/overview).

```text
lib/
├── app.dart                    # Root MaterialApp setup (Theme, Router, i18n, Observers)
├── main.dart                   # Entry point initializing AppDependencies & ProviderScope
├── firebase_options.dart       # Firebase platform configuration
├── core/                       # Shared infrastructure & core services
│   ├── analytics/              # AnalyticsService interface & FirebaseAnalytics implementation
│   ├── env/                    # Environment configuration via Envied
│   ├── feature_flags/          # FeatureFlagService & Firebase Remote Config
│   ├── i18n/                   # Type-safe translations via Slang (strings_de.g.json, strings_en.g.json)
│   ├── info/                   # AppInfo & Package metadata
│   ├── init/                   # AppInitializer static facade & AppDependencies DI container
│   ├── lifecycle/              # AppLifecycleObserver for foreground/background tracking
│   ├── logging/                # Logger abstract interface, ConsoleLogger & SentryLogger
│   ├── notifications/          # PushNotificationService & Firebase Messaging
│   ├── provider/               # RiverpodObserver & global provider utilities
│   ├── router/                 # AutoRoute setup, NavigationObserver & Route definitions
│   ├── settings/               # AppSettingsService & OS native settings launcher
│   ├── splash/                 # SplashService managing flutter_native_splash
│   ├── storage/                # LocalStorage abstraction & SharedPreferences implementation
│   ├── theme/                  # Material 3 Light/Dark theme configuration & ThemeModeProvider
│   └── widgets/                # Reusable design system widgets (AppScaffold, AppTile, etc.)
└── features/                   # Feature-first domain modules
    ├── bingo/                  # Main Bingo game domain, data & presentation layers
    ├── dashboard/              # AutoTabsScaffold tab container screen
    └── settings/               # User settings, preferences & about dialog view
```

---

## 🏗️ Tech Stack & Architecture Overview

### 🌟 Core Stack & Package Breakdown

| Package Category              | Packages                                                                                        | Description & Technical Rationale                                                                                                                                                                     |
|:------------------------------|:------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **State Management & DI**     | `flutter_riverpod`<br>`riverpod_annotation`<br>`riverpod_generator`                             | **Riverpod 3**: Declarative, compile-time safe state management and dependency injection. Enables test overrides (`ProviderScope` overrides) without requiring `BuildContext`.                        |
| **Navigation & Deep Linking** | `auto_route`<br>`auto_route_generator`                                                          | **AutoRoute**: Strongly-typed router handling tab navigation, nested sub-routes, custom dialog routes (`DialogRoute`), and URI deep link resolution (e.g. `sternbingo:///settings`).                  |
| **Code Generation & Models**  | `freezed`<br>`freezed_annotation`<br>`json_annotation`<br>`json_serializable`<br>`build_runner` | **Freezed & JSON Serializable**: Immutable domain state objects, algebraic data types, copy-with operations, and type-safe JSON serialization.                                                        |
| **Environment & Secrets**     | `envied`<br>`envied_generator`                                                                  | **Envied**: Compile-time obfuscated environment key generation, ensuring secrets are not hardcoded and enabling flexible configuration across dev, staging, and prod builds.                          |
| **Localization (i18n)**       | `slang`<br>`slang_flutter`<br>`slang_build_runner`<br>`flutter_localizations`                   | **Slang**: Type-safe, zero-context translation generator supporting German (`de`) and English (`en`), integrating directly with native OS language settings.                                          |
| **Firebase Services**         | `firebase_core`<br>`firebase_analytics`<br>`firebase_remote_config`<br>`firebase_messaging`     | **Firebase Integration**: Remote feature flags with offline fallbacks, analytics event tracking with privacy consent toggles, and push notification permission management.                            |
| **UI Design System**          | `material_ui`<br>`flutter_native_splash`<br>`flutter_launcher_icons`                            | Custom design system tokens (`app_theme.dart`), native launch splash screen preservation during async startup, and customized launcher icons.                                                         |
| **Utilities & Storage**       | `shared_preferences`<br>`app_settings`                                                          | **Local Storage & Native Utilities**: `shared_preferences` for key-value persistence; `app_settings` for directly launching native OS settings screens (e.g., Notification settings).                 |
| **Code Quality & Linting**    | `analysis_options.yaml`<br>`riverpod_lint`<br>`freezed_lint`                                    | **Strict Static Analysis**: 180+ custom linter rules, strict analyzer flags (`strict-casts`, `strict-inference`, `strict-raw-types`), and specialized lint plugins (`riverpod_lint`, `freezed_lint`). |

---

## 🎯 Implemented Showcase Features

### 1. 🎲 Bingo Game Core Engine (`/features/bingo`)

- **Card Selection**: Support for multiple official Sternburg card layouts
  (`BingoCard.officialCards`).
- **Interactive Grid**: Interactive 5x5 grid tracking drawn numbers and collected fields.
- **Winning Logic**: Mathematical evaluation for completed rows, columns, and diagonals
  (`BingoWinningCombo`).
- **In-Tab Dialog Route**: Triggers a custom `BingoWinDialogRoute` modal inside the active tab
  navigator without blowing away tab history.

### 2. 🔗 Custom Deep Linking

- Configured custom scheme: `sternbingo://`
- Direct deep link mapping via AutoRoute to specific tabs (e.g. `sternbingo:///settings`).
- **Showcase Trigger Command** via `adb` (terminal showcase):
  ```bash
  # Deep link directly to Settings Screen
  ~/Library/Android/sdk/platform-tools/adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "sternbingo:///settings"
  ```

### 3. 🔐 Compile-Time Obfuscated Config (`Envied`)

- Secrets and keys generated via `Envied` with compile-time obfuscation
  (`@Envied(obfuscate: true)`).
- Establishes a clean architecture for managing dev, staging, and production environments without
  exposing sensitive credentials in repository code.

### 4. 🌓 Light / Dark / System Theme Switching

- Dynamic theme mode management via `ThemeModeProvider`.
- Full Material 3 dark and light theme specifications (`appLightTheme` & `appDarkTheme`).
- Theme preference persisted locally in `SharedPreferences`.

### 5. 🌍 OS-Linked Dual-Language Localization (i18n)

- Full translation setup via **Slang** supporting German (`de`, default) and English (`en`).
- Direct integration with OS language settings using `AppSettingsService`.

### 6. 🪵 Modular Logging Architecture (Local vs. Sentry)

- Abstract `Logger` interface isolating log outputs.
- **`ConsoleLogger`**: Active in `kDebugMode` for clean developer console output.
- **`SentryLogger`**: Architecture-ready production logger facade for error reporting, breadcrumb
  tracking, and stack trace capturing *(Note: 3rd party logging/monitoring services are prepared at
  the architecture level, but live production DSN endpoints are currently not configured)*.

### 7. 🚀 Native Splash Screen & App Icon

- Managed by `SplashService` using `flutter_native_splash`.
- Splash screen preserved during async initialization (`AppInitializer.initialize()`) and smoothly
  dismissed post-frame.
- Custom app icon generated across Android and iOS platforms via `flutter_launcher_icons`.

### 8. 📊 Privacy-Compliant Analytics

- `AnalyticsService` abstract interface backed by `FirebaseAnalyticsService`.
- Automatic screen tracking via `NavigationObserver`.
- Opt-in / opt-out user consent toggle in Settings for GDPR compliance.

### 9. 🚩 Remote Feature Flags

- `FeatureFlagService` using **Firebase Remote Config**.
- Configured with non-blocking background fetching and instant local offline default fallback
  values.

### 10. 🧪 Testable Setup & Dependency Injection (DI)

- Centralized asynchronous startup in `AppInitializer`.
- Abstract contracts for all infrastructure services (`Logger`, `AnalyticsService`,
  `FeatureFlagService`, `PushNotificationService`, `LocalStorage`, `AppSettingsService`,
  `AudioService`,
  `HapticService`, `ConfettiService`).
- Complete suite of in-memory test doubles (`FakeLogger`, `FakeAnalyticsService`,
  `FakeLocalStorage`, `FakeAudioService`, `FakeHapticService`, `FakeConfettiService`, etc.) enabling
  robust unit testing without network/Firebase dependencies.
- **Unit Test Suite**: Fast unit tests covering domain models, Riverpod state notifiers, JSON
  serialization, and service contracts.

### 11. 🔔 Push Notifications Integration

- `PushNotificationService` managing notification permission flow and status checks.
- Direct navigation trigger to OS Notification settings via `AppSettingsService` if permissions are
  disabled.

### 12. 📱 Bottom Tab Navigation & Settings

- Persistent `AutoTabsScaffold` managing seamless navigation between the **Bingo** game and
  **Settings**.
- Settings screen featuring theme selection, OS language link, notification permissions, analytics
  toggle, and interactive About dialog.

### 13. 🔊 Audio, Haptic & Confetti Victory Effects

- **`AudioService`**: Abstract contract backed by `AudioplayersAudioService` playing victory sound
  effects (`assets/audio/bingo_win.wav`).
- **`HapticService`**: Abstract contract backed by `SystemHapticService` triggering native OS haptic
  feedback (`HapticFeedback.heavyImpact()`).
- **`Confetti`**: Festive confetti particle explosion rendered on screen via `flutter_confetti` when
  the victory dialog appears.

---

## 🚀 Getting Started & How to Run

### Prerequisites

- Flutter SDK `^3.47.0`
- Dart SDK `^3.13.5`

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run Code Generation

To generate code across the project (including `slang` translations, `auto_route` routes, `freezed`
immutable state models, `riverpod_generator` providers, `json_serializable` objects, `envied`
obfuscated environment variables, etc.):

```bash
dart run build_runner build
```

> 💡 **Tip**: For additional helper scripts and development tasks (running tests, cleaning build
> runner artifacts, updating splash screens, configuring Firebase, or updating launcher icons),
> check [`scripts.txt`](./scripts.txt).

---

## 🔮 Open TODOs & Future Roadmap

The following items are planned for future development iterations:

- [ ] **Import Numbers via Camera**: Use camera OCR / ML Kit to automatically scan and import drawn
  bingo numbers (see [Camera Feature Blueprint](docs/camera_feature_blueprint.md)).
- [ ] **User Profile & Authentication**: Implement user accounts (e.g. via Firebase Auth) to unlock
  social features (see [Backend & Cloud Sync Blueprint](docs/backend_connection_blueprint.md)):
    - **Connect with Friends**: Pair with friends to collaborate on bingo progress.
    - **Cliques & Groups**: Form teams or groups to collect bingo fields together.
- [x] **Audio & Haptic Feedback**: Add celebratory sound effects (`audioplayers`), vibration
  feedback (`HapticFeedback`), and confetti (`flutter_confetti`) upon achieving a Bingo victory.
- [ ] **Widget & Golden / Snapshot Testing**: Add widget tests and golden / snapshot test suites for
  UI design system components and screen layouts.
- [ ] **Integration Testing**: Add end-to-end integration tests (`integration_test`) covering
  primary app workflows (e.g. game completion flow, deep linking, and settings interactions).
- [ ] **Network UI & Error Handling**: Implement structured UI states (Loading / Error / Empty /
  Success) with retry mechanisms when connecting to a remote backend.
- [ ] **Advanced Asset & Media Caching**: Implement an advanced asset caching and preloading facade
  for audio, fonts, and remote images using `cached_network_image` with WebP support.
- [ ] **Production Telemetry & 3rd Party Service Logs**: Configure live production DSNs and remote
  logging endpoints for third-party monitoring services (`SentryLogger` error reporting facade is
  architecture-ready but not yet configured with live DSN credentials).
- [ ] **Remote Data Source Integration**: Add a `RemoteDataSource` layer alongside the existing
  `BingoRepository` and `BingoLocalDataSource`.
- [ ] **Repository & Data Source Base Classes**: Define abstract base classes for repositories and
  data sources to standardize CRUD operations across future feature modules.
- [ ] **Accessibility (a11y) Enhancements**: Conduct accessibility audits, add comprehensive
  semantic labels (`Semantics`), optimize focus traversal, and test screen reader (TalkBack /
  VoiceOver) behavior.
- [ ] **Standardized DateTime Formatting**: Create a centralized DateTime formatting facade handling
  timezone conversions, ISO-8601 parsing, and localized formatting.
- [ ] **Custom Bingo Card Creator**: Allow users to design, edit, and persist custom 5x5 bingo cards
  with custom terms or numbers.
- [ ] **Backend Connection**: Connect to Cloud Firestore & Firebase Auth for multi-device game sync
  and cooperative cliques
  (see [Backend & Cloud Sync Blueprint](docs/backend_connection_blueprint.md)).

---

## 🧪 Firebase Analytics Debugging

For verbose logging and event debugging during development, see the official Firebase Analytics
documentation
for [Android](https://firebase.google.com/docs/analytics/android/events#view-events-in-debug-log)
and [iOS](https://firebase.google.com/docs/analytics/ios/events#view-events-in-xcode-debug-console),
as well as the guide on
enabling [DebugView](https://firebase.google.com/docs/analytics/debugview#enable-debug-mode).
