# Feature Specification: Project Setup & Architecture

**Feature Name:** Project Setup & Architecture (Phase 0)
**Status:** DRAFT
**Owner:** Development Team
**Created:** 2026-03-02
**Last Updated:** 2026-03-02

---

## 1. Overview

**One-sentence summary:**
Establish the foundational Flutter project structure with Firebase integration, state management, Quran metadata, and core utilities to enable development of all subsequent features.

**Why this feature:**
Before any user-facing features can be built, the development team needs a properly configured project with standardized architecture, Firebase services, essential dependencies, and reusable utilities. This foundation ensures consistency, maintainability, and adherence to architectural decisions across all future development phases.

**Target audience:**
- Development Team (primary users)
- All future features depend on this setup

---

## 2. Functional Requirements

### FR1: Flutter Project Structure
**Requirement:** Create a feature-based Flutter project structure with clear separation of concerns

**Acceptance Criteria:**
- [ ] Directory structure follows feature-based architecture with `core/` and `features/` separation
- [ ] `core/` contains: models, providers, services, utils, widgets subdirectories
- [ ] `features/` contains placeholder directories for: auth, teacher_home, student_details, parent_portal, admin, notifications
- [ ] Each feature follows data/domain/presentation layer structure where applicable
- [ ] `functions/` directory exists for Cloud Functions with TypeScript configuration
- [ ] `assets/` directory exists for static resources

**Out of Scope:**
- Implementation of actual feature logic (handled in subsequent phases)
- UI theme customization (can be added later)

---

### FR2: Firebase Service Integration
**Requirement:** Configure all required Firebase services for the application

**Acceptance Criteria:**
- [ ] Firebase project created and configured for both development and production
- [ ] Firebase Authentication enabled with Email/Password provider
- [ ] Cloud Firestore database initialized
- [ ] Cloud Functions configured and ready for deployment (requires Blaze plan)
- [ ] Firebase Cloud Messaging (FCM) enabled for push notifications
- [ ] Firebase Storage enabled for file uploads (reports, exports)
- [ ] Firebase Crashlytics enabled for error tracking
- [ ] `firebase_options.dart` generated and committed to repository
- [ ] FlutterFire CLI configured and documented in setup guide

**Out of Scope:**
- Firestore security rules (Phase 8)
- Actual Cloud Function implementations (Phases 6-7)
- FCM token registration logic (Phase 6)

---

### FR3: State Management Infrastructure
**Requirement:** Implement Riverpod as the state management solution with code generation support

**Acceptance Criteria:**
- [ ] Riverpod packages added to `pubspec.yaml` (flutter_riverpod, riverpod_annotation)
- [ ] Code generation packages configured (riverpod_generator, build_runner)
- [ ] `ProviderScope` wrapped around app root in `main.dart`
- [ ] Example provider created in `core/providers/` demonstrating proper usage
- [ ] Build runner configuration tested and working (`flutter pub run build_runner build`)

**Out of Scope:**
- Feature-specific providers (implemented per-feature in later phases)
- Complex state management patterns (added as needed)

---

### FR4: Quran Metadata Asset
**Requirement:** Embed complete Quran metadata as a JSON asset for verse calculations and validation

**Acceptance Criteria:**
- [ ] `quran_metadata.json` file created in `assets/` directory containing all 114 surahs
- [ ] Each surah entry includes: number, Arabic name, English transliteration, verse count
- [ ] Asset registered in `pubspec.yaml` under `flutter.assets`
- [ ] `QuranData` utility class created to load and query metadata
- [ ] Utility provides methods for: getting verse count, calculating total verses between ranges, validating verse ranges
- [ ] Metadata loads successfully on app startup without errors
- [ ] Unit tests verify verse count accuracy for sample surahs (Al-Fatihah: 7, Al-Baqarah: 286)

**Out of Scope:**
- Full Quran text content (only metadata needed)
- Translation or tafsir data
- Audio recitation files

---

### FR5: Core Utility Functions
**Requirement:** Create reusable utility functions for date handling, phone normalization, and Quran calculations

