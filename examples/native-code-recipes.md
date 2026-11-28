# Native JCB coding recipes

Use the recipe that matches the decision in front of you. The [Hello World map](reference-patterns.md#hello-world-native-code-slot-map) identifies the GUI-to-PHP placement; these recipes connect that placement to a real consumer. Keep the editable JCB records, code fields and Power definitions authoritative. Inspect the generated extension with JoomEngine Code; make lasting corrections in the owner and compile again.

| Need | Start here |
| --- | --- |
| A component option changes what a page displays | [Prepare the decision in the model](#prepare-a-display-option-in-the-model) |
| A label must be translated and rendered as plain text | [Translate and render a label](#translate-and-render-a-label) |
| A view needs a script, stylesheet or JS configuration | [Use a view's document and assets](#use-the-views-document-and-assets) |
| A model needs reusable PHP behaviour | [Connect a Power to a real caller](#connect-a-power-to-a-real-caller) |
| Multiple native callers need a shared service | [Wire a focused service](../super-powers/workflows/design-a-service.md) |

**Evidence:** the cited public native records and generated Joomla 6 output were inspected on 2026-11-20. The adaptations and acceptance steps below are instructions, not claims of a new compile/install run. Use the [current target versions](../standards/version-policy.md); the pins show what was inspected. Use an authorized disposable [Playground](../testing/playground/README.md) and known test data for the checks. For training, isolate adaptations from the upstream reference; for a distinct application, follow [entity reuse](../standards/entity-reuse.md) for identities and dependencies.

## Prepare a display option in the model

**Observed pattern.** Service Directory's [Listing model](https://github.com/joomengine/Joomla-Service-Directory/blob/d25ca95084d79e552e2ae99f67011679d41d3ad4/site/src/Model/ListingModel.php#L179-L189) stores the Joomla application parameters in model state. The [native Listing trace](reference-patterns.md#worked-trace-listing-from-records-to-rendered-page) follows its prepared addresses through the model, HtmlView, Company Extras Template and Addresses Layout. Service Directory does not use a `show_addresses` option in that flow.

**Illustrative adaptation:** add a switch for an addresses section in a component that already follows that pattern. The contract is display only: default on, explicit off, and no change to data access or other sections. Use effective page parameters for this example. Joomla's [SiteApplication::getParams()](https://github.com/joomla/joomla-cms/blob/6.2.0/libraries/src/Application/SiteApplication.php#L311-L357) merges active menu parameters over the component options. This example does not add a same-name menu field or a per-item override. For global-only behaviour, read component parameters in the model instead of taking the page's merged state.

**1. Field and component config:** create a native Radio Field named `show_addresses`, with integer values `0` (No) and `1` (Yes), default `1`, and integer filtering. Use the switcher presentation if appropriate. Attach it to the component's **Config** child, not to the Company Admin View's edit form. In its row choose the Field, use **Custom Value** `1` and the appropriate **Tab Name**. Compare the real [Config record](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/joomla_component/children/160d0efb-6bf0-48eb-8d46-55cf74729501/component-config.json) and [`show_login` Field](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/field/10b7b6ec-74a3-454d-b7fa-55db619ac327/item.json) for shape, not values. The [JCB Config form](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/forms/component_config.xml#L126-L189) shows the row controls.

**2. Single-item Dynamic Get:** in the Get selected by the Site View, enable **Add PHP (after getting the Item)** and use its **PHP getItem Method** field (`add_php_after_getitem` / `php_after_getitem`). In the reference-shaped model insert this after preparation has assigned `$this->_item[$pk]` (after `processItem()` in the Listing trace); preserve its existing checks and preparation. The type check keeps a failed or missing result from becoming a display object. Enter raw PHP, without tags or a method declaration. This assumes the model's `params` state is a Joomla Registry as in the pinned Listing; trace the target model before reusing that assumption. If the Get is shared, confirm its other consumers can accept the new property, or put the display-specific decision in the consuming model's supported hook.

```php
if (is_object($this->_item[$pk] ?? null))
{
	$this->_item[$pk]->show_addresses =
		(int) $this->getState('params')->get('show_addresses', 1) === 1;
}
```

**3. Template and Layout:** keep the HtmlView's existing `$this->item = $model->getItem()` handoff. The [Company Extras Template record](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/template/6cf8a790-0d9f-40e5-a5ee-9513fd715fde/item.json) already assigns `$item` and `$addresses` in its Custom View Script. In Template markup, wrap just the addresses call; the reusable Layout still accepts a collection as `$displayData`. Leave unrelated renders where they are.

```php
<?php if (($item->show_addresses ?? false) === true): ?>
	<?php echo LayoutHelper::render('addresses', $addresses); ?>
<?php endif; ?>
```

**4. Compile and inspect:** reopen both saved code fields and the Config association. Look for the generated field and default in the installer's `admin/config.xml`, the boolean assignment in the model's `getItem()` after preparation, and the guard in the logical build path `site/tmpl/listing/default_companyextras.php` (or your aliases). The guard belongs to the Template, not the Layout's internals. If the expected PHP is absent, check the Dynamic Get association, the enabled hook and the template alias before changing the code.

**5. Install and exercise:** use a listing known to have addresses. Save Yes and verify the addresses render; save No and verify addresses disappear while other sections remain; then re-enable it. Independently verify default behaviour with the key truly absent from the effective Registry (a fresh installation may already materialize the XML default of `1`). If the absent state was not exercised, report that separately from explicit Yes. Also open a listing with no related addresses to verify the empty case.

## Translate and render a label

**HtmlView Template example.** In a frontend Template whose generated context provides `Text` and the native HtmlView sanitizer, this is authored **markup**; the source uses the English literal. Use the [Text Joomla Power](../packages/workflows/language-strings.md) when the compiled file would otherwise lack the `Text` import.

```php
<h2><?php echo $this->sanitize(Text::_('Contact details'), false); ?></h2>
```

For a record label, keep its raw plain-text value prepared for display by the model (do not translate stored content). In a standalone Layout, read named entries from `$displayData` and use the [verified StringHelper Power form](../standards/authored-code.md#use-native-helpers-for-frontend-output), not the HtmlView method. A caller that already passes encoded text needs an explicit input contract; apply output handling once. Move preparation statements, if any, into the record's **Custom View Script** without PHP tags; keep the echo in markup. These examples are for plain text, not rich HTML, URLs or JS.

The [Company Listings Template source](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/template/3d13f9b3-a793-4f67-979c-1b03f48fa7ce/item.json) and its [compiled Directory template](https://github.com/joomengine/Joomla-Service-Directory/blob/d25ca95084d79e552e2ae99f67011679d41d3ad4/site/tmpl/directory/default_companylistings.php#L21-L30) show source literals becoming language keys for headings and a formatted greeting. The specimen uses its historical native view helper; use the `sanitize()` policy above for new code where the target provides it.

After compiling, find the resolved language key in both the PHP file and the generated language INI. Lint and render the exact consumer. Change the translation in JCB using the [language round trip](../packages/workflows/language-strings.md), rebuild and check that accented characters, ampersands and quotes appear as intended without literal entity text or unwanted shortening. If a key is printed instead of the translation, check the generated entry, loaded language and consumer client before changing the HTML.

## Use the view's document and assets

Choose the native owner by lifecycle. Use a configured **Library** for a reusable file/load policy or a native direct asset attachment for extension-owned distribution; use the native CSS/JavaScript fields for code that belongs to that view. Use the **PHP Document** field for request-specific document configuration, after checking at which point that target emits each hook. Packaging an asset and using it on a page are different operations.

**Observed pattern.** The Service Directory [Company Admin View](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/admin_view/08a58903-10a4-4ed9-babd-8b9557b095e4/item.json) has separate `php_document` and `javascript_view_file` sources. Its [uploader configuration Custom Code](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/custom_code/vdmUploaderConfig/item.json) obtains a document and Web Asset Manager for request-specific configuration. Compare the [emitted Company HtmlView](https://github.com/joomengine/Joomla-Service-Directory/blob/d25ca95084d79e552e2ae99f67011679d41d3ad4/admin/src/View/Company/HtmlView.php#L477-L579) with the view's JavaScript asset, compiled to `media/js/company.js`. This is evidence for separating the two responsibilities, not a requirement to reproduce the specimen's legacy fallback or asset URLs.

**1. Prepare and pass the data.** Have the model supply any application-dependent values first. In the enabled **PHP Document** field enter PHP statements without tags. For [Joomla script options](https://github.com/joomla/joomla-cms/blob/6.2.0/libraries/src/Document/Document.php#L561-L581), reuse the document already initialized in the generated method; use the existing view's `getDocument()` if the target supplies that accessor and no document local is available. Call the document directly for options. For Web Asset Manager operations, reuse an in-scope manager if one is already initialized, or get it once from that document before the first authored use. Inspect the generated method and order, not the local variable name in a different view.

**2. Give the script a small input contract.** For example, a component with code name `directory` could give its location widget a fixed minimum search length. For a generated view with an existing `$document` local, the PHP Document body uses the following. If that local is absent but the view accessor is available, first assign `$document = $this->getDocument();`.

```php
$document->addScriptOptions('com_directory.locations', [
	'minimumCharacters' => 2,
]);
```

In the owning **JavaScript File** field, read the same key after Joomla core JS is available. Use the target's native asset dependency/load mechanism to ensure core runs before the widget. This sample deliberately falls back to the same threshold if the option group was not supplied:

```js
const { minimumCharacters } = Joomla.getOptions('com_directory.locations', {
	minimumCharacters: 2,
});
```

Pass only data the browser needs; the JavaScript check is not server-side validation. For translated JavaScript labels, follow the actual JCB language collection path and verify the consumer registers and loads the key.

**3. Compile and inspect:** locate the PHP Document body inside the generated HtmlView, before the page is rendered; verify it writes the intended key. Identify the emitted CSS/JS path, manifest entry and asset registration/use order on the target. For a reusable dependency, use the [Library configuration and conditional loading workflow](../packages/models/libraries-and-assets.md#author-integrate-and-debug) for source bytes, destination, load policy and client scope. Do not add a second include for a dependency the compiler already provides.

**4. Install and exercise:** load the actual view in its intended client. Confirm the script loads once, options are available before initialization, and the widget reacts at the specified threshold. Check an unrelated view does not run this view's widget. When output contains redundant document lookups, trace the owning JCB field or compiler emitter before making a fix; a compiler issue is not a reason to add another authored lookup.

## Connect a Power to a real caller

**Observed pattern.** In the [Company Admin View](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/admin_view/08a58903-10a4-4ed9-babd-8b9557b095e4/item.json), `ajax_input` and `php_ajaxmethod` connect an existing cascading selector to a native server-side lookup. The authored Power tokens resolve to `GuidHelper` and `DataFactory` in the [generated AjaxModel](https://github.com/joomengine/Joomla-Service-Directory/blob/d25ca95084d79e552e2ae99f67011679d41d3ad4/admin/src/Model/AjaxModel.php#L30-L145). The country lookup calls `DataFactory::_('Data.Items')->table('state')->get([$country], 'country')` and maps matching records to the selector's `value` (GUID) and `text` (name) entries. This example shows the dependency and caller, not a complete authorization or error-handling policy.

**1. Choose the owner:** keep Field linkage and ordinary page retrieval native. For an interactive selector that requests new options, choose its owning JCB AJAX hook and a narrow model lookup. Inspect the existing input definition and method signature before extending it; verify the expected key, type and response shape in the actual caller.

**2. Reuse and declare the dependency:** trace the source tokens to their ordered Power repositories and preserve their identities. In this snapshot they are GUID helper `9c513baf-b279-43fd-ae29-a585c8cbc4f0` and Data Factory `9d76b8dc-3883-4755-b11c-131d19ca8a53`. Confirm the table alias and relationship column against the receiving component's JCB definitions. For new business rules, add a cohesive Power with an accurate Joomla-style contract and declare its dependencies as in the [complete composed-service example](../super-powers/examples/composed-service/README.md). Wire it into a real owning hook, not a manual include of a generated preview. Keep retrieval in the model/service; retain the controller's request validation, authorization and response responsibilities.

**3. Compile and inspect:** verify the effective Power switch, the generated import/alias, class placement and loader, the AJAX dispatch and actual call. Lint the compiled files with the target PHP version. Where a dependency is absent, check the token, repository resolution and compile gate instead of copying a namespace from the installed package.

**4. Install and exercise:** on a consumer that does not rely on the authoring site's JCB vendor tree, choose a known country and check only its expected states appear with GUID values and names. Exercise a country with no matches, stale selections after changing the parent, and denied access for endpoints that require authorization. Check the actual web response as well as the dropdown; GUID shape validation alone does not grant access. Record repository/Powers, compile evidence and installed outcomes separately.

## Review during the build

Apply the [source and output review](../standards/authored-code.md#review-the-maintained-source-and-its-result) whenever a feature first crosses a new model, controller, presentation or asset boundary. For a large component, close a representative feature through compile and installed use before repeating its pattern across many views. Keep a compact review receipt per changed pattern: **behaviour → JCB owner and enabled field → dependency and compiled file/method → installed cases and outcome**. Reuse the receipt to spot regressions when later edits affect that boundary. If something appears only in generated output, identify its compiler source before deciding where to fix it.
