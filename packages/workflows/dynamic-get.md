# Load page data with Dynamic Get and compose the presentation

Use this workflow for a Site View or Custom Admin View that displays application data. Dynamic Get supplies the main item/list and related data; the generated view exposes it to templates and layouts. Start with configured queries and reusable records so JCB performs the ordinary loading and wiring. Use custom PHP when an actual requirement needs it, retaining JCB's flexibility without rebuilding capabilities already expressed in the blueprint.

The [presentation model contract](../models/presentation-and-queries.md) owns field semantics and compiler evidence. This procedure is project guidance derived from that contract and the [Demo/Service Directory reference patterns](../../examples/reference-patterns.md#dynamic-gets-and-presentation). Those components demonstrate reusable techniques, not a required application schema. Use the [latest JCB release policy](../../standards/version-policy.md); reference revisions identify inspected examples only.

## Inputs and reuse decision

Establish the target Joomla/PHP versions, page route and access rules, main entity, single/list result, required related data, expected empty state, and list ordering/pagination. Identify the Admin Views and Fields that own the data, their GUID relationships, and any external database tables or service dependencies.

Search the configured package repositories through the [entity reuse procedure](../../standards/entity-reuse.md). Inspect a candidate Dynamic Get together with its consumer, joined views/fields, presentation records, hooks, Libraries and Powers. Pull the required feature graph or whole blueprint when appropriate; then preserve identities for unchanged reuse or deliberately remap an independent adaptation. Do not copy a generated model as the starting implementation: its query, imports and related methods may already be produced from records you can reuse.

## Configure the query and relationship shape

1. Select an Admin View main source for a JCB-owned table, or a database-table source for an existing table. Pick main single/list or custom single/multiple to match the consumer. Use a custom PHP main source only after identifying the requirement that configured sources cannot express; that mode bypasses the normal configured joins, restrictions and ordering collections.
2. Set the main selection under alias `a`. Select the needed identifiers, relationship keys and presentation values; use explicit aliases to avoid colliding names. Keep [application row GUIDs](application-identities.md) distinct from the GUIDs selecting Admin View definitions. Choosing a numeric route ID does not require numeric cross-table relationships.
3. Add each relationship with its source, alias, fields, operator, join type, selection and row type. Design the data shape before writing template loops. A single-row relation enriches the applicable query; a multiple-row relation creates a related collection. Dependent single-row joins can enrich the rows inside that collection.
4. Inspect the available dynamic values and generated property names. Do not guess a collection property from its Admin View name. Include the selected parent/child keys needed to call the related methods. If a friendlier presentation property is useful, normalize it in a focused preparation hook while retaining the configured query.
5. Configure runtime `filter` rows, explicit `where` conditions, `order`, `group` and any required `global` state/object mappings. Trace each filter's value source, type, empty-value behavior and table alias. Apply publication/access/ownership rules to the appropriate parent and related queries. A source selector or relationship does not establish the application's authorization policy.
6. For a main list, select pagination deliberately and define stable ordering, including a tie-breaker where needed. Confirm that filtering and grouping preserve the intended parent count. The main-list pagination setting does not establish pagination for every related collection or custom multiple getter.

A reusable relationship design can be expressed without component-specific code:

| Required data | Dynamic Get configuration | Expected consumer shape |
| --- | --- | --- |
| Main record or list | Main Admin View/database source, alias `a` | `$this->item` or `$this->items` |
| One referenced record, such as a managed classification | Single-row relation from the stored relation key to the reference key; select distinct aliases | Additional selected properties on the applicable row |
| Several owned records | Multiple-row relation from the selected parent key to the child's parent key | Generated collection property on the parent object |
| Descriptive data for each owned record | Single-row relation connected to the multiple-row alias | Properties on each object inside that collection |
| Independent supplementary dataset | Custom single/multiple Dynamic Get attached through the view's `custom_get` | Generated named view property |

Multiple collections need not multiply the parent SQL result. Conversely, declaring an actually multiple relation as single can duplicate parents. Inspect generated queries and test their real cardinality. For larger datasets, review related-query counts and indexes as well as main-list pagination; choose further optimization from measured requirements.

## Attach getters and prepare data

Set the view's `main_get` and attach any extra Dynamic Get records through `custom_get`. JCB generates the normal model calls and view property assignments. Check those assignments before adding another call to the same getter or manually loading data in the view.

Use the smallest suitable preparation point:

| Requirement | Authoring point |
| --- | --- |
| Normal selection, related data, restrictions, ordering or grouping | Dynamic Get configuration |
| Additional list-query behavior | Enabled `php_getlistquery`, after inspecting its generated scope |
| Item-specific or collection preparation | Matching before/after item/items hook or calculation field; inspect the actual variables and early-return paths |
| Reusable algorithm or external service integration | Cohesive Power invoked from the relevant hook, with its dependencies included |
| Document metadata/assets or display orchestration | The matching view field, rather than a data-query replacement |
| Markup and repeated rendering | Templates and layouts |

Service Directory's reference demonstrates the distinction: Dynamic Get retrieves GUID-linked relations, then preparation code maps those generated results to display data and routes. Reuse the technique and only the needed feature records; its complete application-specific mapper is not a mandatory layer for every page.

Follow [authored-code standards](../../standards/authored-code.md) for every added PHP/HTML/CSS/JavaScript body. If the code field's destination or scope is unclear, [trace a GUI code field](debug.md#trace-a-gui-code-field) with a temporary comment and compiler diagnostics, inspect the installed output, then correct the authoring record and recompile.

## Compose the presentation

1. Keep the view's default body focused on the page composition. Split meaningful page sections into named Template records and repeated components into Layout records. A small page need not acquire artificial layers; a complex page should not become one unstructured code field.
2. Define each template/layout's input contract: owning `$this->item`/`$this->items`, or the explicit display data passed to a layout. Handle missing single values and empty related collections. Escape output for its HTML/attribute/URL context; avoid double escaping prepared values.
3. Use literal supported template/layout calls so the compiler can discover and include the records. Keep aliases stable, inspect nested calls, and attach needed Libraries and Powers. A layout's Dynamic Get helper selection displays available values; it does not independently fetch those values at render time.
4. Reuse existing renderers where their data contracts fit. For file/image output, follow the [managed media workflow](media-files.md), including its real file entities and delivery behavior, rather than treating an image as an unrelated free-text field.
5. Review the generated imports and rendering blocks. Use the compiler's supported existing aliases where provided; use the correct SPK/JPK dependencies for additional classes. Keep data loading out of presentation bodies when Dynamic Get already supplies it.

## Compile, inspect and exercise

Import or save the complete changed graph, reopen its persisted values, and attach the view to the component with the required menu/router settings. Compile and install on the agreed target through [Playground](../../testing/playground/README.md) or the user's supplied environment.

Inspect the generated model, view and presentation files in JoomEngine Code. Confirm selected aliases, main and related getters, restriction placement, property assignments, pagination, emitted templates/layouts and imports. Exercise a parent with no related rows, one related row and several rows; missing optional relations; authorized and unauthorized access; filters with empty/invalid values; and list ordering/page boundaries. Check page output, route behavior and asset loading. Save the [integration receipt](validate-and-integrate.md) with the blueprint and generated artifacts required for delivery.

If data is absent, trace the actual property back through its getter, relation keys and restrictions before adding manual queries. If rows repeat, inspect single-row cardinality and grouping. If a collection disappears, inspect its generated method and the selected key passed into it. If markup is missing, check the literal alias, compiler discovery and emitted file. Return fixes to JCB records and supporting sources, regenerate, and report guidance failures through the [Skills feedback workflow](../../testing/reporting-issues.md).
