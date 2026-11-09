# Trace the staged Demo importer

Choose this path only when the application needs upload/mapping now and processing later. The [immediate workflow](immediate-import.md) remains the Clothing Store choice. Saving a queue record does not execute the import, register a schedule or create a browser background worker.

**Observed reference:** Packages `master@4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9` and shared Powers `master@9cd980492bed4c8177a6e32b703641950ec93604`, inspected 2026-11-09. Follow the actual graph rather than copying one screen:

| Responsibility | Portable definition / source |
| --- | --- |
| Importer upload/map/queue Custom Admin View | [`917d2c1a-1b37-4ded-9ace-ef486fcc3e4d`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/custom_admin_view/917d2c1a-1b37-4ded-9ace-ef486fcc3e4d/item.json) |
| Queue entity Admin View | [`a9f19a16-fadb-44ea-a9b6-41130aad05ec`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/admin_view/a9f19a16-fadb-44ea-a9b6-41130aad05ec/item.json), Item Import |
| Message log Admin View | [`ab2bbdfc-c0a0-4ffc-9556-67d5af8bec64`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/admin_view/ab2bbdfc-c0a0-4ffc-9556-67d5af8bec64/item.json) |
| Files / File Types Admin Views | `224eb9c7-8b40-48cf-bf77-2afa291fd54a` / `19a973ea-cdfa-4c79-bbbd-1b8a37286b27` |
| Queue Dynamic Get | [`0ac7277b-8f9f-4119-b22b-26f8c22e988b`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/dynamic_get/0ac7277b-8f9f-4119-b22b-26f8c22e988b/item.json) |
| Console registration plugin | [`5df401b4-c9a6-42c8-b50d-87f67c8a15f3`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/joomla_plugin/5df401b4-c9a6-42c8-b50d-87f67c8a15f3/item.json) |
| Console ItemImport Power | [`647316a5-eb42-4bec-82dd-ca0dc2861ad3`](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/647316a5-eb42-4bec-82dd-ca0dc2861ad3/code.power) |

## Acquire and adapt the whole graph

1. Resolve the Custom Admin View's main/custom queries, `importerarea`/`importerqueue` templates, uploader and map controls, the queue/file/message Admin Views and Fields, the console plugin, Powers, providers and spreadsheet library. Follow the recorded dependencies and inspect each persisted record. Keep separately stored entities backed by their own Admin Views.
2. Inspect `saveImportMap()`. The specimen checks CSRF and `importer.access`, records file/mapping plus a job GUID, `import_status=1` and creator, then writes `item_import`. On success it releases the session importer GUID and reports “queued.” Verify the file remains accessible to the later processor and is owned by this job; do not delete it with immediate-import cleanup.
3. Adapt the processing entity and domain services in maintained source. The inspected ItemImport Power explicitly targets `look`, GUID matching, and `detail` joins using `entity`. These are Demo choices, not automatically inferred from whichever component imports it. Align Table metadata, mappings, all queue/status/file/message table names and authorization before use.
4. Compile the console plugin in the component context, install and enable it, and inspect command discovery. The plugin registers `[[[component]]]:item:import` with Joomla's writable console loader; the command uses `Import.Persistent`, `Data.Items` and `Import.Persistent.Entity`. Confirm the actual expanded command name with the target's command list before invoking it.
5. Execute the real command against one synthetic queued file. In Playground, use only the console/automation capabilities actually exposed by that runtime; do not infer a persistent server daemon from browser-hosted PHP. If unattended scheduling is required, establish and test a supported processor lifecycle separately. Keep the page/session ownership and runtime-lifetime limits explicit.
6. Inspect application rows, queue state and persisted row messages. Test a subsequent job and retry after an interrupted job; confirm file retention/removal follows a documented lifecycle. Package only the runtime dependencies that the deployment actually needs.

## Understand processing limits

The corresponding JCB implementation at `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f` was also inspected on 2026-11-09:

- [Console Import::doExecute](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Abstraction/Console/Import.php) reads waiting rows, then updates their status before iterating them. That sequence is not an atomic claim/lease; two workers can read the same waiting jobs. It returns `0` even after counting failures, so exit code alone is not acceptance.
- [Persistent::execute/import/result](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Import/Item/Persistent.php) sets processing state, resolves the stored file, loops rows and collects errors. Row exceptions can coexist with earlier writes; persisted status/messages are not a batch transaction. An interrupted process can leave a processing job.
- [Persistent Message](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Import/Persistent/Message.php) archives prior messages and persists the current set during `result()`. Verify the entity's configured log table against the generated view/query; similar names do not prove agreement.

For one controlled processor, explicitly serialize execution. For multiple workers, implement and test an atomic claim with ownership/expiry and recovery, plus idempotent application writes. Do not label a status update as a lock. A generic retry must not duplicate previously applied rows; use the application's durable operation identity and checked revisions, or reconcile the exact partial state first.

## Acceptance and failure recovery

In a disposable target, prove these stages independently: upload → saved mapping/job → command registered → processor executed → application rows written → messages/status displayed → file cleanup. Test missing file, invalid mapping, one bad row, repeated job, mid-process interruption and two competing processors if concurrency is advertised. Test staff upload/queue visibility separately from the processor's execution identity and domain permissions.

On failure, retain job GUID, input digest, mapping, last known state and sanitized row errors. Inspect completed writes before resetting a job to waiting. Correct the maintained adapter/configuration, compile again and retry under the documented idempotency policy. Report unattended scheduling and multiprocess behavior as unverified until exercised; this source inspection is not a live queue acceptance run.
