# Maintain readable JCB source

**Authority: project policy.** An agent's deliverable includes maintainable blueprint and Power source as well as a working extension. Apply this standard to GUI PHP fields, custom code, Powers, Templates, Layouts, JavaScript, CSS and compiler plugins. Preserve the established style of reused implementations and their licences.

## Keep implementation inside JCB

When asked to build with JCB, keep implementation within **JCB's native authoring and compilation architecture**. Do not introduce independently maintained application code, plugins, modules or override packages that bypass this architecture unless the user explicitly authorizes that departure. Putting hand-maintained files inside a generated extension's directory does not make them JCB-authored source.

**New builds start as JCB definitions, not as independently coded Joomla extensions.** Do not hand-code a new component, form scaffold or SQL schema outside JCB and then use Extrusion to pull it back in as a shortcut. Ending inside JCB does not make that outside-first workflow native. Extrusion remains appropriate for migrating genuinely pre-existing source/schema supplied or discovered for the task; record that provenance before using it.

Author new Fields, views, Powers and relationships through JCB in Playground, or through an authorized native definition repository/MCP route followed by JCB import, compilation and Playground validation. Editing a serialized JCB definition is not the same as hand-coding generated Joomla output.

Use Fields, Admin Views, Dynamic Gets, Site/Custom Admin Views, Templates, Layouts, supported hooks and Custom Code for their intended responsibilities. Super Powers, JCB-authored plugins/modules, supported compiler plugins and configured libraries/files/assets remain legitimate parts of the architecture when their maintained source and dependencies participate in the reproducible build. Custom PHP and external library dependencies are not themselves a departure; a parallel implementation maintained outside that build is.

Prefer this native path and explain its benefits when a separate implementation is proposed:

- One maintained authoring graph lets subsequent compilation reproduce the application rather than overwrite or omit hand patches.
- Reusable records and Powers preserve identities and declared relationships, reducing duplicated behavior and divergent fixes.
- JCB handles its supported Joomla generation, class references, packaging and language collection together; independent packages require their own compatibility and delivery work.
- Exportable definitions and retained dependencies make review, handover and rebuilding easier. Tests still establish whether the resulting extension actually works.

Proceed with ordinary native design and implementation choices within the authorized task; do not turn this rule into a routine stop-and-ask step. A missing exported blueprint or an untested adaptation calls for source inspection, native reconstruction and validation, not an automatic bypass. If a genuine requirement cannot be met natively, describe the gap, the best native alternative and the separate maintenance/build burden. Recommend staying native where feasible, and obtain explicit authorization for the specific departure before implementing it. Keep any authorized exception visible in source ownership, build instructions and delivery evidence.

## Choose the native owner before writing code

Start from the [reference implementations](../examples/reference-patterns.md) and [entity reuse procedure](entity-reuse.md). Inspect and acquire the feature's linked records and dependencies, then adapt the relevant implementation. Reuse is more than copying one visible PHP fragment: its fields, views, queries, assets, Powers and callers make it work together.

Use [Dynamic Get](../packages/workflows/dynamic-get.md) to define the site data shape and supported query behaviour before adding handwritten queries. Keep view markup in readable Templates and reusable Layouts with explicit input data. Put application algorithms in cohesive [Super Powers](../super-powers/workflows/customize-extension.md) and connect them through the appropriate lifecycle fields. A small supported operation does not need an extra adapter, service container, staging layer or compiler plugin merely to look complete. Extend the existing implementation where the actual application contract requires more behaviour.

