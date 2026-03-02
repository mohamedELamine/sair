# Task Breakdown: Project Setup & Architecture (Phase 0)

**Feature:** Project Setup & Architecture
**Plan Reference:** [plan.md](plan.md)
**Created:** 2026-03-02
**Owner:** Development Team
**Total Tasks:** 21
**Estimated Duration:** 2-3 days (18.5 hours)

---

## Overview

Phase 0 establishes the foundational infrastructure for the Quran Madrasa system. Unlike typical user story-driven features, this phase focuses on project initialization, dependency configuration, and development environment setup.

**Key Deliverables:**
- Flutter project with feature-based architecture
- Firebase services configured (Auth, Firestore, Functions, FCM, Storage, Crashlytics)
- Riverpod state management scaffolded
- Quran metadata embedded (114 surahs)
- Core utilities implemented (date, phone, Quran calculations)
- 100% test coverage for utilities

---

## Task Categories

- **Project Setup** — Flutter project initialization, directory structure
- **Dependencies & Config** — Package installation, Firebase configuration
- **Core Utilities** — Date, phone, and Quran calculation functions
- **Assets & Data** — Quran metadata JSON file
- **Testing** — Unit tests for utilities
- **Verification** — Build verification, documentation

---

## Phase 1: Project Initialization (Day 1, 6.5 hours)

**Goal:** Create Flutter project structure and configure Firebase services

### T001: Create Flutter Project Structure
- [ ] T001 Create Flutter project with feature-based directory structure per implementation plan

**Duration:** 1 hour
**Depends On:** None
**Blocks:** T002

**Description:**
Initialize Flutter project and create the complete directory hierarchy for core modules and feature placeholders.

**File Structure to Create:**
```
lib/
├── core/
│   ├── models/
│   ├── providers/
│   ├── services/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── teacher_home/
│   ├── student_details/
│   ├── parent_portal/
│   ├── admin/
│   └── notifications/
└── main.dart
```

**Acceptance Criteria:**
- [ ] Flutter project created via `flutter create quran_madrasa`
- [ ] All `core/` subdirectories exist (models, providers, services, utils, widgets)
- [ ] All `features/` module directories exist with data/domain/presentation structure
- [ ] `main.dart` contains placeholder app entry point
- [ ] Project builds successfully (`flutter build` runs without errors)

**Commands:**
```bash
flutter create quran_madrasa
cd quran_madrasa
mkdir -p lib/core/{models,providers,services,utils,widgets}
mkdir -p lib/features/auth/{data,domain,presentation}
mkdir -p lib/features/{teacher_home,student_details,parent_portal,admin,notifications}
```

---

### T002: Add Dependencies to pubspec.yaml
- [ ] T002 Install and configure all required Flutter packages in pubspec.yaml

**Duration:** 0.5 hour
**Depends On:** T001
**Blocks:** T003, T015

**Description:**
Add all Firebase, Riverpod, and utility packages to `pubspec.yaml` and verify no dependency conflicts.

**File:** `pubspec.yaml`

**Acceptance Criteria:**
- [ ] Firebase packages added: firebase_core, cloud_firestore, firebase_auth, firebase_messaging, firebase_storage, firebase_crashlytics (6 packages)
- [ ] Riverpod packages added: flutter_riverpod, riverpod_annotation, riverpod_generator (3 packages)
- [ ] Routing package added: go_router
- [ ] Utility packages added: intl, freezed_annotation, json_annotation, url_launcher (4 packages)
- [ ] Dev dependencies added: build_runner, freezed, json_serializable, riverpod_lint (4 packages)
- [ ] `flutter pub get` runs successfully without version conflicts
- [ ] No dependency resolution errors in console

**Dependencies to Add:**
```yaml
dependencies:
  firebase_core: ^2.24.0
  cloud_firestore: ^4.14.0
  firebase_auth: ^4.16.0
  firebase_messaging: ^14.7.10
  firebase_storage: ^11.6.0
  firebase_crashlytics: ^3.4.9
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  go_router: ^13.0.0
  intl: ^0.18.1
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  url_launcher: ^6.2.2

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  riverpod_lint: ^2.3.7
```

