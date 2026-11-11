# Build an immediate application importer

Use this workflow when administrators upload and map a spreadsheet, then apply it in the current request. Start with the **complete** [JCB translation-import composition](translation-import.md): its Custom Admin View, upload template, mapping layouts, example export, endpoints and service providers. Select it through the [import router](imports.md); the application's requirements determine whether this or the queued reference is appropriate.

**Authority:** the translation guide records the inspected implementation and its source-specific behavior. The adaptation steps below are project guidance for reusing that feature in another application. Use the [latest JCB version policy](../../standards/version-policy.md); reference commits identify evidence, not an installation requirement.

## Acquire the feature and define its application contract

1. Identify the application tables/Admin Views, required columns, create/update match key and [GUID relationship policy](application-identities.md). Determine supported formats, realistic file volume, permissions, omitted/empty value behavior and what users should see when only some rows can be applied. Keep domain rules tied to the requested feature rather than inheriting another application's business keys or numeric limits.
2. Locate the authoring records and dependencies through the [reference map](../../examples/reference-patterns.md#importers). Where the original immediate blueprint is unavailable, use the [verified native reconstruction map](translation-import.md#author-the-native-jcb-graph) to create new application records from the public source. Reuse the upload Template, mapping Layouts, helper code and asset configuration with the controller/Ajax callers. The immediate reference builds its mapping controls in Layout PHP; it does not require three persistent Field records. Follow [entity reuse](../../standards/entity-reuse.md) when adapting identities and links.
3. Resolve the Import Factory, Transient, Entity, mapping/row services, file services and spreadsheet reader/exporter with their providers, interfaces and libraries. The [translation service trace](translation-import.md#follow-the-real-caller-and-services) identifies their actual construction. Reuse compiler-aware Power references and providers; do not paste generated JCB namespaces into a new component or manually reconstruct a working factory.
4. Choose the file lifecycle. The translation reference stores upload metadata in session state and cleans up the temporary file. Use that for a session-scoped upload. If uploads must remain managed application records, compose the [Files/File Types feature](media-files.md) and define retention separately; immediate execution does not require or prohibit persistent files.

## Adapt upload, mapping and Apply

1. Attach the Custom Admin View and its dependencies to the component. Adapt the existing uploader's type, upload, display and delete endpoints, component/target references, language strings and asset paths. Keep progress, error, cancellation and mapping visibility behavior. Do not replace the frontend with an unrelated file input merely because the backend still calls `File.Agent`.
2. Define the application's supported targets and labels in one maintained source. Use it for both the mapping controls and the **Download Example** action through `Spreadsheet.Exporter`, following the [complete-feature contract](imports.md#deliver-a-complete-import-feature). Keep required-column instructions with this definition. Verify that the downloaded file produces the intended mapping, including case and header labels.
3. Adapt the mapping fields to source `column` → supported `target`. Validate required and ambiguous mappings before applying rows. Read the same sheet/header row for preview and execution. Apply the format and resource limits appropriate to the actual environment; do not silently import a prefix of an over-limit file.
4. Configure the import Entity for the actual parent table, parent key, link/match field and any supported joins/subforms. Follow the existing model and Power behavior before adding an adapter. Reuse ordinary row import where it satisfies the application's save semantics. A new domain Power should address a specific unmet rule and have an actual caller/provider.
5. Keep permission and CSRF checks at the upload, Apply, delete/cancel and example actions as appropriate. Resolve the file from the authenticated operation's owned metadata. Do not accept an arbitrary request-supplied server path. Use a fresh execution payload and capture `execute(...)->result()` once, following the reference's mutable-state semantics.
6. Show the actual result and row errors. Immediate execution is not inherently an all-or-nothing transaction; the inspected Transient importer can continue after row failures. Choose the error policy the feature needs. Retain the normal per-row workflow when that is correct; implement and test a focused transaction/staging adaptation only when the application requires an atomic batch. See [matching the failure policy](#match-the-failure-policy) before making that promise.
7. Clean the temporary upload/session state on completion and cancellation according to the selected retry behavior. If correction/retry retains an upload, keep it bound to the same authorized operation and remove it when no longer needed. Reuse the reference's lifecycle rather than adding queue tables to solve a temporary-upload requirement.

Keep Joomla toolbar dispatch working across the upload and mapping areas. The immediate reference uses one `adminForm`; preserve its task and CSRF fields and avoid nested forms. Exercise the real toolbar buttons after compilation.

## Match the failure policy

| Application requirement | Implementation consequence |
| --- | --- |
| Apply valid rows and report rejected rows | Reuse the ordinary row-processing composition; present row errors and the actual saved result even if the assessor also reports success. |
| Reject the whole file if any row fails | Use a supported transaction around all affected application writes, with validation before mutation as needed; prove rollback on a late failure. This is an application adaptation, not the default Transient contract. |
| Update existing records without duplicating them | Configure a stable match key and check create/update/replay behavior, preserving application GUIDs. |
| Protect against concurrent edits | Use the application's existing locking/revision strategy at the write boundary and test a stale update. A preview check or transaction alone is not a concurrency policy. |

If an atomic adaptation is needed, inspect every writer participating in its boundary, including joins and Joomla Table/asset operations; see [save boundaries](normalized-subforms.md#place-the-transaction-correctly). A collection-only adapter is one possible design, not a required layer for every importer. Do not claim all-or-nothing behavior when underlying services have already persisted rows or commit independently.

## Acceptance and recovery

Compile from saved authoring records and install the genuine ZIP on the target with its spreadsheet library and loader. Run the real interface, not only an isolated importer call:

| Case | Expected result |
| --- | --- |
| Download example, fill a synthetic row, upload, map and Apply | A usable download, correct mapping, saved row and accurate result; all visible controls work. |
| Update and identical replay | The selected match key finds the intended record; GUIDs and relationships remain stable and replay follows the documented policy. |
| Empty file, invalid required value, ambiguous mapping or reader failure | Clear, relevant errors and the chosen per-row or whole-file result; no misleading claim that all rows succeeded. |
| One invalid row among valid rows | Actual saved state agrees with the advertised failure policy. |
| Unauthorized operation or file from another session/user | No unauthorized file access or application mutation. |
| Cancel, expired session and repeated Apply | Defined cleanup/retry behavior and no reuse of an unrelated file. |
| Each advertised format, alternate sheet and expected volume | Preview and processed rows agree; unsupported or over-limit input fails visibly. |
| Late write failure or concurrent edit, when the feature promises protection | The required rollback/conflict behavior holds at the actual write boundary. |

Inspect application rows and related records after execution. If a request disconnects, inspect the saved state before retrying; reconcile partial work under the selected match/error policy. Correct the maintained configuration or focused domain Power, regenerate and repeat the affected case. Use the [translation troubleshooting notes](translation-import.md#source-specific-troubleshooting) when a source behavior explains the symptom.
