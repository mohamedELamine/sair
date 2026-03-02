# Phase 0 Quick Start Guide

**Feature:** Project Setup & Architecture
**Audience:** New developers joining the project
**Prerequisites:** See Section 1 below
**Estimated Setup Time:** 30 minutes (excluding tool installation)

---

## 1. Prerequisites

Before starting, ensure you have these tools installed:

### Required Tools

| Tool | Version | Installation | Verification |
|------|---------|--------------|--------------|
| **Flutter SDK** | 3.0+ (stable) | https://docs.flutter.dev/get-started/install | `flutter --version` |
| **Dart SDK** | Bundled with Flutter | Included with Flutter | `dart --version` |
| **Git** | Latest | https://git-scm.com/downloads | `git --version` |
| **VS Code** or **Android Studio** | Latest | https://code.visualstudio.com/ | — |

### Platform-Specific Tools

**For iOS builds (macOS only):**
| Tool | Version | Installation | Verification |
|------|---------|--------------|--------------|
| **Xcode** | 14+ | Mac App Store | `xcodebuild -version` |
| **CocoaPods** | Latest | `sudo gem install cocoapods` | `pod --version` |

**For Android builds:**
| Tool | Version | Installation | Verification |
|------|---------|--------------|--------------|
| **Android Studio** | Latest | https://developer.android.com/studio | Check IDE version |
| **Android SDK** | API 21+ | Android Studio SDK Manager | Check in Android Studio |
| **Java JDK** | 11+ | Bundled with Android Studio or https://adoptium.net/ | `java --version` |

### Firebase Tools

| Tool | Version | Installation | Verification |
|------|---------|--------------|--------------|
| **Firebase CLI** | Latest | `npm install -g firebase-tools` | `firebase --version` |
| **FlutterFire CLI** | Latest | `dart pub global activate flutterfire_cli` | `flutterfire --version` |
| **Node.js** | 18+ | https://nodejs.org/ | `node --version` |

---

## 2. Clone Repository

```bash
# Clone the repository
git clone <repository-url> quran-madrasa
cd quran-madrasa

# Checkout the project setup branch
git checkout 2-project-setup

# Verify you're on the correct branch
git branch
# Should show: * 2-project-setup
```

---

## 3. Install Flutter Dependencies

```bash
# Get all Flutter packages
flutter pub get

# Verify no dependency conflicts
# Expected output: "Got dependencies!"
```

**Common Issues:**

- **Issue:** `pubspec.lock` version mismatch
  - **Fix:** Delete `pubspec.lock`, run `flutter clean`, then `flutter pub get`

- **Issue:** "version solving failed" error
  - **Fix:** Check Flutter SDK version (`flutter --version`), upgrade if needed

---

## 4. Configure Firebase

### 4.1 Login to Firebase

```bash
# Authenticate with Firebase
firebase login

# Verify login
firebase projects:list
# Should show your Firebase projects
```

### 4.2 Run FlutterFire Configuration

```bash
# Configure Firebase for Flutter
flutterfire configure

# Select options:
# 1. Select existing Firebase project: "quran-madrasa" (or create new if first time)
# 2. Select platforms: iOS, Android, macOS (optional), Web (optional)
# 3. iOS Bundle ID: com.madrasa.quran (or your chosen ID)
# 4. Android Package Name: com.madrasa.quran (or your chosen package)
```

**Expected Output:**
```
✔ Firebase configuration file lib/firebase_options.dart generated successfully
```

### 4.3 Download Platform-Specific Config Files

**For Android:**
```bash
# File should already be downloaded: android/app/google-services.json
# Verify it exists:
ls -la android/app/google-services.json
```

**For iOS:**
```bash
# File should already be downloaded: ios/Runner/GoogleService-Info.plist
# Verify it exists:
ls -la ios/Runner/GoogleService-Info.plist

# Install iOS pods
cd ios
pod install
cd ..
```

---

## 5. Verify Quran Metadata Asset

```bash
# Verify the Quran metadata file exists
ls -la assets/quran_metadata.json

# Check file is registered in pubspec.yaml
grep -A 2 "flutter:" pubspec.yaml | grep "assets"
# Should show: - assets/quran_metadata.json
```

**If missing:**
1. Download from: https://api.alquran.cloud/v1/meta
2. Format as JSON array (see spec Section 5)
3. Place in `assets/quran_metadata.json`
4. Register in `pubspec.yaml` under `flutter.assets`

---

## 6. Run Code Generation

```bash
# Generate Riverpod and Freezed code
flutter pub run build_runner build --delete-conflicting-outputs

# Expected output: "Build completed successfully"
```

**Common Issues:**

- **Issue:** "Conflicting outputs" error
  - **Fix:** Use `--delete-conflicting-outputs` flag (already included above)

- **Issue:** Code generation hangs
  - **Fix:** Kill process (Ctrl+C), run `flutter clean`, retry

---

## 7. Run Tests

```bash
# Run all unit tests
flutter test

# Expected output: All tests pass (0 failures)
```

**Test Coverage (Phase 0):**
- `date_utils_test.dart` — 8 test cases
- `phone_utils_test.dart` — 5 test cases
- `quran_utils_test.dart` — 9 test cases

**Total:** 22 unit tests (should all pass)

---

## 8. Run the App

### 8.1 iOS (macOS only)