**Acceptance Criteria:**
- [ ] `date_utils.dart` created with `dayKey()` function that formats dates as "YYYY-MM-DD"
- [ ] `date_utils.dart` includes `parseDayKey()` function to convert back to DateTime
- [ ] `phone_utils.dart` created with `normalizePhone()` to extract digits-only from phone input
- [ ] `phone_utils.dart` includes `phoneToFakeEmail()` to generate authentication email from phone digits
- [ ] `quran_utils.dart` created with `QuranData` class for metadata operations
- [ ] All utility functions include unit tests with edge cases
- [ ] Utilities are properly exported and accessible from `core/utils/` index

**Out of Scope:**
- Complex date manipulation (can use `intl` package as needed)
- Phone number validation beyond digit extraction
- Quran search or advanced query features

---

### FR6: Offline Persistence Configuration
**Requirement:** Enable Firestore offline persistence for improved app reliability

**Acceptance Criteria:**
- [ ] Firestore settings configured in `main.dart` before app initialization
- [ ] `persistenceEnabled` set to `true`
- [ ] `cacheSizeBytes` set to `CACHE_SIZE_UNLIMITED`
- [ ] Settings applied before any Firestore queries execute
- [ ] Offline behavior tested: app reads cached data when network unavailable

**Out of Scope:**
- Custom cache eviction policies
- Offline-first conflict resolution (Firestore handles automatically)

---

### FR7: Dependency Management
**Requirement:** Install and configure all required Flutter packages

**Acceptance Criteria:**
- [ ] All Firebase packages added with compatible versions (firebase_core, cloud_firestore, firebase_auth, firebase_messaging, firebase_storage, firebase_crashlytics)
- [ ] Riverpod packages added (flutter_riverpod, riverpod_annotation, riverpod_generator)
- [ ] Routing package added (go_router)
- [ ] Utility packages added (intl for date formatting, freezed for immutable models, json_serializable)
- [ ] URL launcher added for opening export links
- [ ] All dev dependencies configured (build_runner, freezed, json_serializable, riverpod_lint)
- [ ] `flutter pub get` runs without errors
- [ ] No dependency conflicts reported
- [ ] Packages documented in README or setup guide

**Out of Scope:**
- Third-party UI libraries (Material Design 3 is sufficient for V1)
- Analytics packages beyond Crashlytics
- Testing frameworks beyond Flutter's built-in test package (can add later)

---

### FR8: Application Entry Point
**Requirement:** Configure `main.dart` with proper initialization sequence

**Acceptance Criteria:**
- [ ] `WidgetsFlutterBinding.ensureInitialized()` called before Firebase initialization
- [ ] Firebase initialized with platform-specific options from `firebase_options.dart`
- [ ] Firestore offline persistence settings applied
- [ ] Crashlytics error handlers configured for Flutter errors
- [ ] QuranData initialized during app startup
- [ ] App wrapped in `ProviderScope` for Riverpod
- [ ] Placeholder home screen shows loading indicator
- [ ] App builds successfully for both iOS and Android

**Out of Scope:**
- Splash screen customization
- App routing logic (Phase 2)
- Production build optimization

---

## 3. Success Criteria

The project setup is considered complete when:

1. **Build Success**: App compiles without errors on both iOS and Android platforms
2. **Firebase Connection**: App successfully connects to Firebase services (verified via Firebase console logs)
3. **Quran Data Loading**: All 114 surahs load from JSON asset with correct verse counts
4. **Offline Capability**: App launches and displays cached data when network is disabled
5. **Code Generation**: Riverpod and Freezed code generation runs without errors
6. **Developer Onboarding**: A new developer can clone the repo, run setup steps, and build the app in under 30 minutes
7. **Zero Console Errors**: App runs without warnings or errors in debug mode

---

## 4. Assumptions

