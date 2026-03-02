# Quran Madrasa - Quran Memorization Tracking System

A Flutter application for tracking Quran memorization progress for teachers, students, and parents.

## 📱 Overview

Quran Madrasa is a comprehensive tracking system designed to help:
- **Teachers**: Monitor student memorization progress, assign revision tasks, and track performance
- **Students**: Track their memorization progress and revision schedules
- **Parents**: View their children's progress and receive notifications

## 🏗️ Project Setup

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: 3.8.1 or higher
  - Download: https://flutter.dev/docs/get-started/install
  - Verify: `flutter --version`

- **Dart SDK**: Included with Flutter

- **Development Tools**:
  - **Android Studio**: For Android development
    - Install Android SDK (API 34+)
    - Install Android Emulator (Pixel 7 API 34)
  - **Xcode**: For iOS development (macOS only)
    - Install Xcode 14+ from Mac App Store
    - Install Command Line Tools: `xcode-select --install`

- **Firebase Tools** (optional, for Firebase Console operations):
  - Install: `npm install -g firebase-tools`
  - Login: `firebase login`

- **CocoaPods** (for iOS development on macOS):
  - Install: `sudo gem install cocoapods`
  - Verify: `pod --version`

### Quick Start (5 Steps)

Follow these steps to get the project running on your machine:

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd quran_madrasa
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Open Firebase Console: https://console.firebase.google.com
   - Create a new project: "quran-madrasa"
   - Enable services:
     - Authentication (Email/Password)
     - Firestore Database (Cloud Firestore)
     - Cloud Functions (requires Blaze plan)
     - Cloud Messaging (FCM)
     - Cloud Storage
     - Crashlytics
   - Download `google-services.json` for Android
   - Download `GoogleService-Info.plist` for iOS
   - Place them in the correct directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`
   - Run: `flutterfire configure` (if needed)

4. **Run the App**
   ```bash
   # On macOS
   flutter run -d macos

   # On Android (requires emulator)
   flutter emulators --launch Pixel_7_API_34
   flutter run

   # On iOS (requires simulator, macOS only)
   flutter run -d "iPhone 15 Pro"
   ```

5. **Run Tests**
   ```bash
   flutter test
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── models/              # Data models (to be added in Phase 1)
│   ├── providers/           # Riverpod state management providers
│   │   └── example_provider.dart  # Example provider for Phase 0
│   ├── services/            # External service integrations
│   ├── utils/               # Utility functions
│   │   ├── date_utils.dart    # Date formatting and parsing
│   │   ├── phone_utils.dart    # Phone number normalization
│   │   └── quran_utils.dart    # Quran metadata and calculations
│   └── widgets/             # Reusable widgets
├── features/                # Feature modules
│   ├── auth/                # Authentication module
│   ├── teacher_home/        # Teacher dashboard
│   ├── student_details/     # Student details view
│   ├── parent_portal/       # Parent dashboard
│   ├── admin/               # Admin panel
│   └── notifications/       # Push notifications
├── main.dart                # App entry point
└── firebase_options.dart    # Firebase configuration
```

## 🎯 Development Workflow

### Running the App

```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d <device-id>

# Run with hot reload
flutter run

# Build for release
flutter build apk --release    # Android APK
flutter build ios --release    # iOS IPA
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/core/utils/date_utils_test.dart

# Run tests in verbose mode
flutter test --reporter expanded
```

### Code Generation

```bash
# Run code generation for code-generated providers/models
flutter pub run build_runner build --delete-conflicting-outputs

# Clean generated files
flutter pub run build_runner clean

# Watch for changes and regenerate
flutter pub run build_runner watch
```

### Code Analysis

```bash
# Check for code issues
flutter analyze

# Fix auto-fixable issues
flutter analyze --fix
```

## 🔧 Configuration Files

### pubspec.yaml

Contains all Flutter dependencies and project configuration.

**Key Dependencies:**
- **Firebase**: `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_messaging`, `firebase_storage`, `firebase_crashlytics`
- **State Management**: `flutter_riverpod`, `riverpod_annotation`
- **Routing**: `go_router`
- **Utilities**: `intl`, `freezed`, `json_annotation`, `url_launcher`

### Firebase Configuration

- **File**: `lib/firebase_options.dart` (auto-generated)
- **Android**: `android/app/google-services.json`
- **iOS**: `ios/Runner/GoogleService-Info.plist`

**Firestore Rules** (created in Phase 0, updated in later phases):
- Public read/write access during development (to be secured in Phase 8)
- All collections follow naming conventions (see spec.md)

## 📊 Current Status

### Phase 0: Project Setup & Architecture - ✅ COMPLETE

- ✅ Flutter project with feature-based architecture
- ✅ Firebase services configured (Auth, Firestore, FCM, Storage, Crashlytics)
- ✅ Riverpod state management scaffolded
- ✅ Quran metadata embedded (114 surahs)
- ✅ Core utilities (date, phone, Quran) with 100% test coverage
- ✅ Offline persistence enabled
- ✅ 56 unit tests passing
- ✅ Builds verified on iOS and Android

### Next Phase

**Phase 1: Data Model Extensions** (upcoming)
- Add `dayKey`, `updatedAt`, `updatedBy` fields to evaluations collection
- Standardize memorization/revision field structures
- Create Freezed models for Evaluation, Student, Class, User

## 🐛 Troubleshooting

### Common Issues

**1. Firebase Options Not Found**
```
Error: DefaultFirebaseOptions.currentPlatform not found
```
**Solution:** Run `flutterfire configure` to generate Firebase options file.

**2. CocoaPods Not Found (macOS/iOS)**
```
Error: CocoaPods not installed. Skipping pod install.
```
**Solution:** Install CocoaPods: `sudo gem install cocoapods`

**3. Pod Install Failures**
```
Error: Could not find an appropriate version of pod...
```
**Solution:** Run `cd ios && pod install && cd ..`

**4. Android Build Issues**
```
Error: Gradle build failed
```
**Solution:**
- Clear Gradle cache: `flutter clean`
- Update dependencies: `flutter pub get`
- Rebuild: `flutter run`

**5. iOS Build Issues (Code Signing)**
```
Error: No valid code signing certificates were found
```
**Solution:**
- Open Xcode: `open ios/Runner.xcworkspace`
- Select "Runner" target
- Under "Signing & Capabilities", select a Development Team
- Or run on simulator: `flutter devices` to list available simulators

**6. Build Runner Issues**
```
Error: Failed to compile build script
```
**Solution:**
```bash
# Update analyzer to compatible version
flutter pub add "analyzer: ^7.6.0" --dev --override
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**7. Test Failures**
```
Error: Some tests failed
```
**Solution:** Check specific error output and fix the failing test.

## 📚 External Documentation

- **Flutter Documentation**: https://flutter.dev/docs
- **Firebase Documentation**: https://firebase.google.com/docs/flutter/setup
- **Riverpod Documentation**: https://riverpod.dev
- **go_router Documentation**: https://pub.dev/packages/go_router
- **Freezed Documentation**: https://pub.dev/packages/freezed

## 📝 Documentation

- **Architecture Decisions**: See `docs/ARCHITECTURE.md`
- **Implementation Plan**: See `.specify/specs/2-project-setup/plan.md`
- **Specification**: See `.specify/specs/2-project-setup/spec.md`
- **Task Breakdown**: See `.specify/specs/2-project-setup/tasks.md`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is proprietary software. All rights reserved.

## 👥 Support

For questions or issues, please contact the development team.

---

**Last Updated**: 2026-03-02
**Version**: 1.0.0+1
**Phase**: Phase 0 Complete - Ready for Phase 1
