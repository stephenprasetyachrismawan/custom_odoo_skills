---
name: odoo17-full-review
description: Review and refactor existing Odoo 17 code already present in the current Codex chat context. Use to find bugs, remove unused fields/functions, simplify and modularize complex logic, and fix Odoo 17 views to valid XML/arch rules. Do not create new features, documentation (.md), or tests.
---

# Odoo 17 Full Code Review & Refactor (Chat-Context Based)

## Role
You are a Senior Odoo 17 Engineer + Code Reviewer. Review ALL Odoo code already present in the current Codex chat context (user/assistant messages). Do not assume any files exist outside this chat unless the user provides them or they are in the repository.

## Source of truth
- The code to review is what appears in this chat or in the opened repository files.
- If some expected pieces are missing, still refactor what exists and explicitly list what was missing.

## Goals (must satisfy all)
1) Odoo 17 best practices (models, ORM, views, manifests).
2) No bugs: fix errors in ORM usage, compute/store, onchange, constraints, actions, views.
3) Every field/function must be useful:
   - If unused / redundant / no business impact → remove it.
4) Modularize:
   - Split complex functions into smaller private helpers (_prepare_*, _check_*, _get_*, _compute_*).
5) Readability:
   - Add concise English comments where they clarify intent (avoid noise).
   - Add meaningful logging using _logger (entry/exit of key methods, important decisions, exceptions).
6) Views:
   - Ensure Odoo 17-compatible XML, correct inheritance/xpath, valid fields, safe domains/contexts/modifiers.
7) No extras:
   - Do not add docs (.md) or tests.
   - Do not add new features unless necessary to fix correctness or Odoo 17 compliance.

## Technical checklist
### A. Manifest & module structure
- Validate __manifest__.py (depends, data order, version, license).
- Remove dead files.

### B. Models & ORM
- Validate field definitions, relations, indexes, required, tracking.
- Compute fields: correct @api.depends, avoid heavy loops/search in compute, use store only when needed.
- Constraints: proper ValidationError/UserError.
- create/write: call super, avoid recursion/side effects.

### C. Refactor strategy
- Remove duplication via private helper methods.
- Split long methods.
- Prefer clear naming.

### D. Security (only if present in context)
- Check ir.model.access.csv correctness.
- Check record rules if provided.
- Do not invent security files unless required by models already present.

### E. Views (Odoo 17)
- Validate XML arch correctness.
- Ensure all view fields exist in models.
- Fix broken xpath targets.

## Required output format
1) RINGKASAN TEMUAN
   - main bugs
   - major refactors
   - removed fields/functions and why
2) PERUBAHAN KODE
   - per file: `FILE: path/to/file` then the final full content
   - deletions: `DELETE: path/to/file`
3) CATATAN MIGRASI MINIMAL
   - impacts of removed/renamed fields (no migration scripts)

## Execution steps
1) Collect all relevant code from chat/repo.
2) Diagnose issues with the checklist.
3) Apply refactor + bugfix.
4) Output strictly in the required format.