1. **Firebase Project Access**: Development team has owner/editor access to Firebase console
2. **Blaze Plan Available**: Firebase project upgraded to Blaze plan for Cloud Functions support
3. **Development Environment**: Developers have Flutter SDK 3.x+ installed with iOS/Android toolchains configured
4. **Quran Metadata Source**: Complete and accurate Quran metadata (surah names, verse counts) is available from reliable sources (e.g., quran.com API, quran-json GitHub repo)
5. **Single Environment Initially**: Development and production share the same Firebase project initially (can separate later if needed based on user's choice of "single environment")
6. **Standard Flutter Versions**: Using stable Flutter channel with latest patch version

---

## 5. Data Model Changes

### New Assets
- `assets/quran_metadata.json` — JSON file containing all 114 surahs with metadata
  - Structure:
    ```json
    {
      "surahs": [
        {
          "number": 1,
          "name": "الفاتحة",
          "nameEn": "Al-Fatihah",
          "verses": 7
        }
      ]
    }
    ```

### No Database Collections Created
This phase does not create or modify any Firestore collections. Database schema changes begin in Phase 1.

---

## 6. Dependencies

### External Dependencies
- Firebase account with Blaze plan
- Flutter SDK 3.x or higher
- Xcode (for iOS builds)
- Android Studio / Android SDK (for Android builds)
- Node.js 18+ (for Cloud Functions development)

### Internal Dependencies
- None (this is the foundation for all other features)

### Blocks
- Phase 1-9 cannot proceed until this phase is complete

---

## 7. Testing Strategy

### Unit Tests
- [ ] `dayKey()` formats dates correctly (test cases: 2026-01-01, 2026-12-31, leap year dates)
- [ ] `parseDayKey()` parses valid strings and returns null for invalid input
- [ ] `normalizePhone()` extracts digits from various formats (with spaces, dashes, parentheses)
- [ ] `phoneToFakeEmail()` generates correct email format
- [ ] `QuranData.getVerseCount()` returns correct counts for known surahs
- [ ] `QuranData.calculateTotalVerses()` correctly sums verses across surah boundaries
- [ ] `QuranData.isValidRange()` rejects invalid ranges (negative numbers, out-of-bounds verses, from > to)

### Integration Tests
- [ ] Firebase initializes without errors on app startup
- [ ] Firestore offline persistence persists data across app restarts
- [ ] Quran metadata loads on first app launch
- [ ] Crashlytics reports test crash successfully

### Manual Verification
- [ ] App runs on iOS simulator/device
- [ ] App runs on Android emulator/device
- [ ] Firebase console shows active connections when app is running
- [ ] Network can be disabled without app crashing

---

## 8. Rollout Plan

### Phase 0 Implementation Steps (2-3 days)

**Day 1: Project Structure & Firebase**
1. Create Flutter project with feature-based directory structure
2. Add all dependencies to `pubspec.yaml`
3. Configure Firebase project via FlutterFire CLI
4. Enable all required Firebase services in console
5. Verify Firebase connection with simple read/write test

**Day 2: Core Utilities & Quran Data**
1. Create `quran_metadata.json` with all 114 surahs
2. Implement `QuranData` utility class
3. Implement date and phone utilities
4. Write unit tests for all utilities
5. Configure Firestore offline persistence

**Day 3: Verification & Documentation**
1. Run full test suite and fix any issues
2. Test app build on both iOS and Android
3. Create setup documentation for new developers
4. Document architecture decisions
5. Commit and push to repository

---

## 9. Out of Scope

The following are explicitly NOT part of Phase 0:

- User authentication logic (Phase 2)
- Any UI screens beyond placeholder (Phases 2-7)
- Firestore security rules (Phase 8)
- Firestore indexes (Phase 8)
- Cloud Function implementations (Phases 6-7)
- Feature-specific state providers (per-phase as needed)
- Production app signing and release configuration
- App store listings or marketing materials
- Localization/internationalization setup
- Accessibility features (can be added incrementally)

---

## 10. Risk Assessment

### Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Firebase Blaze plan cost concerns | Low | Medium | Monitor usage in Firebase console; set budget alerts |
| Quran metadata accuracy errors | Low | High | Use verified source (quran.com API); manual review of verse counts |
| Dependency version conflicts | Medium | Low | Lock versions in pubspec.yaml; test thoroughly |
| Platform-specific build issues | Medium | Medium | Test on both platforms early; maintain CI/CD pipeline |
| Offline persistence cache size | Low | Low | UNLIMITED cache is safe for this app size; can adjust if needed |

### Process Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Developer environment setup delays | Medium | Low | Provide detailed setup guide; use Docker if needed |
| Firebase project misconfiguration | Low | High | Double-check all service enablement; use checklist |
| Missing architectural documentation | Medium | Medium | Document decisions in this spec and in code comments |

---

## 11. Success Metrics

After Phase 0 completion, verify:

1. ✅ **Build Time**: App builds in under 2 minutes on developer machines
2. ✅ **Test Coverage**: All core utilities have 100% unit test coverage
3. ✅ **Zero Errors**: No console warnings or errors on app launch
4. ✅ **Firebase Active**: Firebase console shows active sessions when app runs
5. ✅ **Quran Data Loaded**: Debug log confirms 114 surahs loaded successfully
6. ✅ **Code Generation Works**: Riverpod generators produce no errors
7. ✅ **Cross-Platform**: App runs on at least one iOS and one Android device/emulator

---

## Appendices

### A. Directory Structure (Detailed)

```
quran-madrasa/
├── lib/
│   ├── core/
│   │   ├── models/
│   │   │   ├── evaluation.dart          # Freezed model (Phase 1)
│   │   │   ├── student.dart              # Freezed model (Phase 1)
│   │   │   ├── class_model.dart          # Freezed model (Phase 1)
│   │   │   └── user_model.dart           # Freezed model (Phase 2)
│   │   ├── providers/
│   │   │   └── example_provider.dart     # Demo Riverpod provider
│   │   ├── services/
│   │   │   └── (future: auth_service, firestore_service)
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   ├── phone_utils.dart
│   │   │   └── quran_utils.dart
│   │   └── widgets/
│   │       └── (future: shared UI components)
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── teacher_home/
│   │   ├── student_details/
│   │   ├── parent_portal/
│   │   ├── admin/
│   │   └── notifications/
│   └── main.dart
├── functions/
│   ├── src/
│   │   └── index.ts                      # Cloud Functions entry
│   ├── package.json
│   └── tsconfig.json
├── assets/
│   └── quran_metadata.json
├── test/
│   └── core/
│       └── utils/
│           ├── date_utils_test.dart
│           ├── phone_utils_test.dart
│           └── quran_utils_test.dart
├── pubspec.yaml
├── firebase.json
└── README.md
```

### B. Sample Quran Metadata (First 5 Surahs)

```json
{
  "surahs": [
    {"number": 1, "name": "الفاتحة", "nameEn": "Al-Fatihah", "verses": 7},
    {"number": 2, "name": "البقرة", "nameEn": "Al-Baqarah", "verses": 286},
    {"number": 3, "name": "آل عمران", "nameEn": "Aal-E-Imran", "verses": 200},
    {"number": 4, "name": "النساء", "nameEn": "An-Nisa", "verses": 176},
    {"number": 5, "name": "المائدة", "nameEn": "Al-Ma'idah", "verses": 120}
  ]
}
```

### C. Example main.dart Configuration

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'core/utils/quran_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Configure Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Load Quran metadata
  await QuranData.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Madrasa',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Project Setup Complete'),
        ),
      ),
    );
  }
}
```

### D. References

- Flutter Documentation: https://docs.flutter.dev
- Firebase for Flutter: https://firebase.flutter.dev
- Riverpod Documentation: https://riverpod.dev
- Quran Metadata Source: https://api.alquran.cloud/v1/meta or https://github.com/risan/quran-json
- Implementation Plan: `/docs/IMPLEMENTATION_PLAN.md`

---

## Sign-Off

- [ ] Product Owner: ________ Date: ________
- [ ] Tech Lead: ________ Date: ________
- [ ] Ready for Implementation: ________ Date: ________
