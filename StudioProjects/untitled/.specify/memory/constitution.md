<!--
SYNC IMPACT REPORT
=======================
Version Change: N/A → 1.0.0 (Initial adoption)
Date: 2026-03-02
Status: CREATED

New Sections Established:
- 13 core governance principles
- Authentication policy (teacher/admin + parent phone UI)
- Data model policy aligned to existing Firestore schema
- Business rules for attendance and progress
- FCM notifications policy
- Security & permissions framework
- Implementation standards (feature modules)
- Scope boundaries (V1)

Templates Requiring Updates:
- .specify/templates/spec-template.md (create)
- .specify/templates/plan-template.md (create)
- .specify/templates/tasks-template.md (create)

Deferred Items:
- None; all principle domains fully specified

Next Steps:
1. Create dependent templates referencing these principles
2. Apply constitution checks in spec/plan review workflow
3. Document feature alignment to principles
-->

# Quran Madrasa Management System — Project Constitution

**Version:** 1.0.0
**Ratified:** 2026-03-02
**Last Amended:** 2026-03-02
**Status:** ACTIVE

---

## 1. Mission

Build a simple, reliable Quran madrasa management app where:
- **Teachers** can take attendance and record memorization/revision with minimal taps.
- **Parents** can log in with a phone-number UI, view only their children, and receive essential notifications.
- **Admins** can manage classes/students and export reports (PDF/Excel).

The system preserves existing data structures while adding essential recording and reporting capabilities for daily madrasa operations.

---

## 2. Product Principles

These five principles guide all architectural, feature, and UI/UX decisions:

### Principle 1: Teacher-First UX
Attendance must be fast and inline. Progress is recorded on the student detail screen with minimal friction. No unnecessary summary or "End of Day" workflow in V1.

**Rationale:** Teachers operate under time constraints during class. Every additional tap or navigation step reduces adoption and accuracy.

### Principle 2: One Source of Truth
Daily student activity is stored exclusively in the `evaluations` collection. No duplicate recording of attendance, progress, or notes across other collections.

**Rationale:** Data consistency is critical for reporting and parent communication. Duplicated state leads to sync errors and audit failures.

### Principle 3: No Unnecessary Flows
V1 scope excludes "End of Day" buttons, summary screens, multi-day workflows, and async operations that require user acknowledgment.

**Rationale:** Simpler flows reduce bugs, support faster feature delivery, and match teacher expectation (daily, in-class work).

### Principle 4: Data Continuity
Preserve existing Firestore collections and data. Only **additive** changes are allowed; no breaking migrations of student records, class definitions, or user roles.

**Rationale:** Existing madrasas have live data and user workflows. Breaking changes risk data loss and user disruption.

### Principle 5: Prevent Mistakes by Design
Absent or excused students **cannot** have progress (memorization/revision) recorded for that day. The UI must disable or hide progress input when attendance status is not `present`.

**Rationale:** Recording progress for a non-attending student is nonsensical and indicates a UX/workflow error.

---

## 3. Roles & Permissions (App-Level)

The system enforces three discrete roles with capability boundaries:

### 3.1 Teacher
**Capabilities:**
- Read/write students within their assigned madrasa
- Read/write evaluations (attendance, memorization, revision, notes)
- Edit previously recorded progress entries (with audit trail)
- View absence alerts
- Receive notifications (if applicable)

**Constraints:**
- Cannot modify class definitions, user accounts, or other madrasas' data
- Cannot access parent-only features

### 3.2 Parent
**Capabilities:**
- Read-only access to their children's records (evaluations, progress history)
- Receive push notifications (absence without excuse, behavior notes)
- View attendance summary and memorization progress

**Constraints:**
- Cannot record or modify any data
- Cannot access other students' data
- Cannot access admin/teacher interfaces

### 3.3 Admin
**Capabilities:**
- Full control within the madrasa: classes, students, users, role assignments
- Generate and export reports (PDF, Excel)
- View audit trails and system logs
- Manage FCM token registrations

**Constraints:**
- Must not bypass role checks in Firestore security rules
- Reports and exports must respect data residency (own madrasa only)

---

## 4. Authentication Policy

### 4.1 Teacher & Admin
- Use **email/password** authentication via Firebase Auth.
- Existing process is respected; no breaking changes to enrollment or credential storage.

### 4.2 Parent (Phone UI with Email/Password Backend)
- Parent uses **phone number UI** for login (UX layer).
- Backend maps phone to a derived fake email:
  - **Email format:** `parent<phoneDigits>@example.local`
  - **Password:** `<phoneDigits>` (same as phone)
- Parent identity is a **Firebase Auth UID**, which must map to a `users/{uid}` document with `role = "parent"`.
- Parent's stored `users.phone` field must match the login phone (normalized consistently).

**Rationale:** Parents in madrasas often lack formal email; phone-based login is familiar and reduces friction. The email/password backend allows standard Firebase Auth without custom providers.

---

## 5. Data Model Policy (Aligned to Current Schema)

All changes are **additive**. Existing collections and fields remain untouched unless extended.

