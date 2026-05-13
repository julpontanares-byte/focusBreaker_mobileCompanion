# Deployment Guide

This folder contains the Bicep deployment scaffold for focusBreaker.

Planned deployment flow
1. Set `SQL_ADMIN_PASSWORD` in your shell.
2. Deploy `main.bicep` with `main.bicepparam` at subscription scope.
3. Let the Bicep template create the resource group and app resources.
4. Use the deployment outputs to confirm the web app URL and resource names.

Bicep files
- `main.bicep` - subscription-scope entrypoint that creates the resource group and calls the app module.
- `app-stack.bicep` - resource-group module that creates App Service, SQL, Storage, Key Vault, and App Insights.
- `main.bicepparam` - default non-secret parameter file for the deployment.

Database design
- `database-schema.sql` contains the normalized Azure SQL schema used by the timer app.
- The current app uses a single logical profile with `profileId = 'default'`.
- `api-flow.md` explains how the client, API routes, and database work together.
- `/api/timer` remains the app-facing contract; the backend decides whether the data lands in Azure SQL or the local fallback store.

Security notes
- Do not hardcode passwords in the repository.
- Use the `SQL_ADMIN_PASSWORD` environment variable when deploying Bicep.
- Prefer Managed Identity over shared keys wherever possible.

How to deploy
```powershell
$env:SQL_ADMIN_PASSWORD = '<your-strong-password>'
Set-Location 'D:\Juliet S. Pontanares\Documents\3rd Year\CC\focusBreaker_mobileCompanion\fB_web'
& 'C:\Program Files\nodejs\corepack.cmd' pnpm exec az deployment sub create --location eastus --template-file deployment/main.bicep --parameters @deployment/main.bicepparam --parameters sqlAdminPassword=$env:SQL_ADMIN_PASSWORD
```

Files in this folder
- `main.bicep` - Bicep entrypoint.
- `app-stack.bicep` - app resource module.
- `main.bicepparam` - parameter file.
- `database-schema.sql` - Azure SQL schema for the timer app.
- `api-flow.md` - request/response flow for the timer API.
- `credentials.md` - list of required secrets and how to obtain them.
