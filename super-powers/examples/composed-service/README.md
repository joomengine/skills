# A custom service composed from two Powers

This complete documentation fixture demonstrates the smallest useful application boundary: `LineTotal` calculates a monetary line total through an injected `UnitPriceProvider`. A real Joomla database adapter can implement that interface without putting database or HTTP concerns inside the calculation. The runnable test supplies a deterministic anonymous adapter. This is a teaching example, not an e-commerce extension or a production pricing policy.

Each Power includes `settings.json`, `code.power`, inspection `code.php`, and a README. `super-powers.json` contains both indexed identities. `LineTotal.use_selection` names the interface by GUID, while its source body uses the imported PHP name. There is no global service lookup, client-supplied price or hidden Joomla dependency in the business calculation.

From the complete skills checkout:

```bash
php super-powers/examples/composed-service/smoke.php
```

Expected output: `Composed service: 10 behaviour checks passed.` Requires PHP 8.0+ with a supported target integer size; this fixture does not assert a Joomla compatibility range. The cases cover integer minor units, a free product, the maximum accepted integer, empty SKUs, nonpositive quantities, a missing variant, an invalid adapter price, and multiplication overflow. PHP coercion at an application boundary must still be prevented by that boundary's input validation.

To run the normal repository validator, supply the actual fetched catalogue directory as described in the [validation workflow](../../workflows/validate-and-integrate.md). This fixture resolves its only Power dependency locally. A static pass or test adapter does not prove a production database adapter, Joomla DI registration, JPK resolution, import, compilation or installed execution.

The inspection representations use `NamespacePrefix=VDM`; they were assembled for this fixture and are not claimed as JCB-generated evidence. Both settings retain `[[[NamespacePrefix]]]`. Follow [customize an extension](../../workflows/customize-extension.md) to place a service under the component Administrator or Site namespace, or the Power library. The workflow explains how to connect a real caller and retain source after compilation.

The two UUIDv4 identities were generated with the system random UUID facility for these documentation fixtures on 2026-11-03. They are reserved for these fixture records only; no live global collision scan or production identity reservation is claimed. A new application must allocate and collision-check its own identities, remap the interface reference, and update the index, settings, paths and references together. Preserve the identities only when maintaining these exact fixtures. Source is CC0-1.0; see [LICENSE](LICENSE).
