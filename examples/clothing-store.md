# Clothing Store: a complete application acceptance brief

**Scenario type:** the project owner's example, expanded into an implementation and acceptance brief. **Execution status:** see the [scenario verification record](../testing/scenarios/verification.md). The [9 November contribution review](../packages/evidence/clothing-store/documentation-review.md) records reported implementation slices and their limits; its companion source/acceptance archives were not available for this review. This brief does not establish a completed shop or verified payment/shipping integration.

## Prompt

> Use https://github.com/joomengine/skills to create a small e-commerce component entirely with Joomla Component Builder. Sell clothing in different sizes, colours, genders and categories. Customers need browsing, a shopping cart, shipping and PayPal checkout. Administrators need products, variant matrices, product import, price updates and stock management. Provide an authenticated API so my accounting system can update stock and pricing. Ask the necessary questions, use reusable JCB entities where suitable, validate the compiled extension, and deliver the Joomla package. Offer an editable blueprint backup and complete Playground site export when finished.

## Decide only what changes the implementation

Group material questions so the agent can continue model/reuse research while answers are pending:

1. **Commercial data:** operating currency, price/tax basis, selling countries, category/gender conventions and whether variants have independent SKU, price and stock. Confirm the identifier shared with the accounting system.
2. **Stock authority:** whether accounting owns absolute available stock, how reservations/sales are reconciled, what happens to stale or duplicate updates, and whether backorders are allowed. Establish the update contract from actual accounting-system examples.
3. **Checkout:** guest/account requirements, shipping provider or explicit initial shipping-rate rules, the required PayPal integration, and sandbox account availability. A payment link and a verified payment/order lifecycle are different scopes; clarify what the user expects.
4. **Import and operation:** obtain a representative import file and map required columns, update keys and error behaviour; confirm staff roles, privacy requirements, target versions and final delivery choices.

Avoid blocking field/view research on missing remote credentials. Continue deterministic application work, but label unperformed gateway/carrier integration as blocked. Use test-mode services and synthetic customer data for the example; production transactions require the actual task's authority and configuration.

## Plan the JCB graph

Treat the following as a design starting point rather than a fixed exported schema. Confirm real reusable entities from their indexes, READMEs, configuration and code; record the canonical repository, actual mirror/revision, identity and reuse/adaptation decision.

| Application area | JCB authoring responsibilities |
| --- | --- |
| Products and variants | Product and Variant Admin Views, each attached to the component and owning its table; concrete Fields, `variant.product_guid` → Product application `guid`, SKU uniqueness, attributes, price and stock ownership. |
| Classification | Reuse suitable categories and size/colour/gender definitions; choose Joomla-managed categories or separate views intentionally. A product may need multiple category associations. |
| Orders and lines | Separate Order and Order Line Admin Views/tables with `orderline.order_guid` and `variant_guid` relationships; preserve item description, selected attributes and agreed price/tax snapshots so later catalogue edits do not rewrite order history. |
| Addresses and shipping | Appropriate country/state/city Fields or related views where available; consistent address validation, shipping-rate/service references and the chosen carrier/rules. Avoid assuming every destination has the same address hierarchy. |
| Imports and stock updates | Synchronous upload/map/Apply flow using the shared Transient importer through domain adapters; an Operation Admin View/table for durable replay records; JCB API generation selected for Variants and protected update semantics. |
| Storefront | Site Views for listing, detail, cart and checkout; Dynamic Gets for product data; reusable layouts, assets/JavaScript and explicit router configuration. |
| Configuration | Component option Fields for nonsecret settings and a supported secure configuration path for runtime service credentials. Do not bake tokens into portable source or public backups. |

