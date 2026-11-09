# Joomla Powers: use Joomla APIs from maintained JCB source

A **Joomla Power Key (JPK)** identifies a version-aware namespace mapping. Use it in custom PHP to refer to a Joomla or generated-component class, interface or trait. JCB resolves the mapping and injects the PHP import during compilation. The implementation must already exist in Joomla, the generated extension, or a correctly installed dependency.

A **Super Power Key (SPK)** identifies a maintained custom PHP class/interface/trait whose implementation JCB can compile into the extension or its library. Put algorithms and application services in [Super Powers](../super-powers/SKILL.md); use Joomla Powers inside those classes when Joomla APIs are needed. Neither key is a service-container registration.

| Task | Read |
| --- | --- |
| Understand token spelling, version rows and serialized fields | [Mapping contract](specification.md) |
| Find a Joomla class, acquire its mapping and call it | [Use and maintain](workflows/use-and-maintain.md) |
| Inspect a mapping without loading PHP or Joomla | [Mapping helper](tools/inspect-mapping.sh) and [example](examples/README.md) |
| Compile, install and test a real consumer | [Integration acceptance](workflows/validate-and-integrate.md) |
| Check authority and validation limits | [Sources and verification](sources.md) |

Use the [latest JCB version policy](../standards/version-policy.md) and inspect the current compiler's target mappings. The recorded JCB `6.x@408703a857ad937479b1e28de7f693af178dcc83` snapshot, inspected on 2026-11-03, advertised mapping rows for `0` (fallback), `3`, `4`, `5` and `6`. This is historical metadata evidence, not a required JCB version or a frozen target list. Resolve current choices through the actual [Playground configuration](../testing/playground/configuration.md) and the requested Joomla target.

This module documents namespace mappings, acquisition, maintenance and PHP consumption. It does not generate Joomla core classes, implement domain logic, or validate every API signature. The reference catalogue and offline helper are inspected; Joomla Power import, compilation and installed runtime acceptance for this documentation change have not been run. Do not present static examples as a completed extension.
