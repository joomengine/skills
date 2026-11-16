# Native initial-data installation acceptance

**Status: not run.** This is a prescribed, component-independent test, not a completed verification receipt. Run it against the candidate's actual JCB/Joomla/PHP versions in [Playground](../playground/README.md) using the [initial-data workflow](../../packages/workflows/initial-data.md).

## Setup and cases

Use a small JCB-authored component with two related Admin Views, for example a reference category and an item. Use the application's actual ID/GUID relationship design rather than adding a test-specific relationship system.

1. Compile and install the bare component in the authoring workspace. Through supported application forms, create a few identifiable records in both views and verify their relationship and save/reload behaviour.
2. Configure **Add MySQL install = Yes → Table** in both Admin Views. Select the actual installed tables and review the populated maps. Retain IDs, GUIDs where present, relationship values, required application fields, access/ordering/state. Omit incidental source-site audit/lock fields only where target defaults permit it. Save and reopen both configurations.
3. Compile and retain installer A. Inspect its SQL: correct destination tables, expected rows, selected columns, no omitted audit/asset values or private data. Record any effective SQL tweak that limits/disables rows.
4. Change one distinctive application value through the supported application form; compile installer B. Verify B contains the new value and A remains unchanged. This checks compilation-time snapshot behaviour rather than assuming the selected table is read once when configured.
5. Install B on a separate compatible Joomla site without this component. Verify row counts, identities, relationships, ordering, access/publication behaviour, and representative administrator/site rendering. Save/reload a seeded record to check normal edit behaviour. Do not count an update of the populated authoring installation as this test.
6. If blueprint portability is in scope, inspect exported Admin View records. Do not claim Table maps or source rows traveled in the package. Either restore the complete workspace and verify its live data/map, configure them on the destination, or use deliberately populated **Dump** source SQL and prove acquisition → compile → fresh install on a JCB instance without the original live application data. Record which route was tested.

## Receipt

Follow the [scenario receipt requirements](README.md#record-one-receipt-per-candidate-run). Include the skill/core revisions, Admin View identities, table/mapping decisions, seeded row counts, effective SQL tweaks, both ZIP hashes, relevant generated SQL paths, fresh-consumer installation result and observed application behaviour. Use synthetic values in public evidence. List compile, SQL inspection, fresh installation, runtime and optional blueprint/workspace portability separately as passed, failed, blocked, not run or not applicable.

Do not infer upgrade safety from this scenario. Test any requested existing-installation data migration separately.