### 5.1 Core Collections (Existing)
- `students` — student records, class assignments, parent links
- `classes` — class definitions (level/grade), madrasa assignments
- `evaluations` — daily student activity (attendance, progress, notes)
- `users` — teacher, admin, and parent accounts with role assignments
- `teachers` — teacher metadata (madrasa, active status)
- `notifications` — push notification log
- `absence_alerts` — alert records (deprecated or legacy; prefer evaluations)
- `settings` — app-level configuration

### 5.2 Required Additive Fields (V1)

#### evaluations Collection
- **`dayKey`** (string, format `YYYY-MM-DD`)
  - Required. Enforces one evaluation per student per day.
  - Indexed with `studentId` for fast lookups.
- **`updatedAt`** (timestamp, optional)
  - Set on record creation and any edit.
- **`updatedBy`** (string, optional)
  - UID of the teacher who last updated the record.

#### evaluations.memorization & evaluations.revision Maps
Both use the same shape:
- **`fromSurah`** (int) — starting surah number
- **`fromVerse`** (int) — starting verse number
- **`toSurah`** (int) — ending surah number
- **`toVerse`** (int) — ending verse number
- **`totalVerses`** (int) — computed count (toSurah–fromSurah + 1, or precise count)

These fields allow tracking progress across ranges (e.g., Surah 1 Verse 1 to Surah 2 Verse 50).

### 5.3 Parent–Child Link (Using Existing Data)
- Parent access to children is determined by:
  - `students.parentPhones` (array<string>) — list of parent phone numbers.
- Parent's `users.phone` must match one entry in `students.parentPhones` (normalized consistently).
- Security rules enforce this constraint at the Firestore level (no parent can read students where their phone is absent).

---

## 6. Attendance & Progress Rules (Business Rules)

### 6.1 Attendance Status Canonical Values
V1 recognizes three statuses:
- **`present`** — student attended
- **`absent`** — student did not attend (no excuse)
- **`excused`** — student did not attend (with excuse)

### 6.2 Default Attendance Behavior
- **Teacher Home** defaults each student to `present` for the selected day **if no evaluation exists**.
- If a teacher navigates to a student and no evaluation is recorded, UI shows `present` (not `null` or blank).
- Teacher can change this to `absent` or `excused` before recording progress.

### 6.3 Progress Recording Rules
- **If `attendanceStatus = absent`:** Progress recording is **forbidden** (UI disables input, server rejects writes).
- **If `attendanceStatus = excused`:** Progress recording is **forbidden** (same enforcement).
- **If `attendanceStatus = present`:** Memorization and/or revision can be recorded.

**Rationale:** Recording progress for a student who did not attend is illogical and indicates a teacher error. Preventing it at the UI and database levels enforces data integrity.

---

## 7. Editing Policy (Critical)

### 7.1 Editability
- Memorization and revision entries **can be edited** after initial recording.
- Edits are **not** deletions; the record and audit trail remain.

### 7.2 Edit Constraints
Any edit must:
1. **Preserve valid range ordering:** `fromSurah ≤ toSurah`; if `fromSurah == toSurah`, then `fromVerse ≤ toVerse`. No inverted ranges.
2. **Update audit fields:** Set `updatedAt` and `updatedBy` on every edit.
3. **Update `students.currentProgress` only if this evaluation is the latest relevant record:**
   - If the edited evaluation is the most recent one for that student (across all evaluations), update `students.currentProgress` to reflect the new range.
   - If it is not the latest (newer evaluations exist), leave `students.currentProgress` unchanged.

**Rationale:** Edit audit trails prevent data loss and support reconciliation. Conditional `currentProgress` updates ensure that older edits do not overwrite newer memorization milestones.

---

## 8. Notifications Policy (FCM)

### 8.1 Storage & Delivery
- Notifications are stored in the `notifications` collection.
- Delivery is via Firebase Cloud Messaging (FCM).
- `users.fcmToken` is the primary FCM registration token.

### 8.2 V1 Notification Triggers
- **Absence without excuse:** When a teacher records `attendanceStatus = absent` for a student, a notification is sent to all parent UIDs linked to that student.
- **Behavior notes:** If behavior notes are recorded in `evaluations.notes` (or a dedicated collection if added), notifications are sent based on note severity and configured rules.

### 8.3 Document Schema
Every `notifications` document must include:
- **`userId`** (string) — recipient UID
- **`title`** (string) — notification title
- **`body`** (string) — notification body
- **`data`** (map, optional) — custom data (e.g., `studentId`, `evaluationId`)
- **`createdAt`** (timestamp) — creation time
- **`read`** (boolean) — read/unread status

---

## 9. Reporting & Export Policy

### 9.1 Access Control
- Exports (PDF, Excel) are **admin-only**. No teacher or parent can generate exports.

### 9.2 Filtering
Reports must be filterable by:
- **Date range** (start date to end date)
- **Class** (level/grade)
- **Student** (individual student or all students in a class)

### 9.3 Implementation Context
- Exports should be generated in a **trusted context**:
  - **Phase 1 (V1):** Device-side export (Flutter app generates PDF/Excel locally).
  - **Phase 2 (future):** Cloud Function (server-side, more scalable, audit trail).
