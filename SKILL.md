---
name: joomengine-jcb
description: "Build complete, stable, runnable Joomla extensions from user requirements with the latest Joomla Component Builder (JCB), ready for deployment on the agreed target. Route application requests through reusable blueprint entities, PHP Powers, repository discovery, authorized MCP or Playground authoring, compilation, testing and final delivery. Also use for maintaining extensions, individual Powers, Field Types, Snippets, Packages and their sub-models."
---

# JoomEngine JCB skills

Read [AGENTS.md](AGENTS.md) for the operating contract. Identify the requested artifact, supported Joomla/JCB/PHP versions and authoritative repository before editing. Read the selected module's scope and verification status; load references only for the affected fields or relationships.

Carry the application through the [completion contract](workflows/delivery.md#completion-contract). Resolve the latest JCB at execution time under the [version policy](standards/version-policy.md); source hashes in research references are not runtime requirements. Use the canonical [Playground guide](testing/playground/README.md) for browser authoring.

Let JCB do the routine generation. Start from complete reusable features in the [reference catalogue](examples/reference-patterns.md), acquire their required records, and adapt only what the application needs. JCB intentionally gives advanced authors freedom; apply the established patterns with informed judgment, without adding a framework around capabilities it already supplies.

| Task | Entry point |
| --- | --- |
| Turn an application request into a working extension | [Request-to-extension workflow](workflows/request-to-extension.md) |
| Reuse or adapt existing entities and their relationships | [Entity reuse](standards/entity-reuse.md) |
| Choose GUID application relationships, modal selectors or migrate existing IDs | [Application identities](packages/workflows/application-identities.md), [modal relationships](packages/workflows/modal-relationships.md), [GUID migration](packages/workflows/guid-migration.md) |
| Save repeated form rows to their own tables and Admin Views | [Normalized subforms](packages/workflows/normalized-subforms.md) |
| Load structured page data and compose reusable presentation | [Dynamic Get recipe](packages/workflows/dynamic-get.md), [presentation models](packages/models/presentation-and-queries.md) |
| Add managed file uploads, image cropping and display | [Files and images recipe](packages/workflows/media-files.md) |
| Find complete reference features to pull and adapt | [Demo, Service Directory and JCB patterns](examples/reference-patterns.md) |
| Trace a GUI code field or improve authored source quality | [Compiler tracing](packages/workflows/debug.md#trace-a-gui-code-field), [authored code](standards/authored-code.md) |
| Choose package acquisition, Extrusion, immediate or staged data import | [Import router](packages/workflows/imports.md) |
| Understand Init, Pull, Reset and Push across repository categories | [Repository operations](standards/repository-operations.md) |
| Maintain reusable Custom Code blocks and arguments | [Manual Custom Code](packages/workflows/custom-code.md), [last-resort automation](packages/workflows/custom-code-automation.md) |
| Add custom PHP behaviour and choose administrator/site/library placement | [PHP customization](super-powers/workflows/customize-extension.md) |
| Reference Joomla classes through JPK mappings | [Joomla Powers skill](joomla-powers/SKILL.md) |
| Use an existing Joomla/JCB MCP connection | [MCP setup and execution](workflows/mcp.md) |
| Deliver installable ZIPs, blueprint source or a portable site | [Delivery](workflows/delivery.md) |
| Follow a complete application example and its acceptance cases | [Worked scenarios](examples/README.md), [independent-agent acceptance](testing/scenarios/README.md) |
| Author or maintain reusable PHP Powers | [Super Powers skill](super-powers/SKILL.md) |
| Define field metadata, properties and defaults | [Field Types skill](field-types/SKILL.md) |
| Maintain reusable view source and its classifications | [Snippets skill](snippets/SKILL.md) |
| Build or maintain a component, module or plugin blueprint and its records | [Packages skill](packages/SKILL.md) |
| Find one package sub-model or serialized field | [Model routing](packages/models/README.md), [contract inventory](packages/model-contracts.json) |
| Locate wider JCB blueprint concepts | [Architecture map](architecture/README.md) |
| Author, test or export in browser-hosted JCB | [Playground skill](testing/playground/SKILL.md) |
| Select environment versions and deployment parameters | [Playground configuration](testing/playground/configuration.md) |
| Discover maintained core mirrors or reduce GitHub reads | [Repository network](standards/repository-network.md) |
| Locate official repository families and indexes | [Ecosystem repository catalogue](registries/ecosystem-repositories.json) |
| Run static checks | [Tools](tools/README.md) |
| Report instructions that fail to produce the requested extension | [Skills feedback loop](testing/reporting-issues.md) |
| Introduce another model or sub-model | [Module authoring standard](standards/module-authoring.md) |

Trace maintained source through imported records, a real consuming blueprint, generated output and installed behaviour. Use Playground by default for authorized implementation validation when supported browser access is available. Respect explicit opt-outs and record each failed, blocked or unrun stage separately.

Preserve the identity of existing items; allocate new identities under the selected model's rules. Resolve references against current authoritative catalogues without flattening repository precedence. Reuse Joomla facilities and existing Powers before adding another implementation.

For new application entities, prefer immutable application GUIDs for relationships and portable data exchange, while retaining Joomla's numeric primary keys. Definition GUIDs, application GUIDs, local numeric IDs and business keys have different roles. Each separately persisted child entity needs its own Admin View and component attachment; subform XML alone does not create its table or save lifecycle. Follow the focused workflows above before implementing these features.

Keep source changes and delivery evidence reviewable on the requested branch. When following the skills fails to produce the desired outcome, report the problem in `joomengine/skills` through the [feedback workflow](testing/reporting-issues.md), and continue supported recovery toward completion. Upstream JCB implementation reports follow the separate human-submission procedure in that guide.

Keep the complete distribution under `joomengine-jcb` when registering it as an Agent Skill; follow [loading and distribution](standards/skill-loading.md). Nested model entries rely on shared resources in this distribution. Skill loading does not supply browser tools, credentials or authorization, and automatic discovery depends on the actual client.
