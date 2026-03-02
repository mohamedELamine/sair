# Implementation Plan Template

Use this template after a feature spec is approved. Capture architecture, dependencies, and detailed task breakdown.

---

## Header

**Feature:** [FEATURE_NAME]
**Status:** [DRAFT|REVIEW|APPROVED|IN_PROGRESS]
**Planned Duration:** [X days]
**Owner:** [YOUR_NAME]
**Created:** [YYYY-MM-DD]
**Last Updated:** [YYYY-MM-DD]

---

## 1. Architecture Overview

### High-Level Design
[ASCII diagram or prose description of how components interact]

Example (Principle 4: Data Continuity):
```
Teacher Home (UI)
    ↓
student_details module
    ↓
evaluations collection (Firestore)
    ↓ (single source)
parent_portal, admin_reports (read-only)
```

### Module Dependencies
(Reference Constitution § 12.1: Feature Modules)

| Module | Depends On | Why |
|--------|-----------|-----|
| `teacher_home` | `auth`, `student_details` | Displays students, launches detail view |
| `student_details` | `auth` | Requires authenticated teacher context |
| `parent_portal` | `auth`, `notifications` | Lists children, receives push |

---

## 2. Constitution Alignment Review

### Principle 1: Teacher-First UX
**Plan adherence:**
- [ ] No more than 2 screens for this feature
- [ ] Attendance/progress entry on single screen (no modal overflow)
- [ ] Keyboard shortcuts or bulk actions considered

**Evidence:**
[Describe how the design keeps interaction count low]

### Principle 2: One Source of Truth
**Plan adherence:**
- [ ] All daily activity writes to `evaluations` only
- [ ] No mirror data in `absence_alerts` or other collections
- [ ] Queries read from single source

**Schema rule:**
- New fields in `evaluations` collection: [list]
- No new collections created: [Yes|No — if No, justify]

### Principle 3: No Unnecessary Flows
**Plan adherence:**
- [ ] No "End of Day" or summary dialog
- [ ] No multi-day workflows
- [ ] No async operations requiring user confirmation

**Deferred:**
[Any related features pushed to Phase 2+]

### Principle 4: Data Continuity
**Plan adherence:**
- [ ] No breaking migrations
- [ ] Schema changes are additive only
- [ ] Existing data unaffected

**Migration strategy:**
[How will old documents behave with new schema? Do defaults apply?]

### Principle 5: Prevent Mistakes by Design
**Plan adherence:**
- [ ] Absent attendance → progress input disabled (or hidden)
- [ ] UI prevents invalid state before server write
- [ ] Server-side validation rejects invalid requests

**Enforcement:**
- UI-level: [How is this prevented in the Flutter widget?]
- Server-level (Firestore rules): [Security rule that blocks write if absent?]

### Security (Constitution § 11)
**Plan adherence:**
- [ ] Role validation: Always read `users/{uid}.role` from Firestore
- [ ] Parent isolation: Parent reads only children in `students.parentPhones`
- [ ] Least privilege: Teachers access only own madrasa students

**Firestore rule examples:**
```javascript
// Example: Parent can read only their children
allow read: if request.auth.uid != null &&
  get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == "parent" &&
  resource.data.parentPhones.contains(userPhone);
```

---

## 3. Data Model & Schema Changes

### Firestore Collections

**Collection: `evaluations`** (Modified)
```
- dayKey: string (required, format YYYY-MM-DD)
- studentId: string (required, indexed with dayKey)
- classId: string (optional, indexed for Teacher Home queries)
- attendanceStatus: string (enum: present|absent|excused)
- memorization: map (optional)
  - fromSurah, fromVerse, toSurah, toVerse, totalVerses
- revision: map (optional)
  - fromSurah, fromVerse, toSurah, toVerse, totalVerses
- notes: string (optional)
- updatedAt: timestamp (optional, set on edit)
- updatedBy: string (optional, UID of editor)
- createdAt: timestamp (auto-set)
- createdBy: string (auto-set, UID of creator)
```

**Indexes Required** (Constitution § 10):
- `(studentId, dayKey)` — primary query path
- `(classId, dayKey, date)` — Teacher Home daily view
- `(studentId, date)` — Parent history view

### Additive Fields Only
- If modifying existing collections, list new fields:
  - `fieldName` (type) — validation rule

### Data Validation Rules
- `dayKey` format: `^\d{4}-\d{2}-\d{2}$`
- Range validation: `fromSurah ≤ toSurah`; if equal, `fromVerse ≤ toVerse`
- Attendance status: one of `["present", "absent", "excused"]`

---

## 4. Feature Modules & Code Structure

(Reference Constitution § 12.1)

### Module: `student_details`
**Responsibility:** Display student record, record progress, edit history
**Files:**
- `lib/features/student_details/presentation/screens/student_detail_screen.dart`
- `lib/features/student_details/presentation/widgets/progress_input_widget.dart`
- `lib/features/student_details/data/repositories/evaluation_repository.dart`
- `lib/features/student_details/domain/entities/evaluation.dart`

**Public API:**
- `StudentDetailScreen(studentId: String)` — main screen
- `EvaluationRepository.updateProgress(studentId, dayKey, progress)` — write method
- `EvaluationRepository.getHistory(studentId, limit)` — read method

### Module: `teacher_home`
**Responsibility:** Daily attendance list, filtering, navigation to detail
**Public API:**
- `TeacherHomeScreen()` — main screen
- `StudentListWidget(classId, date)` — reusable list component

---

## 5. API Contracts & Message Types

(Reference Constitution § 4.2 for parent phone authentication)