---

### T003: Configure Firebase Project via FlutterFire CLI
- [ ] T003 Set up Firebase project and generate firebase_options.dart using FlutterFire CLI

**Duration:** 2 hours
**Depends On:** T002
**Blocks:** T004, T005

**Description:**
Authenticate with Firebase, create/select project, and generate platform-specific configuration files.

**Files Generated:**
- `lib/firebase_options.dart` (auto-generated)
- `android/app/google-services.json` (auto-generated)
- `ios/Runner/GoogleService-Info.plist` (auto-generated)

**Acceptance Criteria:**
- [ ] Firebase CLI authenticated (`firebase login` successful)
- [ ] FlutterFire CLI configured (`flutterfire configure` completed)
- [ ] Firebase project selected or created: "quran-madrasa"
- [ ] Platforms configured: iOS (Bundle ID: com.madrasa.quran), Android (Package: com.madrasa.quran)
- [ ] `lib/firebase_options.dart` generated with platform-specific options
- [ ] `google-services.json` placed in `android/app/`
- [ ] `GoogleService-Info.plist` placed in `ios/Runner/`
- [ ] iOS pods installed successfully (`cd ios && pod install`)

**Commands:**
```bash
firebase login
flutterfire configure
# Select: Create new project or select "quran-madrasa"
# Platforms: iOS, Android
# Bundle ID: com.madrasa.quran
# Package: com.madrasa.quran
cd ios && pod install && cd ..
```

---

### T004: Enable Firebase Services in Console
- [ ] T004 Enable Authentication, Firestore, Functions, FCM, Storage, and Crashlytics in Firebase Console

**Duration:** 2 hours
**Depends On:** T003
**Blocks:** T005, T013, T014

**Description:**
Manually enable all required Firebase services through the Firebase Console and verify configuration.

**Acceptance Criteria:**
- [ ] **Authentication:** Email/Password provider enabled
- [ ] **Firestore Database:** Created in region `us-central1` (or closest), started in test mode
- [ ] **Cloud Functions:** Enabled (requires Blaze plan upgrade)
- [ ] **Cloud Messaging (FCM):** Enabled (default, verify server key accessible)
- [ ] **Cloud Storage:** Created in same region as Firestore, test mode
- [ ] **Crashlytics:** Enabled in console
- [ ] Spending limit set to $10/month (safety threshold for Blaze plan)
- [ ] All services show "Active" status in Firebase Console overview

**Console Steps:**
1. Navigate to https://console.firebase.google.com/project/quran-madrasa
2. Authentication → Sign-in method → Enable "Email/Password"
3. Firestore Database → Create database → Production mode → Select region
4. Functions → Upgrade to Blaze plan → Set budget alert $10/month
5. Cloud Messaging → Verify enabled (default)
6. Storage → Get started → Select same region as Firestore
7. Crashlytics → Enable Crashlytics

---

### T005: Verify Firebase Connection with Test Write/Read
- [ ] T005 Test Firebase connectivity by writing and reading a test document in Firestore

**Duration:** 1 hour
**Depends On:** T003, T004
**Blocks:** None

**Description:**
Create a simple test in `main.dart` to verify Firebase is properly configured and connected.

**File:** `lib/main.dart` (temporary test code)

**Acceptance Criteria:**
- [ ] Test writes a document to `test_collection/test_doc` in Firestore
- [ ] Test reads the document back successfully
- [ ] Test deletes the document
- [ ] Firebase Console shows the write operation in Firestore logs
- [ ] No authentication errors or permission errors
- [ ] Test code removed after verification (not committed to production)

**Test Code:**
```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
final firestore = FirebaseFirestore.instance;

// Write test
await firestore.collection('test_collection').doc('test_doc').set({
  'test': true,
  'timestamp': FieldValue.serverTimestamp(),
});

// Read test
final doc = await firestore.collection('test_collection').doc('test_doc').get();
print('Test successful: ${doc.data()}');

// Cleanup
await firestore.collection('test_collection').doc('test_doc').delete();
```

---

## Phase 2: Core Utilities & Quran Metadata (Day 2, 7 hours)

**Goal:** Implement date, phone, and Quran utilities with 100% test coverage

