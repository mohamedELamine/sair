# Task Breakdown Template

Use this template to define actionable tasks for a feature, ordered by dependency. Each task must have measurable acceptance criteria aligned to the Constitution.

---

## Header

**Feature:** [FEATURE_NAME]
**Plan Reference:** [Link to plan.md]
**Created:** [YYYY-MM-DD]
**Owner:** [YOUR_NAME]
**Total Tasks:** [N]
**Estimated Duration:** [X days]

---

## Task Categories

Tasks are categorized by principle and responsibility:

- **Schema & Data** — Firestore schema, migrations, indexing
- **Core Logic** — Business rules, validation, repositories
- **UI/Presentation** — Flutter screens, widgets, user flows
- **Security & Permissions** — Firestore rules, role validation
- **Testing** — Unit, integration, security tests
- **Deployment & Docs** — Rollout, documentation, communication

---

## Task List (Ordered by Dependency)

### T1: Update Firestore Schema — Add Required Fields to evaluations

**Category:** Schema & Data
**Duration:** 0.5 days
**Depends On:** None
**Blocks:** T3, T7

**Description:**
Add three new fields to the `evaluations` collection to support daily tracking and edit auditing.

**Acceptance Criteria:**
- [ ] `dayKey` field (string) added with validation rule: format `YYYY-MM-DD`
- [ ] `updatedAt` field (timestamp) added, optional
- [ ] `updatedBy` field (string, UID) added, optional
- [ ] All existing evaluations have a computed `dayKey` based on `createdAt` (backfill script)
- [ ] Schema documented in `.specify/data-model.md`

**Definition of Done:**
- Firestore collection updated
- Backfill script tested on staging database
- No data loss; all 1000+ existing evaluations retain their data
- Documentation updated with field descriptions and validation

