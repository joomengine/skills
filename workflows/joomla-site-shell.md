# Build a Joomla site shell around a JCB component

**Project policy:** Joomla owns the site shell. JCB owns the component and the content Joomla renders in its component slot. Build a polished site by composing those two layers, rather than making a Site View replace the site around it.

| Owner | Maintains |
| --- | --- |
| Joomla **site template** | Document and page structure, site-wide branding, background, typography, header/footer, shared CSS and JavaScript, and named module positions. |
| Joomla **site configuration** | Site Template Styles and their assignments, menu trees and menu items, module publication, positions, access and menu assignments. The template renders the positions; Joomla decides which modules and menu items belong there. |
| **JCB component** | Data, routes, actions and site/admin views. JCB **Templates** and **Layouts** render the component's content: listings, product cards, filters, variants, checkout forms and other feature UI. Use Joomla's existing Bootstrap classes for the component grid, spacing, forms and controls. Scope feature CSS/JS to that component or view. |

## Choose and configure the Joomla template first

1. **Keep the current site template** when the site's existing shell already meets the design. Configure its style and existing positions. For a new design based on Cassiopeia, create a uniquely named **child template** under **System → Site Templates → Cassiopeia Details and Files → Create Child Template** on a disposable Playground. Change the child; keep the stock Cassiopeia files untouched. A child inherits the parent and needs that parent installed.
2. **Create a separate Joomla site template** with its own name and installation manifest when the site needs an independent design or substantially different structure. If starting from a copy of Cassiopeia, give the copy its own extension identity, paths and asset registration, and preserve the original licensing notices. Edit and maintain it in Joomla's site templates area and retain its source and installer separately from the component blueprint.
3. In **System → Site Template Styles**, make the selected style the site default for a whole-site redesign or assign it to the relevant menu items when only one area needs the design. Keep the previous style available for rollback. For an existing site, confirm which pages the request actually authorizes changing. A component install or update must leave the site's chosen default, template files and unrelated menu/module assignments alone.
4. Create or reuse Joomla menu items for the relevant JCB Site Views. Publish the native Joomla **Menu** module in the template's menu position and choose the intended menu and page assignments. Put a footer, banner or sidebar in its named position using existing modules where possible. For a live feature such as a cart count in the header, publish a dedicated module that uses the component's existing service; keep cart rules in the component. A component-local link or filter is still valid inside the component content.

## Worked example: a catalogue in a Joomla template

The example is illustrative. Start with a namespaced template or child in disposable Playground and a JCB catalogue Site View whose Dynamic Get supplies `$this->items`. The goal is a reusable shell around the catalogue and a regular Joomla article.

**Joomla template:** use existing positions if they fit. If the template introduces positions, declare them in `templateDetails.xml` and render the same names in its `index.php`. Here is the body fragment only; keep the selected template's document head, asset includes, accessibility features and other supported entry points intact.

```php
<header class="site-header">
	<jdoc:include type="modules" name="menu" style="none" />
</header>
<main id="content">
	<jdoc:include type="message" />
	<jdoc:include type="component" />
</main>
<footer class="site-footer">
	<jdoc:include type="modules" name="footer" style="none" />
</footer>
```

In Joomla Menus, add **Catalogue** (the component Site View) and **About** (a Joomla article); select the same site template style for both. Publish a **Menu** module in `menu` and a **Custom** module in `footer` for those pages. Configure the menu and footer content there, not by hard-coding them in the catalogue.

**JCB Site View:** keep the markup inside the component's output area. This uses Joomla Bootstrap grid and spacing classes, the view's native `sanitize()` helper, and its existing `Text` import or verified Joomla Power.

```php
<section class="example-catalogue py-4">
	<h1><?php echo $this->sanitize(Text::_('Catalogue'), false); ?></h1>
	<div class="row g-3">
		<?php foreach ($this->items ?? [] as $item): ?>
			<div class="col-12 col-md-6">
				<h2 class="h5"><?php echo $this->sanitize((string) $item->title, false); ?></h2>
			</div>
		<?php endforeach; ?>
	</div>
</section>
```

**Bootstrap and assets:** Joomla ships Bootstrap. Cassiopeia on the site and Atum in the administrator provide a Bootstrap baseline; on a custom frontend template, verify that the chosen template loads the compatible CSS. JCB views can use the supported classes for component structure, including dashboard and list views; this does not mean JCB supplies a universal Bootstrap bundle to every site template. Load only the interactive Bootstrap features actually needed through Joomla's asset system. Keep site-wide theme CSS/JS in the site template and feature-specific CSS/JS in the [relevant JCB asset location](../packages/models/libraries-and-assets.md), scoped to the component. A full-width hero or heading is fine; style the feature without hiding Joomla's menu, messages or module positions.

## Verify, debug and deliver by owner

1. Compile and install the JCB component. Verify the Catalogue and About pages both use the Joomla shell and exactly one primary menu and main region. Move or unpublish the Menu or footer module in Joomla and verify that the assigned pages respond without recompiling the component. Check Joomla system messages still render.
2. Switch the catalogue menu item to the stock Cassiopeia style on the test site. Verify the component still lists records and its essential actions work. The appearance may differ. Restore the intended style and confirm the unrelated pages keep their assignments.
3. Diagnose a menu, missing position, global background or header issue in **Joomla's style/menu/module configuration and the site template**. Diagnose the catalogue's data, ordering, item markup or local Bootstrap grid in **the owning JCB Dynamic Get, Site View, Template or Layout**. If core assets are missing, inspect the effective template and asset registrations first. Apply the [source repair standard](../standards/authored-code.md#fix-defects-at-their-source) at the layer that owns the fault.
4. For a custom shell, deliver the standalone Joomla template ZIP and its editable source separately from the JCB-generated component and blueprint. Include the template style, menu and module setup; a complete Playground export can carry both layers already installed and assigned. Follow the [delivery workflow](delivery.md) and distinguish compiled, installed and restored results.

**Source references:** [Cassiopeia in Joomla 6.2.0](https://github.com/joomla/joomla-cms/blob/6.2.0/templates/cassiopeia/index.php) shows the component, message and module slots; its [manifest](https://github.com/joomla/joomla-cms/blob/6.2.0/templates/cassiopeia/templateDetails.xml) declares the positions. See Joomla's [child templates](https://docs.joomla.org/J4.x%3AChild_Templates/en), [module render and assignment flow](https://manual.joomla.org/docs/next/building-extensions/plugins/plugin-events/module/) and [Bootstrap asset guidance](https://manual.joomla.org/docs/next/general-concepts/bootstrap/). These references explain the platform; the example still needs installed acceptance on the chosen target.
