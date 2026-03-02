# Feature Specification Template

Use this template when defining a new feature for the Quran Madrasa system.

---

## Header

**Feature Name:** [FEATURE_NAME]
**Status:** [DRAFT|REVIEW|APPROVED|IMPLEMENTED]
**Owner:** [YOUR_NAME]
**Created:** [YYYY-MM-DD]
**Last Updated:** [YYYY-MM-DD]
**Constitution Alignment:** [See section 6 below]

---

## 1. Overview

**One-sentence summary:**
[Describe the feature in one sentence. Example: "Teachers can edit previously recorded progress entries with an audit trail."]

**Why this feature:**
[Explain the business need and user pain point.]

**User roles affected:**
- [ ] Teacher
- [ ] Parent
- [ ] Admin

---

## 2. User Stories & Acceptance Criteria

### User Story 1: [ROLE] can [ACTION]
**As a** [ROLE],
**I want to** [ACTION],
**So that** [BENEFIT].

**Acceptance Criteria:**
- [ ] [Criterion 1 — measurable, testable]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

**Out of Scope (this feature):**
- [Any related but deferred item]

### User Story 2: [ROLE] ...
[Repeat format for additional stories]

---

## 3. Data Model Changes

### New Collections
(If any)
- `collection_name` — brief description
  - `field` (type) — purpose

### Additive Fields (Existing Collections)
(Reference Constitution § 5.2 for required fields)

**Collection: `[NAME]`**
- `newField` (type, optional|required) — description
  - Validation rule (if any)
  - Indexed? Yes|No

---

## 4. API & Messaging

**New Message Types** (if applicable):
- `MESSAGE_NAME` — request/response structure
  - Payload fields
  - Error cases

**Modified Collections:**
- None | [List]

**New Firestore Paths/Queries:**
(Reference Constitution § 10: Indexing & Query Policy)
- `evaluations` by `(studentId, dayKey)` — is this used?

---

## 5. UI/UX Flow

### Screen 1: [SCREEN_NAME]
**Visible to:** [ROLE]
**Entry point:** [How user reaches this screen]
**Layout:**
- [Component 1: description]
- [Component 2: description]
- [Action button: description]

**Business Logic:**
- [Logic rule 1 — e.g., attendance status validation]
- [Logic rule 2]

### Screen 2: [SCREEN_NAME]
[Repeat for additional screens]

---

## 6. Constitution Alignment Check

**Principle 1: Teacher-First UX**
- [ ] Workflow requires ≤3 taps
- [ ] No unnecessary summary screens
- [ ] Clear, single-purpose actions

**Principle 2: One Source of Truth**
- [ ] Data stored only in `evaluations` (no duplication)
- [ ] No parallel collections for daily activity
- [ ] Queries read from single source

**Principle 3: No Unnecessary Flows**
- [ ] No "End of Day" logic added
- [ ] No multi-day confirmation steps
- [ ] V1 scope respected

**Principle 4: Data Continuity**
- [ ] No breaking migrations
- [ ] Only additive schema changes
- [ ] Existing data preserved

**Principle 5: Prevent Mistakes by Design**
- [ ] Absent/excused attendance blocks progress input
- [ ] UI disables unavailable actions (not hidden)
- [ ] Server-side validation enforced

**Security (§ 11):**
- [ ] Role validation via Firestore rules
- [ ] Parent isolation enforced
- [ ] No cross-madrasa data leakage

---

## 7. Implementation Notes

### Dependencies
- [Other features, collections, or APIs this depends on]

### Known Risks
- [Any technical or design risks identified]

### Rollout Plan
- [Phase 1: ... | Phase 2: ...]

---

## 8. Testing Strategy

**Unit Tests:**
- [Test case 1: e.g., "range validation accepts valid surah-verse pairs"]
- [Test case 2]

**Integration Tests:**
- [Test case 1: e.g., "editing progress updates audit fields"]
- [Test case 2]

**Security Tests:**
- [Parent cannot access sibling data]
- [Absent attendance blocks progress save]

---

## 9. Sign-Off

- [ ] Product Owner: ________ Date: ________
- [ ] Tech Lead: ________ Date: ________
- [ ] Constitution Review: ________ Date: ________

---

## Appendices

### A. Wireframes / Mockups
[Link or embed UI mockups]

### B. Data Examples
```json
{
  "evaluationId": "eval_123",
  "studentId": "student_456",
  "dayKey": "2026-03-02",
  "attendanceStatus": "present",
  "memorization": {
    "fromSurah": 1,
    "fromVerse": 1,
    "toSurah": 2,
    "toVerse": 50,
    "totalVerses": 79
  }
}
```

### C. References
- Constitution § 5: Data Model Policy
- Constitution § 6: Attendance & Progress Rules
- Constitution § 7: Editing Policy
- `firestore_full_schema.json` — current live schema
