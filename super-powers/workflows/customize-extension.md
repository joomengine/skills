# Add application behaviour with PHP Powers

Use this workflow when fields, views, relationships and the generated CRUD/API baseline need application-specific algorithms, integrations or services. JCB remains the authoring and compilation system: keep custom PHP in its Power source records and repositories, connect it through the relevant JCB model hooks, and regenerate the extension after changes. Begin with the [request-to-extension workflow](../../workflows/request-to-extension.md) when the application has not yet been designed.

## Contents

- [Choose the responsibility and reusable dependency](#choose-the-responsibility-and-reusable-dependency)
- [Choose a compiled location](#choose-a-compiled-location)
- [Author the class and its dependencies](#author-the-class-and-its-dependencies)
- [Wire a real caller and service construction](#wire-a-real-caller-and-service-construction)
- [Validate the source and compiled consumer](#validate-the-source-and-compiled-consumer)
- [Preserve and deliver the customization](#preserve-and-deliver-the-customization)
- [Source evidence and limits](#source-evidence-and-limits)

## Choose the responsibility and reusable dependency

Record the supported Joomla/JCB/PHP versions, the expected operation, its caller and its output/error contract. For a clothing shop, fields and linked Admin Views describe products, variants and order records; focused PHP services supply pricing rules, stock reconciliation, shipping adapters and payment-state transitions. Site Views and their JavaScript render the experience and invoke server operations. Client-side values never establish authoritative prices, stock or payment completion.

Search Joomla's supported classes first, then the central Super Power foundation and relevant specialist catalogues using [reuse and dependencies](../reuse-and-dependencies.md) and [network discovery](../../standards/repository-network.md). Inspect implementations and contracts, not names alone. Keep version, GUID and repository provenance with the selected dependency.

| Mechanism | What the agent authors or references | Result |
| --- | --- | --- |
| Joomla Power, identified by JPK | A GUID mapping to a Joomla class or interface namespace for the generated Joomla target | The compiler resolves a reference to an existing runtime type. It does not create a new implementation of that Joomla class. |
| Super Power, identified by SPK | A PHP class, interface, trait or abstraction with settings and a raw body | JCB creates PHP source in the selected extension or Power-library location and resolves consuming references. |
| JCB view/model hook | A small call into those services in the correct lifecycle context | The generated extension invokes the custom behaviour. A class present on disk is not itself a caller. |

Use [Joomla Powers](../../joomla-powers/SKILL.md) for JPK mapping/version semantics and the [SPK identity contract](../specification.md#identity-spk-and-source-token-are-different-forms) for Super Powers. Published `Super---...---Power` and `Joomla---...---Power` keys are catalogue keys; active PHP source uses `Super___...___Power` and `Joomla___...___Power`. The inner GUID has underscores in both forms. Never paste the hyphen-delimited display key into PHP.

Reuse an existing suitable entity by its GUID. A distinct project-specific derivative needs a new generated, collision-checked identity and consistent remapping of references, while unchanged dependencies keep their original identities. An ordinary maintenance update to the same Power retains its GUID. A placeholder already expressing the desired namespace variation avoids creating a needless duplicate just to rename the consumer.

## Choose a compiled location

**Source-derived behaviour:** at the [inspected compiler revision](#source-evidence-and-limits), placement is driven by the Power's `namespace` template. There is no separate portable `admin`, `site` or `library` switch to invent in `settings.json`. Its final backslash-separated section can contain dotted subfolders and must end in the class name. Read the complete [namespace algorithm](../specification.md#namespace-templates-and-physical-placement) before changing that boundary.

These complete namespace values assume a Power named `PriceRules`, with compiler values `NamespacePrefix=Acme` and `ComponentNamespace=Clothing`. The table predicts compiler build paths from inspected source; confirm the generated package and installed paths during acceptance.

| Intended location | Portable `namespace` setting | Expected path in component build |
| --- | --- | --- |
| Component administrator source | `[[[NamespacePrefix]]]\Component\[[[ComponentNamespace]]]\Administrator\Service.PriceRules` | `admin/src/Service/PriceRules.php` |
| Component site source | `[[[NamespacePrefix]]]\Component\[[[ComponentNamespace]]]\Site\Service.PriceRules` | `site/src/Service/PriceRules.php` |
| Power library, using the default `jcb_powers_path` | `[[[NamespacePrefix]]]\Joomla\[[[ComponentNamespace]]]\Service.PriceRules` | `libraries/jcb_powers/Acme.Joomla.Clothing/src/Service/PriceRules.php` |

For the first row, the resulting PHP namespace is `Acme\Component\Clothing\Administrator\Service` and the class name is `PriceRules`. The second becomes `Acme\Component\Clothing\Site\Service`. The library row becomes `Acme\Joomla\Clothing\Service`. These are settings **values**; encode backslashes as `\\` inside JSON strings.

Choose administrator placement for an administrator-owned service and site placement for a site-owned service. Use a shared Power library namespace when both clients need an independent domain service, or explicitly verify the extension autoloading and ownership when sharing a component class across clients. The core extension namespace route uses Joomla extension loading; the ordinary library route registers its Power namespace through JCB's generated autoloader. Verify the actual caller can load the class in its client, including an API caller if one is part of the application.

A dotted subpath matters: `...\Administrator\Service.PriceRules` retains `Service` beneath `src`; rewriting it as `...\Administrator\Service\PriceRules` changes the algorithm's path boundary. Do not normalize a settings namespace to look like ordinary PHP. Keep the exact case and final name, and avoid a name/path already generated by JCB such as an existing model or provider unless an intentional supported override is part of the design.

The library row is a Power packaging/loader location, not automatic creation of an independently managed Joomla library extension. Check the generated manifest, installer/update/uninstall handling and namespace ownership when multiple extensions share library code. Custom `jcb_powers_path`, plugin or module targets require their actual target source and generated package inspection. The component resolver has explicit Administrator/Site patterns at this revision; do not invent an equivalent `Api` placement rule from those two rows.

The [live administrator exercise](../../testing/playground/power-placement-verification.md) verified one class using the first namespace convention, its generated import and an installed dashboard caller. Site/library placement and other contexts retain their separate acceptance gates.

## Author the class and its dependencies

1. Use [create a Power](create-power.md) or [maintain and debug](maintain-and-debug.md). Keep the index, `settings.json`, raw body `code.power`, derived `code.php` and README consistent. In the GUI, the corresponding record holds the same identity, namespace, relationships and main class code. The repository body contains members only: omit `<?php`, the namespace, outer class declaration and its outer braces.
2. Put one cohesive responsibility in each class. Define a narrow interface for a replaceable database, shipping, payment or accounting boundary; inject it into the domain service. Keep request parsing, Joomla ACL/CSRF checks and response rendering at the appropriate application boundary. Keep transactions, concurrency and retry/idempotency guarantees explicit for state-changing operations.
3. Use GUID selectors for Super Power parents, interfaces and `use_selection`; use `load_selection` only when inclusion without a normal import is needed. Ensure every selected dependency resolves and its legal PHP type matches the relationship. Importing or loading a provider does not register it.
4. Use a verified Joomla Power source token when referring to a Joomla runtime type. Its target mapping must match the generated Joomla major. A JPK does not guarantee that an optional package is installed or that signatures match across versions. Explicit runtime imports/custom inheritance are also supported through the existing [settings contract](../settings-reference.md); do not place a Joomla Power GUID into a Super Power-only relationship selector.
5. Retain portable placeholders rather than the resolved namespace from one `code.php` preview. Verify public signatures, exceptions, service keys, aliases and licences when adapting existing code. Allocate new identities only for distinct new entities, and update all affected graph edges.

The [complete composed-service fixture](../examples/composed-service/README.md) supplies two fully indexed Powers: a `UnitPriceProvider` interface and a `LineTotal` service that receives it in its constructor. Its body uses a PHP short name supplied by `use_selection`. Run its test to see how the same service can accept a deterministic adapter without Joomla. A production database adapter is a separate application responsibility and must implement the interface against the actual generated schema.

## Wire a real caller and service construction

Choose the consuming JCB model and enabled PHP field by its lifecycle, available variables and generated location. Use the [package model router](../../packages/models/README.md) and the affected field reference. For example, a product/order Admin View operation, a Site View's supporting model or an authorised API operation can call the same service where the operation's contract permits it. Do not assume every field executes at the same time or that all PHP fields are class-member insertion points.

Keep hooks thin: validate/authorise the request, construct or obtain the service, call its public method and translate its outcome into the appropriate Joomla result. Move the algorithm into a Super Power so web UI and API callers share it. An automatically generated CRUD API does not automatically execute a checkout, stock reservation or payment workflow; connect and test the intended server operation explicitly.

For a service using Joomla DI:

1. Select the compatible Joomla `Container` and `ServiceProviderInterface` mapping/imports and define the concrete adapter class as a Power where required.
2. Register the adapter under the service key or interface alias used by the consumer. Bind its real database/configuration dependencies at construction time.
3. Register the domain service with a factory that retrieves that adapter from the same container and passes it to the constructor.
4. Include the provider through an actual GUID reference or supported load selection **and call its registration through the owning factory/bootstrap**. Class placement, PHP `use`, `use_selection` and `load_selection` do not activate registration.
5. Obtain the service through the intended application's container/factory in a real caller. Preserve the correct scope and lifetime; avoid cross-request mutable state in a shared service. Joomla's global container and a specialist factory's private container are not automatically the same container.

Follow the complete, pinned [factory/provider trace](../reuse-and-dependencies.md#concrete-shared-factory-and-di-trace) for actual source examples of interface, factory, provider, aliases, service keys and constructor factories. It demonstrates structure, not a mandate to depend on an unrelated OpenAI service or copy its identities. For a small stateless service, explicit constructor composition can be sufficient; do not add a container purely to satisfy a pattern.

Ensure the effective compiler Power switch is enabled for the component. At the inspected revision, `Config::getAddpower()` reads the compiler's posted `powers` override or the component's `add_powers` value. This is distinct from the Super Power repository-export setting. Verify the effective compile settings in the actual JCB version; a populated source record alone does not prove inclusion.

## Validate the source and compiled consumer

Follow the full [Power integration procedure](validate-and-integrate.md) using the user's authorised Joomla/JCB instance or [Playground](../../testing/playground/README.md), with its supported [configuration](../../testing/playground/configuration.md). Record these specific assertions:

1. **Source:** the complete candidate validates, PHP lints, targeted algorithm/error cases pass and dependency identities resolve against the intended ordered sources. A fixture identity is not a production allocation.
2. **Persistence:** configure the candidate read branch and required sources. Init imports absent records; deliberate Pull refreshes selected remote records; Reset uses effective configured sources. Inspect reopened body, namespace, GUID and selected relationships, not just the operation's notification.
3. **Consumer:** compile an extension whose enabled code actually calls the changed service. Include a concrete implementation for interfaces and a real registration/caller for DI providers.
4. **Output:** inspect the expected Administrator, Site or library file, generated namespace, aliases, JPK/SPK replacement, actual body, loader and package inclusion. Check that all active tokens were resolved and no unrelated generated class was overwritten. Lint generated PHP on the actual supported version.
5. **Runtime:** install the result and execute the real UI/API caller, including a normal case, relevant boundary/failure case, and denied access where applicable. Assert database effects and transaction/idempotency behaviour when the operation changes state. A manually included preview class bypasses the loader and does not prove integration.
6. **Portability:** when placement or placeholders changed, recompile under another component/namespace context and verify the intended paths and caller again. For a shared service, exercise each supported client rather than assuming administrator success proves site/API behaviour.
7. **Round trip:** retain diagnostic evidence, carry fixes back to the source Power or owning JCB record, then regenerate and repeat affected checks. An edit in JoomEngine Code is not a durable Power change by itself.

If a token remains, inspect its delimiters, GUID, active field and compiler switch before changing application code. If the class is missing, check the consuming reference, persisted candidate, namespace final name and placement. If DI lookup fails, inspect registration and container ownership. If the wrong code runs, check local stale records and repository precedence before pulling/resetting a wider scope.

## Preserve and deliver the customization

Deliver the compiled extension requested by the user and retain the source relationship graph. An authorised source backup can contain the component's Packages repository plus its distinct Super Power, Joomla Power or Field Type repositories when those definitions were created or adapted. Unchanged external dependencies keep their own repository identities and provenance. Do not put a Super Power body in `src/power` of the Packages repository as a substitute for its own model contract.

For GUI authoring, configure each actual writable repository, scoped credentials, write branch and the entity's export/approval settings. Inspect effective destinations before Push and verify the resulting files on the remote branch. Read the blueprint into a clean JCB instance, resolve the dependent Powers and repeat compilation/runtime acceptance. Follow [GUI source export](../../packages/workflows/author-in-playground.md) and the selected model's export contract; a component source Push is not evidence that every separately maintained Power was backed up.

## Source evidence and limits

Inspected on **2026-11-03**. The public `joomengine/Joomla-Component-Builder:6.x` head resolved through the GitHub connector to `408703a857ad937479b1e28de7f693af178dcc83`, matching the local source used below. This is source evidence; it does not certify the version installed in a running Playground.

- [Power::setNamespace](https://github.com/joomengine/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php): placeholder expansion, dotted suffix, class-name check, extension/library path and autoloader namespace registration.
- [Joomla Path::core](https://github.com/joomengine/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Joomla/Path.php): Administrator/Site component prefixes and module/plugin paths. Match rules at this revision are prefix-based; use the exact documented namespace form and inspect output rather than relying on unusual prefix collisions.
- [Power Structure::build](https://github.com/joomengine/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Structure.php): file creation under the component build or selected extension root.
- [Power Autoloader](https://github.com/joomengine/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Autoloader.php): generated library namespace mapping and `JPATH_ROOT` lookup; this is distinct from Joomla's component namespace loader.
- [Compiler Config](https://github.com/joomengine/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Config.php): separate inclusion and repository-export configuration.
- [Power Injector](https://github.com/joomengine/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Injector.php) and [Joomla Power Injector](https://github.com/joomengine/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/JoomlaPower/Injector.php): source reference replacement and imports. Follow [Joomla Power sources](../../joomla-powers/sources.md) for mapping and target selection.

The two-Power example's algorithm can be exercised locally; its JCB import, compiled placement, Joomla DI and installed consumer are separate acceptance stages. See [verification](../verification.md) for actual results. Refresh these sources when the target revision changes instead of treating a fixed example as a permanent compiler rule.
