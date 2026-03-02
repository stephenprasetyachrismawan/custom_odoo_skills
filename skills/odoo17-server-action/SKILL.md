---
name: odoo17-server-action
description: Create or update an Odoo 17 ir.actions.server (Server Action) from the current chat context. Generates correct XML records (state=code or multi), optional model methods, and binds the action to a model/menu safely. Does not create tests or documentation.
---

# Odoo 17 Server Action Builder (ir.actions.server)

## Scope and source of truth
- Use ONLY code and requirements present in the current chat and repository context.
- If the user provides a target model, action name, and intent, proceed. If any are missing, infer sane defaults but explicitly list assumptions.

## Goal
Create a correct Odoo 17 Server Action (`ir.actions.server`) via XML data:
- Use `state="code"` for Python code server actions.
- Optionally bind action to a model (Action menu) using the appropriate binding fields.
- Ensure the action is safe, readable, and maintainable.

## Inputs (collect from context; do not ask unless absolutely impossible)
- Target model (e.g., `res.partner`, `sale.order`)
- Action purpose (what it should do)
- Trigger location:
  - Contextual "Action" menu on model view (binding)
  - Called from a button (explicit call)
  - Automation (note: automation rules are separate objects; only mention if asked)

## Output rules
- Produce final code per file:
  - `FILE: <path>` then full final content
- Do NOT generate tests and do NOT generate .md documentation.
- If you must add new files, keep minimal.

## Implementation checklist (Odoo 17)
### A) XML record for ir.actions.server
- Create `<record model="ir.actions.server">`
- Set at minimum:
  - `name`
  - `model_id` (ref to ir.model record for target model)
  - `state` (usually `code`)
- For code actions:
  - Use `code` field with safe Python code.
  - The code must use `records` and `env` properly.
  - Handle multi-record sets.

### B) Binding (optional)
- If the action must appear in Action menu:
  - Add binding fields so it appears on the target model's UI.
  - Use valid binding configuration for Odoo 17 actions.

### C) Python code style
- Keep code short; if complex, call a model method instead of writing everything in `code`.
- Prefer defining a method on the target model, then in server action code do:
  - `records.my_method()` (multi-safe)
- Use `UserError` / `ValidationError` for user-facing errors.
- Add meaningful logging (`_logger`) in model methods, not inside raw server action code unless necessary.

### D) Safety
- No `sudo()` unless clearly required; if used, justify.
- Respect company rules if relevant.
- Avoid hard-coded IDs; use xml_id refs.

## Required deliverable
1) A ready-to-import XML data file containing the `ir.actions.server`.
2) If needed, a Python method in an Odoo model to keep logic maintainable.
3) Minimal manifest update to load the data file (only if the manifest exists in context).

## Output format
- RINGKASAN (what you created/changed)
- PERUBAHAN KODE (per file)
- CATATAN (assumptions, how to trigger from UI)