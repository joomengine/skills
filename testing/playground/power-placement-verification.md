# Custom Power compilation and installed caller

**Observed 3 November 2026.** An agent used a separate disposable Playground site to test one administrator-owned PHP class through JCB's GUI, compiler and an installed component. This is a focused integration exercise, not the full Equipment Loans or Clothing Store scenario, a repository import, or a fresh-agent documentation assessment.

## Maintained source and caller

The site displayed Joomla **6.2.0** and JCB **6.2.0**. The launch selected PHP **8.4**; do not infer an exact patch release or deployed source commit from that selector. The existing Demo J6 component was the consumer, GUID `1c20aec5-bf1a-44e7-9deb-d1c920ca591d`, version `6.0.1`. No production site or remote repository was changed.

The agent created and reopened a Super Power named `PlacementProbe`, GUID `c1dcb28d-aa78-45e2-bb79-512a4518576b`, type `class`, version `1.0.0`. Its saved namespace was:

```text
[[[NamespacePrefix]]]\Component\[[[ComponentNamespace]]]\Administrator\Service.PlacementProbe
```

Its main class code contained only these members:

```php
public function value(): int
{
    return 42;
}
```

The component's `component_dashboard.php_dashboard_methods` field provided the actual caller:

```php
public function getProof()
{
    return (new Super___c1dcb28d_aa78_45e2_bb79_512a4518576b___Power())->value();
}
```

A dashboard tab named **Power Proof** rendered the result through the generated view:

```php
<p id="power-placement-proof">POWER_PLACEMENT_PROOF=<?php echo (int) $this->proof; ?></p>
```

This uses explicit construction for a small stateless service. It does not test Joomla DI registration. The recorded identity belongs to this test; use the documented identity-allocation procedure for a distinct production Power.

## Observed execution

The agent compiled Demo for Joomla 6 with Powers enabled, then used the compiler's supported installation action. Compilation and installation succeeded. Opening the installed Demo dashboard's **Power Proof** tab displayed **`POWER_PLACEMENT_PROOF=42`**. The caller and method remained in their JCB source records; no generated PHP patch was used to produce the result.

JoomEngine Code inspection confirmed these installed values:

| Check | Observed result |
| --- | --- |
| Power file | `administrator/components/com_demo/src/Service/PlacementProbe.php` |
| Namespace | `Demo\Component\Demo\Administrator\Service` |
| Caller file | `administrator/components/com_demo/src/Model/DemoModel.php` |
| Generated import | `use Demo\Component\Demo\Administrator\Service\PlacementProbe;` |
| Generated call | `return (new PlacementProbe())->value();` |

The complete installed class and model were copied through the editor without modification; both passed local PHP **8.3.6** lint. Their SHA-256 hashes were respectively `34875271ee31c6fc3ee63c72b6f6fd9ebeb1f0404e5855e4c30d59f54c2eaa94` and `676f4f71600e55bafe27b8ba99bae27afb5d28e0279cbc266c6601d34328f14c`. The local lint result is separate from the browser runtime result.

Compiler notices about Tidy/string field generation, the absent global Power plugin and the absent global privacy plugin did not prevent this result. The embedded compiler download timed out in the browser automation surface, and the installation action subsequently removed its temporary ZIP. No retained package download is claimed for this exercise; the installed source and actual caller were inspected. Retain the artifact before installation when the installation action removes it.

## Coverage boundary

This establishes one GUI-authored Power, a saved source-token caller, successful compilation/installation and observed execution in the administrator client. It does not establish Site/library placement, another namespace context, a Joomla Power mapping change, DI, source-repository Push/import, whole-site restoration or the behaviour of the separate composed-service and stock-availability candidates. Follow the [customization workflow](../../super-powers/workflows/customize-extension.md) for those additional cases.
