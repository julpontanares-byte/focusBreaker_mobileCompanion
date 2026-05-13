# deployment/ — Azure deployment helpers

This folder contains deployment notes and Bicep-oriented guidance for deploying the focusBreaker app to Azure. Treat the Bicep files in `fB_web/deployment/` as the source of truth for infrastructure.

Prerequisites
- Access to an Azure subscription where you can create resources
- A browser for the Azure Portal
- GitHub access for the deployment workflow

Recommended deployment path

1. Create the Azure resource group and supporting resources in the Azure Portal, using the Bicep model in `fB_web/deployment/main.bicep` and `fB_web/deployment/app-stack.bicep` as the blueprint.
2. Configure the Web App app settings for Azure SQL and Application Insights.
3. Add GitHub secrets for deployment so `.github/workflows/deploy.yml` can publish the app.
4. Push to `main` to trigger the app deploy.

Notes
- Keep passwords out of the repository.
- Use Key Vault for secrets where possible.
- The existing Bicep files are the infrastructure reference even if some provisioning is done manually in the portal.

Current Bicep inputs

- `fB_web/deployment/main.bicep` - subscription-scope entrypoint that creates the resource group and calls the app module.
- `fB_web/deployment/app-stack.bicep` - resource-group module that creates App Service, SQL, Storage, Key Vault, and App Insights.

Files in this folder
- `README.md` - deployment guidance.
- `parameters.env.sample` - sample values for deployment-related settings.
- `deploy.azcli` - legacy Azure CLI scaffold retained for reference.
