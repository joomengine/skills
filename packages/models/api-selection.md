# Select and verify generated APIs

Use this guide for the API delivered by a compiled component. A Joomla MCP connection used to author JCB records is a different service; follow [MCP execution](../../workflows/mcp.md) for that connection.

**Source baseline:** JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f`, inspected 9 November 2026. The following describes compiler source, with installed HTTP acceptance still required for each component and runtime.

## Choose resources and operations

`add_api` is a setting on each [component-to-Admin-View attachment](../reference/component_admin_views.md), not an attribute that automatically exposes all records of an Admin View everywhere.

| Value | Selection | Generated admin route families |
| --- | --- | --- |
| `0` | None | No resource for that admin attachment. |
| `1` | List | GET collection. |
| `3` | Item | GET item; POST collection; PATCH and DELETE item. |
| `2` | Both | Collection and item operations above. |

“Item” includes writes. Selecting it does not grant create/edit/delete permission, nor does it promise that a domain model allows every generated action. Disabled/invalid choices and Joomla targets below 4 resolve to none. Source: [attachment form](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/forms/component_admin_views.xml), [Resources::option/admin](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Api/Resources.php), [Routes::resource](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Api/Plugin/Routes.php).

**Audit the entire route set.** In this revision, enabling any admin API also enables discovery of eligible custom-admin/site dynamic resources through `Resources::enabled()` and `dynamic()`. Their future per-link `add_api` check is commented out. Supported item/list dynamic gets can produce read routes; custom-SQL main gets are excluded. Site `public_access=1` can make those reads public. Turning off one admin attachment is not a global declaration that no other resource is exposed. Inspect generated routes, names/collision warnings, serializers and permissions before delivery; maintain a scoped route policy in the actual plugin/source if generated exposure exceeds the request.

## Build and install the route plugin

1. Set the intended attachment values and field permissions in maintained JCB records. Decide public versus authenticated access and the allowed operations for each resource.
2. Author/link the `webservices` plugin in the component context. Put `[[[API_ROUTES_METHOD]]]` in its class body for the complete generated method, or `[[[API_ROUTES]]]` inside a deliberately authored compatible handler. Use one method owner and avoid duplicate subscriptions. The executable [Placeholder](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Placeholder.php)/[Placefix](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Utilities/Placefix.php) contract uses triple brackets or triple hashes, despite double-bracket shorthand in the route renderer's comment.
3. Compile the component and its attached plugin. Confirm tokens expanded, generated PHP parses, the API client/files exist, and the route plugin uses the target's native event signature/subscriber. The Joomla 6 renderer emits `BeforeApiRouteEvent`; this is separate from the positional [compiler-plugin events](../workflows/compiler-plugins.md).
4. Install the genuine component and plugin ZIPs, enable the webservices plugin, and use the consumer's `/api/index.php/` base. Record the actual routes/methods from the emitted plugin rather than inventing URLs from display names.

## GUIDs, business keys and numeric controllers

For admin resources, the route renderer emits paths under `v1/<component-code>/<list-code>`. Item routes include `/:id` and eligible alternate keys such as `/guid/:guid` or `/sku/:sku`. [RecordId](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Api/Controller/RecordId.php) resolves a positive numeric `id` first; otherwise it resolves the first supplied eligible key, with GUID first, through the Table and returns its numeric ID. Failure on that supplied key returns zero rather than trying every other supplied key.

The compiler recognizes a stored `guid` column specially and other supported stored Fields with `indexes=1` as unique selectors; `list=2` excludes a Field from stored-column discovery. This is not proof of a physical UNIQUE constraint: inspect emitted and installed indexes and enforce [application identity](../workflows/application-identities.md). A scalar GUID relationship does not make the referenced row's business key immutable. The GUID route regex accepts 36 hex/hyphen characters; full UUID validation belongs in the application contract. Preserve Joomla's normal controller/ACL path after lookup.

## PATCH and authorization acceptance

The [Joomla 6 API item-controller template](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/API_VIEW_CONTROLLER.php) retains the submitted payload separately and hydrates omitted stored columns from `getItem()`. Explicit null/empty remains submitted input. Hydration is limited to table columns, with separate tags handling; it does not prove preservation of every external expert-subform projection. If a revision is mandatory for a write, check the original payload so an inherited revision does not accidentally satisfy that requirement.

Test the final installed routes with authorized synthetic fixtures:

- Authenticated collection/item reads; expected fields only; numeric/GUID/business-key selectors resolve the same row.
- Create and PATCH identity rules, unknown/immutable fields, missing versus null/empty values, stale revisions and malformed selectors.
- Anonymous and restricted-account reads/writes, record ownership, parent-change permissions and access/view-level filtering. An empty filtered list and a forbidden item response are different expected outcomes.
- Each exposed DELETE route: either successful authorized domain deletion or deliberate rejection with unchanged data.
- Expert child omission versus explicit replacement, error response status/body and unchanged unrelated values.

Record HTTP status, response and resulting database state. Seeing a Forbidden body without data is not evidence of the exact status, authenticated success or restricted-account coverage. If a route is absent, inspect attachment, resource eligibility, plugin generation/installation/enabled state and route collisions before changing controllers. Fix maintained source and recompile after any diagnostic edits.
