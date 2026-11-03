# Note Desk: a small complete extension

**Scenario type:** original implementation brief. **Execution status:** see the [scenario verification record](../testing/scenarios/verification.md); this page is not a completed build receipt.

## Prompt

> Use https://github.com/joomengine/skills to create a Joomla component called Note Desk entirely with Joomla Component Builder. Administrators should create notes with a title, body and published state. Visitors should browse published notes and open one note through a friendly URL. Unpublished notes must remain private. Give me the installable extension and retain its editable JCB source. Use Playground if I have not supplied a suitable JCB site.

## Decisions and baseline

Establish the target Joomla/JCB/PHP versions, intended administrator roles, and whether the body accepts formatted HTML. Clarify an existing naming or repository constraint if supplied. Otherwise choose a small implementation, state the choice, and continue. Repository destinations and credentials are needed only when the delivery task reaches an authorised remote write; absence of a destination must not prevent local source creation and compilation.

Inspect the [minimal package repository](../packages/examples/minimal-repository/README.md) for the component → view association → Admin View → Field association → Field → external Field Type chain. It is a complete, statically checked **transport fixture**, not evidence that Note Desk or even that fixture has been compiled. Its Note view and Title Field illustrate the contract; its fixture GUIDs are not new-application identifiers. Follow the [creation procedure](../packages/workflows/create-repository.md) and allocate new identities for this separate application.

## Build with JCB

1. Search the current core and authorised project indexes for appropriate text/body Fields and Field Types. Inspect their XML, storage, reusable placeholders and required libraries. Reuse unchanged definitions when suitable; adapt with new identities when the intended consumer behaviour differs.
2. Create one Note Admin View and attach the chosen title/body Fields. Use JCB's appropriate existing state, identity and bookkeeping facilities instead of adding duplicate columns by name. Set list/title/search/display roles, required validation and explicit access behaviour. Inspect the [Admin View guide](../packages/models/admin-views.md).
3. Attach the view to the component. Choose only the needed menus and features. Do not expose an API merely because generation is available; this request does not require one.
4. Add a list Dynamic Get and a single-item Dynamic Get over the Note view. Apply published/access restrictions on the server for both. Create the list/detail Site Views and share a layout only if it removes actual duplication. Match getter shapes to their consumers; review [presentation and queries](../packages/models/presentation-and-queries.md).
5. Attach the Site Views and configure their [router relationships](../packages/models/component.md#router-settings), including item identity, alias and menu context. Escape the title and apply the chosen body filtering consistently. A hidden administrator control does not protect a direct frontend request.
6. Import or save the graph in the target JCB instance, reopen affected records, compile the actual Note Desk component, inspect its generated XML/PHP/SQL, install it, and execute the cases below. Correct maintained source and recompile if any generated-file investigation reveals a defect.

No custom Super Power is mandatory for this small brief. Add a PHP service only when an actual rule warrants it; demonstrate reuse and JCB generation without manufacturing extra abstraction.

## Acceptance cases

Use synthetic data: one published note named **Public note**, one unpublished note named **Private note**, and one note with a literal title such as `<script>example</script>`.

| ID | Action | Required observation |
| --- | --- | --- |
| ND-01 | Create, save, reopen and edit a note as an authorised administrator | The selected values persist; list/search state and edit links point to the same record. |
| ND-02 | Submit an empty title and a value beyond the configured limit | Server-side validation rejects invalid input without partial or silently truncated records. |
| ND-03 | Browse as a visitor, then request the private item's URL directly | Published content is visible; unpublished content is inaccessible through list, detail and alternate request forms. |
| ND-04 | Request a missing item and exercise supported SEF/menu contexts | The defined not-found result occurs; valid links round-trip to the intended record. |
| ND-05 | Open the literal markup title and exercise the permitted body format | The title renders as text; body behaviour matches the chosen filtering policy. |
| ND-06 | Attempt administration as a user without the required permission | Direct create/edit requests are rejected as well as unavailable controls. |
| ND-07 | Make one source-level label or validation change and rebuild | The installed candidate reflects the changed source without a manual generated-file fix. |
| ND-08 | Import the retained source into a second clean JCB instance and compile | Required external definitions resolve; view relationships, privacy rules and generated extension behaviour remain intact. |

Deliver the component ZIP, exact source graph and supporting source references, and a receipt identifying the versions and cases actually tested. If remote backup is requested, verify its read-back separately. If a complete site export is requested, restore that exact export as an independent site and retest ND-01 and ND-03; a source ZIP alone is not a site backup.
