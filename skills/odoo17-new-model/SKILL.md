---
name: odoo17-new-model
description: Create a new Odoo 17 model with well-designed fields and database architecture, after scanning a local ./odoo17 folder to detect existing identical/similar models or features. Generates minimal, correct Odoo 17 code (models, views, manifest, optional access), modular methods, English comments, and meaningful logging. No tests and no docs.
---

# Odoo 17 New Model Builder (with local odoo17 similarity scan)

## Scope & source of truth
- The primary source of truth is the current repository + chat context.
- You MUST scan the local folder `./odoo17` (if present) to detect whether an identical or similar model already exists in Odoo 17 core/addons.
- If `./odoo17` is missing, proceed with best-effort but explicitly note that the scan could not be performed.

## Objective
Create a NEW Odoo 17 model (custom module code) that:
1) Respects Odoo 17 ORM conventions and database architecture.
2) Uses fields that make sense (types, relations, indexing, constraints, compute/store decisions).
3) Avoids duplicating existing Odoo 17 core/addon concepts by checking `./odoo17` for similar models.
4) Is modular and maintainable (split complex logic into small helper methods).
5) Adds concise English comments where they clarify intent.
6) Adds meaningful logging using `_logger` (entry/exit for key methods, key decisions, exceptions). Avoid noisy line-by-line logs.

## Inputs (derive from chat; do not ask unless impossible)
- Business concept/name of the model (e.g., "Training Request", "Asset Calibration", etc.)
- Main entities and relationships (what it links to: partner, user, company, product, etc.)
- Required workflows (states, approvals, sequences, chatter tracking, activities) if specified.

If inputs are incomplete:
- Infer minimal sane defaults.
- Clearly list assumptions in the final output.

## Mandatory scan step: check `./odoo17`
### What to scan
Search under `./odoo17` for:
- Model names in python (`_name =`, `_inherit =`)
- Key terms for the domain concept (e.g., "asset", "maintenance", "calibration")
- Existing features that can be reused via `_inherit` or by extending an existing model instead of creating a new one.

### What to output from scan
- A short list of "closest matches" (file paths + model names) found in `./odoo17`.
- A decision:
  - "Create new model" OR
  - "Extend existing model via _inherit" (preferred if it matches Odoo concept)

## Design rules (Odoo 17 architecture)
### Model naming
- Custom model: `x_<module>.<model>` is acceptable, but prefer clean namespace: `<module>.<model>` (e.g., `my_module.training_request`)
- Use `_description` and, when appropriate, `_rec_name`.
- Multi-company: add `company_id` when the concept is company-scoped.

### Fields & database considerations
- Use `Many2one` for parent links; keep relations explicit.
- Use `One2many` only as inverse; avoid large One2many trees unless needed.
- Use `Many2many` carefully; ensure relation table naming stability.
- Add indexes for fields used in domain/search frequently (`index=True`).
- Avoid `store=True` compute unless needed for searching/grouping/performance.
- Use `sql_constraints` or `@api.constrains` where appropriate.

### Standard Odoo patterns (only if relevant)
- Chatter: `_inherit = ['mail.thread', 'mail.activity.mixin']` if business needs tracking/activities.
- States: selection field `state` + methods `action_confirm`, `action_done`, etc.
- Sequences: use `ir.sequence` only if the record needs unique human-readable numbers.

### Methods & modularity
- Public actions: `action_*`
- Helpers: `_prepare_*`, `_get_*`, `_check_*`, `_compute_*`
- Keep methods small; split complexity.

### Logging policy
- Define `_logger = logging.getLogger(__name__)`
- Log:
  - create/write overrides (only key events)
  - action methods
  - exceptions with `_logger.exception(...)`

## Views (Odoo 17)
Generate minimal valid views:
- tree, form, search
- sensible groups/pages
- correct field usage (must exist)
Avoid obsolete patterns; keep inheritance/xpath correct if used.

## Security (minimal)
- If the model is new, include minimal `ir.model.access.csv` entry.
- Do NOT invent complex record rules unless specified.

## Deliverables (strict)
Output in this structure:
1) RINGKASAN
   - Scan result (closest matches in ./odoo17)
   - Decision (new model vs extend)
   - Key design choices (fields, relations, indexes, constraints)
2) PERUBAHAN KODE
   - `FILE: path` + full final content
   - `DELETE: path` for removals
3) CATATAN MIGRASI MINIMAL
   - only if field changes/renames are involved

## Execution steps
1) Scan `./odoo17` for similar model/features and summarize findings.
2) Decide new model vs extending existing one.
3) Implement the model + minimal views + access + manifest updates if needed.
4) Output strictly in the required format.
