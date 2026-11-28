# Build and wire a focused application service

Use this workflow when a JCB feature needs a reusable business rule or replaceable integration. Start with the native records and the [source ownership standard](../../standards/authored-code.md#choose-the-native-owner-before-writing-code). Start with the configured JCB hook or query for behavior it already supports. Put a custom rule in one focused Power with a named input and result. A small stateless rule with no shared dependencies can use a Power directly. For a service with shared collaborators, register it with the owning provider and resolve it through the existing Factory; add a provider and Factory only if this extension has no suitable one.

## Choose the path before adding code

| Need | Start here |
| --- | --- |
| Ordinary create/edit, or a link into another record's editor | Use the generated Admin View and [return to origin](../../packages/workflows/return-to-origin.md); use [native frontend create/edit](../../packages/workflows/site-edit-view.md) when the editor belongs on the site. |
| A related list, filter, order or page of records | Configure the [Dynamic Get](../../packages/workflows/dynamic-get.md); prepare data in its model hook and render it in the view. |
| A read-only rule shared by views | Follow the [quote example](#plan-one-vertical-slice); reuse the owner and Factory where the rule already exists. |
| A business action that writes data | Use the [packing example](#apply-the-same-pattern-to-a-write-action): generated entry point, permission at the boundary, a shared rule and guarded persistence. Choose the actual success, denial, no-change and failure outcomes before authoring. |
| Page chrome, menu placement, or global styling | Use the [Joomla site shell](../../workflows/joomla-site-shell.md) rather than a component override. |
| A defect or gap in the existing implementation | [Fix its owning source](../../standards/authored-code.md#fix-defects-at-their-source). If the slot is unclear, [trace the generated code to its JCB field](../../packages/workflows/debug.md#trace-a-gui-code-field) before choosing a design. |

## Plan one vertical slice

**Teaching example:** A published product detail shows the indicative total for a two-unit pack. The data comes from a single-item Dynamic Get. The quote is read-only and does not place an order, set a checkout price or reserve stock. Start with an existing disposable Joomla 6 component with one public Product Site View, a published Product Admin View record, and a string Field named `sku` exposed on its Dynamic Get result. Use the [current supported JCB release](../../standards/version-policy.md).

| Responsibility | Native owner | Input → output |
| --- | --- | --- |
| Select the published product | Product Site View's single-item Dynamic Get | Routed product ID → authorized product row with `sku` |
| Calculate a quote | `LineTotal` Power | SKU and positive quantity → integer minor units |
| Supply a trusted unit price | `UnitPriceProvider` interface and concrete adapter Power | SKU → nonnegative minor units, or a missing-price exception |
| Assemble and reuse services | `QuoteServices` provider Power and `QuoteFactory` Power | Service key → typed, shared collaborator |
| Prepare the result for display | Dynamic Get's **PHP getItem Method** after-getting hook | Prepared product row → nullable `pack_total_minor` |
| Present the outcome | Product Site View Template | Prepared quote → localized plain text |

Reuse the [two-Power teaching fixture](../examples/composed-service/README.md) for the algorithm and the interface. Use a new identity and namespace for each distinct adaptation, or preserve the published identities only for unchanged fixture records. For example, when a second Site View also displays a pack quote, call the same `Quote.LineTotal` service from that view’s model hook using its authorized product SKU. The two models prepare their own display data, but both use the same provider registration and calculation. Their Templates render the prepared results. If the use case writes data, keep the controller's request, ACL, CSRF and redirect handling at that boundary. The service owns the transaction and returns an outcome; the UI can distinguish a saved operation with a later notification failure from an operation that did not save.

## 1. Save and inspect the constructor scaffold

1. In JCB **Powers**, save the `UnitPriceProvider` interface. Supply its public `unitPrice(string $sku): int` declaration and a short nonempty Power description from the [fixture's source body](../examples/composed-service/src/20d6e122-d419-4f2d-acfb-a5c1819fc2d1/code.power).
2. Create the `LineTotal` class Power. In **Use Selection**, select the interface record by GUID and keep its class name (`As` can specify an alias). Keep **Properties & Methods** (`main_class_code`) empty. Save, then reopen the Power. JCB seeds the typed property, constructor parameter and assignment at save time. Use the actual generated property name consistently. To use the fixture's `$prices` name, rename the generated property, parameter and assignment together; then add the [calculation method](../examples/composed-service/src/06847141-791d-4482-8640-fc8bf1bf9037/code.power) without adding a second constructor.
3. Choose **Extends** for a supported parent and **Implements** for the Power interface a class fulfils. Choose **Use Selection** for the types the class imports and, for the scaffold, the intended constructor collaborators. Select the small set actually needed by this class. Keep the constructor limited to establishing its dependencies. Use an abstract base when related implementations share a deliberate lifecycle and extension points; use an injected collaborator when several callers need the same operation.

**Verified source behavior.** In JCB `6.x` at `037752c7e6599aa4cec900138dfb61af7ee4ba8f`, inspected 2026-11-28, [PowerModel::save](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/src/Model/PowerModel.php#L1030-L1034) invokes [Power.Generator](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Generator.php#L64-L82) when processing saved data. The generator only seeds an empty body with a nonempty array of selections. [ClassInjectorBuilder](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Generator/ClassInjectorBuilder.php#L65-L93) uses resolvable names and descriptions; [Search::validInject](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Generator/Search.php#L145-L168) accepts classes, final classes and interfaces for scaffolding. Use a Joomla interface's verified import where a dependency is not a Super Power selection. On an existing nonempty Power, update its constructor and provider explicitly when dependencies change. Review generated boilerplate against the target's actual aliases and names.

## 2. Supply the adapter and wire the provider

For this isolated exercise, author `SamplePrices` as a final class Power that **implements** `UnitPriceProvider`. Give the new adapter, provider and factory fresh [checked Power identities](create-power.md). To keep them component-owned, configure the site namespace described in [compiled location](customize-extension.md#choose-a-compiled-location), using a dotted suffix such as `Site\Service.SamplePrices` (the final namespace segment is `Service.SamplePrices`). The existing fixture powers may use their own library namespace; select them by identity to resolve their actual imports.

Use this **Properties & Methods** (`main_class_code`) fragment for `SamplePrices`. The two prices are disposable test data. In a real application the adapter reads prices from authoritative application records using the appropriate supported Joomla/JCB data service.

```php
/**
 * Supply deterministic minor-unit prices for the quote exercise.
 *
 * @param   string  $sku  Exact product identifier.
 *
 * @return  int
 * @throws  \OutOfBoundsException  When the sample has no price for the SKU.
 * @since   1.0.0
 */
public function unitPrice(string $sku): int
{
	return match ($sku)
	{
		'DEMO-PACK' => 1250,
		'DEMO-FREE' => 0,
		default => throw new \OutOfBoundsException('No sample price exists for this SKU.'),
	};
}
```

For `QuoteServices`, under **Implements interface(s)** choose the custom option and enter the Joomla `ServiceProviderInterface` and resolve the target Joomla namespace imports for `Joomla\DI\Container` and `Joomla\DI\ServiceProviderInterface` via verified JPK mappings or the enabled **Class Header Code**. Select `LineTotal`, `UnitPriceProvider` and `SamplePrices` in **Use Selection**. With an empty body and `ServiceProviderInterface` in the custom implementation field, [JCB's provider generator](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Generator/ServiceProviderBuilder.php#L65-L138) can seed aliases and provider methods. Review its output; a generated concrete registration cannot decide which implementation should fulfill your interface. Use the following **Properties & Methods** (`main_class_code`) for these exact bindings:

```php
/**
 * Register the quote service and its price source in this container.
 *
 * @param   Container  $container  The quote package container.
 *
 * @return  void
 * @since   1.0.0
 */
public function register(Container $container): void
{
	$container->alias(UnitPriceProvider::class, 'Quote.Prices')
		->share('Quote.Prices', [$this, 'getPrices'], true);
	$container->alias(LineTotal::class, 'Quote.LineTotal')
		->share('Quote.LineTotal', [$this, 'getLineTotal'], true);
}

/**
 * Construct the price source on first resolution.
 *
 * @return  UnitPriceProvider
 * @since   1.0.0
 */
public function getPrices(): UnitPriceProvider
{
	return new SamplePrices();
}

/**
 * Construct the calculator with its declared price source.
 *
 * @param   Container  $container  The container holding the price source.
 *
 * @return  LineTotal
 * @since   1.0.0
 */
public function getLineTotal(Container $container): LineTotal
{
	return new LineTotal($container->get(UnitPriceProvider::class));
}
```

Use a `QuoteFactory` Power that extends the [shared Factory Power](../reuse-and-dependencies.md#concrete-shared-factory-and-di-trace) (GUID `2e5bf608-de5c-4b00-a20d-47c26aa350d9`). Select `QuoteServices` in **Use Selection** and resolve Joomla's `Container` in the header as above. Author this body directly; it is a factory subclass rather than a service requiring constructor scaffolding:

```php
/**
 * Hold the quote container for the PHP execution lifetime.
 *
 * @var    Container|null
 * @since  1.0.0
 */
protected static ?Container $container = null;

/**
 * Create the quote container and activate its bindings.
 *
 * @return  Container
 * @since   1.0.0
 */
protected static function createContainer(): Container
{
	return (new Container())
		->registerServiceProvider(new QuoteServices());
}
```

The provider owns `new` for the two services. Joomla's [shared container registration](https://manual.joomla.org/docs/4.4/general-concepts/dependency-injection/DIC/) reuses each shared instance **in that container**. The first argument is the service key; the callback receives the container. The third argument protects the registration; it is not a lifetime selector. Keep these shared services free of mutable request or operation state. Give genuinely per-operation objects a fresh instance where their contract requires it. See JCB's own [Import Factory](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Import/Factory.php#L33-L59) for the same provider registration pattern. The subclass registers the provider explicitly; selecting it only imports the type.

## 3. Connect the actual model and template

For the Product Site View's single-item Dynamic Get, enable **Add PHP (after getting the Item)** (`add_php_after_getitem`) and use **PHP getItem Method** (`php_after_getitem`). Check that the generated method assigns the prepared row to `$this->_item[$pk]` before the hook, as in the [native model recipe](../../examples/native-code-recipes.md#prepare-a-display-option-in-the-model). Enter raw PHP statements. In the first service call, replace `QuoteFactory` with the active SPK for your saved factory (use its GUID with underscores, enclosed by `Super___` and `___Power`). The code below shows the resolved alias that you should see after compilation; in authored PHP use the SPK unless an equivalent verified import already provides the alias.

```php
if (is_object($this->_item[$pk] ?? null))
{
	$item = $this->_item[$pk];
	$item->pack_total_minor = null;

	try
	{
		$item->pack_total_minor = QuoteFactory::_('Quote.LineTotal')
			->calculate($item->sku, 2);
	}
	catch (\OutOfBoundsException $error)
	{
		// Missing price is an expected display state in this read-only feature.
		$item->pack_total_minor = null;
	}
}
```

Render only the value the model prepared. This example shows minor units to keep currency and formatting out of the exercise; production formatting belongs to the presentation contract. The Site View passes its prepared `$this->item` to its Template. Use the existing `Text` import or its verified Joomla Power key, and the native HtmlView plain-text helper:

```php
<?php if (($this->item->pack_total_minor ?? null) !== null): ?>
	<p>
		<?php echo $this->sanitize(
			sprintf(Text::_('Two-unit quote: %d minor units'), $this->item->pack_total_minor),
			false
		); ?>
	</p>
<?php else: ?>
	<p><?php echo $this->sanitize(Text::_('Quote unavailable'), false); ?></p>
<?php endif; ?>
```

## 4. Review the source and prove the slice

1. **Source review:** name the owner of the price, the calculation, the model handoff and the Template. Follow the constructor graph from the Factory to the service and its adapter; verify it ends without cycles. Check Joomla-style PHPDoc, concrete types or narrow interfaces and one authoritative implementation of each rule. Verify an independent test can construct the calculation with a test adapter.
2. **Compile:** reopen the saved Powers and the enabled Dynamic Get field, then compile with Power inclusion enabled. Inspect the factory and provider paths, resolved namespaces and aliases, model hook, language strings and view output. Confirm an installed site can load the Power graph without depending on the authoring site's JCB files.
3. **Install and exercise:** use authorized disposable Product records with `DEMO-PACK`, `DEMO-FREE` and an unknown SKU. Expect `2500`, `0` (not “unavailable”) and the translated unavailable message respectively. A missing or unpublished product follows the normal core view behavior. From a temporary diagnostic in the model's existing scope, resolve `Quote.LineTotal` twice and compare instances with `===`; remove the diagnostic and recompile. Test a second operation through the same service when the feature has a second caller. For writes, also exercise denied access, failed validation with no changes, and the post-commit outcome.
4. **Review receipt:** record **behavior → JCB owner and field → service and provider → compiled location → runtime cases and results**. Do this on the first slice before repeating a pattern across the component. A fixture run or green repository validation is not an installed Playground run.

The algorithm fixture has a CLI smoke test. The adapter, wiring and model/Template here are a teaching adaptation, not an existing extension or claim of an installed Playground run.

## Apply the same pattern to a write action

**Example: mark one order as packed from the administrator list.** Use the generated JCB save and publication actions for ordinary editing and publication. Packing needs a custom action because it changes a business status from `paid` to `packed`. In this example, the **Order** Admin View owns `#__example_order`, with primary key `id` and a string Field `order_status` separate from Joomla's publication `state`. Treat this status as action-managed: exclude it from the ordinary edit form and generated API inputs, and confirm their server-side save paths cannot accept a submitted value for it. Route any other legitimate status changes through their owning operations.

### Author the button and controller

In the **Order** Admin View, enable **Add Custom Buttons** (`add_custom_button`), and add a **Custom Buttons** row with **Name** `Pack`, **Method** `packOrder`, **Target** List (`2`), **Type** Selection (`1`), and a suitable icon. For single/list code names `order`/`orders`, the generated task is `orders.packOrder` and the toolbar checks `order.pack` on `com_example`. Review the compiled `access.xml` and toolbar and grant that permission to the intended group. This example also requires the configured record-level **Edit State** action (`order.edit.state` on `com_example.order.<id>`); enable it for that Admin View, verify the emitted asset/action names and test per-record denial. The toolbar permission is generated from the button name, not the method name. See the [native button recipe](../../packages/workflows/admin-authoring-patterns.md#3-a-native-administrator-action-with-controller-and-model) and the [compiler's list-button output](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/CustomButtons.php#L580-L594).

Put the following method in **PHP List view (controller methods)** (`php_controller_list`), as class members without PHP tags. Use the actual component/task/ACL identifiers and the available `Text` import or its Joomla Power. `OrderFactory` below is the resolved alias for the extension's existing order-service Factory; in the maintained source use that Factory's actual SPK or an existing verified import. Use the generated list form and its session token; the controller accepts just one persisted ID from the POSTed `cid[]`.

```php
/**
 * Apply the packing action to one authorized administrator-list selection.
 *
 * @return  void
 * @throws  \RuntimeException  If the request or action is not allowed.
 * @since   1.0.0
 */
public function packOrder(): void
{
	if ($this->input->getMethod() !== 'POST')
	{
		throw new \RuntimeException(Text::_('Submit the order action by POST.'), 405);
	}

	if (!$this->checkToken('post', false))
	{
		throw new \RuntimeException(Text::_('JINVALID_TOKEN_NOTICE'), 403);
	}

	$ids = array_values($this->input->post->get('cid', [], 'array'));
	$id = count($ids) === 1 && is_scalar($ids[0])
		? filter_var($ids[0], FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]])
		: false;

	if ($id === false)
	{
		$this->setRedirect('index.php?option=com_example&view=orders', Text::_('Select one saved order.'), 'warning');

		return;
	}

	$user = $this->app->getIdentity();

	if ($user === null || $user->guest
		|| !$user->authorise('order.pack', 'com_example')
		|| !$user->authorise('order.edit.state', 'com_example.order.' . $id))
	{
		throw new \RuntimeException(Text::_('JERROR_ALERTNOAUTHOR'), 403);
	}

	$changed = OrderFactory::_('Order.Pack')->pack($id);
	$message = $changed ? Text::_('Order marked as packed.') : Text::_('No change: the order is missing or no longer eligible.');

	$this->setRedirect('index.php?option=com_example&view=orders', $message, $changed ? 'message' : 'warning');
}
```

### Put the rule and guarded write in its owning service

Use the existing order persistence service if it already exposes a guarded transition; do not add a second writer for the same rule. The following is the minimal body for a `PackOrder` Power when the extension has no such method. The example has one write and no secondary effects. Use the target's verified Joomla imports for `Joomla\Database\DatabaseInterface` and `Joomla\Database\ParameterType`. This conditional update is the eligibility check and the write in one operation; a PHP read followed by an unconditional save would leave a race.

```php
/**
 * Database used for order status transitions.
 *
 * @var    DatabaseInterface
 * @since  1.0.0
 */
private DatabaseInterface $db;

/**
 * Inject the extension's existing database connection.
 *
 * @param   DatabaseInterface  $db  Configured Joomla database connection.
 *
 * @since   1.0.0
 */
public function __construct(DatabaseInterface $db)
{
	$this->db = $db;
}

/**
 * Transition a paid order to packed if it is still eligible.
 *
 * @param   int  $id  Authorized persisted order ID.
 *
 * @return  bool  True when a row changed; false when missing or ineligible.
 * @since   1.0.0
 */
public function pack(int $id): bool
{
	$paid = 'paid';
	$packed = 'packed';
	$status = $this->db->quoteName('order_status');
	$query = $this->db->createQuery()
		->update($this->db->quoteName('#__example_order'))
		->set($status . ' = :packed')
		->where($this->db->quoteName('id') . ' = :id')
		->where($status . ' = :paid')
		->bind(':id', $id, ParameterType::INTEGER)
		->bind(':paid', $paid, ParameterType::STRING)
		->bind(':packed', $packed, ParameterType::STRING);

	$this->db->setQuery($query)->execute();

	return (int) $this->db->getAffectedRows() === 1;
}
```

Select `PackOrder` in the existing provider Power's **Use Selection**. In its existing `register()` method add `$container->share('Order.Pack', [$this, 'getPackOrder'], true);`, and put the following in the same provider. Confirm the provider is already registered and that its actual container resolves the configured `DatabaseInterface`; supply that binding at the composition boundary if needed. Keep the Factory unchanged. Apply the same permission check at each additional entry point before calling the shared service.

```php
/**
 * Construct the packing service with the existing database driver.
 *
 * @param   Container  $container  Container used by the order Factory.
 *
 * @return  PackOrder
 * @since   1.0.0
 */
public function getPackOrder(Container $container): PackOrder
{
	return new PackOrder($container->get(DatabaseInterface::class));
}
```

A direct update does not call Joomla's generated save hooks, table checks or events. Use the existing persistence operation if the real workflow depends on those, on checkout, on tenant/ownership constraints, or on auditing. Preserve those guarantees in the write, not only on the previously loaded screen. If several database changes must succeed together, put them in the same transaction, and keep any external notification separate from the committed result. Do not treat a database exception as a harmless no-change result or send a success response when nothing was saved.

**Accept the actual compiled action:** authorize a user on one record and deny access on another; check that a paid row becomes packed once, a repeat or stale request leaves it unchanged, and an unpaid, cancelled or missing row never changes. With no selection, multiple selections, no permission, wrong HTTP method or bad token, verify there is no write. Check persisted values and the redirect/message, not just the toolbar. Verify that ordinary edits/API calls cannot write the action-managed status directly. The code is a teaching adaptation; an installed JCB compilation and these acceptance checks must be recorded separately.
