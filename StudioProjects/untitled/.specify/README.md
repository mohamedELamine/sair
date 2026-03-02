# Quran Madrasa System — Specification & Planning Hub

Welcome to the specification and planning framework for the Quran Madrasa Management System. This directory contains the constitution (governance), templates, and planning artifacts for the project.

---

## Quick Links

- **[Constitution (v1.0.0)](./memory/constitution.md)** — Full governance framework, 13 principles, policies
- **[Constitution Summary](./CONSTITUTION_SUMMARY.md)** — One-page quick reference
- **[Code Review Checklist](#code-review-checklist)** — 6-item review guide (below)

---

## Directory Structure

```
.specify/
├── memory/
│   └── constitution.md          # Full governance (v1.0.0, current)
├── templates/
│   ├── spec-template.md         # Feature specification template
│   ├── plan-template.md         # Implementation plan template
│   └── tasks-template.md        # Task breakdown template
├── plans/
│   └── [feature-name]/
│       ├── spec.md              # Feature spec (copy of spec-template.md + filled)
│       ├── plan.md              # Architecture plan (copy of plan-template.md + filled)
│       └── tasks.md             # Task breakdown (copy of tasks-template.md + filled)
├── CONSTITUTION_SUMMARY.md      # Quick reference (this file)
└── README.md                    # You are here
```

---

## Workflow: Creating a New Feature

### Step 1: Write a Specification (Spec Phase)
1. Copy `templates/spec-template.md` to `plans/[feature-name]/spec.md`
2. Fill in the template with:
   - User stories & acceptance criteria
   - Data model changes (reference Constitution § 5)
   - UI/UX flow description
   - **Constitution Alignment Check** (6 sections: Principles 1–5 + Security)
3. Get sign-off from Product Owner & Tech Lead

**Template sections:**
- Overview & user stories
- Data model & schema changes
- API/messaging contracts
- UI/UX flows
- **Constitution alignment checklist** ← Critical
- Testing strategy
- Sign-off gates

### Step 2: Create an Implementation Plan (Plan Phase)
1. Copy `templates/plan-template.md` to `plans/[feature-name]/plan.md`
2. Fill in the template with:
   - High-level architecture & module dependencies
   - **Full Constitution alignment review** (each principle + security)
   - Data model & schema details
   - Feature modules & code structure
   - API contracts & message types
   - Testing plan
   - Rollout & deployment strategy
   - Task breakdown (links to tasks.md)
3. Get sign-off from Tech Lead, Product Owner, & QA Lead

**Key sections:**
- Architecture overview with diagrams
- **Constitution alignment review** (Principles 1–5 + Security)
- Detailed data model with indexes
- Module structure (auth, teacher_home, student_details, etc.)
- Test plan (unit, integration, security)
- Rollout strategy (phases, rollback plan)

### Step 3: Break Down Into Tasks (Tasks Phase)
1. Copy `templates/tasks-template.md` to `plans/[feature-name]/tasks.md`
2. Define 8–15 actionable tasks with:
   - Clear acceptance criteria
   - Dependencies (what each task blocks/depends on)
   - Duration estimate
   - Definition of Done
3. Organize tasks by **Constitution principle & category**

**Task categories:**
- Schema & Data
- Core Logic
- UI/Presentation
- Security & Permissions
- Testing
- Deployment & Docs

### Step 4: Implementation
- Execute tasks in dependency order
- Update task status as you go (Pending → In Progress → Done)
- Reference Constitution principles in code comments where enforcement happens

### Step 5: Code Review (6-Item Checklist)
Before merging, ensure:
- [ ] **Principle 1:** UI flows are teacher-efficient; no extra taps/screens
- [ ] **Principle 2:** Daily data stored only in `evaluations`; no duplication
- [ ] **Principle 3:** No "End of Day" or multi-day workflows added
- [ ] **Principle 4:** No breaking migrations; only additive schema changes
- [ ] **Principle 5:** Absent/excused students cannot record progress (enforced in code & UI)
- [ ] **Security (§ 11):** Role validation via Firestore; parent isolation enforced

---

## Code Review Checklist

Use this 6-item checklist when reviewing PRs:

### Principle 1: Teacher-First UX
- User can complete the main flow in ≤3 taps
- No unnecessary summary screens or confirmation dialogs
- Clear, single-purpose actions (not combining multiple steps)

### Principle 2: One Source of Truth
- Daily activity stored exclusively in `evaluations` collection
- No duplicate/parallel collections (e.g., no `absence_alerts` for daily tracking)
- Queries read from single source, no reconciliation needed

### Principle 3: No Unnecessary Flows
- No "End of Day" button or summary step
- No multi-day workflows or async confirmation
- V1 scope respected (see Constitution § 13)

### Principle 4: Data Continuity
- No breaking migrations of existing collections
- Only additive schema changes (new fields, new collections OK; not renaming/deleting)
- Existing data preserved and accessible

### Principle 5: Prevent Mistakes by Design
- UI prevents entering progress for `absent|excused` students (disables input, not hiding)
- Server-side validation rejects invalid data (in Firestore rules or business logic)
- Error messages guide user to correct action

### Security (Constitution § 11)
- Role validation: always read `users/{uid}.role` from Firestore, never trust client
- Parent isolation: parents can only read children where `students.parentPhones` contains their phone
- Teacher isolation: teachers access only own madrasa's students
- Firestore rules enforce least privilege (example: `allow read if ... resource.data.parentPhones.contains(userPhone)`)

---

## Constitution Amendment Procedure

If project principles or policies need revision:

1. **Document the issue** with concrete examples
2. **Assess impact** on existing code, data, security
3. **Determine version bump:**
   - **MAJOR (X.0.0)** — Principle removal or role redefinition
   - **MINOR (0.X.0)** — New principle or expanded policy
   - **PATCH (0.0.X)** — Clarifications or wording
4. **Update:**
   - `.specify/memory/constitution.md`
   - All dependent templates (spec-template.md, plan-template.md, tasks-template.md)
   - `.specify/CONSTITUTION_SUMMARY.md` (if applicable)
5. **Commit:**
   ```
   git commit -m "docs: amend constitution to vX.Y.Z (<reason>)"
   ```

**Example:** If we add a new principle (e.g., "Performance First"), that's a MINOR bump (v1.0.0 → v1.1.0).

---

## Creating a New Plan

### Directory Layout for a Feature
```
.specify/plans/
└── teacher-daily-attendance/
    ├── spec.md            # Feature spec (filled)
    ├── plan.md            # Implementation plan (filled)
    └── tasks.md           # Task breakdown (10 tasks, dependency-ordered)
```

### File Naming Conventions
- Use kebab-case (lowercase, hyphens) for feature folder names
  - ✅ `teacher-daily-attendance`
  - ❌ `TeacherDailyAttendance`
- Spec, plan, tasks filenames are always lowercase: `spec.md`, `plan.md`, `tasks.md`

### Completing a Plan
1. **Spec phase:** ~1–2 hours (requirements, UI/UX, data model)
2. **Plan phase:** ~2–3 hours (architecture, security, testing strategy)
3. **Tasks phase:** ~1–2 hours (task breakdown, dependencies, acceptance criteria)
4. **Sign-off:** ~1–2 hours (reviews, sign-offs, corrections)

**Total:** ~5–9 hours per feature end-to-end (medium complexity)

---

## Governance & Compliance

### Review Gates
Features progress through three gates:
1. **Spec Sign-Off** — Product Owner & Tech Lead approve requirements & Constitution alignment
2. **Plan Sign-Off** — Tech Lead, Product Owner, & QA Lead approve architecture & rollout strategy
3. **Code Review** — All 6 checklist items must pass before merge

### Compliance Review
- **Quarterly:** Review Constitution alignment across all active features (Q2 2026, Q3 2026, etc.)
- **Per release:** Document Constitution version in release notes
- **Per amendment:** Update all dependent templates & communicate changes to team

### Audit Trail
- Constitution amendments recorded with date & version number
- All feature specs/plans archived with sign-off dates
- Code review checklist items tracked in PR comments

---

## Document References

| Document | Purpose | Audience |
|----------|---------|----------|
| `constitution.md` | Governance, principles, policies | All team (read-only; changes rare) |
| `CONSTITUTION_SUMMARY.md` | One-page quick reference | Developers, PMs, QA |
| `spec-template.md` | Template for feature specs | Feature owners |
| `plan-template.md` | Template for implementation plans | Tech leads, engineers |
| `tasks-template.md` | Template for task breakdowns | Engineers, project managers |
| This README | Workflow & checklist guide | All team members |

---

## FAQ

### Q: When do I need a spec/plan/tasks?
**A:** For any feature that:
- Adds a new user-facing screen or flow
- Modifies data model (schema changes)
- Affects role/permission boundaries
- Involves more than 1–2 files

For small bugfixes or docs-only changes, skip the formal process and reference Constitution principles in your PR description.

### Q: What if I disagree with a Constitution principle?
**A:** Raise a GitHub Issue describing the conflict with concrete examples. The team reviews it, assesses impact, and decides on amendment (if warranted). Document the decision in the amendment log.

### Q: How detailed should the plan be?
**A:** Detailed enough that another engineer can implement it solo. Include:
- Architecture diagrams
- Data model with field types & validation
- Security rules examples
- Task dependencies & time estimates
- Acceptance criteria for each task

### Q: Can I skip the Constitution alignment check?
**A:** No. The 6-item checklist is mandatory for all PRs. It takes 5 minutes and prevents classes of bugs.

### Q: What's the difference between a "spec" and a "plan"?
**A:**
- **Spec** = "What do users need?" (requirements, acceptance criteria, user flows)
- **Plan** = "How will we build it?" (architecture, security, task breakdown, rollout)

Specs are approved by Product; plans are approved by Tech Lead & QA.

---

## Contact & Updates

- **Constitution questions:** Reach out to the Tech Lead
- **Template improvements:** File an issue or PR to this directory
- **Governance amendments:** See "Amendment Procedure" above

---

**Last Updated:** 2026-03-02
**Constitution Version:** 1.0.0
**Next Review:** 2026-06-02