### T006: Create Quran Metadata JSON Asset
- [ ] T006 [P] Download and create quran_metadata.json with all 114 surahs in assets/ directory

**Duration:** 1 hour
**Depends On:** None (can run parallel with T001-T005)
**Blocks:** T007

**Description:**
Fetch complete Quran metadata from reliable source and format as JSON asset.

**File:** `assets/quran_metadata.json`

**Acceptance Criteria:**
- [ ] JSON file created with 114 surah entries
- [ ] Each entry includes: `number` (1-114), `name` (Arabic), `nameEn` (English), `verses` (count)
- [ ] Spot-check verification: Al-Fatihah (1) = 7 verses, Al-Baqarah (2) = 286 verses, An-Nas (114) = 6 verses
- [ ] Asset registered in `pubspec.yaml` under `flutter.assets`
- [ ] File size < 50KB (metadata only, no full text)

**Data Source:**
- Primary: https://api.alquran.cloud/v1/meta
- Backup: https://github.com/risan/quran-json

**Sample Structure:**
```json
{
  "surahs": [
    {"number": 1, "name": "الفاتحة", "nameEn": "Al-Fatihah", "verses": 7},
    {"number": 2, "name": "البقرة", "nameEn": "Al-Baqarah", "verses": 286},
    ...
  ]
}
```

**Update pubspec.yaml:**
```yaml
flutter:
  assets:
    - assets/quran_metadata.json
```

---

### T007: Implement QuranData Utility Class
- [ ] T007 Create QuranData class in lib/core/utils/quran_utils.dart for metadata operations

**Duration:** 2 hours
**Depends On:** T006
**Blocks:** T010, T013

**Description:**
Build utility class to load Quran metadata from asset and provide query methods.

**File:** `lib/core/utils/quran_utils.dart`

**Acceptance Criteria:**
- [ ] `QuranData` static class created with methods:
  - `Future<void> initialize()` — loads JSON from assets on app startup
  - `List<Surah> getSurahs()` — returns all 114 surahs
  - `int getVerseCount(int surahNumber)` — returns verse count for given surah
  - `int calculateTotalVerses({int fromSurah, int fromVerse, int toSurah, int toVerse})` — calculates verses between range
  - `bool isValidRange({int fromSurah, int fromVerse, int toSurah, int toVerse})` — validates verse range
- [ ] `Surah` model class created with fields: `number`, `name`, `nameEn`, `verses`
- [ ] Error handling: throws exception if metadata not initialized before use
- [ ] Asset loading tested: metadata loads successfully on first call to `initialize()`

**Class Signature:**
```dart
class QuranData {
  static List<Surah>? _surahs;

  static Future<void> initialize() async { ... }
  static List<Surah> getSurahs() { ... }
  static int getVerseCount(int surahNumber) { ... }
  static int calculateTotalVerses({...}) { ... }
  static bool isValidRange({...}) { ... }
}

class Surah {
  final int number;
  final String name;
  final String nameEn;
  final int verses;

  Surah({required this.number, required this.name, required this.nameEn, required this.verses});
  factory Surah.fromJson(Map<String, dynamic> json) => ...;
}
```

---

### T008: Implement Date Utilities
- [ ] T008 [P] Create date_utils.dart with dayKey generation and parsing functions

**Duration:** 0.5 hour
**Depends On:** None (can run parallel)
**Blocks:** T011, T013

**Description:**
Implement date formatting utilities for dayKey generation (YYYY-MM-DD format) per Constitution § 12.2.

**File:** `lib/core/utils/date_utils.dart`

**Acceptance Criteria:**
- [ ] `dayKey(DateTime date)` function returns string in "YYYY-MM-DD" format
- [ ] `parseDayKey(String dayKey)` function returns DateTime or null if invalid
- [ ] Edge cases handled: leap years, single-digit months/days zero-padded
- [ ] Functions are pure (no side effects)

