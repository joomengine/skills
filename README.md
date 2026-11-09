# JoomEngine Skills

**Joomla Packaging Engine Skills** guides agents from an application request to a complete, stable, runnable Joomla extension ready for deployment on the agreed target. The workflow covers requirements, reusable entities, custom PHP behaviour, compilation, installed validation and final delivery, with maintainable JCB source throughout. Start with the [request-to-extension workflow](workflows/request-to-extension.md); use the model routes below for a focused change.

Use the **latest JCB** for new work, resolving the current production release when the build begins. Development tasks can use the latest alpha/beta channel. Historical source hashes document inspected behavior; they do not lock the skills to that release. Follow the [version policy](standards/version-policy.md).

Real component builds drive improvement. If following the skills fails to produce the requested outcome or requires an undocumented workaround, [report the problem in the Skills repository](testing/reporting-issues.md). Maintainers use those reports to improve the instructions, examples and tools.

The official [JoomEngine skills repository](https://github.com/joomengine/skills) provides operational guidance for agents working across the **Joomla Component Builder (JCB) ecosystem**. Use [SKILL.md](SKILL.md) as the concise task router, then load only the relevant module, reference and workflow. This repository explains how to locate authoritative sources, make consistent changes and verify the result; it complements JCB source code and its [architecture publication](https://architecture.joomlacomponentbuilder.com/).

**Start with [SKILL.md](SKILL.md) and [AGENTS.md](AGENTS.md), then follow the relevant task below.** Focused skill entry points cover Super Powers, Field Types, Snippets, Packages and shared Playground integration. Consult the [skill registry](registries/skills.json) for entry points and the [module registry](registries/modules.json) for scope and verification status. Follow the [loading guide](standards/skill-loading.md) to supply a complete portable distribution to an agent.

## Choose the task

A starting prompt can be as simple as: “Use https://github.com/joomengine/skills to build my Joomla component in Playground. It must manage equipment, borrowers and loans, prevent overlapping loans, and give me the extension installer and a complete site I can import.” Add an existing Joomla MCP connection when that is the intended environment. The agent discovers available capabilities, asks only for consequential missing requirements, and follows the [application workflow](workflows/request-to-extension.md) through delivery. No local JCB server is required for the browser Playground path.

| Task | Read next |
| --- | --- |
| Build an extension from a user's application requirements | [Request-to-extension workflow](workflows/request-to-extension.md) |
| Reuse an existing entity or create an independent adaptation | [Entity reuse and dependency acquisition](standards/entity-reuse.md) |
| Design portable application keys and modal relationships | [Application identities](packages/workflows/application-identities.md), [modal relationships](packages/workflows/modal-relationships.md) |
| Store subform children in their own tables and Admin Views | [Normalized subforms](packages/workflows/normalized-subforms.md) |
| Load page data and related collections through JCB | [Dynamic Get recipe](packages/workflows/dynamic-get.md) |
| Reuse a complete file uploader, image cropping and display feature | [Files and images](packages/workflows/media-files.md) |
| Locate reusable features in Demo, Service Directory and JCB | [Reference pattern catalogue](examples/reference-patterns.md) |
| Trace generated code to its GUI field and maintain readable source | [Compiler tracing](packages/workflows/debug.md#trace-a-gui-code-field), [authored code standard](standards/authored-code.md) |
| Select the correct import mechanism | [Import router](packages/workflows/imports.md) |
| Understand repository operations and limit Push destinations | [Operations overview](standards/repository-operations.md), [publication preflight](packages/workflows/publication-preflight.md) |
| Add algorithms, integrations and clean PHP classes to an extension | [PHP customization and class placement](super-powers/workflows/customize-extension.md) |
| Reference supported Joomla classes through JPK | [Joomla Powers skill](joomla-powers/SKILL.md) |
| Author on the user's Joomla/JCB installation through MCP | [MCP setup, discovery and execution](workflows/mcp.md) |
| Hand over a compiled extension, blueprint or complete site | [Delivery and verified restoration](workflows/delivery.md) |
| Try a small, intermediate or e-commerce application request | [Worked scenarios and outcomes](examples/README.md) |
| Check what an independent agent has actually demonstrated | [Scenario acceptance](testing/scenarios/README.md) and [execution ledger](testing/scenarios/verification.md) |
| Discover official repository families across the code distributed network | [Ecosystem catalogue](registries/ecosystem-repositories.json) |
| Understand, create, extend, maintain, or debug a Super Power repository | [Super Powers skill](super-powers/SKILL.md) |
| Create or maintain Field Types, research Joomla properties/defaults, or override a core definition | [Field Types skill](field-types/SKILL.md) |
| Create or maintain reusable view snippets and their classifications | [Snippets skill](snippets/SKILL.md) |
| Create or maintain component, module or plugin blueprint repositories | [Packages skill](packages/SKILL.md) |
| Find a package sub-model or exact serialized field | [Model router](packages/models/README.md), [contract inventory](packages/model-contracts.json) |
| Build a package in JCB's GUI and Push its source to an authorized branch | [Playground authoring and export](packages/workflows/author-in-playground.md) |
| Test an implementation in browser-hosted JCB, compile it and inspect its output | [Playground integration workflow](testing/playground/README.md) |
| Choose Joomla/PHP versions, deployment and initial URL path | [Playground configuration](testing/playground/configuration.md) |
| Report a build outcome or missing/incorrect skill guidance | [Skills feedback and issue reporting](testing/reporting-issues.md) |
| Select current JCB releases and interpret historical source references | [Latest-version policy](standards/version-policy.md) |
| Find the right JCB architecture context | [Architecture map](architecture/README.md) |
| Add another operational module to this repository | [Module authoring standard](standards/module-authoring.md) |
| Discover monitored core mirrors, reduce GitHub reads or recover source access | [Repository network workflow](standards/repository-network.md) |
| Check registered Power repositories and their roles | [Power repository registry](registries/power-repositories.json) |
| Find the official Field Types baseline and additional catalogue rules | [Field Type repository registry](registries/field-type-repositories.json) |
| Find the official Snippets baseline and additional catalogue rules | [Snippet repository registry](registries/snippet-repositories.json) |
| Determine documented scope and validation status | [Module registry](registries/modules.json) |
| Run the repository checks | [Validation tools](tools/README.md) |

## Shared engineering policy

JCB performs the heavy lifting through reusable authoring records and its compiler. Pull a suitable Field, Admin View, presentation feature or whole blueprint with its dependencies, then adapt the necessary parts. The [reference catalogue](examples/reference-patterns.md) connects focused Demo patterns and advanced Service Directory composition to practical recipes. These components demonstrate techniques; their business models are not universal application requirements.

JCB deliberately offers advanced authors freedom without restrictive architectural guardrails. The skills teach sound choices within that freedom: use generated retrieval and persistence where they fit, compose Templates and Layouts, and write readable custom behaviour for the application's remaining needs.

1. Research Joomla core/framework solutions for the supported versions first.
2. Search [joomengine/super-powers](https://github.com/joomengine/super-powers), the **central shared foundation and reference standard** for JCB-owned reusable classes.
3. Search relevant specialist Power repositories.
4. Implement new code when the existing capabilities do not adequately satisfy the requirement; record the concrete reason.

Reuse is a design decision, not a requirement to inherit from an unsuitable class. Preserve cohesive responsibilities, dependency injection, established public contracts, and portable Power metadata. Shared foundational changes require review of their consumers.

Prefer immutable GUIDs for relationships between new application entities. Keep Joomla numeric primary keys and distinguish application identities from JCB definition GUIDs and business keys such as SKU. Stable keys make data exchange and multi-database integration easier; database replication, conflict resolution and synchronization still need their own implementation. Preserve deliberate existing ID-based contracts unless a migration is requested. See [application identities](packages/workflows/application-identities.md).

## Official core entity catalogues

[`joomengine/joomla-fieldtypes`](https://github.com/joomengine/joomla-fieldtypes) is the official core Field Types repository. [`joomengine/snippets`](https://github.com/joomengine/snippets) is the official core Snippets repository. Additional repositories can extend those catalogues or intentionally override the same existing items.

Every repository must account for its domain's current core catalogue when allocating a new GUID, as well as additional configured catalogues and local unpublished records. Preserve the original GUID when improving or overriding the same item; generate a fresh collision-checked identity for a distinct new item. Retain source provenance and effective repository order so intentional overrides are visible rather than silently replacing unrelated definitions.

These are different entity formats. A Field Type describes the foundation and configurable properties of concrete fields; a Snippet supplies reusable source content. Use the relevant module's contract instead of copying Super Power file layouts or settings into them.

Use the maintained [repository network](standards/repository-network.md) for core-source discovery and alternative read transports. Its live target list expands over time; preserve canonical identity and record the actual mirror and revision. [`joomengine/packages`](https://github.com/joomengine/packages) is the default Package repository.

## Default integration environment

The [Playground agent guide](testing/playground/README.md) in this repository is the canonical guide for **using Playground to build Joomla extensions**. Playground's runtime Agent link points here. Documentation for developing Playground itself stays in the [Playground repository](https://github.com/joomengine/playground); link to the relevant technical reference when needed instead of maintaining a second agent workflow there.

[JoomEngine Playground](https://playground.joomengine.org/) is the default integration route for agents with browser access working on executable JCB changes. It runs Joomla, PHP and MariaDB in the browser and supplies a JCB deployment, so an agent can configure a repository's target and read branch, import candidate definitions, inspect their local records, compile a real consumer and exercise the generated extension. Respect user opt-outs and declared target versions. Static checks still run; an unavailable browser or unsupported target must be recorded as an unrun integration stage.

Start with the [Playground skill](testing/playground/SKILL.md), then the relevant module's acceptance procedure. Powers require a real class reference and caller; Field Types require concrete Fields and generated form/storage checks; Snippets require copied view content, assets and rendered behaviour; Packages require the root's actual component/module/plugin graph and generated consumers. The [shared receipt](testing/playground/verification.md) and each module's verification record distinguish completed stages from remaining checks. The [configuration reference](testing/playground/configuration.md) documents current version choices, URL parameters and platform limits; future Joomla or development releases become test targets only when the actual Playground supports them.

These operational modules document parts of JCB's blueprint and compilation lifecycle. Import success proves one part of that lifecycle. The intended end-to-end test follows the maintained definition through compilation into an installed, exercised extension, with a separate result for each stage.

## How to use the documentation efficiently

Read the module entry point, the contract sections relevant to the change, and its workflow. Follow source links when a claim depends on version-specific behaviour or when evidence has changed. Use examples to understand the format; do not copy their identities into distinct new records.

The documentation distinguishes project policy, implementation behaviour verified at a recorded revision, observed examples, and known gaps. Static validation, JCB import/compilation, and application runtime checks are separate levels of evidence. A check at one level never silently certifies the others.

For an agent working in another repository, follow the [loading and distribution guide](standards/skill-loading.md). Keep shared tools and references with the model entry points; register the complete distribution when the client supports skills, or supply its path/URL explicitly. An agent will not necessarily discover these instructions automatically. The repository name change does not install capabilities or grant publication access.

This repository's original CC0 [license](LICENSE) is retained. Source examples retain their original attribution and licensing; the repository license does not relicense third-party material.
