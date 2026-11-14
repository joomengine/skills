# Turn a request into a maintained Joomla extension

**Scope: project workflow policy.** Use this route when a user describes an application rather than naming a JCB model. Keep Joomla Component Builder at the centre: the maintained deliverable is its authoring graph and supporting source, from which JCB generates the extension. Choose the environment and delivery format to fit the task. This workflow covers requirements, reuse, customization, compilation, installed behaviour and handover.

Follow the [JCB-native authoring boundary](../standards/authored-code.md#keep-implementation-inside-jcb). Prefer reproducible native records, Powers and supported extensions/assets over independently maintained application code or override packages; obtain explicit authorization only for an actual departure, not ordinary native design decisions.

The required outcome is a complete, stable, runnable extension ready for deployment on the agreed target. Follow the [completion contract](delivery.md#completion-contract) through the final deliverables. Resolve the latest JCB under the [version policy](../standards/version-policy.md); inspect the current implementation when historical references differ.

## Contents

- [Establish the requested outcome](#establish-the-requested-outcome)
- [Choose an execution route](#choose-an-execution-route)
- [Discover reusable building blocks](#discover-reusable-building-blocks)
- [Design records and executable behaviour together](#design-records-and-executable-behaviour-together)
- [Author and validate a complete slice](#author-and-validate-a-complete-slice)
- [Deliver maintainable work](#deliver-maintainable-work)
- [Recover without losing the source](#recover-without-losing-the-source)

## Establish the requested outcome

1. Extract the actors, operations, data relationships, public pages, permissions, integrations and intended output from the user's request. Distinguish a Joomla component, module or plugin from the Packages repository that contains its editable blueprint.
2. Inspect already supplied repositories, installed capabilities and configuration. Reuse answers the user has already given. Ask only questions whose answers change behaviour or the delivery boundary: for example target Joomla versions, payment/shipping providers, currency, accounting ownership of price/stock, or whether an existing site can be changed.
3. Continue independent authorized work while awaiting missing integration details. A missing provider credential need not block modelling products and variants. Do not invent a live integration, production credentials or business rules and label them complete.
4. Agree observable acceptance cases appropriate to the request. For a catalogue, these may be administrator CRUD, public filtering and permissions. A stock-selling application additionally needs validated checkout amounts, stock ownership and concurrency, payment confirmation and failure recovery.

Record a compact task brief: requested behaviour, targets, existing inputs, essential unresolved decisions, selected authoring route, acceptance cases and requested deliverables. Keep it with the project source; it is not an alternative blueprint format.

## Choose an execution route

Select the route from the user's supplied environment and actual tool capabilities. When the request supplies only an application description and this repository, start with [Playground's JCB setup](https://playground.joomengine.org/?deploy=jcb&start=0). Joomla, PHP and MariaDB run in the browser; a local JCB installation or server deployment is not a prerequisite. Choose an isolated Playground workspace and keep its owner tab open. Preserve destination work before deployment or Upload; for an independent restoration test use a separate browser storage context, not merely another tab. Follow the [versioned lifecycle](../testing/playground/configuration.md#lifecycle-persistence-and-evidence). The footer's **Agent guide** explains the current controls.

Use a supplied reachable Joomla/JCB MCP connection first when it fits the user's intent. Discover its operations, and use the same site's supported GUI for gaps. If no such connection is provided, use the Playground administrator GUI; do not turn MCP setup into a requirement for browser authoring. An available same-browser Playground MCP client is an optional additional interface, subject to its discovered capabilities.

| Available input | Authoring route | Required check |
| --- | --- | --- |
| User's Joomla/JCB site with an authorized working MCP connection | Discover its tools and use the supported JCB record operations; use its GUI for available operations absent from MCP | Confirm target site, effective permissions and saved relationships; do not assume every JCB action is exposed |
| Browser access with no supplied development site | Launch a suitable JCB deployment in [Playground](../testing/playground/SKILL.md), then author in its administrator | Verify the installed Joomla/JCB/PHP versions and persistent state |
| Existing blueprint/source repository or efficient structured authoring | Work directly on [Packages](../packages/SKILL.md) and the relevant model repositories, then acquire them in JCB | Preserve exact serialization, identities, indexes and dependencies; validate imported records |
| Existing working JCB definitions | Extend those definitions and export through the supported model Push operation | Preserve local work and inspect every eligible write destination before export |

These routes can be combined. Repository authoring followed by Playground validation and GUI authoring followed by source export must converge on the same JCB contracts. Prefer a supplied suitable environment when that is the user's intent. MCP access, browser access and the in-editor AI assistant are separate capabilities. Follow [MCP setup and execution](mcp.md) for a supplied connection, including the current Playground capability gate; a browser-hosted MCP package is not automatically reachable or writable from an external agent.

Before editing repositories, read the [loading guide](../standards/skill-loading.md), [operating contract](../AGENTS.md) and applicable model entrypoint. Use source at the installed target revision when a field, control or operation differs from the documented baseline. Branches belong to the task; do not enforce the earlier prototype's universal `master` branch or Joomla-6-only scope on this ecosystem workflow.

## Discover reusable building blocks

Use the [repository network](../standards/repository-network.md) and [entity reuse procedure](../standards/entity-reuse.md) to discover currently advertised sources and choose what to reuse. Use official model catalogues and configured project repositories, retaining their order and provenance. Avoid a full remote scan for every field: fetch relevant indexes once, search locally, then inspect the promising records, README descriptions, configuration and source at the recorded revision.

For each requirement, decide whether an existing item can be used unchanged, needs a distinct adaptation, or has no suitable match. Record why a new implementation is necessary. A repository's example is a candidate to inspect, not proof that it already solves the requested application.

Select the smallest complete working feature and its required dependencies. Use the [reference catalogue](../examples/reference-patterns.md) to locate focused Demo patterns and advanced Service Directory compositions. Pull an individual Field or Admin View when that satisfies the requirement, a connected feature when its behaviour spans several records, or a whole blueprint when appropriate. Acquire uploaders, selectors, importers and presentation together with the records that make them work. Use the target model's acquisition semantics rather than inferring them from toolbar labels; [Package acceptance](../packages/workflows/validate-and-integrate.md) and [Super Power acceptance](../super-powers/workflows/validate-and-integrate.md) explain the relevant checks.

Preserve unchanged shared identities. Create a fresh collision-checked identity for a distinct reusable adaptation and update the affected relationships; preserve unchanged dependencies. An intentional same-identity override is a separate maintenance decision and must declare precedence. Parent-owned records, natural keys and file pointers follow the [Package contract](../packages/specification.md), not a blanket GUID replacement.

## Design records and executable behaviour together

Map each requested capability to the [model router](../packages/models/README.md) and exact [field contract](../packages/model-contracts.json). Keep this mapping brief and specific to the application:

Choose component and view code names together. Reserve the standard dashboard's component code name, avoid generated class/path collisions, and keep visible product names separate from those internal identifiers; follow [component naming](../packages/models/component.md#root-identity-and-build-settings).

- Model stored data with concrete Fields, Field Types and Admin Views. Attach records through their actual association settings. Decide whether repeating data is stored in JSON or in related rows according to query, lifecycle and API needs; a visible subform alone does not prove a separate table or endpoint exists.
- Model frontend pages with Site Views and custom backend pages with Custom Admin Views. These share a query/presentation approach, distinct from conventional Admin Views that define data and backend CRUD; see the [native concept map](../architecture/concepts.md). Use [Dynamic Gets](../packages/workflows/dynamic-get.md) to retrieve Admin View data for either presentation type and define the item/items shape, related collections, restrictions and ordering before writing manual loaders. Compose page sections in Templates and reusable fragments in Layouts, with the required assets, routes, actions and permissions.
- Let JCB and the selected reusable features perform ordinary persistence and retrieval. Put additional algorithms, business rules and integrations in cohesive PHP classes using [Super Powers](../super-powers/SKILL.md) when needed. Use [Joomla Powers](../joomla-powers/SKILL.md) for additional target-appropriate Joomla class references, retaining aliases JCB already supplies in the actual code slot. Follow the [customization workflow](../super-powers/workflows/customize-extension.md) for exact Power placement, namespace, autoload and service wiring supported by the target compiler; keep authored source readable under the [code standard](../standards/authored-code.md).
- Use [Snippets](../snippets/SKILL.md) when appropriate for reusable view source and inspect their asset/library requirements. Copied snippets do not automatically track catalogue updates.
- Treat generated API configuration as part of application design. Inspect exposed resources, authentication, authorization, accepted fields and relation semantics. Generating CRUD endpoints does not implement stock reconciliation, payment verification or other business rules automatically.

Resolve the following decisions before building the affected slice; load only the applicable guide:

| Decision | Default and operational route |
| --- | --- |
| Portable entity relationships | Prefer immutable application GUIDs while keeping Joomla numeric primary keys. Distinguish runtime rows from JCB definition GUIDs and business keys; follow [application identities](../packages/workflows/application-identities.md). |
| Repeated child records | Give every independently persisted child table its own real Admin View and component association. Wire the parent's expert Field to its child table through [normalized subforms](../packages/workflows/normalized-subforms.md); XML alone creates no persistence. |
| Related record picker and linked New | Match stored key, title lookup, edit controller, defaults and permissions using [modal relationships](../packages/workflows/modal-relationships.md). |
| Managed categories and vocabularies | Create or reuse the managed entity and its selector; allow independent CRUD and store the relationship key instead of substituting unconstrained text. |
| File uploads and product/entity images | Reuse the complete [Files/File Types, uploader, cropping and display feature](../packages/workflows/media-files.md), adapting its configuration and consumers. |
| Page data and presentation | Use [Dynamic Get](../packages/workflows/dynamic-get.md) for the result graph and [Templates/Layouts](../packages/models/presentation-and-queries.md) for its presentation. |
| Acquire definitions or import business data | Select the operation in the [import router](../packages/workflows/imports.md). Immediate import and staged queue processing are different application designs. |
| Migrate genuinely pre-existing forms/schema (record their provenance; do not generate scaffolds for this purpose) | Use [Extrusion](../packages/workflows/extrusion.md), then inspect the persisted graph and emitted schema for lossy conversions. |
| Generate API resources | Choose the actual component-view API mode and test routes/ACL through [API selection](../packages/models/api-selection.md). |
| Maintain compiler corrections | Keep them in the supported [compiler-plugin workflow](../packages/workflows/compiler-plugins.md), with build activation and retained source assets. |
| Change an existing ID-based application | Use the [GUID migration workflow](../packages/workflows/guid-migration.md); preserving data is a separate task from choosing new-project defaults. |

Use placeholders for the contexts JCB supports. Preserve their exact syntax and scope; do not replace portable component/view identifiers with one project's compiled names. External API behaviour must be established from the actual provider's documentation and tested in an appropriate non-production environment.

## Author and validate a complete slice

1. Build a minimal useful slice containing storage, its administrator operation, any required custom behaviour and an observable consumer. Start from the selected reusable feature. Add the project's remaining capabilities after the source-to-runtime path works.
2. Run the relevant [static validators](../tools/README.md). Inspect all unresolved references and intentional shadows. A static pass proves only the stated profile.
3. Acquire or update the exact candidate in JCB. Init is for missing local definitions; confirm whether existing local records require the applicable Pull or Reset operation. Inspect saved/reopened records and associated children; a success notice alone does not establish refresh.
4. Compile the actual extension with the target JCB compiler. Inspect generated PHP, namespaces, class placement/autoloading, XML, SQL, routes, assets and API output relevant to the slice. Retain the generated package and identify its source revision. If a build-only plugin is required, bootstrap, install, enable and select it before the final component build; compile again to check that required update SQL and assets survive repeated compilation.
5. Install in a compatible disposable Joomla environment and execute the acceptance cases. Include permission denial, malformed input, failure/retry behaviour and persisted data when those change correctness. Use the [Playground procedure](../testing/playground/README.md) for available editor/debugging tools.
6. If code placement or origin is unclear, use the [GUI comment probe and compiler tracing toggles](../packages/workflows/debug.md#trace-a-gui-code-field). Put lasting fixes back into JCB records, Power source or compiler source as appropriate. Remove temporary probes, return tracing to the intended effective setting, regenerate and repeat the affected cases.

Report source validation, acquisition, persisted-record inspection, compilation, installation and runtime results separately. Add provider sandbox and native-server results where relevant. An unsupported target or unavailable connection is a named blocker; it is not a passed stage and does not justify silently changing the requested platform.

## Deliver maintainable work

Follow [delivery and portability](delivery.md) and deliver what the user requested, identifying the distinct artifacts:

- **Installable extension:** the JCB-generated component/module/plugin package and the target versions and checks actually exercised.
- **Editable blueprint:** the complete affected Packages graph, indexes and assets, plus references to supporting Power/Field Type/Snippet repositories. Export supporting models through their own source contracts; do not assume component Push publishes every external catalogue.
- **Complete development site:** the supported Playground archive including its database and files, with a successful restore check when claiming portability.

When the user only requested an extension, offer blueprint backup at handover. Obtain the destination repositories, intended write branches and appropriately scoped temporary credentials if they want JCB to Push the source. Use secure credential input; never commit tokens. Existing authorization to publish does not need a second routine approval. Follow [GUI authoring and export](../packages/workflows/author-in-playground.md), verify remote changes and reimport the published source into a fresh site.

Do not equate a Git-host source ZIP with a complete Playground export. When an authorized repository is the archive's delivery channel, preserve the supported archive's bytes and verify retrieval/restoration. Check the destination's visibility and the site's contents before publishing a database or credentials. Describe untested stages honestly at handover.

## Recover without losing the source

On discovery failure, follow the network's bounded retry and alternate-host procedure. On import failure, inspect source identity, selected repository/branch, dependencies and local record state before retrying. On compile or runtime failure, preserve the actual error and trace the generated location back to its JCB authoring field or Power; repair that maintained source.

Save/export useful work before a destructive site reset. Report a blocked operation with the smallest missing input or reproducible failure. Continue independent work that remains authorized. Completion requires the agreed deliverables and evidence; neither the amount of documentation nor an unrelated successful demo certifies the requested application.

If these instructions fail to lead to the requested result, or a successful build requires an undocumented correction, [create or update a Skills issue](../testing/reporting-issues.md) with the reproduction and the useful improvement. Continue resolving the build while maintainers use that feedback to improve the canonical guidance. Link the report in the handoff so the finding can be followed through to its correction.
