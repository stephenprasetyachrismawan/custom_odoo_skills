---
name: odoo17-wizard-builder
description: Create an Odoo 17 wizard (TransientModel) for form or confirmation flows, including clean modal views, buttons, actions, and minimal access rules. Uses existing code in the current chat/repo context, follows Odoo 17 conventions, keeps logic modular, adds concise English comments and meaningful logging. No tests and no docs.
---

# Odoo 17 Wizard Builder (Form + Confirmation)

## Scope & source of truth
- Work ONLY with the code and requirements present in the current chat and repository.
- Do not assume external files exist beyond what is available.
- If a required target model/module is missing, proceed with best-effort and list assumptions.

## Objective
Build a new wizard in Odoo 17 using `models.TransientModel` that can be:
1) A **Form Wizard** (collect inputs, apply changes), OR
2) A **Confirmation Wizard** (confirm action with minimal/no fields).

Deliver a clean UI (modal), proper buttons, and a correct action binding.

## Required inputs (derive from context; avoid asking unless impossible)
- Wizard type: `form` or `confirmation`
- Target model (where the action applies): e.g. `sale.order`, `res.partner`
- Business purpose: what it does
- Trigger mechanism:
  - context Action menu
  - button on form
  - called by another method

If incomplete: infer minimal defaults and list assumptions.

## Odoo 17 rules
### Wizard model (TransientModel)
- Use `models.TransientModel`
- Include fields needed for the user decision/input
- Use context keys:
  - `active_model`
  - `active_id`
  - `active_ids`
- Must work for multi-record (`active_ids`) safely.

### Method design
- Public entry methods: `action_confirm`, `action_apply`, `action_cancel`
- Helpers: `_get_active_records()`, `_validate_inputs()`, `_apply_changes(records)`
- Keep methods small and modular.

### Logging & comments
- Add `_logger = logging.getLogger(__name__)`
- Add meaningful logs at:
  - entry/exit action methods
  - key decision points
  - exceptions (`_logger.exception`)
- Add concise English comments only where they clarify intent. Avoid noise.

### Views (modal UI)
- Provide a clean `form` view for the wizard:
  - proper `<group>` layout
  - clear labels
  - footer buttons:
    - primary action (Confirm/Apply)
    - secondary Cancel (special="cancel")
- Use `target="new"` on the action to open as modal.

### Action
- Create `ir.actions.act_window` referencing wizard model
- Context must pass `active_model/active_ids` automatically (Odoo handles this), but add safe defaults if needed.

### Security
- Add minimal `ir.model.access.csv` for the wizard model (usually full create/read/write/unlink for base users if needed).
- Do not invent complex record rules unless specified.

## Deliverables (strict output)
1) RINGKASAN
   - what wizard was created
   - how it's triggered
   - key fields/buttons
2) PERUBAHAN KODE
   - `FILE: path` then full final content
   - `DELETE: path` for removed files
3) CATATAN
   - assumptions
   - usage steps in UI (short)

## Execution steps
1) Determine wizard type + target model + purpose from context.
2) Generate wizard model (`TransientModel`) with modular methods.
3) Generate wizard view (clean modal layout + footer buttons).
4) Generate action window (target="new") + add to existing views or server action if required by context.
5) Add minimal access + manifest update to load XML.
6) Output strictly in the required format.