Follow [component assembly](../packages/models/component.md#attach-views-through-full-linking-records), [API selection](../packages/models/api-selection.md), [Fields and relationships](../packages/models/fields-and-relationships.md), and [presentation/query/router guidance](../packages/models/presentation-and-queries.md). API generation is selected on the appropriate component/Admin View associations. Inspect the generated routes, supported operations, authentication, ACL and save path for the installed version; neither a visible flag nor a successful compile proves the accounting integration.

### Select portable application identity

Use immutable application GUIDs for this store's Product, Variant, Order, Order Line and Operation rows and their application relationships. Retain numeric Joomla primary keys, users, assets and access levels. A JCB definition GUID identifies the authoring record; a SKU is a business key with its own uniqueness/lifecycle. Neither substitutes for the application's row GUID. Follow [application identities](../packages/workflows/application-identities.md) for schema, allocation, copy and import rules; deliberate numeric relationships remain supported for other applications.

Enforce uniqueness in the actual generated/installed schema and preserve existing identities on edit/import. Seed relationships with persisted application keys, never the GUID of a Field or Admin View definition. A retained legacy `product_id` must be derived from `product_guid`, not independently writable. Use the [migration workflow](../packages/workflows/guid-migration.md) for an existing ID-based store; a new design policy is not permission to rewrite its data automatically.

GUIDs make cross-environment identity and import/export reconciliation easier. Database replication, conflict resolution, query/index design and concurrent stock control still need their own implementation and tests.

### Trace an existing normalized subform

The public Packages specimen at `4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9` contains [Addresses (look-subform)](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/71e5f1b0-7c81-4fbb-8a05-e3949212f2ed/item.json). Its `store: 6` expert handlers, `on_get_model_field` and `on_save_model_field`, call the referenced Super Power factory's `Data.Subform` service against the separate `address` table, using the `look` parent relation and application-row `guid`. The subform XML defines the controls; the PHP handlers implement their related-table load/save path. Trace the Field, owner view/attachment, Address Admin View and referenced Factory/Subform Power dependencies before adapting the pattern for product variants.

The same revision's [Countries (multisubform)](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/4d96ceea-7dd1-45c3-86fd-0d73d66332a8/item.json) uses `Data.MultiSubform` with nested country/timezone relationships. It is a useful second source when nested ownership is actually required, not a reason to make a simple variant editor more complex. These are inspected source examples, not runtime passes for the Clothing Store or guarantees that those records fit its domain unchanged.

The related Variant view/table must exist and its API must be configured independently when required. Every separately persisted child entity needs its own actual Admin View and component association, even when staff normally edit it inside Product's subform. A normal repeatable JSON field does not automatically create a table or API. Follow [normalized subforms](../packages/workflows/normalized-subforms.md) for both expert handlers, the non-database parent attachment, complete projection and guarded Items adapter. The shared setter's replacement behaviour is not this store's deletion policy: reject omitted inventory rows or apply the explicit domain policy before mutation.

Validate/stage child changes, save the Joomla parent, then apply the checked child-only inventory batch. Do not claim one atomic parent-plus-child transaction without verifying the actual Table/Asset driver path; the contribution reports an implicit-commit failure on that path. A late child failure must clearly report that parent details were saved while child changes were not. Test new child creation, ordinary edits, malformed/omitted data, wrong-parent ownership and Save as Copy separately. Parent/child rows use application keys; those keys are distinct from the JCB package GUIDs used to link authoring definitions. Follow [modal relationships](../packages/workflows/modal-relationships.md) for GUID selection, title lookup, numeric edit routing and linked-New defaults.

API selection is implemented in the pinned JCB [Resources::option](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Api/Resources.php) and [Plugin/Routes::resource](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Api/Plugin/Routes.php). Use the [current model guide](../packages/models/component.md#attach-views-through-full-linking-records) for the selection contract and recheck the target revision. Inspect the generated webservices plugin, enabled state, real routes, authentication and permissions before promising an accounting endpoint. Also inspect any generated public read routes associated with Site Views for unintended internal pricing, customer or order data exposure.

## Design custom behaviour as reusable PHP services

### Use the selected immediate importer

Follow [import routing](../packages/workflows/imports.md) and the [immediate importer workflow](../packages/workflows/immediate-import.md). This store selects the synchronous pattern of JCB's [translation importer](../packages/workflows/translation-import.md): session-owned upload, header preview, mapping, Apply, results and cleanup. Reuse the actual shared Transient/reader/mapper services with a domain Parent adapter that validates and collects rows before the application transaction writes inventory. Reject the batch on reader/row errors, invalid mappings, duplicate SKU or stale revisions; recheck ownership and revisions at commit. An importer success banner alone does not establish that every row succeeded.

Map SKU, product GUID, title, size, colour, gender, integer minor-unit price, stock, revision and published state, with optional variant GUID. Existing SKU and supplied GUID must identify the same row. Record explicit size/row/sheet limits for the implementation. The contribution's 2 MB, 5,000-row and sheet-0 choices are example limits, not shared defaults. Test identical replay without duplicate records or repeated revision increments. Package acquisition, Extrusion and the [Demo Looks staged queue](../packages/workflows/staged-import.md) are separate operations; do not add a worker/cron requirement to this synchronous design.

### Compose domain services and their consumers

Use [Super Powers and Joomla Powers](../super-powers/workflows/customize-extension.md) for coherent PHP classes and framework references. Reuse the shared foundation before introducing new implementations. Potential responsibilities include price calculation, inventory reservation/reconciliation, import mapping, checkout coordination, payment verification and shipping adapters. These are responsibilities to discover or implement, not names of guaranteed existing catalogues.

Keep presentation and JavaScript focused on browsing and interaction. Calculate authoritative totals, stock availability and order transitions on the server. Inject database, clock and remote-service collaborators; isolate providers behind contracts so failure/retry cases can be tested without live transactions. Decide whether each class belongs in administrator source, site source or supported shared/library placement from its actual consumers, then verify generated namespaces and autoload/services.

Define the payment state transitions and inventory effects explicitly. A browser return URL must not alone establish payment success. Verify the provider's documented authoritative confirmation and associate it with the expected order, amount and currency. Handle duplicate/delayed notifications idempotently. Establish current PayPal and carrier behaviour from their official documentation when implementing; this brief does not specify unverified endpoint names or imply outbound/inbound networking works inside browser-hosted PHP.

## Build in verifiable increments

1. Establish a reuse ledger and application key/relationship map. Acquire the smallest useful existing entities using the [reuse workflow](../standards/entity-reuse.md); preserve unchanged identities and remap distinct adaptations coherently.
2. Build catalogue administration and variant persistence first. Save/reopen through JCB, compile, install and exercise the generated forms. Verify actual schema and related-table handling before adding checkout.
3. Add the storefront, product queries, layouts, assets and router. Exercise published/access filtering and variant selection against real saved data.
4. Add the synchronous import and authenticated stock/pricing update paths. Use the same application rules as appropriate and test duplicates, malformed rows, stale data and access limits. Inspect generated GUID/SKU adapters without assuming generic numeric routes have become GUID-aware.
5. Add cart, order creation, shipping and payment using the agreed policies. Test deterministic rules locally, then verify provider integration in a suitable sandbox/native environment. Record browser networking limits instead of declaring a mock equivalent to a live sandbox pass.
6. Preserve compiler prerequisites, durable update SQL, libraries and assets in maintained source. If a build plugin is required, bootstrap/install/enable/select it and compile again; follow [compiler plugins](../packages/workflows/compiler-plugins.md). Check two consecutive builds for retained migrations before delivering an update.
7. Export the maintained blueprint and supporting Powers separately using [publication preflight](../packages/workflows/publication-preflight.md), rebuild from clean JCB, and rerun applicable acceptance cases. Deliver genuine installer ZIPs and the requested Complete site archive through the [delivery workflow](../workflows/delivery.md). Record source publication, same-site repeat compilation, clean-source rebuild and independent complete-site import as four separate results.

## Observable acceptance

Create synthetic catalogue data: **Tee**, variants **TEE-BLK-M** and **TEE-BLU-L**, each with a unique SKU and independent stock. Use a confirmed currency with two decimal places for this reference dataset: prices of 12,000 and 13,000 minor units, stock of five and zero respectively. Adapt the fixture if the agreed currency has different precision. Record the chosen shipping/tax policy separately so total expectations are reproducible. Restore an independent copy of this baseline before each case; do not allow preceding imports, API writes or payments to change a later case's prerequisites. For CS-07 specifically seed TEE-BLK-M with stock one and no earlier reservations before starting its two competing requests.

Apply integration cases to the agreed scope. For fixed shipping rates, CS-08 checks the exact configured rate and unsupported destination; a carrier timeout applies only to a remote adapter. CS-09/10 are required for verified payment/order integration. If the user explicitly accepts link-only payment, instead verify the configured merchant/link, agreed amount/currency handling and cancellation/return navigation, and verify that a browser return never automatically marks the order paid or triggers fulfilment. Record the accepted link-only limitation; missing sandbox credentials are a blocker for a promised verified integration, not permission to reduce it to a link.

| ID | Action | Required observation |
| --- | --- | --- |
| CS-01 | Create products and variants in the parent editor; save/reopen and inspect rows | Each variant persists in the intended table with the correct product link and unique SKU; add/edit/remove behaviour agrees with the selected ownership policy. |
| CS-02 | Browse/filter by agreed categories, gender, colour and size | Results contain the correct published products; selection resolves an actual available variant rather than an impossible attribute combination. |
| CS-03 | Import a valid row, duplicate SKU and malformed row; repeat the import | The agreed create/update policy holds, errors identify rows, and repetition does not produce duplicate products or variants. |
| CS-04 | Send an authorised pricing/stock update, then missing/invalid credentials and an unauthorised field update | Intended values persist and appear in the storefront; disallowed calls cannot alter data or permissions. Inspect both response and stored result. |
| CS-05 | Repeat and reorder accounting updates, including a missing SKU | The documented idempotency/staleness policy holds; failures are explicit and do not silently update a different item. |
| CS-06 | Add TEE-BLK-M to the cart, tamper with client price/quantity and select TEE-BLU-L | Server-calculated totals use the agreed prices; invalid quantities and zero-stock selections follow policy; client data cannot set the payable price. |
| CS-07 | Race two checkouts for the last item and inject a failure in the write sequence | The reservation/stock policy prevents overselling and partial inconsistent orders. Record real concurrent-request evidence, not only sequential mock tests. |
| CS-08 | Request an allowed and unsupported destination; cause a shipping timeout | The correct service/rate or explicit failure is shown; no unagreed free-shipping fallback occurs. |
| CS-09 | Complete a sandbox payment; also exercise cancellation, invalid confirmation and a tampered browser return | Only validated provider confirmation changes the order to paid; amount/currency/order identity checks hold and rejected requests have no payment side effects. |
| CS-10 | Replay a valid payment notification and process a delayed notification | The order and stock effects occur once under the documented transition policy; retries do not duplicate fulfilment. |
| CS-11 | Change catalogue prices/address data after a test order; inspect that order as its owner and another customer | Historical order values remain correct and access follows the agreed customer/staff rules. |
| CS-12 | Follow product/cart/checkout routes with SEF enabled, missing records and alternate menu contexts | Routes, query results, rendered assets and error outcomes agree; no unpublished or private records leak. |
| CS-13 | Rebuild from exported blueprint plus supporting entity sources in clean JCB | Required PHP classes, API routes, relationships, layouts/assets and behaviour reproduce without manual generated-file edits. |
| CS-14 | Restore a requested complete site export as an independent Playground site | Files, database and configuration are present; catalogue/variant data and nonremote checks still pass. Use the actual complete-site archive, not an arbitrary repository ZIP. |
| CS-15 | Exercise GUID create/edit/import, uppercase input, malformed/duplicate values and Save as Copy | Valid identities remain stable; invalid changes reject; copied parents receive fresh identities without adopting original children; links use real application keys. |
| CS-16 | Select/clear/edit/reselect a Product in a Variant modal and use linked New, including a failed save | Stored GUID, title and edit target agree; defaults never overwrite submitted/recovery data; permissions and wrong-parent cases hold. |
| CS-17 | Upgrade an existing ID-based synthetic store, interrupt/retry, then restore the pre-upgrade backup | Stable journal identities preserve all rows, relationships, historical/replay JSON and business values; drift is detected; restore works independently. |
| CS-18 | Compile twice with the declared compiler prerequisite, then install on clean Joomla without JCB | Required update SQL persists; runtime libraries/assets/autoloaders are present; the final build does not depend on undeclared authoring-host files. |

Keep separate evidence for static/source checks, provider-free tests, JCB compilation, installed behaviour, concurrent requests, PayPal sandbox, carrier sandbox, blueprint read-back and site restore. Fulfil the requested result only when its applicable cases pass, or explicitly describe the remaining incomplete capability. A neat storefront or downloaded component ZIP alone is insufficient evidence for this application.