**Function Signatures:**
```dart
/// Generate dayKey in format YYYY-MM-DD
String dayKey(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-"
         "${date.month.toString().padLeft(2, '0')}-"
         "${date.day.toString().padLeft(2, '0')}";
}

/// Parse dayKey back to DateTime
DateTime? parseDayKey(String dayKey) {
  try {
    final parts = dayKey.split('-');
    if (parts.length != 3) return null;
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2])
    );
  } catch (e) {
    return null;
  }
}
```

---

### T009: Implement Phone Normalization Utilities
- [ ] T009 [P] Create phone_utils.dart with phone normalization and fake email generation

**Duration:** 0.5 hour
**Depends On:** None (can run parallel)
**Blocks:** T012

**Description:**
Implement phone utilities for digits-only normalization and parent authentication email generation per Constitution § 4.2.

**File:** `lib/core/utils/phone_utils.dart`

**Acceptance Criteria:**
- [ ] `normalizePhone(String phone)` extracts digits only (removes spaces, dashes, parentheses)
- [ ] `phoneToFakeEmail(String phoneDigits)` generates format: `parent{digits}@madrasa.local`
- [ ] Functions handle empty strings gracefully (return empty, not crash)
- [ ] Functions are pure (no side effects)

**Function Signatures:**
```dart
/// Normalize phone to digits-only (per Constitution § 12.3)
String normalizePhone(String phone) {
  return phone.replaceAll(RegExp(r'[^0-9]'), '');
}

/// Generate fake email for parent auth (per Constitution § 4.2)
String phoneToFakeEmail(String phoneDigits) {
  return 'parent$phoneDigits@madrasa.local';
}
```

---

### T010: Write Unit Tests for QuranData
- [ ] T010 Create test/core/utils/quran_utils_test.dart with comprehensive test coverage

**Duration:** 1.5 hours
**Depends On:** T007
**Blocks:** T016

**Description:**
Write unit tests for all QuranData methods to achieve 100% coverage.

**File:** `test/core/utils/quran_utils_test.dart`

**Acceptance Criteria:**
- [ ] Test `initialize()` loads 114 surahs successfully
- [ ] Test `getVerseCount()` returns correct counts for known surahs (Al-Fatihah: 7, Al-Baqarah: 286)
- [ ] Test `calculateTotalVerses()` for same-surah range (1:1 to 1:7 = 7)
- [ ] Test `calculateTotalVerses()` for cross-surah range (1:1 to 2:50 = 57)
- [ ] Test `isValidRange()` accepts valid ranges
- [ ] Test `isValidRange()` rejects invalid ranges (fromSurah > toSurah)
- [ ] Test `isValidRange()` rejects out-of-bounds verse numbers
- [ ] Test error thrown if `getSurahs()` called before `initialize()`
- [ ] All tests pass (`flutter test test/core/utils/quran_utils_test.dart`)

**Test Cases (9 total):**
```dart
test('initialize loads 114 surahs', () async { ... });
test('getVerseCount returns 7 for Al-Fatihah', () { ... });
test('getVerseCount returns 286 for Al-Baqarah', () { ... });
test('calculateTotalVerses for same surah', () { ... });
test('calculateTotalVerses for cross-surah range', () { ... });
test('isValidRange accepts valid range', () { ... });
test('isValidRange rejects inverted surah range', () { ... });
test('isValidRange rejects inverted verse range', () { ... });
test('getSurahs throws if not initialized', () { ... });
```

---

### T011: Write Unit Tests for Date Utilities
- [ ] T011 [P] Create test/core/utils/date_utils_test.dart with edge case coverage

**Duration:** 0.5 hour
**Depends On:** T008
**Blocks:** T016

**Description:**
Write unit tests for date formatting and parsing functions.

**File:** `test/core/utils/date_utils_test.dart`

**Acceptance Criteria:**
- [ ] Test `dayKey()` formats 2026-01-01 correctly
- [ ] Test `dayKey()` formats 2026-12-31 correctly
- [ ] Test `dayKey()` handles leap year (2024-02-29)
- [ ] Test `parseDayKey()` parses valid string "2026-03-02"
- [ ] Test `parseDayKey()` returns null for invalid format "2026-3-2"
- [ ] Test `parseDayKey()` returns null for invalid month "2026-13-01"
- [ ] Test `parseDayKey()` returns null for non-date string "invalid"
- [ ] All tests pass

