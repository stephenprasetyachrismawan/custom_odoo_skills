---
name: odoo17-report-builder
description: Build an Odoo 17 report (QWeb PDF/HTML) triggered from a button or ir.actions.server. Supports reporting on a single model or a joined dataset (model + related models). Generates clean Odoo 17 code: report action, QWeb template, Python report values, optional button/server action wiring, minimal manifest updates. No tests and no docs.
---

# Odoo 17 Report Builder (button / server action, single or joined models)

## Scope & source of truth
- Work ONLY with code and requirements present in the current chat and repository.
- Do not assume files outside the repo/chat exist.
- If required target model/module is missing, proceed best-effort and list assumptions.

## Objective
Create an Odoo 17 report that can be printed from:
1) A form/button (recommended UX), OR
2) An `ir.actions.server` (Action menu / automation entry point)

The report can target:
- A single model (`docs` are records of that model), OR
- A joined dataset where the report aggregates related data from other models.

## Required inputs (derive from chat context; avoid asking unless impossible)
- Report type: QWeb PDF (default) or QWeb HTML
- Target model: e.g. `sale.order`, `stock.picking`, `res.partner`, etc.
- Trigger mode: `button`, `server_action`, or both
- Join requirement:
  - "simple join" via relational fields (Many2one/One2many/Many2many)
  - "computed join" via searches/read_group (preferred)
  - "SQL view" join ONLY if explicitly requested or required for performance (avoid by default)

If missing: infer minimal sane defaults and list assumptions.

## Odoo 17 implementation rules

### A) Report action
- Use `ir.actions.report` with:
  - `report_type = 'qweb-pdf'` (default) or `qweb-html`
  - `model = <target model>`
  - `report_name` / `report_file` matching the QWeb template name
- Provide a clear `print_report_name` expression when useful.

### B) QWeb template
- Use a clean layout:
  - `web.external_layout` wrapper
  - readable headings and tables
- Avoid heavy logic in QWeb; do data preparation in Python.

### C) Python report values
- Implement an AbstractModel:
  - `_name = 'report.<module>.<template_name>'`
  - `_get_report_values(self, docids, data=None)`
- Prepare:
  - `docs` = browse(docids)
  - `lines` or `joined_rows` prepared via helper methods
- Keep methods modular:
  - `_get_docs(docids)`
  - `_prepare_context(docs)`
  - `_prepare_joined_rows(docs)`
  - `_safe_formatters()` if needed

### D) Joined data strategy (preferred order)
1) Use relational fields in docs (simple join)
2) Use search/read_group to build joined rows (computed join)
3) Use SQL view ONLY if explicitly requested; otherwise avoid

### E) Trigger wiring
#### Button trigger (preferred)
- Add a method on the model:
  - `action_print_<report>()` returning `self.env.ref('<xmlid>').report_action(self)`
- Add a button in form view calling that method

#### Server action trigger
- Create `ir.actions.server` (state=code) that calls:
  - `records.action_print_<report>()`
- Optionally bind the server action to the model Action menu.

### F) Logging & comments
- Add `_logger = logging.getLogger(__name__)`
- Meaningful logs at:
  - entry/exit of print action / report value generation
  - join preparation steps (counts)
  - exceptions via `_logger.exception`
- Concise English comments where they clarify intent (no noise).

## Deliverables (strict output)
1) RINGKASAN
   - what report was created
   - trigger mode(s)
   - join approach used and why
2) PERUBAHAN KODE (per file)
   - `FILE: path` then full final content
   - `DELETE: path` for removed files
3) CATATAN
   - assumptions
   - how to trigger from UI / action menu

## Execution steps
1) Identify target model, report name, trigger mode(s), join requirement.
2) Generate:
   - `ir.actions.report`
   - QWeb template
   - Python AbstractModel for report values (modular)
3) Add optional model button method + view button.
4) Add optional `ir.actions.server` to call the print method.
5) Update manifest/data loading minimally.
6) Output strictly in the required format.
