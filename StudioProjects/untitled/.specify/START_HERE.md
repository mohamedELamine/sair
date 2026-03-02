# 🚀 Start Here: Quran Madrasa Constitution

**Welcome!** This project now has a comprehensive governance framework. Here's your quick-start guide.

---

## 📚 What Is This?

Your Flutter + Firestore project now has a **constitution** — a set of 13 principles, policies, and standards that govern all development. Think of it as your project's "rules of the road."

**Why?**
- ✅ Consistency across all features
- ✅ Prevention of common mistakes (absent students recording progress, breaking migrations, etc.)
- ✅ Clear expectations for code review, architecture, and testing
- ✅ Documented decision-making & amendment process

---

## 🎯 The 5 Core Principles (30-Second Summary)

| Principle | In One Sentence |
|-----------|-----------------|
| **Teacher-First UX** | Attendance happens in ≤3 taps (inline, no extra screens) |
| **One Source of Truth** | All daily activity stored in `evaluations`; no duplication |
| **No Unnecessary Flows** | No "End of Day" buttons or multi-day confirmation steps |
| **Data Continuity** | Only additive changes; never breaking migrations |
| **Prevent Mistakes by Design** | Absent/excused students cannot record progress (UI blocks it) |

**Plus:** 3 roles (teacher, parent, admin) with clear capabilities, plus 5 policies (auth, data model, business rules, notifications, security).

---

## 📖 Read These Files (In Order)

### 1. **Quick Reference (5 min)**
**→ [CONSTITUTION_SUMMARY.md](./CONSTITUTION_SUMMARY.md)**
- 5 principles at a glance
- Role matrix
- Data rules & V1 scope
- Code review checklist (6 items)

### 2. **Full Constitution (20 min)**
**→ [memory/constitution.md](./memory/constitution.md)**
- Complete 13 principles with rationale
- Policies (authentication, data model, security)
- Amendment procedure

### 3. **Workflow Guide (10 min)**
**→ [README.md](./README.md)**
- How to create a new feature (4-step process)
- 6-item code review checklist
- FAQ & governance timeline

### 4. **How We Got Here (5 min)**
**→ [CONSTITUTION_INIT_REPORT.md](./CONSTITUTION_INIT_REPORT.md)**
- What was created
- Key governance decisions
- Amendment policy & version numbering

---

## 🛠️ Creating Your First Feature (Fast Track)

### Step 1: Copy Spec Template
```bash
mkdir -p .specify/plans/my-feature
cp .specify/templates/spec-template.md .specify/plans/my-feature/spec.md
```

### Step 2: Fill in 5 Sections
1. **User stories** — "As a [teacher], I want to [do X] so that [benefit Y]"
2. **Data model** — New/modified Firestore fields
3. **UI flows** — Screen descriptions
4. **Constitution alignment** — Check all 6 items ✅
5. **Testing strategy** — Unit + integration tests

**Time:** 1–2 hours

### Step 3: Get Sign-Off
- Product Owner approves requirements
- Tech Lead reviews architecture impact
- (No signature required if solo; just reference principles in PR)

### Step 4: Create Implementation Plan
```bash
cp .specify/templates/plan-template.md .specify/plans/my-feature/plan.md
```

Fill in architecture, security rules, testing plan, rollout strategy.

**Time:** 2–3 hours

### Step 5: Break Into Tasks
```bash
cp .specify/templates/tasks-template.md .specify/plans/my-feature/tasks.md
```

Define 8–15 actionable tasks with acceptance criteria & dependencies.

**Time:** 1–2 hours

### Step 6: Code Review = 6-Item Checklist
Before merging, verify:
- [ ] **Principle 1:** Teacher UX is efficient (≤3 taps)
- [ ] **Principle 2:** No data duplication (evaluations only)
- [ ] **Principle 3:** No extra workflows (no End of Day, etc.)
- [ ] **Principle 4:** No breaking migrations (additive only)
- [ ] **Principle 5:** Absent/excused blocks progress (enforced in code & UI)
- [ ] **Security:** Role validation, parent isolation, least privilege

