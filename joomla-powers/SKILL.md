---
name: joomla-powers
description: "Use, create, maintain and validate JCB Joomla Power namespace mappings and Joomla Power Keys (JPK). Use when custom PHP needs Joomla classes, interfaces or traits, version-specific namespaces, component placeholders, collision-safe imports, or Joomla Power repository acquisition. Route custom PHP class implementation and placement to Super Powers (SPK)."
---

# Joomla Powers

Read [README.md](README.md) for scope and [specification.md](specification.md) for the exact mapping contract. Keep this module with the complete JoomEngine Skills distribution.

1. Identify the target Joomla/JCB/PHP versions and the Joomla capability the consumer needs. Inspect that target's actual API; a namespace mapping does not preserve removed methods or changed signatures.
2. Discover the official `joomengine/joomla-powers` catalogue and advertised mirrors through the [repository network](../standards/repository-network.md). Read the selected index and item; preserve configured source order, actual commit and GUID. Do not access `git.vdm.dev`.
3. Follow [use and maintain](workflows/use-and-maintain.md) to acquire mappings, reference JPKs in PHP, or author a missing mapping. Use [Super Powers](../super-powers/SKILL.md) for custom class bodies and class placement.
4. Inspect the selected namespace with [the mapping helper](tools/inspect-mapping.sh); its output is source inspection, not compilation. See [the complete reference example](examples/README.md).
5. Run [integration acceptance](workflows/validate-and-integrate.md): check persisted mappings, compile a real caller, inspect imports and aliases, install and exercise that caller. Record every unrun stage.

Read [sources.md](sources.md) before asserting behavior on another JCB revision. Match exact versions before claiming compatibility. A Joomla Power references an available symbol; it does not install a PHP implementation, configure dependency injection, grant permissions, or supply payment/shipping behavior.
