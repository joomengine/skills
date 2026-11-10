# Build presentation views and their data queries

A [`site_view`](../reference/site_view.md) renders a frontend page; a [`custom_admin_view`](../reference/custom_admin_view.md) renders a custom backend page. They are distinct from a database-backed [Admin View](admin-views.md). Each has its own GUID and must be attached through the appropriate [component child](component.md#attach-views-through-full-linking-records). A [`dynamic_get`](../reference/dynamic_get.md) supplies data; [`layout`](../reference/layout.md) and [`template`](../reference/template.md) hold reusable presentation code. None of these records alone creates the application's write model or permission policy.

For a build, follow the [Dynamic Get and presentation workflow](../workflows/dynamic-get.md). Configure ordinary data loading, relationships and restrictions in Dynamic Get, then render its results through connected templates and layouts. Inspect the [reference patterns](../../examples/reference-patterns.md#dynamic-gets-and-presentation) before writing replacement query or view plumbing. JCB deliberately leaves advanced application design open; custom PHP remains available for requirements beyond the configured query, with responsibility for its correctness in the authored source.

Make all authored interface text, including buttons and accessible labels, translatable in every Site View, Template and Layout. Follow the complete [language-string workflow](../workflows/language-strings.md) for Text/JPK references, per-file imports, HTML separation, collection, filters, spreadsheet export/import and runtime verification.

## Define a page from its consumer inward

Set `system_name` for authoring identification, `name` for the view's display identity, and `codename`/`context` deliberately for generated code and context. Keep the GUID stable when updating the same view. Renaming a generated route or code name can affect menus, router code, links, templates and integrations even when the package identity stays unchanged.

The view's `default` holds its main layout body. `main_get` is the primary Dynamic Get; `custom_get` is a collection of additional getters. Match the PHP/template's expected result shape to the getter type rather than treating every result as a list. Add the required Libraries to `libraries`; writing a stylesheet URL in a comment or selecting a Snippet does not attach a Library. The `snippet` and `dynamic_get` helper selections can themselves serialize as references, but do not replace the authoritative code or the `main_get`/`custom_get` consumer configuration.

Optional view logic is controlled by distinct switches and contexts:

| Settings | Intended context to inspect in generated output |
| --- | --- |
| `add_php_view` / `php_view` | PHP associated with rendering the view's presentation. |
| `add_php_document` / `php_document` | Document preparation, including assets/metadata. |
| `add_php_jview_display` / `php_jview_display` | Generated view display method logic. |
| `add_php_jview` / `php_jview` | Additional generated view-class PHP. |
| CSS/document JavaScript/JavaScript file flags and bodies | Their corresponding inline/document/file output, not a universal code injection slot. |
| Custom buttons and AJAX flags/collections | Generated actions and handlers; validate routing, authorization and input handling separately. |

Use complete code for the actual slot's scope: a class member cannot be inserted into an expression/body slot just because both accept PHP. Existing generated source is useful to locate that scope; make the lasting edit in the blueprint. The [Customview data consumer](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Customview/Data.php) processes the default body, Library attachments, template/layout discovery and primary/custom getters. The [view references](../reference/site_view.md) retain the complete enable/body pairs and nested button shapes.

## Choose a Dynamic Get source and result shape

| Setting | Source-supported meaning and consequence |
| --- | --- |
| `main_source=1` | Query an Admin View selected by `view_table_main`; its GUID identifies the generated table definition. Use `view_selection`. |
| `main_source=2` | Query a Joomla database table selected by `db_table_main`; this is a database-table value, not an Admin View GUID. Use `db_selection`. |
| `main_source=3` | Supply `php_custom_get`; the inspected compiler disables the configured joins, filters, where/order/group/global collections for this path. Implement the required query/result behaviour in that code. |
| `gettype=1` | Main single-item getter (`getItem`). |
| `gettype=2` | Main list query (`getListQuery`); design pagination and ordering together. |
| `gettype=3` / `4` | Custom single/multiple getters; set `getcustom` and attach the record to the view's `custom_get`. The generated display method calls attached getters and assigns their results to view properties. Inspect the generated property names instead of adding duplicate calls. |
| `select_all=1` | Select all columns. The inspected compiler also falls back to `*` for an empty selection; an empty string is not “select none.” |

For generated queries the main table alias is `a`. Define explicit selections/aliases when a stable template contract matters, particularly with joins or future schema changes. A query referencing a raw Joomla table requires that table to exist at runtime; the package graph cannot create or migrate an external extension's schema merely from its name.

The generated view loads a main single result into `$this->item`, a main list into `$this->items`, and the enabled main-list pagination into `$this->pagination`. Attached custom getters supply additional named properties; the inspected compiler derives a property from `getcustom` by removing `get` and normalizing the remainder. These attached Dynamic Get records are distinct from the related-result methods generated internally for multiple-row joins. See [`DisplayMethod::get()` and `getCustomGet()`](https://github.com/vdm-io/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/CustomView/DisplayMethod.php).

The package exporter has a specialized transform: custom-source records null out the inapplicable table/query collections; view and database sources clear each other's main-table value and custom PHP. The view-table assignment includes a strict numeric `source === 1` check. Preserve supported value types and inspect the exported payload; do not assume every numeric-looking string behaves identically. Nulls have the import semantics described in the [package contract](../specification.md), so an exported null does not independently prove an existing imported value was cleared. Sources: [DynamicGet exporter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Remote/DynamicGet/Set.php), [query model](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Dynamicget.php).

## Joins, restrictions and hooks

`join_view_table` points to Admin View GUIDs; `join_db_table` names external/database tables. Each row supplies `as`, join `type`, `on_field`, `operator`, `join_field`, `selection` and `row_type`. Join types are `1` LEFT, `2` LEFT OUTER, `3` INNER, `4` RIGHT and `5` RIGHT OUTER. Select the actual supported operator from the [nested reference](../reference/dynamic_get.json); do not replace an enum with literal SQL.

The row type determines the generated relationship structure:

- `row_type=1` adds a single-row relation to the applicable query. A relation connected to main alias `a` contributes to the parent query; one connected to a multiple-row relation can enrich that relation's separate query.
- `row_type=2` generates related-result methods and attaches their returned collections to the owning data objects. This supports a parent with several independently loaded collections, each with its own joined descriptive data. It does not simply flatten every related row into the parent query.

Declare relationships in dependency order, select the linking fields needed by related getters, and use the editor's dynamic-value helper plus generated model to identify the resulting property names. Service Directory demonstrates GUID-linked collections with single-row joins inside them; follow its [blueprint-to-output example](../../examples/reference-patterns.md#dynamic-gets-and-presentation). Check both the parent query and related methods: wrongly declaring a one-to-many relationship as single can duplicate parents, while related getters need their own restrictions and suitable indexes. A configured single-row relation does not create a uniqueness constraint in the database. Source: [`Dynamicget::processJoinGroup()`](https://github.com/vdm-io/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Dynamicget.php).

`filter` connects a runtime source (`filter_type`) and `state_key` to a `table_key`/operator, with an explicit empty-value setting. Its source options include IDs, users, access levels, groups, categories, tags, dates, function variables, arrays, repeatable data and other values. `where` supplies a table key/operator/value expression; `order` defines column/direction; `group` names grouping keys. `global` maps named values to state (`type=1`) or the object (`type=2`). These are not automatically authorization rules. Confirm the generated code obtains and validates the intended input and applies access constraints for the current user.

Enable `addcalculation`/`php_calculation` or the matching before/after item/list hook for focused data preparation. Main and custom single/list paths have different insertion points and variables; inspect the generated method before relying on a scope. Custom single getters use the item generator; custom multiple getters support their list-query and before/after-items hooks. `add_php_getlistquery`/`php_getlistquery` affects query construction, not a presentation template. The inspected consumer handles content `plugin_events` for the main single-item type. See [hook preparation](https://github.com/vdm-io/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Dynamicget/Data.php) and [custom method generation](https://github.com/vdm-io/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Dynamicget/Methods.php). Test hooks with missing records and empty lists, not only populated results; an early return can precede an after hook.

Keep query configuration responsible for fetching rows. Use focused hooks or reusable Powers for application-specific preparation, such as computed display values, route preparation or integrating a service. Keep HTML composition in presentation records. Follow [authored-code standards](../../standards/authored-code.md), including readable formatting, documented methods and correct SPK/JPK references for added dependencies.

## Reuse layouts and templates

Layouts and templates are GUID-keyed package records with an `alias` used by code references. They hold their respective `layout`/`template` body, optional enabled `php_view`, descriptive metadata and Library selections. Choose an alias unique in the relevant lookup context and keep it stable when callers depend on it. The compiler's alias lookup tries supplied and normalized forms; two names that normalize alike can be ambiguous even when their GUIDs differ.

Their `dynamic_get` selector supports the editor's display of available dynamic values; it is not proof that the rendered layout independently invokes that getter. The inspected alias consumer compiles the saved presentation/PHP and Library attachments. Supply the actual data through the owning view/module and the supported layout call, then test the expected variables. See the [layout editor's dynamic-value helper](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/media/js/admin/layout.js).

Use a literal supported layout/template invocation, then inspect the dependency scan and generated destination. The compiler discovers references in selected HTML/PHP, resolves aliases, caches records by target/view and recursively scans nested presentation code. A dynamically constructed alias is not proven discoverable merely because PHP could evaluate it at runtime. Explicitly verify that every nested layout/template and asset is emitted. See [Templatelayout/Data](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Templatelayout/Data.php) and [Alias/Data](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Alias/Data.php).

## Author and prove the page

1. Define URL/menu entry, user/access expectations, single/list result shape, empty/not-found behaviour and the exact target Joomla/PHP versions.
2. Reuse or create the Dynamic Get and required table/view references. Configure explicit selections, joins, restrictions, ordering and hook flags. Review result cardinality before writing presentation code.
3. Create/modify the Site or Custom Admin View, attach getters/Libraries and compose its default body from cohesive templates and reusable layouts. Define each input contract; keep each block focused enough to understand and maintain. Use the [presentation steps](../workflows/dynamic-get.md#compose-the-presentation) rather than accumulating query logic, HTML and services in one field.
4. Attach the view to the component, including applicable menu/router settings. Import/refresh the complete graph and reopen the persisted values.
5. Compile; inspect generated model query and bindings, view class, layout files, asset registration and route/menu wiring. Resolve every external table/service/Power requirement.
6. Install and exercise authorized/unauthorized users, empty/one/many rows, joins with missing/multiple matches, search/filter/order/pagination, invalid request values and nested layout rendering. Record the [integration receipt](../workflows/validate-and-integrate.md).

For a blank page, inspect the view attachment, getter result shape and generated errors before changing the HTML. For missing rows, compare generated SQL and bindings with expected source data and access constraints. For duplicate/wrong counts, inspect join cardinality and pagination. For a missing layout, inspect the exact alias/reference scanner and emitted path. For a missing asset, follow [Library and asset resolution](libraries-and-assets.md); the view's successful compile is not proof that a browser loaded its dependencies.

New compiler claims above were inspected on 2026-11-09 at JCB `6.x`, commit `037752c7e6599aa4cec900138dfb61af7ee4ba8f`. This is source evidence; use the [current production version policy](../../standards/version-policy.md) for builds. Existing older citations retain their historical scope.