**Test Cases (7 total):**
```dart
test('dayKey formats 2026-01-01 correctly', () { ... });
test('dayKey formats 2026-12-31 correctly', () { ... });
test('dayKey handles leap year', () { ... });
test('parseDayKey parses valid string', () { ... });
test('parseDayKey rejects invalid format', () { ... });
test('parseDayKey rejects invalid month', () { ... });
test('parseDayKey rejects non-date string', () { ... });
```

---

### T012: Write Unit Tests for Phone Utilities
- [ ] T012 [P] Create test/core/utils/phone_utils_test.dart with format variations

**Duration:** 0.5 hour
**Depends On:** T009
**Blocks:** T016

**Description:**
Write unit tests for phone normalization and email generation.

**File:** `test/core/utils/phone_utils_test.dart`

**Acceptance Criteria:**
- [ ] Test `normalizePhone()` with spaces: "050 123 4567" → "0501234567"
- [ ] Test `normalizePhone()` with dashes and country code: "+966-50-123-4567" → "966501234567"
- [ ] Test `normalizePhone()` with parentheses: "(050) 123-4567" → "0501234567"
- [ ] Test `normalizePhone()` with empty string returns empty
- [ ] Test `phoneToFakeEmail()` generates correct format: "0501234567" → "parent0501234567@madrasa.local"
- [ ] All tests pass

**Test Cases (5 total):**
```dart
test('normalizePhone removes spaces', () { ... });
test('normalizePhone removes dashes and plus', () { ... });
test('normalizePhone removes parentheses', () { ... });
test('normalizePhone handles empty string', () { ... });
test('phoneToFakeEmail generates correct format', () { ... });
```

---

### T013: Configure Firestore Offline Persistence in main.dart
- [ ] T013 Update lib/main.dart to enable Firestore offline persistence before app initialization

**Duration:** 0.5 hour
**Depends On:** T004, T007, T008
**Blocks:** T014

**Description:**
Configure Firestore settings for offline persistence per Constitution § 12.

**File:** `lib/main.dart`

**Acceptance Criteria:**
- [ ] `WidgetsFlutterBinding.ensureInitialized()` called before Firebase initialization
- [ ] Firebase initialized with `DefaultFirebaseOptions.currentPlatform`
- [ ] Firestore settings configured: `persistenceEnabled: true`, `cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED`
- [ ] Settings applied before any Firestore queries
- [ ] QuranData.initialize() called during app startup
- [ ] App wrapped in `ProviderScope` for Riverpod

**Initialization Sequence:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Load Quran metadata
  await QuranData.initialize();

  runApp(const ProviderScope(child: MyApp()));
}
```

---

### T014: Configure Crashlytics Error Handlers in main.dart
- [ ] T014 Set up Crashlytics to capture Flutter errors and fatal crashes

**Duration:** 0.5 hour
**Depends On:** T004, T013
**Blocks:** None

**Description:**
Configure Firebase Crashlytics to automatically report errors.

**File:** `lib/main.dart`

**Acceptance Criteria:**
- [ ] `FlutterError.onError` set to Crashlytics handler
- [ ] `PlatformDispatcher.instance.onError` set to Crashlytics handler for async errors
- [ ] Test crash reported successfully to Firebase Console (manual verification)
- [ ] Crashlytics logs visible in Firebase Console under "Crashlytics" tab

**Error Handler Configuration:**
```dart
// Configure Crashlytics
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

// Handle async errors not caught by Flutter framework
PlatformDispatcher.instance.onError = (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true;
};
```

---

### T015: Create Example Riverpod Provider
- [ ] T015 Create lib/core/providers/example_provider.dart to demonstrate Riverpod integration

**Duration:** 0.5 hour
**Depends On:** T002
**Blocks:** None

**Description:**
Create a simple example provider to verify Riverpod code generation and usage.

**File:** `lib/core/providers/example_provider.dart`

**Acceptance Criteria:**
- [ ] Provider created using `@riverpod` annotation
- [ ] Provider returns a simple string: "Quran Madrasa Setup Complete"
- [ ] Provider used in placeholder home screen (MyApp widget)
- [ ] Code generation runs successfully: `flutter pub run build_runner build`
- [ ] No errors in generated files

**Provider Code:**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'example_provider.g.dart';

@riverpod
String exampleGreeting(ExampleGreetingRef ref) {
  return 'Quran Madrasa Setup Complete';
}
```

