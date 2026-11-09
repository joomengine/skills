# Choose the correct import workflow

Use this router whenever a request says “import.” Identify the **input**, the **maintained destination** and whether the operation changes JCB definitions or application rows before choosing a toolbar action or service.

| Input and intended result | Workflow | Completion evidence |
| --- | --- | --- |
| Repository definitions into JCB | [Package acceptance](validate-and-integrate.md) and [repository operations](../../standards/repository-operations.md) | Saved identities, dependencies and real consumer; Init/Pull/Reset are not inventory import |
| Existing extension forms, SQL or source into authoring records | [Extrusion](extrusion.md) | Reviewed saved graph and comparison with generated schema; harvesting is not business-data migration |
| Conventional generated Admin View data import/export | [Admin Views](../models/admin-views.md) | Enable the installed version's import/export options, inspect generated controller/model, test that view's actual columns and update policy |
| Language translation spreadsheet into JCB | [Translation reference](translation-import.md) | Existing source strings, mapped languages, observed per-row results and preservation test |
| Application spreadsheet, applied during the current request | [Immediate application import](immediate-import.md) | Validated mapping, explicit batch policy, persisted rows and replay/error tests |
| Application spreadsheet queued for later processing | [Staged reference](staged-import.md) | Saved job **and separately executed processor**, status/messages, retry and concurrency behavior |
| Existing application changing relationship keys | [GUID migration](guid-migration.md) | Preserved data/identity graph, durable retry plan and recovery checks |
| Exported complete Playground website | [Delivery and restore](../../workflows/delivery.md) | Successful import into an independent Playground session; not a JCB package repository operation |

For an application, select immediate or staged execution from the user's timing and volume requirements. Use the immediate translation-style path for the Clothing Store example. A reusable queued importer is not a reason to introduce cron into a synchronous requirement. If the requested file size cannot fit the tested browser/runtime budget, explain that concrete limit and choose chunking or an explicitly supported queue; do not silently truncate input.

Resolve suitable shared Powers through [core discovery](../../standards/repository-network.md), retaining their identities and actual dependency metadata. The import library supplies mechanisms, not the application's permissions, transaction, matching, revision or deletion policy. Maintain adapters and callers in the JCB blueprint and compiler-aware Powers, then compile and install a clean consumer. Follow [package verification](../verification.md); source inspection, a successful upload and a success banner are different evidence levels.