**Time:** 5 minutes per PR

---

## 🎓 Example: Teacher Daily Attendance Feature

If you were building "Teacher Daily Attendance," here's how it'd look:

### Spec (User Stories)
```
As a teacher, I want to see a daily list of my students so that I can quickly record attendance.
AC: [1] List loads in <2 sec, [2] Shows date + class selector, [3] One-tap attendance toggle
```

### Plan (Architecture)
```
teacher_home module
  ↓
  StudentListWidget (reads evaluations from Firestore)
  ↓
  stores attendance in evaluations.attendanceStatus
  ↓
  (downstream) parent_portal reads same collection (single source of truth)
```

### Tasks
```
T1: Add Firestore composite index (evaluations: classId, dayKey, date)
T2: Implement StudentRepository.getStudentsByClass(classId, dayKey)
T3: Build StudentListWidget (Flutter UI)
T4: Add attendance toggle (present/absent/excused buttons)
T5: Write tests (60+ tests covering all paths)
T6: Deploy & monitor
```

### Code Review
✅ Principle 1: 1-tap attendance toggle
✅ Principle 2: Stored in evaluations only
✅ Principle 3: No End of Day workflow
✅ Principle 4: Only added `dayKey` field (additive)
✅ Principle 5: Attendance blocks progress (enforced in UI)
✅ Security: Teacher scoped to own madrasa

---

## 📋 Templates at a Glance

| Template | Use When | Time | Output |
|----------|----------|------|--------|
| **spec-template.md** | Starting a new feature | 1–2 hrs | spec.md (requirements doc) |
| **plan-template.md** | Feature approved, planning build | 2–3 hrs | plan.md (architecture doc) |
| **tasks-template.md** | Plan approved, ready to code | 1–2 hrs | tasks.md (task breakdown) |

All templates have **built-in Constitution alignment checks**. Use them!

---

## 🔐 Security at a Glance

**Principle 5 (Prevent Mistakes):** Absent/excused students cannot record progress.

**Example enforcement (all three layers):**
```
UI Layer: Progress input is grayed out if attendanceStatus != "present"
Firestore Rules: allow update if attendanceStatus == "present"
Code Layer: EvaluationRepository.updateProgress() throws if absent
```

**Other key rules:**
- Parents can only read their own children's data (phone-based access control)
- Teachers access only their madrasa's students (madrasaId check)
- Always validate role via `users/{uid}.role` (never trust client-side claims)

---

## 🚨 Common Mistakes to Avoid

### ❌ Don't: Store daily attendance in multiple places
**Why:** Constitution § 2 (One Source of Truth) — causes sync issues, audit failures
**Do:** Only write to `evaluations` collection

### ❌ Don't: Add an "End of Day" summary button
**Why:** Constitution § 3 (No Unnecessary Flows) — complexity, extra taps
**Do:** Teachers record attendance inline during class

### ❌ Don't: Let absent students record progress in the UI
**Why:** Constitution § 5 (Prevent Mistakes) — nonsensical data, user confusion
**Do:** Disable progress input when attendance is not `present` (all three layers)

### ❌ Don't: Break existing data when adding new fields
**Why:** Constitution § 4 (Data Continuity) — existing madrasas have live data
**Do:** Only add new fields; backfill gracefully; never delete/rename

### ❌ Don't: Skip the code review checklist
**Why:** Checklist catches 80% of principle violations early
**Do:** Use the 6-item checklist on every PR

---

## 📅 Governance Calendar

| Date | Event | Action |
|------|-------|--------|
| 2026-03-02 | Constitution created (v1.0.0) | Review & adopt ✅ |
| 2026-Q2 (06-02) | Quarterly review | Check all features for alignment |
| 2026-Q3 (09-02) | Quarterly review | Assess if amendments needed |
| Ongoing | Code review | Use 6-item checklist on all PRs |
| As needed | Amendment | Follow procedure (document issue → assess → update → commit) |

