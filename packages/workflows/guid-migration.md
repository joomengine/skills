# Migrate an existing application to GUID relationships

**Authority:** derived application guidance. This is a migration design and acceptance procedure, not a generic executable migration for arbitrary schemas. Use [application identities](application-identities.md) first. Package Init/Pull/Reset changes authoring definitions; it does not perform this runtime business-data migration.

## Inputs and maintained deliverables

Require the exact installed schema/version, entity and relationship inventory, every writer, identity validation policy, a privately retained restorable backup and a reviewed target schema. Inspect exported JSON/replay/payment references as well as relational columns. Write the migration as maintained application Powers/installer hooks and durable versioned SQL or assets in JCB; never make an installed-only database patch the source of truth.

Keep numeric primary keys, Joomla asset/user/access identities, business values and historical snapshots. Use additive GUID columns and links first. Do not replace a live application's identity model merely because new projects recommend GUID relationships.

## Plan the entire graph before mutation

1. Stop **all** application writers: administrator forms, frontend, APIs, imports, workers, cron and webhooks. Joomla frontend offline alone does not establish this boundary. For an externally replicated database, include the actual replication/write topology in the plan.
2. Read the actual database/prefix and schema. Record row identities, existing GUIDs, relationships, unique constraints, collation/default/null states and affected serialized payloads. Distinguish absent identity from malformed nonempty identity.
3. Preserve valid existing GUIDs and canonicalize only their representation. Allocate secure random UUIDv4 values only for missing identities under the declared application policy. Reject duplicate-in-table GUIDs, nil/malformed values, orphan links and meaningful ID/GUID links that disagree. Uniqueness is typed by entity; a matching GUID in an unrelated table is not a valid parent.
4. Build a complete typed mapping from each old entity identity to its intended GUID. Resolve relationship targets through actual parent rows. If historical data requires SKU/order-reference matching, require an unambiguous proven association; deleted/reused business keys or similar names are not evidence.
5. Include embedded snapshots and idempotency/replay results in the plan. Rewrite identity references while preserving historical titles, prices, quantities, provider identifiers and business results. Do not refresh an old order from today's catalogue.
6. Persist the complete plan and newly allocated identities **before** applying them in a durable private journal. Bind it to the actual database/prefix, migration version and exact relevant before/after states. Do not publish it or include it in a public source PR; it can contain private business data.

The migration must stop before writes if the graph cannot be resolved. Do not partially allocate again after an uncertain run: recovery must reuse the same journal identities.

## Apply in explicit phases

| Phase | Action and success condition |
| --- | --- |
| Additive schema | Add nullable identity/link columns using maintained migration SQL; verify actual schema after each DDL stage |
| Backfill entities | Set planned canonical identities, preserving existing IDs and values |
| Backfill links/payloads | Apply the typed mapping to relationships and known serialized references; reject unknown shapes |
| Validate | Check uniqueness, parent existence, snapshots, compatibility mirrors and replay results against the plan |
| Harden | Enforce intended length/collation, UNIQUE/relationship indexes and final null/default rules only after data passes |
| Enable application | Install/use the matching maintained save/query/import/API contract, test it, then reopen writers |

Use a transaction for the compatible data phase where supported, but do not claim that it rolls back the entire installation. MySQL lists `ALTER TABLE`, other DDL and `LOCK TABLES` among [implicit-commit operations](https://dev.mysql.com/doc/refman/9.7/en/implicit-commit.html); inspect the deployed database/version's behavior. Framework calls can also cross the boundary. See [normalized subform save boundaries](normalized-subforms.md) before wrapping ordinary Joomla parent/Asset saves in a purported aggregate transaction.

Fresh installation and an already-migrated update are distinct paths. A fresh install needs a complete valid schema and coherent fixtures, not a fabricated legacy journal. An already-canonical update should verify that state without allocating identities anew. Do not overwrite upgraded data with fresh demonstration seeds to satisfy expected row counts.

## Resume or recover deliberately

- On interruption, keep writers stopped. Inspect the exact installed schema and data before choosing the next action; an exception is not evidence that prior DDL or data rolled back.
- Resume only if the state matches the journal's defined before-state, after-state or an explicitly supported intermediate phase. Reuse its original IDs/GUIDs and validate every completed phase.
- Treat unexpected drift as a stop condition. A journal replay proven immediately after migration is not permission to replay it after ordinary application edits.
- If safe continuation is impossible, restore the verified backup with its corresponding code and configuration, then validate the restored graph before reopening writers. Rehearse recovery in a disposable instance; possessing a backup file does not establish restoration.
- Make installer verification failures observable. Inspect the target installer's return/exception handling; do not rely on a success banner or a return value that its caller ignores. Never suppress broad SQL errors solely to make an update finish.

## Required acceptance

Test a copied old-version site with representative synthetic relationships and snapshots before production use. Record these as separate assertions:

1. Invalid GUID, duplicate, orphan, conflicting dual link and ambiguous snapshot each fail **before mutation**.
2. Existing valid identities and every numeric primary key/business value survive; missing identities are allocated once and relationships resolve to the intended typed parents.
3. Canonicalized schema has the actual expected indexes and rejects empty/duplicate persistent GUIDs.
4. Repeating the same operation without drift performs no new allocation and preserves the graph. Introduced drift is detected.
5. Failures after additive DDL and during data application have a documented, exercised resume/restore result.
6. Administrator, subform, API and importer reads/writes use the new relationship contract; compatibility mirrors cannot diverge.
7. Historical snapshots and payment/idempotency results retain their original business meaning.
8. Fresh install, upgraded install and subsequent update each pass their own checks. Two compilations retain the required historical migration SQL.

Deliver maintained source, migration version, artifact hashes, exact runtime versions and a sanitized result matrix. Keep the private journal/backup separate. The contribution handover's Clothing Store migration is a reported example of this architecture, with additional application-specific assumptions; the companion archives were not supplied to this documentation task, so their restore/replay/runtime claims are not independently certified here.
