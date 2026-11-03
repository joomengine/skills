# From a user request to a Joomla extension

Use these application scenarios to learn and assess the complete [request-to-extension workflow](../workflows/request-to-extension.md). Each starts with an ordinary request, identifies consequential decisions, maps the application to JCB models, and defines observable acceptance. They are implementation briefs and test cases, **not prebuilt extensions or successful execution reports**.

| Scenario | What it exercises | Starting point |
| --- | --- | --- |
| [Note Desk](note-desk.md) | Concrete Fields, Admin View, frontend list/detail, routing, permissions and a reproducible compile | The existing minimal package transport fixture and a small new application graph |
| [Equipment Loans](equipment-loans.md) | Related tables, custom PHP services, date rules, concurrent writes and an optional connected-MCP route | Reused Fields/views plus project-specific Super Powers |
| [Clothing Store](clothing-store.md) | Variants, parent/child editing, import, stock/pricing API, checkout, shipping and payment lifecycle | A researched reuse plan spanning Packages, Field Types, Joomla Powers, Super Powers and presentation assets |

Read only the scenario relevant to the task. Its suggested data model is a design starting point; reconcile it with the user's requirements and the actual target JCB/Joomla version. Do not invent an existing country selector, cart, carrier adapter or payment class merely because a scenario needs one. Discover available entities through the [reuse procedure](../standards/entity-reuse.md), inspect their configuration and code, and record why each is reused, adapted or newly authored.

Keep JCB authoring records and supporting repositories as the maintained source. Put application algorithms in cohesive PHP classes using the [customization workflow](../super-powers/workflows/customize-extension.md); use view code for presentation and the actual supported integration hooks. A generated-file patch is complete only after the source produces it again.

For execution, use the user's suitable authorised environment or [Playground](../testing/playground/SKILL.md); inspect [MCP setup](../workflows/mcp.md) when that route is available. Choose [deliverables](../workflows/delivery.md) separately: installation ZIP, blueprint/supporting repositories and a complete site export serve different purposes.

The [scenario acceptance procedure](../testing/scenarios/README.md) defines how to run these prompts with a fresh agent and record outcomes. Its [verification record](../testing/scenarios/verification.md) distinguishes written procedures, offline checks, browser/native integration, remote publication and restored artifacts. A passing documentation checker does not mark these applications complete.

These are original application briefs. Existing fixtures and upstream examples retain their stated identities, attribution and licenses; the briefs do not relicense their dependencies. Generate fresh identities for distinct applications rather than copying reserved fixture GUIDs.