```bash
# List available iOS simulators
flutter devices

# Run on iOS simulator
flutter run -d "iPhone 15 Pro"  # or your preferred simulator

# Expected: App launches showing "Project Setup Complete" screen
```

### 8.2 Android

```bash
# List available Android devices/emulators
flutter devices

# Start Android emulator (if not running)
flutter emulators --launch Pixel_7_API_34  # or your emulator name

# Run on Android emulator
flutter run -d emulator-5554  # or your device ID

# Expected: App launches showing "Project Setup Complete" screen
```

### 8.3 Verify App Behavior

**✅ Success Criteria:**
- App launches without errors
- Screen shows "Project Setup Complete" text
- Console shows: "Firebase initialized successfully"
- Console shows: "Quran metadata loaded: 114 surahs"
- No red error messages in console

---

## 9. Verify Firebase Connection

### 9.1 Check Firebase Console

1. Open https://console.firebase.google.com
2. Select your project ("quran-madrasa")
3. Navigate to **Firestore Database** → Data tab
4. Verify "Connected" status indicator (green dot)

### 9.2 Test Offline Persistence

```bash
# 1. Run app with network enabled
flutter run

# 2. Enable airplane mode on device/simulator
# (iOS: swipe down Control Center, tap airplane icon)
# (Android: swipe down, tap airplane mode)

# 3. Close and reopen app
# Expected: App still launches without errors (cached data)

# 4. Disable airplane mode
```

---

## 10. Troubleshooting

### Common Setup Issues

#### Issue: "firebase_options.dart not found"

**Symptoms:**
```
Error: Could not resolve the package 'firebase_options' in 'lib/main.dart'
```

**Fix:**
```bash
flutterfire configure
# Re-run configuration and select your project
```

---

#### Issue: iOS build fails with "No such module 'firebase_core'"

**Symptoms:**
```
Module 'firebase_core' not found
```

**Fix:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

---

#### Issue: Android build fails with "Duplicate class" error

**Symptoms:**
```
Duplicate class com.google.android.gms...
```

**Fix:**
Add to `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        multiDexEnabled true
    }
}
```

---

#### Issue: Quran metadata fails to load

**Symptoms:**
```
Exception: Unable to load asset: assets/quran_metadata.json
```

**Fix:**
1. Verify file exists: `ls assets/quran_metadata.json`
2. Verify listed in `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/quran_metadata.json
   ```
3. Run `flutter clean` and rebuild

---

#### Issue: Firestore offline persistence not working

**Symptoms:**
App crashes when network disabled

**Fix:**
Verify in `lib/main.dart`:
```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

---

## 11. Development Workflow

### Daily Workflow

```bash
# 1. Pull latest changes
git pull origin 2-project-setup

# 2. Install any new dependencies
flutter pub get

# 3. Run code generation (if models/providers changed)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run tests before making changes
flutter test

# 5. Make your changes

# 6. Run tests again
flutter test

# 7. Commit and push
git add .
git commit -m "feat: your feature description"
git push origin 2-project-setup
```

### Before Creating PR

```bash
# 1. Run full test suite
flutter test

# 2. Run static analysis
flutter analyze

# 3. Format code
flutter format lib/ test/

# 4. Build for both platforms
flutter build ios --debug
flutter build apk --debug

# All steps should pass with no errors
```

---

## 12. Next Steps

Once Phase 0 setup is complete:

1. ✅ Verify all acceptance criteria from spec (FR1-FR8)
2. ✅ Verify all success metrics achieved
3. ✅ Create PR for team review
4. ✅ Await approval and merge to main branch
5. ✅ Proceed to **Phase 1: Data Model Extensions**

---

## 13. Helpful Resources

### Documentation
- **Project Spec:** `.specify/specs/2-project-setup/spec.md`
- **Implementation Plan:** `.specify/specs/2-project-setup/plan.md`
- **Constitution:** `.specify/memory/constitution.md`

### External Links
- **Flutter Docs:** https://docs.flutter.dev
- **Firebase Flutter Docs:** https://firebase.flutter.dev
- **Riverpod Docs:** https://riverpod.dev
- **Freezed Docs:** https://pub.dev/packages/freezed

### Team Contacts
- **Tech Lead:** [Name] — [Email/Slack]
- **Firebase Admin:** [Name] — [Email/Slack]
- **DevOps:** [Name] — [Email/Slack]

---

## 14. Quick Reference

### Essential Commands

```bash
# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run app (iOS)
flutter run -d "iPhone 15 Pro"

# Run app (Android)
flutter run -d emulator-5554

# Static analysis
flutter analyze

# Format code
flutter format lib/ test/

# Clean build artifacts
flutter clean
```

### File Locations

```
lib/
├── main.dart                      # App entry point
├── firebase_options.dart          # Firebase config (generated)
├── core/
│   ├── utils/
│   │   ├── date_utils.dart        # Date utilities
│   │   ├── phone_utils.dart       # Phone normalization
│   │   └── quran_utils.dart       # Quran metadata
│   └── providers/
│       └── example_provider.dart  # Riverpod example
└── features/                      # Feature modules (placeholder)

assets/
└── quran_metadata.json            # 114 surahs

test/
└── core/
    └── utils/
        ├── date_utils_test.dart
        ├── phone_utils_test.dart
        └── quran_utils_test.dart
```

---

**Questions or Issues?**
- Check troubleshooting section above
- Review plan.md for detailed implementation notes
- Contact tech lead or create GitHub issue