**Usage in main.dart:**
```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(exampleGreetingProvider);

    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(greeting)),
      ),
    );
  }
}
```

---

## Phase 3: Verification & Documentation (Day 3, 5 hours)

**Goal:** Verify build success, test coverage, and create developer documentation

### T016: Run Full Test Suite and Fix Issues
- [ ] T016 Execute flutter test and achieve 100% pass rate for all unit tests

**Duration:** 2 hours
**Depends On:** T010, T011, T012
**Blocks:** T017, T018

**Description:**
Run all unit tests and fix any failing tests or code issues.

**Acceptance Criteria:**
- [ ] `flutter test` runs successfully with 0 failures
- [ ] All 22 unit tests pass (9 QuranData + 7 date + 5 phone + 1 example)
- [ ] Test coverage report generated (100% for core utilities)
- [ ] `flutter analyze` shows 0 issues
- [ ] Code generation completed: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] All generated files (`*.g.dart`) committed to repository

**Commands:**
```bash
flutter test
flutter analyze
flutter pub run build_runner build --delete-conflicting-outputs
```

**Test Summary Expected:**
```
22 tests passed, 0 failed
```

---

### T017: Test iOS Build and Run
- [ ] T017 Build and run app on iOS simulator to verify platform compatibility

**Duration:** 1 hour
**Depends On:** T016
**Blocks:** T019

**Description:**
Verify app builds and runs successfully on iOS platform.

**Acceptance Criteria:**
- [ ] iOS build completes: `flutter build ios --debug`
- [ ] App runs on iOS simulator (iPhone 15 Pro or available device)
- [ ] App shows placeholder screen with "Quran Madrasa Setup Complete" text
- [ ] Console logs show: "Firebase initialized successfully"
- [ ] Console logs show: "Quran metadata loaded: 114 surahs"
- [ ] No red errors in Xcode console
- [ ] Firebase Console shows iOS device connection (green indicator)

**Commands:**
```bash
flutter devices  # List available simulators
flutter run -d "iPhone 15 Pro"  # or your simulator name
```

---

### T018: Test Android Build and Run
- [ ] T018 [P] Build and run app on Android emulator to verify platform compatibility

**Duration:** 1 hour
**Depends On:** T016
**Blocks:** T019

**Description:**
Verify app builds and runs successfully on Android platform.

**Acceptance Criteria:**
- [ ] Android build completes: `flutter build apk --debug`
- [ ] App runs on Android emulator (Pixel 7 API 34 or available device)
- [ ] App shows placeholder screen with "Quran Madrasa Setup Complete" text
- [ ] Logcat shows: "Firebase initialized successfully"
- [ ] Logcat shows: "Quran metadata loaded: 114 surahs"
- [ ] No red errors in Android Studio Logcat
- [ ] Firebase Console shows Android device connection (green indicator)

**Commands:**
```bash
flutter devices  # List available emulators
flutter emulators --launch Pixel_7_API_34  # Start emulator
flutter run -d emulator-5554  # or your emulator ID
```

---

### T019: Write Setup Documentation (README.md)
- [ ] T019 Create comprehensive setup guide for new developers in README.md

**Duration:** 1 hour
**Depends On:** T017, T018
**Blocks:** T021

**Description:**
Document setup steps, prerequisites, and troubleshooting for developer onboarding.

**File:** `README.md` (project root)

**Acceptance Criteria:**
- [ ] Prerequisites section lists all required tools with versions
- [ ] Setup steps documented (clone, dependencies, Firebase config, run)
- [ ] Troubleshooting section covers common issues (firebase_options.dart not found, pod install failures, etc.)
- [ ] Architecture overview section references `.specify/specs/2-project-setup/plan.md`
- [ ] Quick start commands provided (flutter pub get, flutter run, flutter test)
- [ ] Links to external documentation (Flutter, Firebase, Riverpod)
- [ ] Time estimate for setup: ~30 minutes

