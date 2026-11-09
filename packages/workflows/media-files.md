# Reuse managed files, image uploads and cropping

Use this workflow when an extension needs managed attachments or images. Deliver the complete feature: an upload control, persisted file records linked to the owning entity, configured file types, image variants where required, and usable display, replacement and deletion. An image URL text field is appropriate only when the requirement is an externally managed URL.

**Authority:** reuse and portable identities are project policy. The acquisition and adaptation steps below are derived guidance; concrete media behaviour comes from the [inspected reference graphs](../../examples/reference-patterns.md#files-and-images). That catalogue contains the source revisions, record identities and generated counterparts. Resolve the latest suitable definitions under the [version policy](../../standards/version-policy.md), and inspect changes before applying an older example to the current target.

## Select and acquire the complete feature

Start with the owning Admin View, its application-row GUID and target name; the intended file formats, number of retained uploads, image sizes, storage location and permitted users; and the administrator/site screens that consume the files. Choose the smallest suitable reference graph using [entity reuse](../../standards/entity-reuse.md). The reference components demonstrate mechanisms; their business entities, crop dimensions and presentation are not application requirements.

| Part to acquire | Where it belongs and what to inspect |
| --- | --- |
| Files Admin View and Fields | The actual persisted file entity: file GUID, owner entity GUID and target, file-type GUID, name, extension, MIME, size, path and access metadata |
| File Types Admin View and Fields | The application's upload configuration: allowed targets and formats, storage path, quantity, download access and crop definitions |
| Owning Admin View's Field associations | Entity File Type selector, uploader Note and display Note, including their Field Types and the DOM IDs that connect them |
| GUID hooks | The owning entity's GUID Field, form initialization and save behaviour; uploaded files must retain the same owner identity after save |
| Document code and Custom Code | `vdmUploaderConfig`, the selected asset-loading code and the placeholders/arguments used by the consuming view |
| AJAX methods and inputs | Type details, upload, display and delete methods, with their enabled code switches, input definitions and generated controller path |
| FileFactory and dependent Powers | `File.Type`, `File.Manager`, `File.Display`, image processing, upload agent, definitions/interfaces and the provider chain supplying Table, Data and database services |
| Display Layout and assets | The layout's data contract, image grouping, download/delete controls, UIkit resources and the uploader JavaScript |

**File Types is an application Admin View.** It is different from JCB's Field Type catalogue. Both may be dependencies: the former stores runtime upload rules; the latter defines the behaviour of a JCB Field.

1. Select missing Admin Views, Fields, Layouts and Custom Code from the source Package catalogue with **Init**. If a needed definition already exists locally, inspect it; use **Pull** only when an intentional refresh is required. Apply the [acquisition rules](../../standards/entity-reuse.md#acquire-the-smallest-useful-graph), including selected-source recursion and separate external catalogues.
2. Acquire external Powers, Joomla Powers and Field Types through their own configured sources. Inspect provider registrations and metadata as well as token references: a FileFactory record without its services is incomplete. Preserve upstream service construction rather than manually rebuilding the container in each AJAX method.
3. Attach the real Files and File Types Admin Views to the destination component, with their Fields, schema and access settings. Attach the uploader/type/display Fields to the owning Admin View. Inspect the component's asset settings and any referenced Library or file/folder payloads; importing one Field does not establish the entire upload feature.
4. Reuse unchanged definitions with their existing identities. For an independent adaptation, follow the [typed remapping procedure](../../standards/entity-reuse.md#adapt-a-graph-without-breaking-identities). A changed display Layout may need a new definition and render alias while the public File services remain unchanged. Custom Code names are natural keys; remap their callers if a distinct variant is necessary.

The inspected services expect the `file` and `file_type` table conventions. Retain these when reusing them unchanged. Renaming those application tables requires inspecting and adapting all affected service lookups and metadata, not just changing the Admin View label.

## Connect the owning entity and uploader

1. Confirm the owning record has a stable application GUID under [application identities](application-identities.md). Distinguish it from the owning Admin View's definition GUID and the runtime File Type record's GUID.
2. Set the File Type selector's entity target to the owning view's actual target name. In the inspected selector, `key_field="guid"` returns a File Type row GUID and its target filter selects applicable types. Keep the portable component/view placeholders unless this consumer needs an explicit override.
3. Preserve the uploader Note's `data-type-id`, progress, display, success, error and allowed-format element references together with the display Note. If renaming DOM IDs or adding another uploader, change the corresponding configuration and layout callbacks coherently.
4. Put the selected `vdmUploaderConfig` invocation in the owning view's document code, with its enabled switch. The reference invocation is:

```text
[CUSTOMCODE=vdmUploaderConfig+vdm-uikit-uploader,file_vdm_uploader,getFileTypeDetails,uploadFile,displayFiles,deleteFile]
```

Its arguments are the target CSS class, uploader element/configuration key, type-details action, upload action, display action and delete action, in that order. These are source contract names, not invented settings. Keep them unchanged when their corresponding controls/actions are unchanged; update both ends when adapting them.

5. Inspect the generated configuration. The reference Custom Code takes `$entity` from `$this->item->guid` when no explicit value is supplied, and base64-encodes the current view for `$target`. It builds component AJAX URLs and the form token using portable placeholders and Joomla Powers. The entity and target emitted into those URLs must match the saved file links. A GUID present only in the form does not prove that document code sees it: exercise the new-record path. Preserve a source-supported upload-before-save flow with the same GUID, or expose uploading after the initial save when that is the selected flow.
6. Enable and retain the corresponding AJAX methods and input definitions. In the reference, type-details receives `guid` and `target`; upload receives `guid`, `entity` and `target`; display receives `entity` and `target`; delete receives a file `guid`. Here upload's `guid` is the File Type row GUID, while delete's `guid` identifies a stored file. Preserve the target's BASE64 input handling and method decoding together.
7. Retain the asset-loading path used by the selected reference, including the uploader script as well as UIkit. Verify the compiled page actually loads those assets and initializes the matching controls. Reuse JPK/SPK references and compiler-provided imports under the [authored-code standard](../../standards/authored-code.md); do not copy generated application namespaces into portable authoring code.

The AJAX methods should remain small callers of `File.Type`, `File.Manager` and `File.Display`. Add application-specific work only for a requirement the selected feature does not already satisfy.

## Configure file types and image output

Create the application's File Type **runtime records** in the installed component, or deliver them through its supported initial-data mechanism. Importing their Admin View definition creates the editor and schema; it does not by itself establish the application's upload rules.

| Configuration | Action and resulting contract |
| --- | --- |
| Target | Include the exact target used by the selector, uploader and display calls; the inspected `File.Type` rejects a type/target combination that is not configured |
| Kind and formats | Select the intended image/document/media/file kind and its allowed formats; the type service supplies uploader details and the upload definition |
| Storage path | Configure a valid destination for this site; check the selected service's path resolution and resulting file location after upload |
| Quantity | Set the intended retained-upload count; inspect the current service's limit behaviour, including its treatment of crop variants, before using it for single-image replacement |
| Access | Configure who may use the type and the download access carried onto stored files; align these with the component's intended operations |
| Image crops | Use the reference's crop Fields and their actual associations to set the crop array of names, widths and heights consumed by `File.Type` and `File.Image` |

Keep crop naming and the display Layout compatible. The reference layouts group named main/thumbnail/icon variants; changing the generated names without adapting that grouping breaks the display. Choose sizes and names for this application, using the exact source example in the catalogue to understand their contract.

The inspected manager uploads through its agent, processes configured image variants, and persists each resulting file with its own file GUID plus `file_type`, `entity`, `entity_type` and file metadata. Use these managed relationships for an entity's image or gallery. Do not add a parallel free-text path as the authoritative image store. Where the requirement includes retaining an original, inspect the image-processing lifecycle: the reference crop path removes its uploaded source after writing the variants.

## Load and render the files

Reuse the display method's `File.Display` call and Layout for the editing interface. The service retrieves files for the entity, filters the target/access and prepares file-type and link information. The reference passes a layout data array containing `data`, `entity` and `target`; inspect the chosen layout before changing that shape or its render alias.

For Site Views, use [Dynamic Get](dynamic-get.md) for the main entity and ordinary relationships. Follow the reference's existing file relation or focused `File.Display` call where its link/access processing is needed. Render the resulting structured data through Templates and Layouts using [presentation and queries](../models/presentation-and-queries.md). Keep uploader controls on screens that edit files and configure the public display for its intended actions.

Preserve the actual authorization points in the selected graph: AJAX user checks and form token, type/target eligibility, upload access, file display/download access and deletion checks. The inspected reference manager uses access view levels for upload and deletion; a view level alone does not express every application's record-editing rule. Compare that behaviour with the intended users and owning entities, reuse sufficient controls, and add only the missing policy in the appropriate maintained caller/service. Do not insert a new authorization or staging framework merely because the feature uses AJAX.

## Compile and exercise the complete lifecycle

Compile, install and exercise this feature in the [Playground workflow](../../testing/playground/README.md) or the requested target. Inspect both generated code and actual application rows. Use [GUI-to-output tracing](debug.md#trace-a-gui-code-field) when a hook, asset or configuration value appears in an unexpected place.

1. Open a new owning record and an existing one. Confirm the intended upload timing, stable entity GUID and target, applicable type options, initialized controls and error display. Save the record and confirm its GUID still matches its uploaded files.
2. Upload an allowed document and an image as applicable. Inspect the Files rows, File Type GUID, owning entity/target, MIME, size and stored paths. For configured crops, verify every expected variant exists and has the intended dimensions and display grouping.
3. Close and reopen the owning record. Confirm the same files display and download correctly. Exercise the corresponding Site View, including an entity with no files and a user with the intended access level.
4. Replace an image through the selected quantity/replacement flow, then delete it through the interface. Check both database rows and stored files. The inspected manager deletes one file GUID per call; the image layout supplies the grouped variant GUIDs to its multi-delete callback. Preserve that distinction so removing an image does not leave its thumbnails behind.
5. Exercise the application's relevant disallowed format, inaccessible type and unauthorized operation paths. Confirm failures leave the UI usable and preserve existing files as intended. If uploads occur before the owner is saved, also exercise cancel/reopen and establish the intended handling of those files; do not assume the owner's cancel/delete automatically cleans them up.
6. Verify the delivery includes the source graph, runtime File Type configuration and required assets. A full-site handoff must also retain the actual uploaded files; follow [authoring and export](author-in-playground.md). For importer uploads, continue with the [staged import workflow](staged-import.md) or the selected immediate-import flow, including its own file-retention lifecycle.

If type selection is empty, inspect target, publication/access and File Type records first. If upload succeeds but display is empty, compare the saved entity/target, access and layout input. If cropping or deletion is incomplete, inspect the configured crop names, stored variant rows and layout callbacks before replacing the public services. Correct the authoritative Fields, views, Custom Code, Layout or Power definition, regenerate, and repeat the affected lifecycle. Report unresolved guidance gaps through the [Skills feedback workflow](../../testing/reporting-issues.md).