### Firestore Collections (Write Paths)
**Create evaluation:**
```
POST /evaluations
{
  studentId: "student_123",
  classId: "class_456",
  dayKey: "2026-03-02",
  attendanceStatus: "present",
  memorization: { fromSurah: 1, fromVerse: 1, toSurah: 2, toVerse: 50, totalVerses: 79 },
  createdAt: <server timestamp>,
  createdBy: <auth uid>,
  updatedAt: null,
  updatedBy: null
}
```

**Update evaluation (edit):**
```
PATCH /evaluations/{evalId}
{
  memorization: { fromSurah: 1, fromVerse: 1, toSurah: 3, toVerse: 10, totalVerses: 130 },
  updatedAt: <server timestamp>,
  updatedBy: <auth uid>
}
```

**Constraints:**
- No field can be updated to an invalid state (e.g., inverted range)
- If `attendanceStatus` is `absent|excused`, progress maps must be null/empty
- `updatedAt` and `updatedBy` are set atomically by Cloud Function or server rule

### Error Responses
| Status | Message | Handling |
|--------|---------|----------|
| 400 | "Invalid dayKey format" | Show input error to teacher |
| 403 | "Absent students cannot record progress" | Disable progress UI |
| 409 | "Range validation failed" | Highlight invalid verse entry |

---

## 6. Testing Plan

### Unit Tests
**File:** `test/features/student_details/domain/entities/evaluation_test.dart`
- [ ] Range validation: `fromSurah > toSurah` raises error
- [ ] `dayKey` format validation: accepts `YYYY-MM-DD`, rejects other formats
- [ ] Audit field updates: `updatedAt` and `updatedBy` set on edit

**File:** `test/features/student_details/data/repositories/evaluation_repository_test.dart`
- [ ] `updateProgress()` throws if attendance is `absent`
- [ ] `getHistory()` returns records sorted by date descending

### Integration Tests
**File:** `test/features/student_details/presentation/screens/student_detail_screen_test.dart`
- [ ] User enters memorization range; "Save" button is enabled
- [ ] User selects `absent` attendance; progress input is disabled
- [ ] User edits a previous entry; `updatedBy` is set to current teacher

### Security Tests (Firestore Rules)
- [ ] Parent cannot read sibling's data
- [ ] Teacher cannot modify attendance for another madrasa's students
- [ ] Admin export respects madrasa boundary

**Test tools:**
- `firebase-rules-unit-testing` for Firestore rules
- `mockito` for repository mocks
- `flutter_test` for widget tests

---

## 7. Rollout & Deployment Plan

### Phase 1: Internal QA (Days 1–3)
- [ ] Unit & integration tests passing (100% coverage for new code)
- [ ] Manual testing on device (both teacher and parent flows)
- [ ] Firestore rules deployed to staging

### Phase 2: Beta Release (Day 4)
- [ ] Feature flag enabled for beta testers
- [ ] Monitoring: log errors, slow queries
- [ ] Collect user feedback

### Phase 3: General Release (Day 5)
- [ ] Feature flag enabled for all users
- [ ] Rollback plan ready (revert feature flag, restore old schema)
- [ ] Release notes published

### Rollback Plan
If critical issues arise:
1. Disable feature flag (users see old UI)
2. Revert Firestore rules to previous version
3. Investigate data corruption (none expected if writes were validation-gated)
4. Deploy hotfix

---

## 8. Task Breakdown

Each task should map to a "Definition of Done" (see `tasks-template.md`).

| Task ID | Title | Duration | Depends On |
|---------|-------|----------|-----------|
| T1 | Update evaluations schema; add dayKey, updatedAt, updatedBy | 0.5d | — |
| T2 | Create Firestore indexes (3 composite indexes) | 0.5d | T1 |
| T3 | Implement EvaluationRepository (CRUD) | 2d | T1 |
| T4 | Create student_details module & UI screens | 3d | T3 |
| T5 | Add range validation & edit logic | 2d | T4 |
| T6 | Implement absence → progress blocking | 1d | T4 |
| T7 | Update Firestore security rules | 1d | T3 |
| T8 | Write unit & integration tests | 3d | T3, T4, T5, T6 |
| T9 | Manual QA & bug fixes | 2d | T8 |
| T10 | Deploy to production | 0.5d | T9 |

**Critical path:** T1 → T3 → T4 → T5 → T8 → T9 → T10 (~12 days)

---

## 9. Known Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Old evaluations lack `dayKey` | Queries break | Backfill script; graceful degradation |
| Phone normalization inconsistent | Parent access fails | Enforce E.164 format at login |
| Firestore rule complexity | Rules reject valid requests | Unit test all rule paths |
| Performance: `evaluations` scans | Slow Teacher Home | Ensure indexes on (studentId, dayKey) |

---

## 10. Documentation & Communication

### Developer Notes
- [Any implementation gotchas or tips for the team]

### User Facing Changes
- [New screens, buttons, workflows teachers/parents see]

### Stakeholder Communication
- [Release notes, announcements]

---

## 11. Sign-Off

- [ ] Tech Lead: ________ Date: ________
- [ ] Product Owner: ________ Date: ________
- [ ] QA Lead: ________ Date: ________

---

## Appendices

### A. Detailed Task Specs
[For each task ID, expand with acceptance criteria and code examples]

### B. Firestore Rules (Complete)
[Full security rules file with comments]

### C. Entity Diagrams
[Data model ER diagram or Mermaid UML]

### D. References
- Constitution § 5: Data Model Policy
- Constitution § 6: Attendance & Progress Rules
- Constitution § 7: Editing Policy
- Constitution § 10: Indexing & Query Policy
- Constitution § 11: Security Rules Policy