---

## ❓ FAQ (5 Questions)

### Q1: Do I need a spec/plan/tasks for everything?
**A:** No. Only for features that:
- Add a new user screen or workflow
- Change the data model
- Affect role/permission boundaries
- Touch >2–3 files

Small bugfixes? Reference principles in your PR description instead.

### Q2: Can I skip the code review checklist?
**A:** No. It's 6 items, takes 5 minutes, and catches most principle violations. Do it.

### Q3: What if I disagree with a principle?
**A:** File a GitHub Issue with concrete examples. The team reviews it, assesses impact, and decides on amendment (MAJOR/MINOR/PATCH version bump). See amendment procedure in [README.md](./README.md).

### Q4: How detailed should my plan be?
**A:** Detailed enough that someone else can implement it solo. Include architecture diagrams, data model with validation rules, security rules examples, task dependencies, and acceptance criteria.

### Q5: What's the difference between a spec and a plan?
**A:**
- **Spec:** "What do users need?" (user stories, acceptance criteria, UI flows)
- **Plan:** "How do we build it?" (architecture, security, testing, task breakdown)

Specs are reviewed by Product; plans by Tech Lead & QA.

---

## 🎬 Next Steps

### For Product Leads
1. Review [CONSTITUTION_SUMMARY.md](./CONSTITUTION_SUMMARY.md) (5 min)
2. Review [memory/constitution.md](./memory/constitution.md) (20 min) — focus on § 13 (V1 Scope)
3. Review [README.md](./README.md) (10 min) — understand feature creation workflow
4. Done! Use the spec-template.md when creating new features.

### For Engineers
1. Read [CONSTITUTION_SUMMARY.md](./CONSTITUTION_SUMMARY.md) (5 min)
2. Read [README.md](./README.md) (10 min) — code review checklist (6 items)
3. Bookmark this checklist: You'll use it on every PR.
4. When creating a feature, follow the 4-step workflow in [README.md](./README.md)

### For QA Leads
1. Review [CONSTITUTION_SUMMARY.md](./CONSTITUTION_SUMMARY.md) (5 min)
2. Review [memory/constitution.md](./memory/constitution.md) (20 min) — focus on § 6 (Business Rules)
3. Review [templates/tasks-template.md](./templates/tasks-template.md) (15 min) — testing strategy section
4. Use the 6-item checklist during QA sign-off.

### For Tech Leads
1. Read [CONSTITUTION_INIT_REPORT.md](./CONSTITUTION_INIT_REPORT.md) (15 min)
2. Review [memory/constitution.md](./memory/constitution.md) (30 min) — all 13 principles
3. Review [templates/plan-template.md](./templates/plan-template.md) (20 min) — implementation standards
4. Update your code review process to include the 6-item checklist.
5. Schedule quarterly reviews (Q2, Q3, Q4 2026).

---

## 📞 Questions?

- **About Constitution:** See [memory/constitution.md](./memory/constitution.md)
- **About Workflow:** See [README.md](./README.md)
- **About Decisions:** See [CONSTITUTION_INIT_REPORT.md](./CONSTITUTION_INIT_REPORT.md)
- **Quick Ref:** See [CONSTITUTION_SUMMARY.md](./CONSTITUTION_SUMMARY.md)

---

## ✅ Checklist: You're Ready When...

- [ ] You've read [CONSTITUTION_SUMMARY.md](./CONSTITUTION_SUMMARY.md)
- [ ] You understand the 5 core principles
- [ ] You know the 6-item code review checklist
- [ ] You can explain why "absent students can't record progress"
- [ ] You've bookmarked [README.md](./README.md) for future features

**You're good to go! Let's build. 🚀**

---

**Last Updated:** 2026-03-02
**Constitution Version:** 1.0.0
**Status:** Ready for Team Adoption