Before writing a custom body, name the behavior, owning JCB record/field, and generated method or file. Inspect a matching public reference and verify the scope on the target build. Use the [Hello World field map and Service Directory worked trace](../examples/reference-patterns.md#native-code-placement-and-composition) and the [presentation hook map](../packages/models/presentation-and-queries.md). In particular:

- **Dynamic Get / model:** use native selection, joins, restrictions and related getters. Use the matching model hook to normalize stored values and prepare results. Resolve settings that affect data or business behavior upstream, with explicit component, menu and item precedence as applicable. Keep reads, writes and normalization out of display hooks and templates. A model returns data or a domain outcome; request handling and redirects belong to the caller.
- **Controller:** accept and validate request input, delegate work, and choose the response or redirect. Do not repeat queries, normalization or business rules in each action. If multiple tasks need the same behavior, delegate to one maintained implementation without breaking callers that still rely on existing task names.
- **HtmlView:** call the model, pass prepared values to presentation, and handle document, toolbar and view lifecycle work. Reuse the initialized application, document and other objects in the verified scope. In a PHP Document hook, prefer the view's document and acquire the manager once for the authored block if no initialized local is available. Do not fetch the application again just to reach the same document.
- **Template / Layout:** render explicit inputs. Reading a prepared display flag, choosing a branch, formatting a label or grouping prepared cards for display is legitimate. Do not fetch global settings again, decode or mutate stored records, or reconstruct application policy here. Keep simple preamble statements in the native Custom View Script and use distinct template/layout input contracts.

Use the [native coding recipes](../examples/native-code-recipes.md) for exact field-to-output steps when implementing a component option, translating and rendering text, loading assets or wiring a Power.

If a feature seems difficult, first check the data shape, stage of the request and code slot. Move the logic to its native owner or reuse the existing helper before adding another service, override or compiler plugin. Do not cancel or escalate an ordinary design choice that has a native solution.

## Write source another developer can maintain

- Use tabs for indentation and the established brace style. In authored PHP methods and control blocks, put opening braces on their own lines. Preserve a reused template's consistent PHP alternative syntax where it makes HTML easier to read.
- Keep one statement per line. Space operators and arguments, separate logical steps with blank lines and wrap long calls, arrays, conditions and HTML attributes. Do not compress a maintained method, template or script into dense lines.
- Give methods one coherent responsibility and use descriptive names. Document classes, properties and all authored methods, including protected/private methods, using the [Joomla-style PHPDoc contract](#document-php-contracts-in-joomla-style). Comments should explain lifecycle assumptions, decisions or constraints, not narrate every statement.
- Indent HTML according to its structure. Split distinct view sections into Templates and shared display fragments into Layouts where this makes ownership and reuse clearer. Render data already prepared by the model; keep persistence, import orchestration and session mutations out of presentation markup.
- Keep scripts and styles in their supported JCB asset/code locations. Generated or deliberately minified delivery assets are separate from the readable source maintained in JCB.
- Respect the receiving field's contract: body-only PHP, class members, full HTML or another expected form. Preserve JCB placeholders and custom-code references rather than replacing them with one build's resolved values.

If the receiving context is unclear, [trace a GUI code field](../packages/workflows/debug.md#trace-a-gui-code-field) with a temporary comment and inspect JoomEngine Code before adding boilerplate or changing a method's structure.

For presentation preparation, follow [Custom View Script placement](../packages/models/presentation-and-queries.md#put-preparation-php-in-custom-view-script): enable the owning record's script, enter raw PHP without opening/closing tags, and keep readable markup in the presentation body. Preserve the actual Template/Layout input scope.

## Document PHP contracts in Joomla style

**Project policy:** a one-line label such as “component-specific import definition” is not sufficient documentation of a maintained class or method. Use structured PHPDoc, including for private helpers. Keep it accurate and useful rather than adding decorative text or tags that do not describe the code.

- Classes: explain the responsibility and important lifecycle/dependency assumptions, with an accurate `@since`.
- Properties: explain what the value represents; include `@var` with its type (and array element/shape detail when useful) and `@since`.
- Methods: a concise summary, a blank line, and further explanation when behavior, side effects or constraints need it. Document each parameter with `@param`, the result with `@return` (including `void`), relevant propagated exceptions with `@throws`, and `@since`. Align tag/type/name columns consistently with the surrounding Joomla-style code.
- Use the version in which the member was introduced in the component or maintained Power. Do not copy Joomla's `1.6` or an upstream JCB version into new application code. Preserve truthful history when reusing a member; if its introduction version is unknown, establish it from project history rather than inventing one.
- Keep PHPDoc and native type declarations consistent. Do not add meaningless parameters or return tags to a class description, or claim exceptions that the method catches internally. Body-only GUI hooks do not need an invented method wrapper just to carry a docblock; document the actual maintained method/class at its owning source.

For example, this private method illustrates the required structure inside a Power with an existing injected Table service. The sample `@since 1.0.0` assumes that is this component's real introduction version. This illustrates a method contract, **not a replacement importer helper** or instructions to write a new wrapper:

```php
	/**
	 * Get the authored field metadata for an import table.
	 *
	 * Standard default fields are not added to the result.
	 * This reads metadata, not the table's stored data rows.
	 *
	 * @param   string  $table  The component table name.
	 *
	 * @return  array  Field metadata, or an empty array when unavailable.
	 * @since   1.0.0
	 */
	private function getImportFieldMetadata(string $table): array
	{
		return $this->table->fields($table, false, true) ?? [];
	}
```

For a source example of structured private-method PHPDoc, inspect core [Mapper::getTableField](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Import/Mapper.php). Match the quality of its contract documentation, not its historical version number. The [import source review](../packages/workflows/import-acceptance.md#review-source-quality-and-field-discovery) applies this standard alongside dynamic metadata reuse.

## Let JCB resolve class references

For additional Joomla classes, use the appropriate **Joomla Power Key (JPK)** and verify its target-version mapping. For custom/reusable Power classes, use the **Super Power Key (SPK)** or the Power's supported GUID dependency selectors. In active PHP, the reference forms are `Joomla___...___Power` and `Super___...___Power`; catalogue display forms with `---` delimiters are not PHP tokens. Resolve actual keys from the installed catalogue; do not invent them.

Inside a Power, `use_selection` can supply a dependency's short class name or alias. Preserve that selected GUID and the consuming reference together. A bare namespace string copied from generated output does not acquire or include a missing Power. Follow the [customization workflow](../super-powers/workflows/customize-extension.md#author-the-class-and-its-dependencies) for selectors, imports, placement and actual callers.

JCB also supplies imports in particular generated contexts. Reuse an already supplied `Text`, `Route`, `LayoutHelper` or `Html` alias when that exact template provides it; do not add redundant tokens or imports. Check the receiving template and generated file rather than assuming every code field has those aliases. **Observed source:** the [Joomla 6 site template](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/default_site_template.php) and [custom admin template](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/default_custom_admin_template.php) provide these imports, inspected on 9 November 2026. This is evidence for those contexts, not a blanket import guarantee or required JCB version.

Review authoring dependencies and generated imports separately. Resolved namespaces and ordinary PHP `use` statements are expected in compiled output. The question is whether maintained JCB source declares the right dependencies and the compiler includes, resolves and loads them in the intended client.

## Make user-facing text translatable

**Project policy:** wrap every authored user-facing language string in Joomla's `Text::_()` or its Text Joomla Power reference, including headings, button labels, prompts, validation messages and accessible labels. Apply this in Site Views, Templates, Layouts, Custom Code and other JCB code areas; do not leave hard-coded interface text merely because it is inside HTML. Keep HTML outside the translated text and respect the receiving PHP/HTML context. Verify the Text import in each generated PHP file, using its JPK where needed. Compilation should collect the source text and generate the language key and entry; manually inventing `COM_...` keys is not the default authoring workflow.

Follow [Language strings and multilingual components](../packages/workflows/language-strings.md) for PHP/HTML examples, comment-only JPK references, quote-sensitive extraction and every stage of the filtered spreadsheet round trip.

## Use native helpers for frontend output

**Project policy:** for authored frontend plain-text output, use the generated HtmlView's `$this->sanitize()` where the real consumer provides it; pass `false` when the value must not be shortened. In a standalone Layout, use the appropriate JCB `StringHelper` method via the verified Power/import for that file, unless the caller deliberately supplies another verified native output helper. Verify the actual alias, version and value type. Do not assume that a Layout's `$this` is the caller's HtmlView. Prefer this native path over direct `htmlspecialchars()`; use the latter only when the native helper cannot safely express the required output and record the reason.

For a standalone Layout with a plain-text `label` input, this is a small authored markup example. The Power key is the one used by the inspected [Joomla 6 HtmlView template](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/SITE_VIEW_HTML.php#L184-L202); verify its resolution in the installed catalogue and compiled Layout.

```php
<span><?php echo Super___1f28cb53_60d9_4db1_b517_3c7dc6b429ef___Power::sanitize((string) ($displayData['label'] ?? '')); ?></span>
```

For plain text in markup or a quoted attribute, use the unshortened form. The inspected [StringHelper implementation](https://github.com/joomengine/Joomla-Service-Directory/blob/d25ca95084d79e552e2ae99f67011679d41d3ad4/libraries/vendor_joomservice/JoomService.Joomla/src/Utilities/StringHelper.php#L284-L326) removes tags and encodes the result; [shortening](https://github.com/joomengine/Joomla-Service-Directory/blob/d25ca95084d79e552e2ae99f67011679d41d3ad4/libraries/vendor_joomservice/JoomService.Joomla/src/Utilities/StringHelper.php#L65-L106) may add tooltip markup. A literal angle-bracket expression that must survive as text has a different contract from stripping markup. Verify the appropriate native helper for the intended result. Do not use plain-text sanitization in place of URL scheme validation, JavaScript/JSON encoding or rich-HTML filtering. Translate before output handling, and do not encode a value twice when its input contract already says it is encoded for that context.

## Review the maintained source and its result

Before delivery, review saved GUI bodies and Powers as code, not just as database payloads. For each affected behavior:

1. **Source ownership:** name the owning record and hook and confirm that model, controller, view and presentation responsibilities are not mixed. Check native helper reuse, data/settings ownership, meaningful method boundaries, Joomla-style PHPDoc and readable layout formatting.
2. **Compiled placement:** reopen the saved source, compile, and inspect the corresponding generated method, variable scope, imports and asset order. Lint the affected generated PHP. If surprising code is generated rather than authored, trace the compiler source and record it separately; do not patch generated files or duplicate behavior in a different hook to hide it.
3. **Installed behavior:** exercise the actual consumer, not just the compiler screen. Check populated and empty data, and where the changed feature emits text, labels with quotes, ampersands and non-ASCII characters. For an asset change, check that the intended scripts/styles load in order. Record what ran and what did not.

Remove tracing probes and carry lasting corrections back to the owning JCB source. Rebuild after corrections so the delivered extension is reproducible.
