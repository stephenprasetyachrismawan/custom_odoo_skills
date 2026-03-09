---
name: odoo17-manual-testcase-generator
description: Generate an advanced, structured manual test case suite for a specific Odoo 17 feature. Covers models/views/wizards/reports/server actions, security/access rights/record rules, multi-company, chatter/activity, scheduled actions, assets/JS widgets, performance sanity, audit/logging, and regression. Outputs step-by-step cases with preconditions, data setup, expected results, and traceability. No automated tests and no test files.
---

# Odoo 17 Advanced Manual Test Case Generator (Feature-Focused)

## Scope & source of truth
- Use ONLY the feature requirements, screenshots, and code context available in the current chat and repository.
- If requirements are incomplete, infer minimal reasonable assumptions and list them explicitly.
- Do NOT generate automated tests. Output is manual test cases only.

## Objective
Produce a comprehensive manual test suite for a specific Odoo 17 feature with coverage across:
- Functional workflows (happy/alt/negative paths)
- Odoo UI surfaces (form/list/kanban/calendar/pivot/graph/search)
- Wizards (transient models) and confirmations
- Reports (QWeb) and printing flows
- Server Actions / Automated Actions / Scheduled Actions (if applicable)
- Security: groups, ACLs, record rules, company rules
- Multi-company / multi-currency / multi-language (as applicable)
- Mail/thread chatter, activities, followers, notifications
- Data integrity: constraints, onchange behavior, computed fields, stored fields
- JS widgets/components (OWL), assets loading, cache refresh, view modifiers
- Concurrency and locking risks (two users editing, stale data)
- Performance sanity checks (large dataset, list rendering, search)
- Observability: logs, mail.message, audit trail (if implemented), error messages
- Regression coverage around touched models/views/assets

## Inputs (derive from context; ask only if impossible)
- Feature name and business goal
- Entry points:
  - menu/action window
  - button (type="object")
  - server action
  - wizard modal (target="new")
  - report print
- Affected models, key fields, and state transitions
- Roles/groups involved
- Integrations (email, cron, external API), if any

If missing: infer minimal defaults and list assumptions.

---

## Mandatory Odoo 17 decomposition method
### Step 1 — Identify feature boundaries
Map:
- Primary model(s)
- Secondary/related models (joins)
- Views involved (list/form/search/kanban)
- Any JS widgets or custom components used
- Wizards / Reports / Server actions
- Security layer: ACL + record rules + groups

### Step 2 — Build Odoo 17 coverage matrix (must include)
Create a short matrix for these dimensions:

A) UI/UX & Views
- Form view: create/edit/save/discard, required fields, modifiers
- List view: columns, optional columns, sorting, grouping, multi-edit, export/import (if enabled)
- Search: filters, group by, domains, context
- Smart buttons / stat buttons (if any)
- Studio-like behavior not assumed unless present

B) ORM & Data Integrity
- create/write behavior
- computed fields (store vs non-store)
- onchange (UI-only) vs constraints (hard validation)
- sql_constraints and @api.constrains
- company_id and check_company behavior if present

C) Workflows
- state transitions
- cancellations/rollbacks
- idempotency (repeat click)
- partial failures

D) Security & Access
- ACLs for each role (read/write/create/unlink)
- record rules (own records, company records)
- sudo usage (should not be required in UI path)
- multi-company access boundaries

E) Chatter & Activities (if used)
- message_post
- followers
- activity scheduling/mark done
- notifications/email templates

F) Actions
- act_window action opens correct view modes
- server action triggers correct logic and handles multi-record
- scheduled action (cron) if present

G) Reports (if used)
- report output correctness
- print name
- multi-record printing
- access restrictions on report

H) JS / Widgets (if used)
- assets bundle inclusion and cache refresh
- widget renders correctly on supported views
- widget handles readonly/invisible states
- error handling (console errors, RPC failures)
- behavior consistency across browsers (basic)

I) Concurrency & Performance (manual-friendly)
- two users update same record
- list view with large dataset
- search performance sanity
- avoid UI freeze

J) Regression surface
- nearby views/actions on same model
- modules inheriting the same view
- existing server actions on the model
- existing widgets in same assets bundle

### Step 3 — Prioritize
Each test case must have:
- Priority: P0/P1/P2
- Risk label: Security, DataLoss, Finance, UX, Performance, Integration, Compliance
- Traceability: Behavior ID (e.g., B-01)

---

## Output format (strict)
### 1) FEATURE SUMMARY
- Feature scope
- Actors/roles
- Entry points
- Models/views/assets involved
- Assumptions

### 2) COVERAGE MATRIX
- Behavior list (B-01..)
- Coverage mapping per dimension above

### 3) MANUAL TEST CASES (main deliverable)
For each case include:
- ID: O17-MTC-###
- Title
- Priority (P0/P1/P2)
- Risk label(s)
- Preconditions (including user role, company context, required configuration)
- Test data/setup (sample records)
- Steps (numbered, UI-oriented)
- Expected results (explicit and verifiable)
- Evidence tips (where to check: chatter, logs, mail, record values)
- Traceability (B-##)

### 4) MINIMAL REGRESSION CHECKLIST
- Short bullet list of "must re-check" areas after changes.

## Constraints
- Manual tests only.
- No automated test code.
- No test files.
- Keep it executable with Odoo UI + developer mode + logs if needed.

## Execution steps
1) Extract requirements from context and decompose into behaviors (B-##).
2) Build coverage matrix.
3) Generate exhaustive-but-practical manual test cases.
4) Provide regression checklist.

## Usage
Invoke: `$odoo17-manual-testcase-generator` then provide 5–10 lines of feature context:
- module & model
- entry point (button/wizard/server action/report)
- state/validation rules
- roles involved
- JS widget present or not

## Optional: Script for extracting Odoo context
Run `scripts/extract_odoo_feature_context.sh` against the module/repo to gather entry points, business rules, security, and JS/widgets before generating test cases.

## Optional: Templates
- `templates/odoo_coverage_matrix.txt.j2` — Jinja2 matrix template
- `templates/odoo_testcase_suite.md.j2` — Jinja2 test suite template
