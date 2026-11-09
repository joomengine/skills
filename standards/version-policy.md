# Build with the latest JCB

**Project policy:** resolve and use the latest production JCB release for the selected supported Joomla target when starting a production-target build. The skills follow current JCB capabilities; a version number, commit hash or old test receipt in these documents is not a required runtime pin. Use the latest alpha/beta build when the task explicitly targets development or prerelease work, and keep that work distinct from the production release path.

## Select the running version

1. Identify the user's Joomla/PHP target and whether this is a production build or development work. Use the latest production JCB release by default; do not copy an old alpha version from an example.
2. Resolve the current release through JCB's official release/update metadata or the current supported Playground version catalogue. Inspect the actual release channel and compatibility. A moving source branch is not itself an installable production release, and a cached recipe named “latest” is not evidence of the version installed.
3. Select the current compatible release and verify JCB's displayed version after deployment or update. Follow the [Playground configuration guide](../testing/playground/configuration.md) for the controls available now; do not invent a version parameter or package URL.
4. Use current controls, model contracts and compiler behavior. If these differ from an older source example, inspect the current implementation, adapt the maintained blueprint/Power source, and continue the build. Do not downgrade JCB merely to make a historical citation match.
5. Validate the generated extension against its declared Joomla/PHP target and requested behavior. For development work that uses an alpha/beta-only feature, establish its production-release path before delivering the production build. Preserve reusable source and identities while adapting to the release that supplies the feature.
6. Preserve an existing project's work and data before updating its authoring environment. Use the supported upgrade path within the task's scope; selecting “latest” does not authorize resetting a site, replacing application identities or changing the user's Joomla major version. Handle an explicitly requested legacy compatibility or regression reproduction as a named additional target.

Refresh release discovery at the start of a new build or resumed upgrade task. Once a build has started, retain a consistent toolchain for that build and its verification; do not replace the running compiler midway merely because another release appears. Select the latest again for the next build or deliberate upgrade.

## Keep operating defaults separate from research references

| Reference | How to use it |
| --- | --- |
| Latest production JCB release | Default authoring/compiler version for production-target work, resolved at execution time |
| Latest alpha/beta channel | Development target when requested; inspect the currently available build and feature behavior |
| Source URL containing a commit hash | Evidence for a particular implementation observation; compare it with current code when behavior matters |
| Fixture, package digest or past test version | Identity of an artifact or reproduction; retain it to explain history, not as a default environment choice |
| Observed version in a build receipt | Record what actually produced the delivered extension, enabling diagnosis and reproduction |

Keep immutable source citations and historical receipts accurate. Do not rewrite an old test as though it ran against the newest release, or replace a source URL with a moving branch while continuing to call the claim verified. Document the current supported procedure in the workflow and retain the dated source finding in its evidence section.

JCB is the authoring/compiler environment. A generated extension's deployment requirements are its declared Joomla/PHP versions and packaged runtime dependencies; do not add JCB as a consumer dependency unless the extension actually uses it.

## Improve the skills as JCB evolves

When current JCB behavior exposes a missing, incorrect or obsolete instruction, follow the [Skills feedback workflow](../testing/reporting-issues.md): report the affected guide, current version, expected outcome, reproduction and correction. Continue the authorized implementation using the current supported path. Maintainers use these reports to keep the skills aligned with the latest JCB and complete extension delivery.
