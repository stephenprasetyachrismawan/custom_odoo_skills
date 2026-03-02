---
name: odoo17-list-view-builder
description: Create or refactor an Odoo 17 List View (XML) with validated attributes and fields. Ensures all fields exist on the target model, all list view attributes/modifiers are compatible with Odoo 17, and the view/action/menu wiring is correct. Produces clean, maintainable views. No tests and no documentation files.
---

# Odoo 17 List View Builder (Validated)

## Scope & source of truth
- Work ONLY with the current chat context and repository files.
- Do not assume missing files exist.
- If a target model or view is not found, proceed best-effort and list assumptions.

## Objective
Create (or refactor) an Odoo 17 **List View** that is:
1) Valid XML and compatible with Odoo 17 view rules.
2) Uses only fields that exist on the model.
3) Uses only attributes/modifiers that are valid and appropriate.
4) Has clean UX: readable columns, sensible optional columns, proper ordering, and safe decorations.
5) Optionally includes a correct `ir.actions.act_window` and menuitem wiring.

## Inputs (derive from context; avoid asking unless impossible)
- Target model (e.g., `sale.order`, `res.partner`, `my_module.my_model`)
- View purpose (main list, sublist in notebook, reporting list, etc.)
- Required columns + optional columns
- Needed behaviors:
  - editable (if any)
  - multi-edit (if required)
  - decorations (danger/success/info/muted/bf/italic)
  - default ordering
  - row-level buttons (if needed)
- Whether to create/update action window and menu item.

If any input is missing:
- Infer minimal sane defaults and list assumptions.

## Mandatory validation steps (must perform)
1) **Field existence check**
   - Verify every `<field name="...">` exists on the target model (including inherited fields).
   - If not found: remove or replace and document the change in summary.

2) **Attribute compatibility check**
   Validate list/list-tree attributes used are compatible and meaningful in Odoo 17:
   - `create`, `edit`, `delete`, `import`, `duplicate` (only if needed)
   - `editable` (only when appropriate; avoid for complex objects)
   - `default_order`
   - `decoration-*` conditions must be valid Python domain-like expressions (safe, uses fields that exist)
   - Avoid obsolete/incorrect attributes; do not invent non-standard ones.

3) **Modifiers check**
   - Any conditional `invisible`, `readonly`, `required` must use valid expressions and fields.
   - Ensure group-based visibility uses `groups` properly.

4) **View wiring check**
   - If creating action: `ir.actions.act_window` must target the correct model and include list/form modes.
   - If adding menu: must link to the action correctly.

## Design rules (Odoo 17)
- Prefer `<list>` tag (Odoo 17), but allow `<tree>` only if existing module uses it consistently.
- Keep columns minimal; move less-used fields to `optional="hide"`.
- Use widgets only when they add value and are valid for the field type.
- Avoid heavy business logic in views; keep UI declarative.

## Output format (strict)
1) RINGKASAN
   - what was created/changed
   - validation results (fields/attributes/modifiers)
   - removed/replaced fields and why
2) PERUBAHAN KODE
   - `FILE: path` then full final content
   - `DELETE: path` for removals
3) CATATAN
   - assumptions
   - where the view is used (action/menu/model inheritance)

## Execution steps
1) Identify target model and existing view(s) in repo context.
2) Scan model fields (best-effort via repository code).
3) Build/refactor list view with clean columns and valid attributes.
4) Validate fields + attributes + modifiers; fix any mismatch.
5) Add/update action + menu if requested/required.
6) Output strictly in required format.
