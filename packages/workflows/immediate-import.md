# Build an immediate application importer

Use this workflow when administrators upload and map a spreadsheet, then apply it in the current request. Reuse the actual Transient reader/mapper composition from the [translation reference](translation-import.md), while keeping application rules in compiler-aware Powers. This is the selected route for the [Clothing Store example](../../examples/clothing-store.md); its queue alternative is documented separately.

**Authority:** the service contracts below are inspected shared source; the guarded batch design is derived application guidance. The supplied Clothing Store handover reports a working adaptation, but its private implementation/checkpoint was not supplied for independent reconstruction by this PR. Do not copy that report's test counts as new evidence.

## Inputs and composition

Determine file formats, maximum bytes/rows, required columns, create/update match key, application GUID policy, authorization, omission/null meaning, error policy and replay behavior. Derive these from the requested domain; ask only for unresolved product decisions. A file extension is not content validation.

Resolve the shared Powers' `settings.json`, `code.power`, interfaces, providers and external libraries. The identifiers below locate reusable source; they are not identities to assign to new application classes.

| Responsibility | Shared Power GUID |
| --- | --- |
| Import Factory | `ff8d5fdb-2d1f-4178-bd18-a43b8efd1068` |
| Transient execution | `abd147d0-2f8c-4905-80f5-164f20278d1c` |
| Message / Mapper / Data | `25a4968a-94a1-415f-9353-3fc131773a82` / `90b48ea8-0930-48d1-869a-bce9c901589c` / `05f23281-58e3-482e-be42-2dc1355ef4ea` |
| Spreadsheet Reader / RowData | `c4169332-3914-400e-b861-972b2d465963` / `36063502-2115-4c8d-b16a-0c76cc8c1ada` |
| Row / Parent / Join | `afb5b891-7130-422a-b389-1934b0e4fc48` / `cc923dc9-8f5c-46ea-810c-d93df2e5752b` / `db00768d-c7a6-421d-8f39-577550ddf792` |
| Assessor / Entity | `8aab17d9-f0cc-436b-9da0-c63a96e2e5b9` / `ae8978fd-bfd3-45a3-97ef-1b8bf2140c10` |

These are a navigation subset, not complete dependency closure. Inspect [Transient's body](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/abd147d0-2f8c-4905-80f5-164f20278d1c/code.power) and [settings](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/abd147d0-2f8c-4905-80f5-164f20278d1c/settings.json) at shared Powers `master@9cd980492bed4c8177a6e32b703641950ec93604`. Constructor order and the actual JCB provider are in the translation guide. Preserve compiler-aware dependency references so the generated namespace resolves in a clean component, rather than hardcoding JCB's host namespace.

## Implement upload, mapping and Apply

1. Add a maintained Custom Admin View/controller or supported equivalent and an actual permission-protected caller. Upload through the file service, store metadata bound to the authenticated session/user, and display header/row preview. Apply, cancel and download-example actions require their own permission and CSRF handling where applicable.
2. Define the form's mapping rows as source `column` → supported `target`. Reject unknown targets, duplicate target assignments, duplicate source columns and missing required targets before execution. Read the same sheet and header row in preview and processing. Validate limits before allocation and during row reading; reject over-limit input rather than importing a prefix silently.
3. Resolve the file from session-owned metadata. Check that it is still the exact file prepared for this operation; never accept an arbitrary server path. Preserve the original immutable input receipt or digest needed for retry. Use a new payload because Transient removes `maps` from the object.
4. Construct Transient with a domain ParentTable adapter that **validates and collects rows without application writes**. Return a meaningful non-null row key only for a valid staged row; return `null` or throw for rejection. Do not allow the JoinTables collaborator to perform writes during this collection phase. Isolate/reset mutable Mapper, Data, Row, Message and Entity state between attempts.
5. Obtain the result once. Require no row/reader errors and at least one valid staged row before applying the batch. The shared assessor's success banner is not sufficient; retain row errors and replace misleading success messages on rejection. Catch thrown failures at the application boundary as well as inspecting collected messages.
6. Start one application transaction for the staged batch on transactional tables. Reload and recheck access, typed parent ownership, unique business/application keys, revisions and domain constraints. Protect the check-to-write interval with appropriate row locks or conditional updates matching the expected revision, and verify affected-row counts; a transaction and reread alone do not prevent a concurrent overwrite. Apply through checked writers; throw on false results. Commit only if the whole batch succeeds, otherwise roll it back. Avoid Joomla parent Table/asset lifecycle or DDL inside this boundary unless its transactional behavior is independently proved; see [subform save boundaries](normalized-subforms.md#place-the-transaction-correctly).
7. Return exact created/updated/unchanged/rejected counts and row-level reasons. Define idempotency: identical replay must not duplicate rows or increment revisions merely because it is retried. Recheck expected revisions at the write boundary so a file preview cannot overwrite concurrent changes.
8. Clean temporary file/session state after completion and cancellation using an explicit retry policy. A failed batch can retain a session-owned file for corrected mapping only when that is the documented UI flow; otherwise remove it and require a new upload. Clean unexpected failures in `finally` and avoid leaking server paths in user errors.

For the Clothing Store profile, the handover selects SKU matching, immutable Variant GUIDs, Product GUID ownership and exact integer price/stock/revision validation. Its 2 MB/5,000-row limits and ten mandatory columns are example choices, not shared defaults. Map to the actual application's named fields and reuse its existing services; do not silently introduce a substitute CSV parser or staged queue.

Custom layouts with separate upload and mapping forms must preserve Joomla toolbar dispatch: use one separate hidden `adminForm` with task and CSRF fields where the generated toolbar expects it. Do not nest the upload/map forms inside another form. Verify actual button submissions after compilation.

## Acceptance and recovery

Compile from saved authoring records and install the genuine ZIP on a clean Joomla consumer, with its spreadsheet library and loader. Run these cases through the real UI and inspect full before/after application snapshots:

| Case | Expected policy for an atomic importer |
| --- | --- |
| Valid create/update and identical replay | Stable GUIDs, correct ownership and revisions; replay creates no duplicate or extra revision |
| Empty file, reader failure or all invalid rows | No application writes; clear failure |
| Duplicate keys, mapping collision or unknown target | Rejected before mutation |
| One invalid row among valid rows | Whole batch rejected with unchanged snapshot |
| Late stale revision or database error | Whole application batch rolled back; no success banner |
| Unauthorized upload/apply or forged parent GUID | No data disclosure or mutation outside authorization |
| Cancel, expired session and repeated Apply | Defined cleanup and replay result; no arbitrary path access |
| Alternate sheet, each advertised format and resource limit | Preview and processed rows agree; unsupported/over-limit input rejects visibly |

If results are uncertain after a disconnected request, inspect the operation's durable result/idempotency state before retrying. Preserve the source file and sanitized evidence according to the chosen cleanup policy; do not retry a partially applied generic importer as though it were atomic. Fix the maintained adapter and regenerate. Report source/isolated/installed/concurrency evidence separately.
