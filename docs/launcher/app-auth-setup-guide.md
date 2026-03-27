# App Authentication Setup Guide

## Purpose
Use this guide when the launcher is configured for application authentication instead of delegated interactive sign-in. The launcher stores only setup intent in this phase. It does not submit credentials or perform sign-in from the UI yet.

## Step 1. Register an application
1. Open the Microsoft Entra admin center.
2. Go to App registrations.
3. Create a new registration for the AuditXpert service identity.
4. Record the application or client ID and the tenant ID for launcher configuration.

## Step 2. Decide how the app will authenticate
Choose one of these patterns:
- Client secret for simpler short-term lab or internal testing scenarios.
- Certificate authentication for stronger unattended or consultant repeatability scenarios.

## Step 3. Configure required API permissions
Review the least-privilege and connector documentation already maintained in this repository before assigning permissions:
- `docs/Least-Privilege-M365.md`
- `docs/Least-Privilege-Azure.md`
- `docs/launcher/profile-mapping-notes.md`

Only grant permissions that align to the assessment scope and supported connectors. Do not grant broad permissions only because the launcher exposes app-auth controls.

## Step 4. Grant admin consent
1. Review the requested permissions with an administrator.
2. Grant tenant-wide admin consent only when the planned connector scope requires it.
3. Document the granted permission set outside the launcher if your client-delivery workflow requires evidence.

## Step 5. Configure a client secret if you chose that path
1. Create a new client secret in the app registration.
2. Store the secret in an approved secure location.
3. In the launcher, prefer a secret path or secure runtime entry indicator rather than storing the secret value in files.
4. Do not commit secret material into this repository.

## Step 6. Configure a certificate if you chose that path
1. Create or select a certificate that meets your client policy requirements.
2. Upload or associate the public certificate with the app registration.
3. Record the selector metadata needed by the launcher:
   - thumbprint
   - subject
   - certificate store
   - optional certificate path metadata
4. Keep private key material outside the repository.

## Step 7. Validate the scope before use
1. Confirm the chosen execution profile actually supports later app-auth binding.
2. Confirm the target assessment modules match the permission scope that was granted.
3. Confirm the launcher configuration contains only metadata and placeholders, not secrets.

## Notes
- This guide supports setup and operator readiness. It does not imply automatic connector support for every auth pattern yet.
- If the current PowerShell profile does not accept auth parameters today, keep the auth settings in launcher state only until the bridging phase adds a supported execution path.
