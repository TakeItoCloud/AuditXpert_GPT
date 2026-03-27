# UI Behavior Notes

## State model
- The main window owns one shared `LauncherConfig` instance.
- Each panel updates only the section of state it is responsible for.
- Panels emit lightweight `config_changed` or `status_message` signals back to the main window.

## Dynamic behavior

### Assessment panel
- Changing the execution profile updates the selected profile in launcher state.
- If the selected profile does not support assessment-module selection, module checkboxes are disabled and cleared.
- If the selected profile supports modules and provides defaults, those defaults are applied when nothing is selected.

### Authentication panel
- Delegated login hides app-only credential sub-options.
- App authentication reveals sub-options for client secret or certificate.
- Client secret mode reveals the secret-path and secure-entry controls.
- Certificate mode reveals thumbprint, subject, store, and optional certificate-path controls.
- The `How to setup App Auth` action opens a separate help window backed by `docs/launcher/app-auth-setup-guide.md`.

### AI panel
- AI-dependent fields are hidden until AI is enabled.
- Provider, model, and secure key-location placeholders are stored in launcher state only.

### Paths panel
- Repository root is display-only.
- Output and evidence paths update launcher state directly.
- Install-missing-modules and open-results preferences are stored for later bridging phases.

### Status panel
- Summarizes the current profile, selected modules, auth mode, AI state, and output path.
- Re-runs config validation whenever launcher state changes.
- Stores a simple operator-facing status log for placeholder actions.

## Non-goals in this phase
- No PowerShell execution from UI button handlers
- No embedded secrets in the UI state model
- No duplicate assessment or connector logic in Python
