---
name: joomengine-jcb
description: "Build, extend, maintain and validate Joomla extensions from user requirements with Joomla Component Builder (JCB). Route application requests through reusable blueprint entities, custom PHP Super Powers and Joomla class references, repository discovery, authorized MCP or Playground authoring, compilation, testing and delivery. Also use for individual Powers, Field Types, Snippets, Packages and their sub-models."
---

# JoomEngine JCB skills

Read [AGENTS.md](AGENTS.md) for the operating contract. Identify the requested artifact, supported Joomla/JCB/PHP versions and authoritative repository before editing. Read the selected module's scope and verification status; load references only for the affected fields or relationships.

| Task | Entry point |
| --- | --- |
| Turn an application request into a working extension | [Request-to-extension workflow](workflows/request-to-extension.md) |
| Reuse or adapt existing entities and their relationships | [Entity reuse](standards/entity-reuse.md) |
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
| Introduce another model or sub-model | [Module authoring standard](standards/module-authoring.md) |

Trace maintained source through imported records, a real consuming blueprint, generated output and installed behaviour. Use Playground by default for authorized implementation validation when supported browser access is available. Respect explicit opt-outs and record each failed, blocked or unrun stage separately.

Preserve the identity of existing items; allocate new identities under the selected model's rules. Resolve references against current authoritative catalogues without flattening repository precedence. Reuse Joomla facilities and existing Powers before adding another implementation.

Keep source changes and evidence reviewable on the requested branch. Report actual checks and remaining limits. Prepare JCB issue reproductions for [human submission](testing/reporting-issues.md); do not submit under this project's human-led policy.

Keep the complete distribution under `joomengine-jcb` when registering it as an Agent Skill; follow [loading and distribution](standards/skill-loading.md). Nested model entries rely on shared resources in this distribution. Skill loading does not supply browser tools, credentials or authorization, and automatic discovery depends on the actual client.
