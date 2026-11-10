# Maintain readable JCB source

**Authority: project policy.** An agent's deliverable includes maintainable blueprint and Power source as well as a working extension. Apply this standard to GUI PHP fields, custom code, Powers, Templates, Layouts, JavaScript, CSS and compiler plugins. Preserve the established style of reused implementations and their licences.

## Compose the feature before adding code

Start from the [reference implementations](../examples/reference-patterns.md) and [entity reuse procedure](entity-reuse.md). Inspect and acquire the feature's linked records and dependencies, then adapt the relevant implementation. Reuse is more than copying one visible PHP fragment: its fields, views, queries, assets, Powers and callers make it work together.

Use [Dynamic Get](../packages/workflows/dynamic-get.md) to define the site data shape and supported query behaviour before adding handwritten queries. Keep view markup in readable Templates and reusable Layouts with explicit input data. Put application algorithms in cohesive [Super Powers](../super-powers/workflows/customize-extension.md) and connect them through the appropriate lifecycle fields. A small supported operation does not need an extra adapter, service container, staging layer or compiler plugin merely to look complete. Extend the existing implementation where the actual application contract requires more behaviour.

## Write source another developer can maintain

- Use tabs for indentation and the established brace style. In authored PHP methods and control blocks, put opening braces on their own lines. Preserve a reused template's consistent PHP alternative syntax where it makes HTML easier to read.
- Keep one statement per line. Space operators and arguments, separate logical steps with blank lines and wrap long calls, arrays, conditions and HTML attributes. Do not compress a maintained method, template or script into dense lines.
- Give methods one coherent responsibility and use descriptive names. Add useful PHPDoc for public methods and non-obvious contracts: inputs, return values, exceptions and relevant side effects. Comments should explain lifecycle assumptions, decisions or constraints, not narrate every statement.
- Indent HTML according to its structure. Split distinct view sections into Templates and shared display fragments into Layouts where this makes ownership and reuse clearer. Render data already prepared by the model; keep persistence, import orchestration and session mutations out of presentation markup.
- Keep scripts and styles in their supported JCB asset/code locations. Generated or deliberately minified delivery assets are separate from the readable source maintained in JCB.
- Respect the receiving field's contract: body-only PHP, class members, full HTML or another expected form. Preserve JCB placeholders and custom-code references rather than replacing them with one build's resolved values.

If the receiving context is unclear, [trace a GUI code field](../packages/workflows/debug.md#trace-a-gui-code-field) with a temporary comment and inspect JoomEngine Code before adding boilerplate or changing a method's structure.

## Let JCB resolve class references

For additional Joomla classes, use the appropriate **Joomla Power Key (JPK)** and verify its target-version mapping. For custom/reusable Power classes, use the **Super Power Key (SPK)** or the Power's supported GUID dependency selectors. In active PHP, the reference forms are `Joomla___...___Power` and `Super___...___Power`; catalogue display forms with `---` delimiters are not PHP tokens. Resolve actual keys from the installed catalogue; do not invent them.

Inside a Power, `use_selection` can supply a dependency's short class name or alias. Preserve that selected GUID and the consuming reference together. A bare namespace string copied from generated output does not acquire or include a missing Power. Follow the [customization workflow](../super-powers/workflows/customize-extension.md#author-the-class-and-its-dependencies) for selectors, imports, placement and actual callers.

JCB also supplies imports in particular generated contexts. Reuse an already supplied `Text`, `Route`, `LayoutHelper` or `Html` alias when that exact template provides it; do not add redundant tokens or imports. Check the receiving template and generated file rather than assuming every code field has those aliases. **Observed source:** the [Joomla 6 site template](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/default_site_template.php) and [custom admin template](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/default_custom_admin_template.php) provide these imports, inspected on 9 November 2026. This is evidence for those contexts, not a blanket import guarantee or required JCB version.

Review authoring dependencies and generated imports separately. Resolved namespaces and ordinary PHP `use` statements are expected in compiled output. The question is whether maintained JCB source declares the right dependencies and the compiler includes, resolves and loads them in the intended client.

## Make user-facing text translatable

**Project policy:** wrap every authored user-facing language string in Joomla's `Text::_()` or its Text Joomla Power reference, including headings, button labels, prompts, validation messages and accessible labels. Apply this in Site Views, Templates, Layouts, Custom Code and other JCB code areas; do not leave hard-coded interface text merely because it is inside HTML. Keep HTML outside the translated text and respect the receiving PHP/HTML context. Verify the Text import in each generated PHP file, using its JPK where needed. Compilation should collect the source text and generate the language key and entry; manually inventing `COM_...` keys is not the default authoring workflow.

## Review the maintained source and its result

Before delivery, read the saved GUI source and Power bodies as code, not just database payloads. Confirm readable formatting, useful method boundaries, correct reference selectors, appropriate Template/Layout composition and the absence of temporary probes. Compile, inspect the resulting imports and placement, lint the generated PHP and exercise the affected feature. Carry corrections back to the owning source and rebuild so the delivered result is reproducible.
