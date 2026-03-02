---
name: odoo17-model-adaptive-upgrader
description: Safely upgrade an existing Odoo 17 model by either extending with _inherit OR editing files directly, depending on the existing codebase patterns. Preserves behavior and data compatibility, validates references (views/actions), and applies minimal modular changes with meaningful logging. No tests and no docs.
---

# Odoo 17 Model Adaptive Upgrader (Inherit OR Direct Edit)

## Scope & source of truth
- Work ONLY with the current chat context and repository files.
- Do not assume missing files exist.
- Primary goal: preserve existing behavior and data integrity.

## Objective
Implement requested changes to an existing Odoo 17 model while:
1) Minimizing regression risk.
2) Preserving data compatibility.
3) Respecting existing patterns in the codebase.
4) Keeping changes modular and reviewable.
5) Ensuring Odoo 17 compliance (ORM, views, actions, security if present).

## Inputs (derive from context; avoid asking unless impossible)
- Target model name (e.g. `my_module.my_model`)
- Requested changes (fields / logic / constraints / views / performance)
- Compatibility constraints (must keep old API, etc.)

If incomplete: infer safe defaults and list assumptions.

---

## Critical decision: choose approach per change
You MUST decide per change-set whether to:
A) Extend via `_inherit`, OR
B) Edit existing files directly, OR
C) Hybrid (some safe extension + small direct bugfix).

### Prefer DIRECT EDIT when:
- The model is already custom and the repo consistently edits it directly (not extension-style).
- Fix is clearly a bug in-place (wrong depends, wrong domain, wrong compute/store, wrong constraint).
- The change must be inside an existing method override to avoid duplicated/competing logic.
- The module structure expects everything in the same file for maintainability.

### Prefer `_inherit` extension when:
- You are adding optional features without touching core behavior.
- You can keep public API stable and reduce churn in existing files.
- The repo uses extension patterns already.

### Non-negotiable: do NOT force `_inherit` if it increases complexity
If using `_inherit` would create duplicate logic, confusing behavior, or more maintenance burden than editing directly, choose direct edit.

---

## Safety-first rules (apply to BOTH approaches)
### A) No breaking changes by default
Do NOT do these unless explicitly required:
- Rename existing fields
- Change field type (Char -> Many2one, etc.)
- Remove fields used in views/reports
- Change method signatures used externally
- Add constraints that invalidate existing data

If unavoidable, add "CATATAN MIGRASI MINIMAL" describing impact (no scripts).

### B) Preserve existing public API
- If a method is used by buttons/actions or external code, keep signature.
- If refactoring, create new helper methods and keep old method as wrapper.

### C) Reduce regression risk
- Prefer smallest diff.
- Avoid sweeping renames/format-only changes.
- Keep behavior identical unless change request explicitly alters behavior.

---

## Mandatory analysis steps (must do)
1) Locate model definition(s) and extensions in repo.
2) Identify:
   - existing fields and their usage
   - key methods and overrides (create/write, action_*, compute)
   - constraints and onchange
   - existing views referencing the model/fields/methods
3) Search usages of:
   - any field/method you plan to change
   - buttons calling `type="object"`
   - server actions calling methods
4) Decide approach (inherit vs direct vs hybrid) and justify briefly in summary.

---

## Direct edit rules (important)
When editing existing files directly:
- Keep method boundaries stable; refactor internally with helper methods.
- If splitting a complex function:
  - keep original method name and signature
  - move logic into `_helper_*` methods
  - original method calls helpers in the same order
- When adjusting fields:
  - new fields should be additive
  - changing attributes (required/index/store/tracking) must be justified
- When changing compute:
  - validate @api.depends completeness
  - avoid heavy loops/search in compute; optimize carefully
- Use meaningful logging:
  - add `_logger` and log at key points (not line-by-line noise)

---

## Views adaptation
- Prefer view inheritance for small UI changes, but direct edit is allowed if the view is already custom and direct edits are the existing pattern.
- Validate:
  - all fields exist
  - xpath targets exist (if inherited)
  - modifiers are Odoo 17 compatible
- If a field is removed/renamed (only if required), fix all references.

---

## Output format (strict)
1) RINGKASAN
   - baseline findings (what exists today)
   - chosen approach (inherit/direct/hybrid) and why
   - what changed (minimal set)
   - compatibility notes (why it's safe)
2) PERUBAHAN KODE
   - `FILE: path` then full final content (or minimal final file content if small)
   - `DELETE: path` only if truly safe
3) CATATAN MIGRASI MINIMAL
   - only if unavoidable compatibility impacts exist

---

## Execution steps
1) Scan repo for model and references (fields/methods/views/actions).
2) Decide approach per change-set; do not force `_inherit`.
3) Implement minimal modular changes.
4) Validate field/method references across views/actions.
5) Output strictly in the required format.
