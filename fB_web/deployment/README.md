# Deployment Guide

This folder contains the Bicep deployment scaffold for focusBreaker.

Planned deployment flow
1. Use the Bicep files as the infrastructure source of truth.
2. Create the Azure resource group and app resources through the Azure Portal or a deployment experience that supports Bicep.
3. Configure the Web App settings for Azure SQL and Application Insights.
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
- Keep the SQL administrator password outside the repository.
- Prefer Managed Identity over shared keys wherever possible.

How to deploy

1. Open the Azure Portal.
2. Create or select the target resource group.
3. Use the Bicep template in `main.bicep` as the provisioning reference.
4. Create the matching App Service, SQL, Storage, Key Vault, and Application Insights resources.
5. Add the needed app settings in the Web App configuration.
6. Publish the app through the GitHub Actions workflow in `.github/workflows/deploy.yml`.

Files in this folder
- `main.bicep` - Bicep entrypoint.
- `app-stack.bicep` - app resource module.
- `main.bicepparam` - parameter file.
- `database-schema.sql` - Azure SQL schema for the timer app.
- `api-flow.md` - request/response flow for the timer API.
- `credentials.md` - list of required secrets and how to obtain them.

Related workflow
- `.github/workflows/deploy.yml` - publishes the Next.js app to Azure Web App from the `fB_web` directory.
