# JCB's native building blocks

Joomla Component Builder (JCB) turns connected authoring records into a Joomla extension. Start by modelling the application's data and pages in those records. Let the compiler generate routine forms, models, queries and wiring; add custom PHP for the behavior the application still needs.

## The short concept map

| Building block | Role and connection |
| --- | --- |
| Field Type → Field | A Field Type defines the kind of control and its supported properties; a concrete Field configures an actual application value/control. |
| Fields → Admin View | An Admin View defines application data and its conventional **backend** list/edit management. Attach it to the component with the required fields, access and persistence configuration. |
| Admin View → Dynamic Get | A Dynamic Get retrieves data from an Admin View's table, with selected fields, relationships, filters and ordering. It can provide a main item/list or additional data. |
| Dynamic Get → Site View | A Site View presents that data on the **frontend**. Attach the getter and the Site View to their actual consumers, including component/menu/router configuration. |
| Dynamic Get → Custom Admin View | A Custom Admin View presents a custom **backend** page using a query/presentation structure like a Site View. It is not the conventional Admin View/table definition. |
| View → Templates and Layouts | The view composes the page; Templates provide page sections and Layouts provide reusable rendering fragments. They render supplied data rather than automatically fetching it. |
| Hooks → Powers and Libraries | Native code hooks call additional behavior. Super Powers supply reusable PHP classes; Joomla Powers resolve Joomla class references; Libraries/files supply required assets and external dependencies. |
| Component associations → Compiler → Extension | The component assembles the selected records and settings. Compilation produces installable Joomla output. Preserve the authoring graph so fixes survive regeneration. |

**The usual data path:** Fields and Admin Views define the data → Dynamic Gets retrieve it → Site Views show it on the frontend, or Custom Admin Views show it on the backend → Templates and Layouts compose the presentation.

Dynamic Get also supports an existing database table or custom PHP as its source. Use those capabilities when appropriate rather than forcing every page into a table query. For example, the immediate importer's getter supplies session-owned upload state, while the queued importer also retrieves saved queue rows. Neither exception changes the normal Admin View → Dynamic Get → presentation relationship.

## Choose the smallest native composition

| Requested feature | Start with |
| --- | --- |
| Maintain application records in administrator | Fields, Admin View and component association, then generated CRUD. |
| Show those records on a public page | Dynamic Get plus Site View, Templates/Layouts and required route/access configuration. |
| Provide a custom administrator screen | Dynamic Get plus Custom Admin View, Templates/Layouts and the required actions. |
| Upload, map and immediately apply a spreadsheet | The [native immediate importer](../packages/workflows/translation-import.md#author-the-native-jcb-graph): session-state getter, Custom Admin View, upload Template, mapping Layouts, Ajax/controller hooks and existing Powers. |
| Queue a spreadsheet for later processing | The [native Demo queue](../packages/workflows/staged-import.md#native-record-map): the same presentation approach plus managed Files, persisted jobs/messages and an installed, enabled console processor. |

Keep data retrieval in Dynamic Get when it expresses the requirement. Put presentation in the view, Templates and Layouts, and additional algorithms in cohesive Powers with real callers. A small page does not need extra services merely to wrap JCB-generated behavior.

## Read only what the task needs

- [Admin Views](../packages/models/admin-views.md) for tables, Fields and backend management.
- [Dynamic Get workflow](../packages/workflows/dynamic-get.md) and [presentation contract](../packages/models/presentation-and-queries.md) for retrieval, view types, hooks and composition.
- [Component associations](../packages/models/component.md#attach-views-through-full-linking-records) for assembling the graph.
- [Import router](../packages/workflows/imports.md) for package import versus application-data import, and immediate versus queued processing.
- [Request-to-extension workflow](../workflows/request-to-extension.md) for the complete build and delivery process.

This is an orientation map, not a separate authoring format or a completed beginner build. The linked model contracts carry the detailed source evidence and acceptance procedures. The [importer receipt](../packages/evidence/importer-building-blocks.md) records what the two concrete examples actually demonstrated.
