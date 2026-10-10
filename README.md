# Base Flutter Project

A scalable Flutter starter application that demonstrates a layered architecture,
dependency injection, BLoC state management, and REST API integration. The sample
feature retrieves the current weather for Jakarta from OpenWeather.

## Highlights

- Feature-first project organization
- Data, domain, and presentation layers
- BLoC for predictable state management
- Flutter Modular for routing and dependency injection
- Dio client with an authentication interceptor
- Development, UAT, and production entry points
- Compile-time configuration without committing API keys
- Shared preferences and secure-storage foundations

## Tech stack

- Flutter and Dart
- Flutter BLoC
- Flutter Modular
- Dio
- Equatable
- Connectivity Plus
- Flutter Secure Storage
- Shared Preferences
- ScreenUtil and Google Fonts

## Project structure

```text
lib/
├── app/
│   ├── launcher/                 # Environment-specific entry points
│   ├── app_module.dart           # Global dependency injection and routes
│   └── app_widget.dart           # Root application widget
├── features/
│   └── home/
│       ├── data/                 # Data sources, models, repositories
│       ├── domain/               # Entities, contracts, use cases
│       └── presentation/         # BLoC and UI
└── libraries/
    ├── core/                     # Configuration, networking, storage
    └── dependencies/             # Shared dependency registration
```

## Prerequisites

- Flutter SDK compatible with Dart `^3.9.2`
- Android Studio or another Flutter-compatible IDE
- An OpenWeather API key

## Getting started

1. Clone the repository and enter the project directory.

   ```bash
   git clone https://github.com/Dwibonggo25/base_flutter_project.git
   cd base_flutter_project
   ```

2. Install dependencies.

   ```bash
   flutter pub get
   ```

3. Create the local development configuration.

   ```bash
   cp config/example.json config/dev.json
   ```

4. Replace `YOUR_OPENWEATHER_API_KEY` in `config/dev.json` with your own key.

5. Run the development entry point.

   ```bash
   flutter run \
     -t lib/app/launcher/main_dev.dart \
     --dart-define-from-file=config/dev.json
   ```

## Android Studio configuration

Open **Run > Edit Configurations** and add the following to **Additional run
args** for the development configuration:

```text
--dart-define-from-file=config/dev.json
```

Set the Dart entry point to:

```text
lib/app/launcher/main_dev.dart
```

## Configuration and secrets

`config/dev.json` is excluded from version control. Only
`config/example.json`, which contains a placeholder value, is committed.

Values supplied with `--dart-define` are embedded in the compiled application.
For production credentials that must remain secret, use a backend service rather
than distributing the credential in a mobile application.

## Quality checks

Run static analysis before committing changes:

```bash
flutter analyze
```

Run automated tests when tests are available:

```bash
flutter test
```

## Roadmap

- Add unit and widget tests
- Improve API error mapping and user-facing error states
- Complete secure token storage and refresh-token handling
- Add screenshots and an application demo
