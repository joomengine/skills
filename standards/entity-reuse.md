# Reuse existing JCB entities and adapt only what the application needs

**Policy:** start with suitable Joomla capabilities and published JCB entities. Keep JCB authoring records and reusable code definitions as the maintainable source, and prove their behaviour in a real compiled consumer. A repository is a catalogue of reusable building blocks, not merely a complete application to copy wholesale.

## Contents

- [Discover and assess candidates](#discover-and-assess-candidates)
- [Reuse a complete feature](#reuse-a-complete-feature)
- [Choose unchanged reuse, adaptation or maintenance](#choose-unchanged-reuse-adaptation-or-maintenance)
- [Separate definition identity from application identity](#separate-definition-identity-from-application-identity)
- [Acquire the smallest useful graph](#acquire-the-smallest-useful-graph)
- [Adapt a graph without breaking identities](#adapt-a-graph-without-breaking-identities)
- [Compile, verify and hand off](#compile-verify-and-hand-off)
- [Evidence and limits](#evidence-and-limits)

## Discover and assess candidates

1. Translate the user's goal into entities and behaviour: persistent data, administrator editing, frontend pages, queries, routing, API operations, custom PHP services and external integrations. Ask about missing choices that change the design, such as supported Joomla version, stock ownership or payment provider. Do not ask users to specify JCB serialization details the agent can research.
2. Inspect the existing JCB instance and authorised repositories first. Record local entity identities and modifications before refreshing anything. A locally available definition may already satisfy the requirement.
3. Use the [repository network](repository-network.md) and [ecosystem registry](../registries/ecosystem-repositories.json) to identify the logical source and a usable read transport. Search Joomla core/framework capabilities, the Super Powers foundation and relevant specialist Power sources for PHP behaviour. Search Package indexes for concrete Fields, Admin Views, Site Views, Custom Admin Views, Dynamic Gets, Layouts, Templates and extension roots. Consult the separate Field Type and Snippet catalogues where applicable.
4. Read the relevant index once, then inspect only plausible payloads, their generated READMEs when available, and their dependencies. Index names/descriptions support discovery; they do not prove suitability. A missing README is not itself invalid for a model that deliberately omits one. Follow the model's actual locators: Package `item.json`, Field Type `item.json`, Power `settings.json` plus `code.power`, and the Snippet's own contract.
5. Assess configuration and code together: target versions, field storage and validation, expected tables, view aliases, available variables, placeholders, permissions, language keys, library assets, external services, namespace assumptions, public interfaces and licensing. A generic name such as “country” does not establish the required data set or relationship. A portable placeholder can make the same definition usable in several components; do not replace it with a hard-coded component name without a reason.
6. Retain a compact reuse ledger: requirement, typed entity/key, source repository/ref/commit, actual fetch host, suitability evidence, unchanged/adapt/maintain decision, required dependencies and consumer. Record why a new entity is needed when a plausible existing one was rejected.

For a checked-out Package catalogue, the following command searches the documented Field index summaries. Run it from that source checkout; it discovers candidates and does not execute their code:

```bash
jq -r 'to_entries[] |
	select(([.value.name, .value.desc] | map(. // "") | join(" ") |
		ascii_downcase | test("country|state|city"))) |
	[.key, .value.name, .value.path] | @tsv' index/field.json
```

Use the selected model's index path and format for other families. Fetching an entire component to discover one Field is unnecessary. A dependency index identifies membership; inspect the actual dependency payload when its behaviour matters.

## Reuse a complete feature

Choose the smallest **working feature**, which can span several records. A file-upload Field without its type configuration, storage, handlers and display is not the reusable uploader. A Site View without its Dynamic Get, Templates, Layouts and assets is not the reusable page. JCB can acquire individual blueprint entities or an entire component; choose the scope that delivers the requested behaviour with its dependencies.

Use the [reference pattern catalogue](../examples/reference-patterns.md) to locate actual source records and generated consumers. Demo supplies focused examples; Service Directory demonstrates larger compositions of the same mechanisms. Inspect both the authoring records and the generated result to see which work JCB already performs. Keep domain-specific names and GUIDs in the specimen catalogue, not as fixed requirements for every new application.

| Required capability | Reuse and adapt together |
| --- | --- |
| Smart subform with its own table | Parent expert Field, child Admin View and Fields, GUID link, component association, shared `Data.Subform` hooks; follow [normalized subforms](../packages/workflows/normalized-subforms.md) |
| Managed relationship | Target Admin View, stored key, title lookup, selector Field/Field Type, edit/New links and permissions; follow [modal relationships](../packages/workflows/modal-relationships.md) |
| Managed files and images | Files and File Types Admin Views, upload/display Fields, configuration, AJAX tasks, shared Powers, assets, crop settings and display Layout; follow [media files](../packages/workflows/media-files.md) |
| Public list or detail page | Dynamic Get and defined result shape, Site View, Templates, Layouts, routes and assets; follow [Dynamic Get](../packages/workflows/dynamic-get.md) |
| Data importer | Custom Admin View, upload/mapping/feedback presentation, example download, shared import/export Powers, handlers, and queue records when required; follow the [import router](../packages/workflows/imports.md) |

Acquire the selected records from their real repositories using the operations below. Inspect the saved graph before adapting it. In the GUI, **Save as Copy** can start an independent variant where that editor supports it; inspect the resulting identity, owned settings and linked records before attaching the variant. Copying a view does not imply that every shared Field or Power has also been cloned. Remap only the records that must differ, preserving unchanged reusable dependencies.

Before adding custom code, identify the unmet requirement precisely. A bespoke adapter, manual SQL query, staging layer or compiler plugin is justified by behaviour the existing mechanism cannot supply; none is a routine prerequisite for using JCB. Its intentionally open architecture supports advanced choices without forcing them onto every feature.

## Choose unchanged reuse, adaptation or maintenance

| Decision | Identity and ownership | Result |
| --- | --- | --- |
| Reuse the same entity unchanged | Retain its portable identity and upstream provenance | Reference it and ensure its source is available in the consuming JCB setup; copy it into a distributable graph only when the export/availability plan requires that |
| Create a distinct project-specific variant | Allocate a new identity under that model's rules; retain upstream attribution | The original remains available and unchanged; only the new variant's intended consumers refer to the new identity |
| Maintain the existing entity | Preserve identity and compatibility obligations | Existing consumers can receive the correction through an intentional update |
| Intentionally override the same item in an ordered repository | Preserve identity and record the override and required precedence | The earlier configured repository supplies the winner; all shadowed occurrences stay visible |

The default for a changed, independently reusable project variant is a new identity. Do not silently turn that variant into a same-GUID override. Conversely, do not assign a new GUID merely because the same unchanged item is fetched from a mirror or moved between authorised repositories.

Follow each domain's identity contract. Most standalone Package records and Powers use GUIDs; a concrete Field and its Field Type are different entities. Package child records use the owning parent's key. Custom Code, Placeholders and Validation Rules have natural keys, and filesystem payloads have their own path/pointer rules. Use the [Package identity table](../packages/specification.md#typed-identities-and-supported-families); never allocate UUIDs for every object indiscriminately.

For a manually authored new GUID-based entity, use a cryptographically generated UUIDv4 and check the relevant current core/additional catalogues plus unpublished local additions. Use the existing [Power](../super-powers/workflows/create-power.md), [Field Type](../field-types/workflows/create-repository.md), [Snippet](../snippets/workflows/create.md) or [Package](../packages/workflows/create-repository.md) procedure. Supported importers can have their own identity contract: the inspected [Extrusion Guid resolver](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Extrusion/Resolver/Guid.php) preserves valid supplied GUIDs or derives UUIDv5 identities from source coordinates. Do not replace those established identities merely to make them UUIDv4. Unavailable catalogues are a disclosed collision-check limitation, not evidence of a completed universal collision scan.

## Separate definition identity from application identity

**Project policy, clarified 2026-11-09:** recommend stable application GUIDs for relationships between new application entities, especially for import/export, cross-site data movement and external integrations. Keep Joomla's numeric primary keys and core-managed user, asset and access identities. Deliberate numeric-ID application relationships remain supported; document their portability boundary instead of silently converting an existing system.

| Identity | Example | Meaning |
| --- | --- | --- |
| JCB definition GUID | Product Admin View GUID | Identifies one reusable blueprint record across authoring repositories |
| Application-row GUID | A particular Product's `guid` | Identifies one runtime business record across data exports and environments |
| Numeric primary key | Product `id` | Identifies the local database row for Joomla Table/controller/ACL handling |
| Business key | SKU | Domain identifier with independently defined uniqueness and change rules |

A Field definition GUID never becomes the value of that Field in every business row. Keep the portable blueprint graph and runtime data graph separate. GUID links avoid rebasing relationship values when local numeric IDs change; they do not configure database replication, resolve conflicting writes, or guarantee performance by themselves. Index the actual lookups and design synchronization separately.

Use [application identities](../packages/workflows/application-identities.md) for GUID and numeric variants, [modal relationships](../packages/workflows/modal-relationships.md) for controls and routing, and [GUID migration](../packages/workflows/guid-migration.md) for an existing application.

## Acquire the smallest useful graph

Configure the correct model target, source provider/host, organisation/repository, read branch, enabled state and repository order. Use the selected source's actual branch, not a universal `master`/`main` assumption. Apply the excluded-host policy before JCB performs network reads. Keep write tokens and branches unset for read-only mirrors.

| Needed starting point | Select in JCB | Scope to inspect afterward |
| --- | --- | --- |
| One reusable concrete Field | Fields | That Field, Field Type and any actual validation/subform dependencies |
| An administrator data model | Admin Views | View, its owned field/condition/relation records and referenced Fields |
| A frontend page or query | Site Views or Dynamic Gets | Selected page/query, referenced data, Layouts/Templates and code/assets |
| A complete existing extension | Joomla Components, Modules or Plugins | Root, owned records and the reachable dependency graph required by that extension |
| Custom PHP logic or a Joomla class reference | Super Powers or Joomla Powers | Its own metadata/code contract, referenced Powers and real caller |

These are acquisition boundaries, not assurances that every declared dependency is automatically available. Selecting a component can recursively acquire its linked graph; selecting a Field avoids unrelated views and components. Inspect result logs and persisted records, including separate external catalogues.

Choose the acquisition operation deliberately:

- **Init** is for missing definitions. In the inspected selection UI, locally available items are marked local and cannot be selected. The ordinary initializer preserves existing local records. This avoids repeated acquisition, but does not refresh an existing item's payload or discover new dependencies through a skipped item.
- **Pull** opens the acquisition flow for an explicit refresh, including already-local definitions. In the inspected Package controller it uses forced initialization. Preserve intentional local changes, choose the exact repository, and inspect all refreshed/not-found results.
- **Reset** restores selected local definitions from effective configured sources and can overwrite edits. In the inspected Package builder it follows inbound owned-child dependencies, not all ordinary outgoing references. Resetting a component is therefore not a guarantee that every referenced Field, View or Power has also been refreshed. Reset relevant dependent entities separately when the intended change requires it.

**Cross-repository dependency detail:** the inspected Package Init/Pull passes the selected repository into recursive dependency retrieval. Do not assume a forced Pull will search every other configured catalogue for a missing dependency. For reuse across package sources, Init the required shared definitions from their actual repositories first, then Init the new consuming graph so those local records can be reused. Alternatively, publish a coherent candidate package graph containing its required package records. Field Types, Super Powers and Joomla Powers remain separate catalogue/configuration paths. Verify the installed version's actual behaviour and use the [model acceptance procedure](../packages/workflows/validate-and-integrate.md) when testing refresh and Reset.

## Adapt a graph without breaking identities

1. Snapshot the source and select the minimal records that must differ. Leave unchanged shared dependencies referenced by their existing identities. Preserve source licences and attribution in the derivative repository.
2. Build an explicit typed old-to-new identity map for the distinct records. Allocate all new identities before editing relationships. A component clone, an Admin View variant and a Field variant may require different sets of changes; a root rename alone does not make a safe independent blueprint.
3. Copy the selected payloads and the owned records needed by each new parent. Re-key parent-owned children to that new parent; do not generate unrelated child GUIDs. Update index keys, index locators, source paths and the actual identifying members consistently.
4. Rewire intended consumer references using Table/form/Remote Config metadata, including nested subforms, child associations and code references. Preserve references to unchanged shared entities. Update GUID-based SPK/JPK tokens using the exact token conventions when their referenced entity changed. Natural-key changes require their own consuming-token migration. Avoid indiscriminate repository-wide string replacement: the same textual value may appear in attribution, examples or a different identity domain.
5. Recompute or review `@dependencies` against the actual updated records and code; keep descriptors and real relationships coherent. JCB Push can produce metadata from persisted authoring records. Direct repository authoring must follow the [resolver contract](../packages/specification.md), not treat a hand-written dependency list as proof that references are correct.
6. Recheck context-specific values: local database identifiers, tabs, table names, Dynamic Gets, route aliases, access rules, menu settings, language strings, component placeholders and class placement. A portable GUID does not make every scalar in a copied record portable. Configure the new consumer through the correct JCB editor when local IDs must be resolved.
7. Run the relevant structural validators on the complete candidate and ordered supporting sources. Inspect every unresolved/shadowed reference and unexpected old identity. Then acquire in a clean test instance and inspect the persisted graph before compiling. A validation pass does not replace real import or runtime evidence.

A small example: reuse a Country Field unchanged in a new Checkout Admin View. Keep the Country Field's identity and its Field Type; allocate a fresh Admin View identity and key the new Admin Fields association record to it. If the checkout needs a different Country Field XML/data rule, create a distinct Field, keep its original Field Type if still suitable, and update only the checkout association to the new Field. The original Field and its other consumers remain intact.

## Compile, verify and hand off

JCB's compiler and acquisition services can search configured sources for missing definitions through their Grep/resolver paths. Treat that as a supported aid whose coverage depends on the model, installed version, available handlers and repository setup. Do not assume compilation repairs every missing graph edge or replaces planned acquisition. Review the actual selected source and outcome when automatic acquisition occurs; a failed lookup must not be hidden by silently changing a GUID or dropping a dependency.

Compile a real consumer of every changed reusable item, install it into a compatible test site and exercise its intended behaviour. Check that the custom PHP services are called, the frontend/admin data relationships work, routes and generated APIs operate as intended, and relevant failures are handled. When debugging generated output, return lasting corrections to the JCB authoring record or Power source, regenerate and retest.

Deliver the requested compiled package, reusable source repositories or complete site export through the appropriate [authoring/export workflow](../packages/workflows/author-in-playground.md). When exporting a source blueprint, include or document every external repository needed to reproduce it, its branch/revision and order. Back up distinct project Powers and adapted Field Types through their own appropriate repository targets. Do not imply that a Package export contains every external catalogue automatically. Verify import and compilation from the delivered sources in a fresh instance before claiming the source backup is reproducible.

## Evidence and limits

The identity, smallest-scope reuse and derivative ownership rules above are project maintenance policy, clarified by the owner on 2026-11-03. Detailed import semantics here were re-inspected in the pinned JCB `6.x@408703a857ad937479b1e28de7f693af178dcc83` source on that date; they are not a promise that every newer or installed release behaves identically:

- [Package Builder Get](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Builder/Get.php), `init`, `reset` and `getDirectChildrenGuids`: selected-source recursion and Reset direction filtering.
- [Package source map P07](../packages/sources.md#p07): controller/UI, generic remote import and tracker evidence for Init/Pull/Reset, including local-preservation and result limits.
- [Package specification](../packages/specification.md): exact identity and serialization contracts, external families and graph boundaries.
- [Package acceptance](../packages/workflows/validate-and-integrate.md): distinct new-import, preserved-local, forced-update and ordered-override checks.
- [Repository network](repository-network.md): dynamic source discovery, forbidden-host policy and evidence limits of monitored availability.

This guide provides the shared decision process. It does not certify that a particular repository contains a ready-made checkout, carrier integration or country dataset, and does not claim an application has passed integration merely because it reuses known definitions. Record the actual candidates found and the checks run for each task.