- Device-side exports are acceptable for V1 (limited data volume, no sensitive credential exposure).

---

## 10. Indexing & Query Policy (Performance)

Composite indexes are required for:

1. **`evaluations`** by `(studentId, dayKey)`
   - Fast lookup of a student's evaluation for a given day.

2. **`evaluations`** by `(classId, dayKey, date)`
   - Fast lookup of all students' evaluations for a class on a specific day (supporting Teacher Home).

3. **`evaluations`** by `(studentId, date)`
   - Historical queries for a student across date ranges (supporting Parent Portal history view).

4. **`students`** by `(classId, active)`
   - Fast lookup of active students in a class (supporting Teacher Home filters).

**Policy:** No feature is considered "done" if it requires slow full-collection scans. Queries must be indexed.

---

## 11. Security Rules Policy (Firestore)

### 11.1 Least Privilege Principle
- **Parents** read only children where `students.parentPhones` contains their phone.
- **Teachers** read/write evaluations for students within their assigned madrasa.
- **Admins** operate within their madrasa only (no cross-madrasa access unless explicitly scoped).

### 11.2 Role Validation
- **Never trust client-submitted role claims.** Always read `users/{uid}.role` from Firestore in security rules.
- Client-side role checks (UI visibility) are for UX; server-side role checks are mandatory.

### 11.3 Data Isolation
- **Avoid exposing other students' data to parents under any condition.**
  - No "view all students in class" queries for parents.
  - No leakage of sibling data if one child is linked to a parent.
- Queries must be filtered by the parent's children list before return.

---

## 12. Implementation Standards

### 12.1 Feature Modules
The Flutter app uses feature-based modularity:
- **`auth`** — authentication (teacher/admin email, parent phone)
- **`teacher_home`** — daily list, attendance, filtering
- **`student_details`** — progress recording, history, edit UI
- **`parent_portal`** — read-only child records, notifications
- **`admin_reports`** — export and reporting tools
- **`notifications`** — FCM token management, notification display

### 12.2 Date Normalization
- All dates used in daily flows **must be normalized to `dayKey = YYYY-MM-DD`** format (UTC, no time component).
- Avoid time-of-day sensitivity; treat all evaluations as "the day's record" regardless of creation time.

### 12.3 Phone Number Normalization
- Phone numbers must be normalized consistently across `users.phone`, `students.parentPhones`, and login forms.
  - Suggested: store as **E.164 format** (e.g., `+201001234567`) or **digits-only** (e.g., `201001234567`).
  - **Choose one canonical format and enforce it everywhere** (database, login UI, queries).

---

## 13. Scope Boundaries (V1)

### 13.1 Included Features
- **Teacher daily list:** date selection, class filter, name search
- **Inline attendance:** record `present/absent/excused` on the daily list
- **Student details screen:** progress recording (memorization/revision), history view, edit UI
- **Parent portal:** read-only child records, attendance summary, progress timeline
- **Admin exports:** PDF and Excel reports, filterable by date/class/student
- **Push notifications:** absence alerts, behavior notes (if added)

### 13.2 Excluded Features (Deferred to Later Phases)
- AI suggestions for daily memorization targets
- End-of-day summary or confirmation flow
- Multi-teacher complexity (e.g., co-teachers, hierarchical assignment)
- WhatsApp/SMS notifications (FCM only in V1)
- Student/parent mobile app (web or Flutter web dashboard only in V1, native iOS/Android deferred)
- Attendance QR codes or biometric integration
- Family account linking beyond phone-based parent mapping

---

## Governance

### Amendment Procedure
If project principles, policies, or scope require revision:
1. **Document** the issue with concrete examples or failing use cases.
2. **Assess** the impact on existing code, data model, and security posture.
3. **Determine version bump:**
   - **MAJOR (X.0.0):** Principle removal, backward-incompatible governance change, or role/permission redefinition.
   - **MINOR (0.X.0):** New principle, new policy section, or materially expanded guidance.
   - **PATCH (0.0.X):** Clarifications, wording refinements, non-semantic updates, typo fixes.
4. **Update constitution** and all dependent templates (spec, plan, task templates).
5. **Commit** with message: `docs: amend constitution to vX.Y.Z (<reason>)`

### Versioning Policy
- **Backward compatible updates** (clarifications, additions) bump MINOR.
- **Clarifications that do not change enforcement** bump PATCH.
- **Principle removals or role redefinitions** bump MAJOR.

### Compliance Review
- **Code review checklist** references this constitution's principles.
- **Spec sign-off** confirms alignment to principles and policies.
- **Release notes** document constitution version in effect.

---

## References & Related Artifacts

- `.specify/templates/spec-template.md` — Feature specification template (aligned to 13 principles)
- `.specify/templates/plan-template.md` — Architecture plan template (Constitution checks embedded)
- `.specify/templates/tasks-template.md` — Task breakdown template (Principle-driven categorization)
- `README.md` — Quick reference and project navigation
- `firestore_full_schema.json` — Live Firestore structure (Principle 4: Data Continuity)

---

**Last Review:** 2026-03-02
**Next Review:** 2026-06-02 (quarterly)