**Sections to Include:**
1. Project Overview
2. Prerequisites (Flutter 3.x+, Xcode, Android Studio, Firebase CLI)
3. Quick Start (5 steps: clone, dependencies, Firebase, run, test)
4. Project Structure (directory tree)
5. Development Workflow
6. Troubleshooting
7. References

---

### T020: Document Architecture Decisions
- [ ] T020 [P] Create docs/ARCHITECTURE.md documenting key technical decisions

**Duration:** 0.5 hour
**Depends On:** T019
**Blocks:** T021

**Description:**
Document rationale for major architecture choices made in Phase 0.

**File:** `docs/ARCHITECTURE.md`

**Acceptance Criteria:**
- [ ] **State Management Choice:** Why Riverpod (vs Bloc/Provider/GetX)
- [ ] **Firebase Configuration:** Why single environment initially (dev/prod shared)
- [ ] **Phone Normalization:** Why digits-only format (vs E.164)
- [ ] **Offline Persistence:** Why unlimited cache size
- [ ] **Quran Data:** Why embedded asset (vs API calls)
- [ ] Each decision includes: context, considered alternatives, rationale, tradeoffs
- [ ] Document references Constitution where applicable

**Template:**
```markdown
# Architecture Decisions

## State Management: Riverpod

**Context:** Need reactive state management for complex forms and async data.

**Alternatives Considered:**
- Bloc: More boilerplate, but very structured
- Provider: Simpler but less type-safe
- GetX: Fast but harder to test

**Decision:** Riverpod (with code generation)

**Rationale:**
- Compile-safe providers
- Excellent testability
- Code generation reduces boilerplate
- Active maintenance and community

**Tradeoffs:** Slightly steeper learning curve than Provider
```

---

### T021: Commit and Push to Repository
- [ ] T021 Stage all files, create commit, and push to feature branch

**Duration:** 0.5 hour
**Depends On:** T019, T020
**Blocks:** None (final task)

**Description:**
Finalize Phase 0 by committing all work and pushing to remote repository.

**Acceptance Criteria:**
- [ ] All files staged: `git add .`
- [ ] Commit created with message: `feat: complete Phase 0 project setup`
- [ ] Commit includes all source files, tests, documentation, and generated files
- [ ] Push to feature branch: `git push origin 2-project-setup`
- [ ] GitHub/GitLab shows commit with green CI status (if CI configured)
- [ ] No uncommitted changes remain: `git status` shows clean working tree

**Commands:**
```bash
git add .
git status  # Review files to be committed
git commit -m "feat: complete Phase 0 project setup

- Flutter project with feature-based architecture
- Firebase services configured (Auth, Firestore, Functions, FCM, Storage, Crashlytics)
- Riverpod state management scaffolded
- Quran metadata embedded (114 surahs)
- Core utilities (date, phone, Quran) with 100% test coverage
- Offline persistence enabled
- Documentation complete (README.md, ARCHITECTURE.md)
- All tests passing (22 unit tests)
- Builds verified on iOS and Android

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

git push origin 2-project-setup
```

---

## Dependency Graph

```
Setup Phase (Parallel Start Points):
├─ T001 (Project Structure)
│   └─ T002 (Dependencies)
│       ├─ T003 (Firebase Config)
│       │   └─ T004 (Enable Services)
│       │       └─ T005 (Verify Connection)
│       └─ T015 (Example Provider)
│
├─ T006 (Quran Metadata) [P]
│   └─ T007 (QuranData Utility)
│       └─ T010 (QuranData Tests)
│
├─ T008 (Date Utils) [P]
│   └─ T011 (Date Tests) [P]
│
└─ T009 (Phone Utils) [P]
    └─ T012 (Phone Tests) [P]

Initialization Phase:
T004 + T007 + T008 → T013 (Firestore Offline)
                      └─ T014 (Crashlytics)

Testing Phase:
T010 + T011 + T012 → T016 (Run Full Test Suite)
                      ├─ T017 (iOS Build)
                      └─ T018 (Android Build) [P]

Documentation Phase:
T017 + T018 → T019 (README)
              └─ T020 (Architecture Docs) [P]
                  └─ T021 (Commit & Push)
```

