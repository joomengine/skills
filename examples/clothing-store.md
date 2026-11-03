# Clothing Store: a complete application acceptance brief

**Scenario type:** the project owner's example, expanded into an implementation and acceptance brief. **Execution status:** see the [scenario verification record](../testing/scenarios/verification.md). No storefront, payment integration or shipping integration is claimed implemented by this document.

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
| Products and variants | Product and Variant Admin Views with concrete Fields and view associations; variant → product key, SKU uniqueness, attributes, price and stock ownership. |
| Classification | Reuse suitable categories and size/colour/gender definitions; choose Joomla-managed categories or separate views intentionally. A product may need multiple category associations. |
| Orders and lines | Separate Order and Order Line records with stable relationships; preserve item description, selected attributes and agreed price/tax snapshots so later catalogue edits do not rewrite order history. |
| Addresses and shipping | Appropriate country/state/city Fields or related views where available; consistent address validation, shipping-rate/service references and the chosen carrier/rules. Avoid assuming every destination has the same address hierarchy. |
| Imports and stock updates | Custom admin interface or supported import flow plus PHP parsing/validation/application services; JCB API generation configured for the required views and protected update semantics. |
| Storefront | Site Views for listing, detail, cart and checkout; Dynamic Gets for product data; reusable layouts, assets/JavaScript and explicit router configuration. |
| Configuration | Component option Fields for nonsecret settings and a supported secure configuration path for runtime service credentials. Do not bake tokens into portable source or public backups. |

Follow [component assembly and API selection](../packages/models/component.md#attach-views-through-full-linking-records), [Fields and relationships](../packages/models/fields-and-relationships.md), and [presentation/query/router guidance](../packages/models/presentation-and-queries.md). API generation is selected on the appropriate component/Admin View associations. Inspect the generated routes, supported operations, authentication, ACL and save path for the installed version; neither a visible flag nor a successful compile proves the accounting integration.

### Trace an existing normalized subform

The public Packages specimen at `4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9` contains [Addresses (look-subform)](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/71e5f1b0-7c81-4fbb-8a05-e3949212f2ed/item.json). Its `store: 6` expert handlers, `on_get_model_field` and `on_save_model_field`, call the referenced Super Power factory's `Data.Subform` service against the separate `address` table, using the `look` parent relation and application-row `guid`. The subform XML defines the controls; the PHP handlers implement their related-table load/save path. Trace the Field, owner view/attachment, Address Admin View and referenced Factory/Subform Power dependencies before adapting the pattern for product variants.

The same revision's [Countries (multisubform)](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/4d96ceea-7dd1-45c3-86fd-0d73d66332a8/item.json) uses `Data.MultiSubform` with nested country/timezone relationships. It is a useful second source when nested ownership is actually required, not a reason to make a simple variant editor more complex. These are inspected source examples, not runtime passes for the Clothing Store or guarantees that those records fit its domain unchanged.

The related Variant view/table must exist and its API must be configured independently when required. A normal repeatable JSON field does not automatically create a table or API. Adapt relation keys, fields and identities consistently, then test create, edit, remove and parent ownership through both form and API paths. Parent/child rows use application keys; those keys are distinct from the JCB package GUIDs used to link authoring definitions.

API selection is implemented in the pinned JCB [Resources::option](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Api/Resources.php) and [Plugin/Routes::resource](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Api/Plugin/Routes.php). Use the [current model guide](../packages/models/component.md#attach-views-through-full-linking-records) for the selection contract and recheck the target revision. Inspect the generated webservices plugin, enabled state, real routes, authentication and permissions before promising an accounting endpoint. Also inspect any generated public read routes associated with Site Views for unintended internal pricing, customer or order data exposure.

## Design custom behaviour as reusable PHP services

Use [Super Powers and Joomla Powers](../super-powers/workflows/customize-extension.md) for coherent PHP classes and framework references. Reuse the shared foundation before introducing new implementations. Potential responsibilities include price calculation, inventory reservation/reconciliation, import mapping, checkout coordination, payment verification and shipping adapters. These are responsibilities to discover or implement, not names of guaranteed existing catalogues.

Keep presentation and JavaScript focused on browsing and interaction. Calculate authoritative totals, stock availability and order transitions on the server. Inject database, clock and remote-service collaborators; isolate providers behind contracts so failure/retry cases can be tested without live transactions. Decide whether each class belongs in administrator source, site source or supported shared/library placement from its actual consumers, then verify generated namespaces and autoload/services.

Define the payment state transitions and inventory effects explicitly. A browser return URL must not alone establish payment success. Verify the provider's documented authoritative confirmation and associate it with the expected order, amount and currency. Handle duplicate/delayed notifications idempotently. Establish current PayPal and carrier behaviour from their official documentation when implementing; this brief does not specify unverified endpoint names or imply outbound/inbound networking works inside browser-hosted PHP.

## Build in verifiable increments

1. Establish a reuse ledger and application key/relationship map. Acquire the smallest useful existing entities using the [reuse workflow](../standards/entity-reuse.md); preserve unchanged identities and remap distinct adaptations coherently.
2. Build catalogue administration and variant persistence first. Save/reopen through JCB, compile, install and exercise the generated forms. Verify actual schema and related-table handling before adding checkout.
3. Add the storefront, product queries, layouts, assets and router. Exercise published/access filtering and variant selection against real saved data.
4. Add the import and authenticated stock/pricing update paths. Use the same application rules as appropriate and test duplicates, malformed rows, stale data and access limits.
5. Add cart, order creation, shipping and payment using the agreed policies. Test deterministic rules locally, then verify provider integration in a suitable sandbox/native environment. Record browser networking limits instead of declaring a mock equivalent to a live sandbox pass.
6. Export the maintained blueprint and supporting entities, rebuild from a clean JCB instance, and rerun the acceptance cases. Deliver through the [delivery workflow](../workflows/delivery.md), with remote backup and complete-site restoration tested separately when requested.

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

Keep separate evidence for static/source checks, provider-free tests, JCB compilation, installed behaviour, concurrent requests, PayPal sandbox, carrier sandbox, blueprint read-back and site restore. Fulfil the requested result only when its applicable cases pass, or explicitly describe the remaining incomplete capability. A neat storefront or downloaded component ZIP alone is insufficient evidence for this application.