**Notes:**
- If dayKey backfill fails on any document, log error and skip (don't crash)
- Migration is non-breaking; old evaluations without dayKey can be queried separately if needed

---

### T2: Create Firestore Composite Indexes

**Category:** Schema & Data
**Duration:** 0.5 days
**Depends On:** T1
**Blocks:** T4, T6

**Description:**
Create three composite indexes required by the Constitution (§ 10: Indexing & Query Policy).

**Acceptance Criteria:**
- [ ] Index 1: `(evaluations: studentId, dayKey)` created and verified
- [ ] Index 2: `(evaluations: classId, dayKey, date)` created and verified
- [ ] Index 3: `(evaluations: studentId, date)` created and verified
- [ ] All indexes active (green status in Firebase Console)
- [ ] No slow query warnings in logs after 24-hour observation

**Definition of Done:**
- Indexes deployed to production
- Query latency measured (must be <200ms for 1000-doc collections)
- Documented in `.firestore.indexes.json`

**Notes:**
- Use `gcloud firestore indexes create` or Firebase CLI
- Indexes take 5–15 minutes to activate; monitor in console

---

### T3: Implement EvaluationRepository (Core CRUD)

**Category:** Core Logic
**Duration:** 2 days
**Depends On:** T1
**Blocks:** T4, T5, T6, T8

**Description:**
Build the data layer repository that reads and writes evaluations from/to Firestore, enforcing business logic constraints.

**Acceptance Criteria:**
- [ ] `EvaluationRepository` class created with methods:
  - `Future<Evaluation> getEvaluationForDay(studentId, dayKey)` — read single eval
  - `Future<List<Evaluation>> getHistory(studentId, limit)` — read sorted by date descending
  - `Future<void> createEvaluation(studentId, classId, dayKey, attendanceStatus, progress)` — write
  - `Future<void> updateEvaluation(evalId, updates)` — write (edit)
  - `Future<void> deleteEvaluation(evalId)` — delete (admin only)
- [ ] **Range validation enforced:** `fromSurah ≤ toSurah`; if equal, `fromVerse ≤ toVerse`
- [ ] **Attendance constraint:** If `attendanceStatus` is `absent|excused`, progress maps must be null
- [ ] **Audit fields:** `updatedAt` and `updatedBy` set on every write (server timestamp via Firestore)
- [ ] **Error handling:** Throws typed exceptions for validation failures
- [ ] **Unit tests pass:** 100% coverage of validation logic

**Definition of Done:**
- `lib/features/student_details/data/repositories/evaluation_repository.dart` complete
- All methods have return types and error handling (custom exceptions)
- Unit tests in `test/...evaluation_repository_test.dart` (10+ tests)
- Code review approved

**Example Code Structure:**
```dart
class EvaluationRepository {
  Future<void> updateEvaluation(String evalId, EvaluationUpdate update) async {
    // Validate range
    if (update.memorization != null) {
      _validateRange(update.memorization);
    }
    // Write to Firestore with server timestamp
    await _firestore.collection('evaluations').doc(evalId).update({
      ...update.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': _authService.currentUserId,
    });
  }

  void _validateRange(ProgressRange range) {
    if (range.fromSurah > range.toSurah) {
      throw ValidationException('Invalid range: fromSurah > toSurah');
    }
    if (range.fromSurah == range.toSurah && range.fromVerse > range.toVerse) {
      throw ValidationException('Invalid range: verses inverted');
    }
  }
}
```

---

### T4: Create StudentDetailsModule UI & Screens

**Category:** UI/Presentation
**Duration:** 3 days
**Depends On:** T3
**Blocks:** T5, T8

**Description:**
Build the Flutter screens and widgets for viewing and editing a student's evaluation record.

**Acceptance Criteria:**
- [ ] `StudentDetailScreen` created (takes `studentId` as parameter)
  - Displays: student name, class, current date selector
  - Shows attendance status selector (3 buttons: present|absent|excused)
  - Shows memorization & revision progress cards (if recorded)
  - Shows history button (opens EditHistoryWidget)
- [ ] `ProgressInputWidget` created (reusable)
  - 4 input fields: fromSurah, fromVerse, toSurah, toVerse
  - Real-time validation: highlights invalid ranges (red border)
  - Save button (enabled only if attendance is `present` AND range is valid)
- [ ] `EditHistoryWidget` created
  - Lists all evaluations for the student (paginated, 10 per page)
  - Edit button → opens editing dialog
- [ ] **Teacher-First UX:** Max 2 taps to record attendance + progress
- [ ] **No unnecessary screens:** No "confirmation" or "summary" dialogs
- [ ] All screens use Material Design 3 and theme from Constitution

**Definition of Done:**
- All screens render correctly on device (tested on iOS & Android emulator)
- Navigation between screens works (no crashes)
- Keyboard handling verified (no overlapping inputs)
- Widget tests pass (15+ tests for progress validation)

**Notes:**
- Use `flutter_bloc` for state management
- Display attendance status as 3 large buttons (not dropdown)
- Disable progress input if `attendanceStatus != present` (not hidden; show grayed-out)

---

### T5: Implement Range Validation & Edit Logic

**Category:** Core Logic
**Duration:** 2 days
**Depends On:** T4
**Blocks:** T8

**Description:**
Add validation rules for progress range editing and ensure `currentProgress` field is updated correctly.

**Acceptance Criteria:**
- [ ] **Range validation:**
  - Rejects: `fromSurah > toSurah`
  - Rejects: `fromSurah == toSurah && fromVerse > toVerse`
  - Accepts: all valid ranges
  - Error messages are user-friendly (e.g., "Ending verse cannot come before starting verse")
- [ ] **currentProgress update logic:**
  - When editing an evaluation, check if it's the latest for that student (across all evals)
  - If latest: update `students.currentProgress` to new range
  - If not latest: do not update `students.currentProgress` (keep newer value)
  - Include `updatedAt` and `updatedBy` in update
- [ ] **Compute `totalVerses`:**
  - Formula: (toSurah - fromSurah) × 30 + (toVerse - fromVerse + 1) *approximately* (Quranic verse count varies)
  - Or: accept user input for exact count
- [ ] Unit tests pass: 20+ test cases covering all validation scenarios

**Definition of Done:**
- `lib/features/student_details/domain/usecases/update_progress_usecase.dart` complete
- All validation logic thoroughly tested
- Code review approved
- Documentation of validation rules added to spec.md

**Example Test Cases:**
```
✓ Valid: fromSurah=1, toSurah=2 (different surahs)
✓ Valid: fromSurah=5, toSurah=5, fromVerse=1, toVerse=10 (same surah, valid verses)
✗ Invalid: fromSurah=5, toSurah=4 (reversed)
✗ Invalid: fromSurah=5, toSurah=5, fromVerse=10, toVerse=5 (reversed verses)
✓ Editing old eval: currentProgress NOT updated if newer eval exists
✓ Editing latest eval: currentProgress updated to new range
```

---

### T6: Implement Absence → Progress Blocking

**Category:** Core Logic & UI
**Duration:** 1 day
**Depends On:** T4, T2
**Blocks:** T8

**Description:**
Enforce the critical business rule: students with `absent` or `excused` attendance cannot have progress recorded.

**Acceptance Criteria:**
- [ ] **UI enforcement:**
  - When user selects `absent` or `excused`, progress input widgets are disabled (visual feedback: grayed out)
  - Disabled state is **not** hiding; widgets remain visible
  - Save button is disabled if attendance is not `present`
- [ ] **Server-side enforcement (Firestore rules):**
  - Firestore security rule rejects any write to `evaluations.memorization|revision` if `attendanceStatus != present`
  - Rule applies to both create and update operations
- [ ] **Error handling:**
  - Server rejection shows user-friendly message: "Only students marked present can have progress recorded"
- [ ] Unit + integration tests pass (10+ tests)

**Definition of Done:**
- UI state management prevents progress input when `attendanceStatus != present`
- Firestore rule written and tested (`firebase-rules-unit-testing`)
- Manual test on device: select `absent` → verify input is grayed out → verify save fails if attempted
- Code review approved

**Example Firestore Rule:**
```javascript
allow update: if request.auth.uid != null &&
  (request.resource.data.attendanceStatus == "present" ||
   request.resource.data.memorization == null);
```

---

### T7: Update Firestore Security Rules

**Category:** Security & Permissions
**Duration:** 1 day
**Depends On:** T1, T3
**Blocks:** T9

**Description:**
Update Firestore security rules to enforce Constitution § 11 (least privilege, role validation, parent isolation).

**Acceptance Criteria:**
- [ ] **Role validation:**
  - All rules read `users/{uid}.role` from Firestore (never trust client claims)
  - Teachers can read/write evaluations for own madrasa only
  - Parents can read only children (where `students.parentPhones` contains parent phone)
  - Admins can read/write all within own madrasa
- [ ] **Data isolation:**
  - Parent cannot read sibling's data (security test: query returns 0 results for other children)
  - Teacher cannot modify another madrasa's evaluations (security test: write rejected)
- [ ] **Attendance constraint (from T6):**
  - Rule prevents writing progress when `attendanceStatus != present`
- [ ] **Audit fields:**
  - `updatedAt` and `updatedBy` are server-set (client cannot override)
- [ ] Security tests pass (15+ tests using `firebase-rules-unit-testing`)

**Definition of Done:**
- `firestore.rules` file updated and tested
- All security rules reviewed by a second developer
- Tests demonstrate: parent isolation, teacher isolation, attendance blocking, role validation
- Code review approved

---

### T8: Write Unit, Integration & Security Tests

**Category:** Testing
**Duration:** 3 days
**Depends On:** T3, T4, T5, T6
**Blocks:** T9

**Description:**
Write comprehensive test suite covering business logic, UI flows, and security constraints.

**Acceptance Criteria:**
- [ ] **Unit tests (50+ tests):**
  - `evaluation_entity_test.dart` — range validation (20 tests)
  - `evaluation_repository_test.dart` — CRUD, audit fields (15 tests)
  - `progress_input_widget_test.dart` — UI state, validation feedback (10 tests)
  - `attendance_blocking_logic_test.dart` — absence/excused blocking (5 tests)
- [ ] **Integration tests (15+ tests):**
  - `student_detail_screen_test.dart` — user flow: select attendance → record progress → save (5 tests)
  - Navigation tests: detail screen → edit history → back (3 tests)
  - Error handling: invalid input → show error message → allow retry (3 tests)
  - Edit latency test: editing 100-item history performs in <1s (1 test)
- [ ] **Security tests (15+ tests, using firebase-rules-unit-testing):**
  - Parent cannot read other students (3 tests)
  - Teacher cannot modify other madrasa evaluations (3 tests)
  - Absent attendance blocks progress write (3 tests)
  - Audit fields cannot be overridden by client (3 tests)
  - Role validation enforced (3 tests)
- [ ] **Coverage:** Minimum 85% code coverage (excluding generated files)
- [ ] CI/CD: All tests pass in GitHub Actions on every PR

**Definition of Done:**
- All test files created and passing
- `flutter test` runs in <5 minutes locally
- CI/CD pipeline shows green checkmark
- Code coverage report generated (85%+ documented)

---

### T9: Manual QA & Bug Fixes

**Category:** Testing & Deployment
**Duration:** 2 days
**Depends On:** T8
**Blocks:** T10

**Description:**
Test the feature on real devices, across role scenarios, and document any bugs found.

**Acceptance Criteria:**
- [ ] **Teacher flow QA (iOS & Android):**
  - Log in as teacher; navigate to Student Details
  - Record attendance for 5 students (varied statuses: present, absent, excused)
  - Record memorization/revision for 2 students
  - Edit one previous record; verify audit fields are updated
  - No crashes or visual glitches
- [ ] **Parent flow QA:**
  - Log in as parent; view child's records
  - Verify cannot edit or modify data
  - Verify notifications appear for absent student
  - No crashes
- [ ] **Admin flow QA:**
  - Log in as admin; generate PDF report (date filter, class filter)
  - Verify report includes all students' attendance & progress
  - No sensitive data exposure
- [ ] **Performance checks:**
  - Teacher Home loads in <2 seconds
  - Student Details loads in <1 second
  - Edit history (100 items) scrolls smoothly
  - No memory leaks (check with DevTools)
- [ ] **Data integrity:**
  - Create evaluation as teacher; verify `createdAt`, `createdBy` are set
  - Edit evaluation; verify `updatedAt`, `updatedBy` are set
  - Verify `dayKey` is always in `YYYY-MM-DD` format
  - Export data; spot-check 10 evaluations match UI
- [ ] **Bug tracking:**
  - All bugs found logged in GitHub Issues with severity, steps to reproduce
  - Critical bugs (crashes, data loss) fixed before T10
  - Non-critical bugs (cosmetic) logged for Phase 2

**Definition of Done:**
- QA checklist signed off by QA lead
- All critical bugs resolved
- Release notes drafted with feature description & known issues (if any)
- Ready for production deployment

---

### T10: Deploy to Production

**Category:** Deployment & Docs
**Duration:** 0.5 days
**Depends On:** T9
**Blocks:** None (last task)

**Description:**
Deploy the feature to production, monitor for errors, and communicate rollout.

**Acceptance Criteria:**
- [ ] **Code deployment:**
  - Feature merged to main branch
  - Version bumped (follow semver)
  - APK/IPA built and released to Play Store / App Store (or internal beta)
- [ ] **Database & rules deployment:**
  - Firestore security rules deployed to production
  - Composite indexes verified as active
  - Firestore schema changes reflected in live database
- [ ] **Monitoring:**
  - Error logging enabled; Firebase Crashlytics monitored for 24 hours
  - Firestore latency metrics monitored (target: <200ms for queries)
  - User feedback channels open (in-app feedback, support email)
- [ ] **Communication:**
  - Release notes published (in-app, app store, Slack)
  - Stakeholders notified (product, support, admins)
  - Documentation updated (wiki, README.md, Constitution)
- [ ] **Rollback plan:**
  - Feature flag added (if not already; for future A/B testing)
  - Rollback steps documented: revert commit, revert Firestore rules, clear cache
  - Tested rollback procedure on staging

**Definition of Done:**
- Feature live in production
- No critical errors in monitoring (24-hour period)
- Stakeholders confirm receipt of release notes
- Documentation updated
- Rollback plan tested & ready

---

## Dependency Graph

```
T1 (Schema)
  ↓
T2 (Indexes) ─┐
  ↓           ├→ T3 (Repository)
  ↓           │    ↓
  └─────→ T4 (UI Screens)
             ↓
             ├→ T5 (Edit Logic)
             ├→ T6 (Absence Blocking)
             ↓
       ┌─────┴─────┬───────┐
       ↓           ↓       ↓
  T7 (Security) T8 (Tests)
       ↓           ↓
       └─────┬─────┘
             ↓
          T9 (QA)
             ↓
         T10 (Deploy)
```

---

## Cross-Cutting Concerns

### Constitution Alignment Checklist (All Tasks)

Every task above must satisfy:
- [ ] **Principle 1:** UI flows are teacher-efficient (no extra taps/screens)
- [ ] **Principle 2:** Daily data stored only in `evaluations`
- [ ] **Principle 3:** No "End of Day" or multi-day workflows
- [ ] **Principle 4:** Schema changes are additive; no breaking migrations
- [ ] **Principle 5:** Absent students cannot record progress (enforced)
- [ ] **Security (§ 11):** Role validation, parent isolation, least privilege

---

## Completion & Sign-Off

- [ ] All tasks completed & QA approved
- [ ] Code review sign-off: ________ Date: ________
- [ ] QA sign-off: ________ Date: ________
- [ ] Product sign-off: ________ Date: ________

---

## References

- Constitution § 5: Data Model Policy
- Constitution § 6: Attendance & Progress Rules
- Constitution § 7: Editing Policy
- Constitution § 10: Indexing & Query Policy
- Constitution § 11: Security Rules Policy
- Constitution § 12: Implementation Standards
- Plan: `plan.md` (architecture & rollout)