**Critical Path:** T001 → T002 → T003 → T004 → T007 → T010 → T016 → T017 → T019 → T021 (11.5 hours)

**Parallelizable Tasks:** T006, T008, T009, T011, T012, T015, T018, T020 (7 hours can overlap)

**Total Duration:** 18.5 hours sequential, ~12 hours with parallelization

---

## Parallel Execution Opportunities

### Day 1 Parallelization
- **T006 (Quran Metadata)** can run while T001-T004 execute (saves 1 hour)
- Result: Day 1 reduces from 6.5 hours to 5.5 hours

### Day 2 Parallelization
- **T008, T009** can run in parallel after project setup (saves 0.5 hour)
- **T011, T012** can run in parallel with T010 (saves 1 hour)
- Result: Day 2 reduces from 7 hours to 5.5 hours

### Day 3 Parallelization
- **T018 (Android)** can run in parallel with T017 (iOS) (saves 1 hour)
- **T020 (Arch Docs)** can run in parallel with T019 (README) (saves 0.5 hour)
- Result: Day 3 reduces from 5 hours to 3.5 hours

**Optimized Timeline:** 5.5 + 5.5 + 3.5 = **14.5 hours (1.8 days)** with full parallelization

---

## Success Metrics (from Specification)

After completing all tasks, verify these success criteria:

1. ✅ **Build Time**: App builds in under 2 minutes on developer machine
2. ✅ **Test Coverage**: All core utilities have 100% unit test coverage (22 tests pass)
3. ✅ **Zero Errors**: No console warnings or errors on app launch
4. ✅ **Firebase Active**: Firebase Console shows active sessions when app runs
5. ✅ **Quran Data Loaded**: Debug log confirms "114 surahs loaded successfully"
6. ✅ **Code Generation Works**: Riverpod and Freezed generators produce no errors
7. ✅ **Cross-Platform**: App runs on at least one iOS and one Android device/emulator

---

## Constitution Alignment

Phase 0 aligns with the Constitution as follows:

- **Principle 1 (Teacher-First UX):** ✅ N/A (no UI in Phase 0)
- **Principle 2 (One Source of Truth):** ✅ Firestore offline persistence uses single cache
- **Principle 3 (No Unnecessary Flows):** ✅ Minimal setup, no wizards
- **Principle 4 (Data Continuity):** ✅ Additive-only (no existing data to migrate)
- **Principle 5 (Prevent Mistakes by Design):** ✅ N/A (no business logic in Phase 0)
- **Security (§11):** ✅ Firebase Auth configured; rules deferred to Phase 8

---

## Completion & Sign-Off

- [ ] All 21 tasks completed
- [ ] All acceptance criteria verified
- [ ] All 22 unit tests passing
- [ ] App builds on iOS and Android
- [ ] Documentation complete (README.md, ARCHITECTURE.md)
- [ ] Code committed and pushed to repository

**Sign-Off:**
- [ ] Developer: ________ Date: ________
- [ ] Tech Lead: ________ Date: ________
- [ ] Ready for Phase 1: ________ Date: ________

---

## Next Phase

After Phase 0 completion, proceed to:

**Phase 1: Data Model Extensions (1 day)**
- Add `dayKey`, `updatedAt`, `updatedBy` fields to evaluations collection
- Standardize memorization/revision field structures
- Create Freezed models for Evaluation, Student, Class, User

**Reference:** `.specify/specs/1-video-detection-export/spec.md` (if exists) or next feature in implementation plan

---

## References

- **Specification:** `.specify/specs/2-project-setup/spec.md`
- **Implementation Plan:** `.specify/specs/2-project-setup/plan.md`
- **Quick Start Guide:** `.specify/specs/2-project-setup/plan/quickstart.md`
- **Constitution:** `.specify/memory/constitution.md` (v1.0.0)
- **Implementation Plan (Overview):** `/docs/IMPLEMENTATION_PLAN.md` (Phases 0-9)

---

**Document Version:** 1.0
**Last Updated:** 2026-03-02
**Status:** Ready for Implementation
