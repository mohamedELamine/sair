# Quran Madrasa Constitution — Quick Reference

**Version:** 1.0.0 | **Status:** ACTIVE | **Last Updated:** 2026-03-02

---

## The 5 Core Principles

| Principle | Core Rule |
|-----------|-----------|
| **Teacher-First UX** | Attendance is fast & inline; no unnecessary flows |
| **One Source of Truth** | All daily activity in `evaluations`; no duplication |
| **No Unnecessary Flows** | No "End of Day" or multi-day summaries in V1 |
| **Data Continuity** | Preserve existing collections; additive changes only |
| **Prevent Mistakes by Design** | Absent/excused students cannot record progress |

---

## 3 Roles & Capabilities at a Glance

### Teacher
✅ Read/write students & evaluations (own madrasa)
✅ Edit progress with audit trail
✅ View absence alerts
❌ No class/user management

### Parent
✅ Read-only child records
✅ Receive absence/behavior notifications
❌ No data modification

### Admin
✅ Full madrasa control (classes, students, users)
✅ Generate PDF/Excel exports
❌ No cross-madrasa access

---

## Authentication Methods

| Role | Method | Details |
|------|--------|---------|
| Teacher/Admin | Email/Password | Existing Firebase Auth process |
| Parent | Phone UI → Fake Email Backend | UI: phone number; Backend: `parent<digits>@example.local` |

---

## Key Data Rules

### Attendance Statuses
- `present` → progress can be recorded
- `absent` → progress **forbidden** (UI disabled)
- `excused` → progress **forbidden** (UI disabled)

### Progress Fields (memorization/revision)
```
{
  fromSurah: int,
  fromVerse: int,
  toSurah: int,
  toVerse: int,
  totalVerses: int
}
```

### Evaluation Record (additive fields)
- `dayKey` (string, `YYYY-MM-DD`) — one eval per student per day
- `updatedAt` (timestamp, optional)
- `updatedBy` (string, optional)

---

## Editing Rules
- ✅ Can edit progress entries
- ✅ Must update `updatedAt` & `updatedBy`
- ✅ Must preserve range ordering (no inverted ranges)
- ✅ Only update `students.currentProgress` if this is the latest eval

---

## Notifications Policy (FCM)
- **Triggers:** absence without excuse, behavior notes
- **Recipients:** parent UIDs linked to the student
- **Storage:** `notifications` collection with userId, title, body, data, createdAt, read

---

## V1 Scope (Included)

✅ Teacher daily list (date + class filter + search)
✅ Inline attendance recording
✅ Student details → progress & history & edit
✅ Parent portal read-only view
✅ Admin PDF/Excel exports
✅ Push notifications (absence alerts)

## V1 Scope (Excluded)

❌ AI memorization suggestions
❌ End-of-day workflows
❌ Multi-teacher complexity
❌ WhatsApp/SMS (FCM only)
❌ Native mobile apps (web/Flutter web only)

---

## Code Review Checklist (6 Items)

Use when reviewing PRs:

- [ ] **Principle 1:** UI flows are teacher-efficient; no unnecessary steps
- [ ] **Principle 2:** Daily data stored only in `evaluations`; no duplication
- [ ] **Principle 3:** No "End of Day" or multi-day logic added
- [ ] **Principle 4:** No breaking migrations; only additive schema changes
- [ ] **Principle 5:** Absent/excused students cannot record progress (enforced in code & UI)
- [ ] **Security:** Role validation via Firestore; parent isolation enforced

---

## Governance & Amendments

**Version Bumps:**
- `MAJOR` (X.0.0) — Principle removal or role redefinition
- `MINOR` (0.X.0) — New principle or expanded policy
- `PATCH` (0.0.X) — Clarifications & wording

**Compliance:**
- Constitutional alignment checked in spec sign-off
- Code review references 6-item checklist above
- Quarterly review: 2026-06-02

**Amendment Process:**
```
Document issue → Assess impact → Determine version → Update constitution + templates → Commit
Message: docs: amend constitution to vX.Y.Z (<reason>)
```

---

## Feature Module Structure

```
auth              → email/password (teacher, admin), phone UI (parent)
teacher_home      → daily list, attendance, filtering
student_details   → progress recording, history, edit
parent_portal     → read-only child records, notifications
admin_reports     → PDF/Excel export, filtering
notifications     → FCM token management, push UI
```

---

## Normalization Standards

**Dates:** `YYYY-MM-DD` (no time, UTC) — used for `dayKey`
**Phone:** E.164 (`+201001234567`) or digits-only (`201001234567`) — **pick one, enforce everywhere**

---

**For full details:** See `.specify/memory/constitution.md`
