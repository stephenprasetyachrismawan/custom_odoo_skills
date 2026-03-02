---
name: odoo17-clone-view-js
description: Clone/adapt an existing Odoo 17 view (XML) or JS module from local Odoo sources (e.g. ./odoo17) or the current custom workspace, ensuring full compatibility, uniqueness (xml_ids, js module names), and clear provenance markers (source path + reason). Validates XML/JS and prevents collisions.
---

# Odoo 17 Clone View/JS Skill (Advanced, Provenance-Safe)

## Scope & source of truth
- Use ONLY local repository/workspace files and local Odoo source folder(s).
- Prefer scanning in this order:
  1) current custom workspace (the repo you are editing)
  2) local Odoo sources folder (commonly `./odoo17`, but also check common variants if present)
- Never assume web resources.

## Objective
Create a new, unique, Odoo 17-compatible implementation by *copying the structure/pattern* of an existing:
- XML view (list/form/search/kanban/templates), OR
- JS module (OWL/component, controller, patch, service, etc.)

while guaranteeing:
1) Unique identifiers (no collisions with existing xml_ids, view names, JS module names).
2) Odoo 17 compatibility (views and JS patterns aligned with the existing codebase).
3) Provenance markers: clearly indicate:
   - the source file path(s)
   - what was copied and what was adapted
   - the reason (business need) in one short sentence

## Required inputs (derive from chat/repo; only ask if impossible)
- Artifact type: `xml_view` or `js`
- Source location preference:
  - `odoo17` (core) OR
  - `custom` (current workspace) OR
  - `auto` (search best match)
- Source reference:
  - file path, OR
  - a keyword/name to search (e.g., "sale order list view", "kanban controller", "pos receipt component")
- Target module name + target file path where the new artifact should live
- Target model (for views), if applicable
- Desired changes vs source (add/remove fields, buttons, behaviour)

If any are missing: infer minimal safe defaults and list assumptions.

---

## Mandatory steps (non-negotiable)
### Step A — Locate best source candidate(s)
1) Search current workspace first.
2) Search local `./odoo17` if present.
3) Provide a short "source selection summary":
   - chosen source path(s)
   - why that source is the closest match

### Step B — Clone with uniqueness guarantees
#### For XML views:
- Create NEW xml_id(s) with a strict prefix:
  - `<module>_clone_<short_slug>_...`
- Update:
  - `<record id="...">`
  - `<field name="name">...` to a unique value
  - `inherit_id` only if you intentionally inherit (do not blindly keep it)
- Ensure every referenced field exists on the target model (or is added in code). If not, remove or replace.
- Ensure xpath expressions (if inherited) match the target base view (avoid broken xpath).

#### For JS:
- Ensure module name is unique:
  - `/** @odoo-module **/` stays
  - use unique import path/name under your module, e.g.:
    - `my_module/static/src/...`
- Avoid copying hard-coded selectors/registries that collide:
  - rename components/classes/registries with a unique prefix
- Ensure imports are correct for Odoo 17 structure used in the codebase.

### Step C — Provenance marker (must add)
Add a short marker comment (not documentation file) at the top of the new file:

- XML: comment near top of `<odoo>` or inside `<data>`
- JS: comment after `/** @odoo-module **/`

Marker must contain:
- `CLONED_FROM: <path>`
- `CLONE_REASON: <one line>`
- `CLONE_DATE: <YYYY-MM-DD>`
- `CLONE_ID: <unique id>` (slug-like)

### Step D — Validate and fix
- Run XML well-formed validation.
- Run JS syntax validation (best-effort).
- Search for xml_id collisions and fix if found.
- Search for JS module/name collisions and fix if found.
- Ensure manifest/assets load if needed (add minimal updates only).

---

## Output format (strict)
1) RINGKASAN
   - chosen source(s)
   - key adaptations
   - uniqueness strategy used (xml_id prefix / JS prefix)
   - validations performed and results
2) PERUBAHAN KODE
   - `FILE: path` + full final content
   - `DELETE: path` if removals (rare)
3) CATATAN
   - assumptions
   - where/how it is loaded (views data / assets bundle / action)

---

## Execution strategy (default)
1) Scan sources with keywords/path.
2) Pick best candidate; quote exact path.
3) Clone into target module with provenance marker + unique IDs.
4) Validate; fix collisions/errors.
5) Output final code.
