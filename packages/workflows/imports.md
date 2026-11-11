# Choose the correct import workflow

Use this router whenever a request says “import.” Identify the **input**, the **maintained destination** and whether the operation changes JCB definitions or application rows before choosing a toolbar action or service.

| Input and intended result | Workflow | Completion evidence |
| --- | --- | --- |
| Repository definitions into JCB | [Package acceptance](validate-and-integrate.md) and [repository operations](../../standards/repository-operations.md) | Saved identities, dependencies and real consumer; Init/Pull/Reset are not business-data import |
| Existing extension forms, SQL or source into authoring records | [Extrusion](extrusion.md) | Reviewed saved graph and comparison with generated schema; harvesting is not business-data migration |
| Conventional generated Admin View data import/export | [Admin Views](../models/admin-views.md) | Enable the installed version's import/export options, inspect generated controller/model, test that view's actual columns and update policy |
| Language translation spreadsheet into JCB | [Translation reference](translation-import.md) | Downloaded example, mapped languages, observed per-row results and preservation test |
| Application spreadsheet, applied during the current request | [Immediate application import](immediate-import.md) | Example download, upload, mapping, execution, persisted rows and result display |
| Application spreadsheet queued for later processing | [Staged reference](staged-import.md) | Complete uploader/mapping/queue feature, saved job **and executed processor**, status/messages and retry behavior |
| Existing application changing relationship keys | [GUID migration](guid-migration.md) | Preserved data/identity graph, durable retry plan and recovery checks |
| Exported complete Playground website | [Delivery and restore](../../workflows/delivery.md) | Successful import into an independent Playground session; not a JCB package repository operation |

## Select a reference from the requirements

Choose execution timing and file retention separately. The [JCB translation importer](translation-import.md) is a complete immediate, session-scoped reference. The [Demo importer](staged-import.md) combines managed Files and File Types, upload/mapping templates, queue/history display and a persistent processor. Use the composition that fits the requested experience; neither is a universal application default.

| Required behavior | Starting point and decision |
| --- | --- |
| Upload, map and apply while the administrator waits; discard the upload afterward | Translation-style immediate composition with its session-owned file lifecycle |
| Retain uploads as managed application files, including for an immediate operation | Reuse the [Files/File Types feature](media-files.md) and define retention independently of execution timing |
| Queue work, retain mapping/history and process later | Demo persistent composition, including the actual processor and its deployment lifecycle |
| Existing feature already satisfies the requested import | Reuse it and its dependencies; add only the missing domain behavior |

Determine the advertised formats, expected volume, matching key, relationship identities, permissions, required columns, failure policy and retry behavior from the application request. Confirm that the chosen processor fits the target runtime. Browser-hosted PHP does not imply an unattended server worker. If a tested resource limit is insufficient, choose supported chunking or queue processing and make the resulting user experience explicit.

## Deliver a complete import feature

**Project policy:** reuse the working feature graph before writing new importer code. Locate the [reference specimens](../../examples/reference-patterns.md#importers), then follow [entity reuse](../../standards/entity-reuse.md) to acquire the relevant Custom Admin View, queries, templates, layouts, Fields where actually used, Custom Code, Powers/providers, assets and any persisted entities. Use JCB's repository operations to pull available definitions and dependencies. When only generated source is published, reconstruct the supported native records using the [immediate authoring map](translation-import.md#author-the-native-jcb-graph), then maintain and compile those records. Missing original GUIDs do not block an independent reconstruction; they prevent claiming unchanged upstream identity.

The delivered interface must include:

1. A working **Download Example** action. Generate the file through the existing spreadsheet exporter from the same maintained target/header definition used by the mapping form. Adapt its labels and columns together. An empty header-only workbook is a useful template; include safe sample rows when the requested format needs them. A button, help-text promise or separately maintained header list is not a working example download.
2. The reference uploader's type configuration, endpoint wiring, progress/error display and delete/cancel behavior. Calling `File.Agent` alone does not reuse this frontend. Preserve the appropriate transient or managed-file lifecycle.
3. Mapping controls with readable target names, required fields and any relevant relationship guidance. Preview, mapping and execution must use the same sheet and header convention.
4. A real Apply or Queue action, authorized for the current actor, plus understandable results. If queued, include queue/history and messages and prove that its processor runs.
5. Domain behavior implemented through the configured import entity and suitable existing Powers. Add a focused Power only where the requested matching, validation or save behavior is not already provided; do not rebuild the engine or add a staging/transaction framework by default.

Keep the Custom Admin View as the composition point. Retain reusable Templates and Layouts for the upload area, mapping, queue and messages rather than collapsing them into a single PHP/HTML block. Use [Dynamic Gets](dynamic-get.md) for configured view data and [compiler-aware PHP references](../../super-powers/workflows/customize-extension.md) for custom behavior. Preserve readable [authored code](../../standards/authored-code.md).

Resolve shared Powers through [core discovery](../../standards/repository-network.md), retaining their identities and dependency metadata. The importer supplies reusable mechanisms; the application determines its match key, GUID relationships, permissions, omission/null meaning, failure policy and deletion rules. Describe any required all-or-nothing or concurrent-update behavior explicitly rather than assuming that immediate execution or a saved queue record provides it.

## Verify the user journey

Compile from saved authoring records and install the generated extension with its runtime libraries. Follow **download example → fill a synthetic row → upload → inspect/correct mapping → apply or queue and process → inspect saved rows → inspect results/history**. Verify an update and a repeated request under the selected matching/retry policy, then cancellation, invalid input and access denial. Test each advertised format and the expected data volume. Inspect GUID links and any retained Files records as applicable.

Recover failures in the maintained blueprint or Power, regenerate and repeat the affected journey. If a code field's destination is unclear, use [compiler tracing](debug.md#trace-a-gui-code-field). Record the actual checks through [package verification](../verification.md) and report missing guidance through the [Skills feedback loop](../../testing/reporting-issues.md).
