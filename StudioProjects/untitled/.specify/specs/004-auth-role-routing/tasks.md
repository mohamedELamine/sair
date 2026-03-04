# Tasks: Authentication & Role-Based Routing

**Input**: Design documents from `/Users/mohammed/specs/004-auth-role-routing/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

**Tests**: Tests are included per specification requirements and TDD best practices.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `- [ ] [ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Repository root: `/Users/mohammed/StudioProjects/untitled/`
- Source: `lib/`
- Tests: `test/`
- Integration tests: `integration_test/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and Firebase configuration

- [x] T001 Verify pubspec.yaml includes required dependencies (firebase_auth ^5.0.0, cloud_firestore ^5.0.0, go_router ^13.0.0, flutter_riverpod ^3.2.1)
- [x] T002 [P] Add test dependencies to pubspec.yaml (firebase_auth_mocks ^0.14.2, fake_cloud_firestore ^3.0.0)
- [x] T003 [P] Create lib/core/models/ directory structure
- [x] T004 [P] Create lib/core/services/ directory structure
- [x] T005 [P] Create lib/core/providers/ directory structure
- [x] T006 [P] Create lib/core/router/ directory structure
- [x] T007 [P] Create lib/core/utils/ directory structure
- [x] T008 [P] Create lib/features/auth/presentation/ directory structure
- [x] T009 [P] Create lib/features/auth/presentation/widgets/ directory structure
- [x] T010 [P] Create test/core/services/ directory structure
- [x] T011 [P] Create test/core/router/ directory structure
- [x] T012 [P] Create test/features/auth/presentation/ directory structure
- [x] T013 [P] Create integration_test/ directory if not exists
- [x] T014 Run `flutter pub get` to install dependencies

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T015 Create UserModel (freezed) in lib/core/models/user_model.dart with fields: id, role, email, phone, madrasaId, active, createdAt
- [x] T016 Add freezed and json_serializable annotations to UserModel
- [x] T017 Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate user_model.freezed.dart and user_model.g.dart
- [x] T018 Create phone normalization utility in lib/core/utils/phone_utils.dart with normalizePhone() and phoneToFakeEmail() functions
- [x] T019 Create custom exception classes in lib/core/services/auth_exceptions.dart (UserNotFoundException, WrongPasswordException, InvalidPhoneException, AccountInactiveException, NetworkException, ThrottleException)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Teacher Authentication & Access (Priority: P1) 🎯 MVP

**Goal**: Teachers can sign in with email/password and access /teacher-home screen

**Independent Test**: Create a teacher user in Firestore, login with email/password, verify redirect to /teacher-home and authentication persists across app restarts

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T020 [P] [US1] Create auth_service_test.dart in test/core/services/ for email authentication unit tests
- [x] T021 [P] [US1] Write test case: signInWithEmail with valid credentials returns UserModel with role='teacher'
- [x] T022 [P] [US1] Write test case: signInWithEmail with user-not-found throws UserNotFoundException
- [x] T023 [P] [US1] Write test case: signInWithEmail with wrong-password throws WrongPasswordException
- [x] T024 [P] [US1] Write test case: signInWithEmail with inactive account throws AccountInactiveException
- [x] T025 [P] [US1] Write test case: failed attempts counter increments and throttling delays apply (2s/5s/10s)

### Implementation for User Story 1

- [x] T026 [US1] Implement AuthService class in lib/core/services/auth_service.dart with constructor accepting FirebaseAuth and FirebaseFirestore instances
- [x] T027 [US1] Implement signInWithEmail(email, password) method in AuthService with Firebase Auth integration
- [x] T028 [US1] Add failed attempts tracking (Map<String, int>) and throttling logic to signInWithEmail
- [x] T029 [US1] Implement _fetchUserData(uid) private method to load user profile from Firestore users collection
- [x] T030 [US1] Add inactive account check in _fetchUserData (throw AccountInactiveException if active=false)
- [x] T031 [US1] Implement error mapping from FirebaseAuthException to custom exceptions (user-not-found, wrong-password, etc.)
- [x] T032 [US1] Implement signOut() method in AuthService to clear auth state and failed attempts counter
- [x] T033 [US1] Create authStateChanges() stream getter in AuthService returning Firebase Auth user stream
- [x] T034 [US1] Create authServiceProvider in lib/core/providers/auth_provider.dart using Riverpod to expose authStateChanges stream
- [x] T035 [US1] Create currentUserProvider in lib/core/providers/auth_provider.dart to fetch UserModel from Firestore when auth state changes
- [x] T036 [US1] Create placeholder TeacherHomeScreen widget in lib/features/teacher_home/presentation/teacher_home_screen.dart (simple Scaffold with Text "Teacher Home")
- [x] T037 [US1] Verify all unit tests for US1 pass (T020-T025)

**Checkpoint**: At this point, User Story 1 authentication logic should be fully functional and testable independently

---

## Phase 4: User Story 4 - Role-Based Route Protection (Priority: P1)

**Goal**: Authenticated users are automatically routed to role-specific screens, unauthorized access attempts are blocked

**Independent Test**: Login as teacher → verify redirect to /teacher-home; login as parent → verify redirect to /parent-portal; attempt cross-role navigation → verify redirect to authorized screen

**Dependencies**: Depends on US1 (AuthService) being complete

### Tests for User Story 4

- [x] T038 [P] [US4] Create route_guards_test.dart in test/core/router/ for redirect logic unit tests
- [x] T039 [P] [US4] Write test case: unauthenticated user accessing protected route redirects to /login
- [x] T040 [P] [US4] Write test case: teacher logging in redirects to /teacher-home
- [x] T041 [P] [US4] Write test case: parent logging in redirects to /parent-portal
- [x] T042 [P] [US4] Write test case: parent accessing /teacher-home redirects to /parent-portal
- [x] T043 [P] [US4] Write test case: teacher accessing /parent-portal redirects to /teacher-home
- [x] T044 [P] [US4] Write test case: auth state loading shows /splash screen

### Implementation for User Story 4

- [x] T045 [US4] Create SplashScreen widget in lib/features/auth/presentation/splash_screen.dart (simple loading indicator)
- [x] T046 [US4] Create placeholder ParentPortalScreen widget in lib/features/parent_portal/presentation/parent_portal_screen.dart (simple Scaffold with Text "Parent Portal")
- [x] T047 [US4] Create AuthStateNotifier class in lib/core/router/app_router.dart extending ChangeNotifier to trigger router refresh on auth changes
- [x] T048 [US4] Implement redirect logic function in lib/core/router/app_router.dart following research.md pattern (handle loading, auth check, role-based routing, route protection)
- [x] T049 [US4] Create routerProvider in lib/core/router/app_router.dart using Provider<GoRouter> with routes: /splash, /login, /teacher-home, /parent-portal
- [x] T050 [US4] Configure GoRouter with refreshListenable using AuthStateNotifier and redirect function
- [x] T051 [US4] Update main.dart to use MaterialApp.router with routerProvider
- [x] T052 [US4] Verify all unit tests for US4 pass (T038-T044)

**Checkpoint**: At this point, role-based routing should be fully functional with protection against unauthorized access

---

## Phase 5: User Story 5 - Seamless Login Mode Switching (Priority: P3)

**Goal**: Users can toggle between teacher/admin and parent login modes on the login screen

**Independent Test**: Toggle between modes → verify correct form fields appear; login in each mode → verify authentication works

**Dependencies**: Depends on US1 (AuthService) being complete

### Tests for User Story 5

- [x] T053 [P] [US5] Create login_screen_test.dart in test/features/auth/presentation/ for login UI widget tests
- [x] T054 [P] [US5] Write widget test: default mode is teacher/admin (email + password fields visible)
- [x] T055 [P] [US5] Write widget test: clicking toggle switches to parent mode (phone field visible, email/password hidden)
- [x] T056 [P] [US5] Write widget test: clicking toggle again switches back to teacher/admin mode
- [x] T057 [P] [US5] Write widget test: switching modes clears form data

### Implementation for User Story 5

- [x] T058 [P] [US5] Create EmailPasswordForm widget in lib/features/auth/presentation/widgets/email_password_form.dart with email TextField, password TextField, and login button
- [x] T059 [P] [US5] Create PhoneForm widget in lib/features/auth/presentation/widgets/phone_form.dart with phone TextField (10 digits validation) and login button
- [x] T060 [US5] Create LoginScreen widget in lib/features/auth/presentation/login_screen.dart with StatefulWidget managing login mode state (teacher-admin vs parent)
- [x] T061 [US5] Add SegmentedButton to LoginScreen for mode toggle (Teacher/Admin vs Parent options)
- [x] T062 [US5] Implement conditional rendering in LoginScreen: show EmailPasswordForm when mode=teacher-admin, show PhoneForm when mode=parent
- [x] T063 [US5] Add form clearing logic when mode switches (reset TextEditingController values)
- [x] T064 [US5] Implement loading state management in LoginScreen to disable form during authentication
- [x] T065 [US5] Connect EmailPasswordForm login button to AuthService.signInWithEmail
- [x] T066 [US5] Implement error display in LoginScreen using SnackBar for authentication failures
- [x] T067 [US5] Verify all widget tests for US5 pass (T053-T057)

**Checkpoint**: At this point, login UI should be fully functional with mode switching

---

## Phase 6: User Story 2 - Parent Phone-Only Authentication (Priority: P2)

**Goal**: Parents can login with phone number only, accounts are auto-created on first login

**Independent Test**: Enter new phone number in parent mode → verify account auto-created and redirect to /parent-portal; login again with same phone → verify existing account authenticated

**Dependencies**: Depends on US1 (AuthService) and US5 (PhoneForm widget) being complete

### Tests for User Story 2

- [x] T068 [P] [US2] Add test case to auth_service_test.dart: signInWithPhone with new phone creates account and returns UserModel with role='parent'
- [x] T069 [P] [US2] Add test case to auth_service_test.dart: signInWithPhone with existing phone authenticates and returns UserModel
- [x] T070 [P] [US2] Add test case to auth_service_test.dart: signInWithPhone with invalid phone format (not 10 digits) throws InvalidPhoneException
- [x] T071 [P] [US2] Add test case to auth_service_test.dart: phone normalization removes spaces, dashes, country codes

### Implementation for User Story 2

- [x] T072 [US2] Implement signInWithPhone(phoneNumber) method in lib/core/services/auth_service.dart
- [x] T073 [US2] Add phone normalization using phone_utils.dart normalizePhone() function
- [x] T074 [US2] Add phone validation (exactly 10 digits after normalization) throwing InvalidPhoneException if invalid
- [x] T075 [US2] Implement fake email generation using phoneToFakeEmail() function (parent{digits}@madrasa.local)
- [x] T076 [US2] Attempt Firebase Auth signInWithEmailAndPassword with fake email and phone digits as password
- [x] T077 [US2] On user-not-found error: call createUserWithEmailAndPassword and create Firestore user document with role='parent', phone, madrasaId='default', active=true
- [x] T078 [US2] On success: fetch and return UserModel from Firestore
- [x] T079 [US2] Connect PhoneForm login button to AuthService.signInWithPhone
- [x] T080 [US2] Add phone validation in PhoneForm widget showing error "Phone number must be exactly 10 digits" for invalid input
- [x] T081 [US2] Verify all unit tests for US2 pass (T068-T071)

**Checkpoint**: At this point, parent phone authentication should be fully functional with auto-account creation

---

## Phase 7: User Story 3 - Admin Privileged Access (Priority: P2)

**Goal**: Admins can login with email/password and are routed to /teacher-home (shared interface with teachers)

**Independent Test**: Create admin user in Firestore with role='admin', login with email/password, verify redirect to /teacher-home and role is recognized

**Dependencies**: Depends on US1 (AuthService) and US4 (routing) being complete

### Tests for User Story 3

- [x] T082 [P] [US3] Add test case to auth_service_test.dart: signInWithEmail with admin role returns UserModel with role='admin'
- [x] T083 [P] [US3] Add test case to route_guards_test.dart: admin logging in redirects to /teacher-home (same as teacher)
- [x] T084 [P] [US3] Add test case to route_guards_test.dart: admin accessing /parent-portal redirects to /teacher-home

### Implementation for User Story 3

- [x] T085 [US3] Verify app_router.dart redirect logic handles role='admin' by routing to /teacher-home (already implemented in US4)
- [x] T086 [US3] Add admin role test user creation to quickstart.md test data setup section
- [x] T087 [US3] Verify all unit tests for US3 pass (T082-T084)

**Checkpoint**: At this point, admin authentication and routing should be fully functional

---

## Phase 8: Integration Testing

**Purpose**: End-to-end testing of complete authentication flows

- [ ] T088 Create auth_flow_test.dart in integration_test/ directory
- [ ] T089 [P] Write integration test: teacher login flow (enter credentials → submit → verify /teacher-home loaded → close app → reopen → verify still authenticated)
- [ ] T090 [P] Write integration test: parent first-time login flow (enter new phone → submit → verify account created → verify /parent-portal loaded)
- [ ] T091 [P] Write integration test: parent existing login flow (enter existing phone → submit → verify /parent-portal loaded)
- [ ] T092 [P] Write integration test: unauthorized access attempt (login as parent → attempt navigation to /teacher-home → verify redirect to /parent-portal)
- [ ] T093 [P] Write integration test: logout flow (login → sign out → verify redirect to /login)
- [ ] T094 Run all integration tests and verify they pass

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Error handling, logging, and final improvements

- [ ] T095 [P] Add console logging for auth events (signInWithEmail, signInWithPhone, signOut, unauthorized access) in lib/core/services/auth_service.dart per FR-022
- [ ] T096 [P] Add error message constants file in lib/core/constants/error_messages.dart with all user-facing error messages from FR-011
- [ ] T097 [P] Update error display in LoginScreen to use specific error messages from error_messages.dart
- [ ] T098 [P] Add input formatters to phone TextField in PhoneForm to show placeholder "(xxx) xxx-xxxx" for UX
- [x] T099 [P] Add loading indicator to login button in EmailPasswordForm and PhoneForm while authentication in progress
- [ ] T100 Verify offline authentication works (login online → go offline → close app → reopen → verify still authenticated)
- [ ] T101 Verify throttling works (fail login 3 times → verify 10 second delay enforced before next attempt)
- [x] T102 [P] Run `flutter analyze` and fix any warnings or errors
- [ ] T103 [P] Run `flutter test` and verify all unit tests pass (100% pass rate target)
- [ ] T104 Test app manually on iOS simulator per quickstart.md
- [ ] T105 Test app manually on Android emulator per quickstart.md
- [ ] T106 Update quickstart.md with any discovered issues or additional setup steps
- [ ] T107 Create simple README.md in /Users/mohammed/specs/004-auth-role-routing/ with feature summary and links to design docs

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational - Can start immediately after Phase 2
- **User Story 4 (Phase 4)**: Depends on Foundational + US1 (AuthService) - Critical for MVP
- **User Story 5 (Phase 5)**: Depends on Foundational + US1 (AuthService) - UI layer for MVP
- **User Story 2 (Phase 6)**: Depends on Foundational + US1 (AuthService) + US5 (PhoneForm widget)
- **User Story 3 (Phase 7)**: Depends on Foundational + US1 + US4 (routing) - Simple verification
- **Integration Testing (Phase 8)**: Depends on all user stories being complete
- **Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

```text
Phase 2: Foundational
    ├─ Phase 3: US1 (Teacher Auth) ← MVP Core #1
    │   ├─ Phase 4: US4 (Route Protection) ← MVP Core #2
    │   │   └─ Phase 7: US3 (Admin Auth) [simple]
    │   ├─ Phase 5: US5 (Login UI) ← MVP Core #3
    │   │   └─ Phase 6: US2 (Parent Auth)
    │   └─ [All paths converge]
    └─ Phase 8: Integration Testing
       └─ Phase 9: Polish
```

### Minimal MVP Scope (US1 + US4 + US5)

For fastest time-to-value, implement only:
1. Phase 1: Setup
2. Phase 2: Foundational
3. Phase 3: US1 (Teacher Authentication)
4. Phase 4: US4 (Route Protection)
5. Phase 5: US5 (Login UI)

This delivers a working teacher authentication flow. Parent and admin authentication can be added later.

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Models before services
- Services before UI components
- Core implementation before integration
- All tests for that story must pass before moving to next story

### Parallel Opportunities

**Setup Phase (Phase 1)**:
- All T003-T013 (directory creation) can run in parallel

**Foundational Phase (Phase 2)**:
- T016 (freezed annotations) can run parallel with T018 (phone utils)
- T019 (exception classes) can run in parallel with T016 and T018

**User Story 1 Tests**:
- All T020-T025 can be written in parallel (different test cases)

**User Story 4 Tests**:
- All T038-T044 can be written in parallel (different test cases)

**User Story 5 Tests**:
- All T053-T057 can be written in parallel (different widget test cases)

**User Story 5 Widgets**:
- T058 (EmailPasswordForm) and T059 (PhoneForm) can be implemented in parallel

**User Story 2 Tests**:
- All T068-T071 can be written in parallel (different test cases)

**User Story 3 Tests**:
- All T082-T084 can be written in parallel (different test cases)

**Integration Tests (Phase 8)**:
- All T089-T093 can be written in parallel (different integration test cases)

**Polish Phase (Phase 9)**:
- T095 (logging), T096 (error constants), T097 (error messages), T098 (input formatters), T099 (loading indicators), T102 (analyze), T103 (tests) can all run in parallel

---

## Parallel Example: User Story 1 Implementation

```bash
# Step 1: Write all tests in parallel (they should FAIL)
Task T020: "Create auth_service_test.dart in test/core/services/"
Task T021: "Write test case: signInWithEmail with valid credentials"
Task T022: "Write test case: signInWithEmail with user-not-found"
Task T023: "Write test case: signInWithEmail with wrong-password"
Task T024: "Write test case: signInWithEmail with inactive account"
Task T025: "Write test case: failed attempts counter and throttling"

# Step 2: Implement core authentication (sequential - dependencies exist)
Task T026: "Implement AuthService class"
Task T027: "Implement signInWithEmail method"
Task T028: "Add throttling logic"
Task T029: "Implement _fetchUserData method"
Task T030: "Add inactive account check"
Task T031: "Implement error mapping"
Task T032: "Implement signOut method"

# Step 3: Integrate with providers (sequential)
Task T033: "Create authStateChanges stream"
Task T034: "Create authServiceProvider"
Task T035: "Create currentUserProvider"

# Step 4: Create placeholder screen (can run parallel with providers)
Task T036: "Create TeacherHomeScreen widget"

# Step 5: Verify tests pass
Task T037: "Run tests and verify all pass"
```

---

## Implementation Strategy

### MVP First (Phases 1-5: Teacher Authentication Only)

1. Complete Phase 1: Setup (15 mins)
2. Complete Phase 2: Foundational (1 hour)
3. Complete Phase 3: User Story 1 - Teacher Auth (4-6 hours)
4. Complete Phase 4: User Story 4 - Route Protection (3-4 hours)
5. Complete Phase 5: User Story 5 - Login UI (2-3 hours)
6. **STOP and VALIDATE**: Manual test teacher login flow end-to-end
7. Deploy/demo if ready → Teachers can now login!

**Estimated MVP Time**: 1-1.5 days

### Full Implementation (All User Stories)

1. Complete MVP (above) → 1-1.5 days
2. Add Phase 6: User Story 2 - Parent Auth → 3-4 hours
3. Add Phase 7: User Story 3 - Admin Auth → 1 hour (verification only)
4. Complete Phase 8: Integration Testing → 2-3 hours
5. Complete Phase 9: Polish → 2-3 hours

**Estimated Full Time**: 3-4 days

### Parallel Team Strategy

With 3 developers working simultaneously:

1. **Day 1**: Team completes Setup + Foundational together (2-3 hours)
2. **Day 1-2**:
   - Developer A: User Story 1 (Teacher Auth) + User Story 4 (Routing)
   - Developer B: User Story 5 (Login UI) + User Story 2 (Parent Auth)
   - Developer C: User Story 3 (Admin Auth) + Integration Tests
3. **Day 2**: Merge and test integrated system
4. **Day 2-3**: Polish phase together

**Estimated Parallel Time**: 2-2.5 days

---

## Task Metrics

- **Total Tasks**: 107
- **Setup Tasks**: 14 (T001-T014)
- **Foundational Tasks**: 5 (T015-T019)
- **User Story 1 Tasks**: 18 (T020-T037)
- **User Story 4 Tasks**: 15 (T038-T052)
- **User Story 5 Tasks**: 15 (T053-T067)
- **User Story 2 Tasks**: 14 (T068-T081)
- **User Story 3 Tasks**: 6 (T082-T087)
- **Integration Testing Tasks**: 7 (T088-T094)
- **Polish Tasks**: 13 (T095-T107)

**Parallel Opportunities**: 42 tasks marked [P] (39% of total)

**Independent Test Criteria**:
- US1: Create teacher user → Login → Verify /teacher-home access
- US2: Enter new phone → Verify account created → Verify /parent-portal access
- US3: Create admin user → Login → Verify /teacher-home access
- US4: Login as each role → Verify correct routing and protection
- US5: Toggle modes → Verify form changes → Login in each mode

**Format Validation**: ✅ All 107 tasks follow checklist format with checkbox, ID, optional [P] marker, optional [Story] label, and file paths

---

## Notes

- All tasks include exact file paths
- [P] marker indicates parallelizable tasks (different files, no dependencies)
- [Story] label (US1, US2, etc.) maps each task to its user story for traceability
- Tests are written FIRST (TDD approach) and must FAIL before implementation
- Each user story is independently completable and testable
- Stop at any checkpoint to validate story independently before proceeding
- Commit after each task or logical group of tasks
- MVP can be delivered with just Phases 1-5 (teacher authentication only)
