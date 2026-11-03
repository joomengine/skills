# Equipment Loans: related records and custom PHP behaviour

**Scenario type:** original implementation brief. **Execution status:** see the [scenario verification record](../testing/scenarios/verification.md).

## Prompt

> Use https://github.com/joomengine/skills to build an Equipment Loans Joomla component with JCB. Staff should manage individual pieces of equipment, borrowers and reservations. Authorised users should see availability and request a loan. An item cannot have overlapping active reservations. Staff can approve, cancel and mark a loan returned. Keep the business rules in reusable PHP classes and deliver the extension plus its editable blueprint. Use my connected Joomla/JCB MCP if suitable; otherwise use Playground.

## Clarify consequential rules

Establish the operating timezone, whether reservations use dates or timestamps, which statuses block availability, who may approve/cancel, and whether borrowers are Joomla users or independent records. Confirm whether adjacent reservations are permitted. For this example's reference cases, use half-open timestamp intervals `[start, end)` so a return at 10:00 permits the next loan at 10:00; this is an explicit example rule, not a JCB default.

The prompt specifies individual items, not a quantity pool. If the user instead needs pooled inventory, revise the capacity algorithm and acceptance cases before implementation. Do not silently reinterpret one as the other.

## Model and reuse plan

Use a separate Equipment Admin View/table and Reservation Admin View/table. A reservation links to one equipment row and one authorised borrower identity and stores its start/end, state and necessary audit values. Use Joomla users directly when that is the agreed borrower model. A separate borrower view is warranted only for additional independent data or lifecycle. The [Field/relationship guide](../packages/models/fields-and-relationships.md) distinguishes application-row keys from JCB package GUIDs.

Research existing text, date/time, status and record-selection Fields, supported Field Types, and suitable layouts before creating replacements. Inspect any shared definition's storage and timezone assumptions. Reusing a control does not supply the reservation algorithm, database constraints or permission policy.

Create availability/list/detail Site Views and their Dynamic Gets. Apply ownership/access filters in the write/read paths as required, and keep joins and pagination explicit. Build the parent/child administrator experience using the target's supported linked-view or subform mechanism; verify actual persisted rows. A repeated form field alone does not prove separate-table storage.

## Keep algorithms in PHP classes

Use the [customization workflow](../super-powers/workflows/customize-extension.md) to define or reuse cohesive Super Powers. Use Joomla Powers to reference appropriate Joomla framework classes. Choose placement from the actual consumers: administrator-only code, site-only code, or shared/library use as supported by the target compiler. Verify the emitted namespace, autoloading and service registrations in both required clients.

Separate these responsibilities:

- **Reservation rules:** validate intervals, state transitions and overlap semantics without a browser or database dependency.
- **Reservation persistence:** fetch conflicting rows and perform the agreed atomic create/update operation using Joomla database facilities. Prepared query bindings, transactions and concurrency strategy belong here.
- **Reservation application service:** authorise the requested operation, apply the rules and coordinate persistence. Inject the required collaborators and clock; do not duplicate policy in a view and an API handler.

Wire real generated consumers to the service using supported JCB PHP hooks. A named class saved in a Power repository is not evidence that any request invokes it. Frontend JavaScript may improve date selection, but server-side rules must reject invalid direct requests. Keep durable edits in the Power inputs and owning JCB records.

## Execute through the available environment

Inspect the connected [MCP's advertised tools and permissions](../workflows/mcp.md) before choosing it. Confirm that it can read back the needed records and perform the required operations in the intended site. Use the supported GUI where a necessary operation is absent; do not invent tool names or assume database write access implements JCB import/export.

Compile and install in a disposable target. Use PHP unit/smoke checks for pure rules and actual Joomla requests for persistence, service wiring and ACL. Exercise concurrency in an environment that supports simultaneous requests; a serialized browser test cannot establish race safety.

## Acceptance cases

Reference data: equipment **Camera A**; authorised borrowers **User A** and **User B**; an active reservation from 09:00 to 10:00 on the same test day in the chosen timezone. Record the equivalent stored timestamps. Start each case from a separate copy of this baseline and add only that case's extra rows. In particular, EL-04 must not retain the adjacent reservation created by EL-03. Record any deliberately different setup with the case result.

| ID | Action | Required observation |
| --- | --- | --- |
| EL-01 | Save a reservation, reopen it, and inspect its equipment/borrower links | The intended related rows and keys persist; no duplicate borrowed-object record is created. |
| EL-02 | Request 09:30–10:30 for Camera A | The server rejects the overlap under the chosen blocking-state rule. |
| EL-03 | Request 10:00–11:00, then equal/reversed endpoints | The adjacent interval succeeds; zero-length and reversed intervals fail. |
| EL-04 | Cancel the active reservation and retry the formerly conflicting request | Availability changes according to the documented state policy, without deleting history unintentionally. |
| EL-05 | Modify a reservation while excluding its own identity from conflict lookup | An unchanged interval does not conflict with itself; moving into another reservation is rejected. |
| EL-06 | Submit two conflicting creates concurrently through real supported requests | At most one succeeds; no conflicting persisted pair remains after both requests finish. Record the concurrency evidence. |
| EL-07 | Request another user's private record or approval action without permission | Read/write access follows the agreed roles; frontend filtering alone is insufficient. |
| EL-08 | Exercise the agreed timezone boundary and a clock change if applicable | Displayed and stored instants agree; comparison uses the documented interval semantics. |
| EL-09 | Change a rule in its maintained Power, rebuild, and invoke administrator and site consumers | Both intended callers use the new implementation; there are no stale duplicated rule bodies. |
| EL-10 | Import the blueprint and supporting Power sources into clean JCB and rebuild | The resulting extension reproduces the tested rules, wiring and related-record behaviour. |
| EL-11 | Mark an approved/active loan returned as authorised staff, repeat the operation, then attempt it without permission | The agreed return transition and resulting availability hold; repeated submission has no duplicate side effects, history remains intact, and the unauthorised operation is rejected. |

Deliver the generated extension and package/Power sources with the class-placement evidence and the cases actually run. Clearly retain a blocked concurrency test as blocked rather than promoting pure-PHP checks to a runtime pass.
