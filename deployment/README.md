<<<<<<< HEAD
# deployment/ — Complete Azure Deployment Documentation

This folder contains complete deployment scripts and documentation for deploying the focusBreaker app to Azure.

> Note: Some Azure resources were created manually through the Azure Portal, but `deployment/main.bicep` is the authoritative infrastructure source going forward.
>
> Use `deployment/README.md` as the primary deployment guide and treat other files in this folder as legacy references.

## Deployment Methods

### Method 1: PowerShell Script (Recommended for Windows)

Use `deploy.ps1` for a complete automated deployment.

**Prerequisites:**
- Azure CLI installed and logged in (`az login`)
- PowerShell 7+ or Windows PowerShell

**Steps:**
1. Copy `parameters.env.sample` to `parameters.env` and fill in your values
2. Set the SQL admin password securely:
   ```powershell
   $securePassword = Read-Host -AsSecureString "Enter SQL Admin Password"
   .\deploy.ps1 -SqlAdminPassword $securePassword
   ```

**Parameters:**
- `ResourceGroupName`: Azure resource group name (default: rg-focusbreaker)
- `Location`: Azure region (default: southeastasia)
- `SqlAdminPassword`: Secure string for SQL admin password (required)

### Method 2: Azure CLI Script

Use `deploy.azcli` for bash-based deployment.

**Prerequisites:**
- Azure CLI installed
- `sqlcmd` utility (from SQL Server tools or Azure CLI)

**Steps:**
1. Copy `parameters.env.sample` to `parameters.env` and fill in your values
2. Set environment variable: `export AZ_SQL_ADMIN_PASSWORD='YourStrongPassword123!'`
3. Make script executable: `chmod +x deploy.azcli`
4. Run: `./deploy.azcli`

### Method 3: Bicep Manual Deployment

For manual control using Bicep templates.

**Prerequisites:**
- Azure CLI installed

**Steps:**
1. Set SQL password: `$env:SQL_ADMIN_PASSWORD = 'YourStrongPassword123!'`
2. Deploy: `az deployment sub create --template-file deployment/main.bicep --parameters deployment/main.bicepparam --location southeastasia`
3. Apply schema manually using sqlcmd or Azure Portal Query Editor

## Infrastructure Created

The deployment creates:
- **Resource Group**: Container for all resources
- **App Service Plan** (B1): Linux hosting plan
- **App Service (Web App)**: Next.js application hosting
- **Azure SQL Database** (S0): Data persistence with schema applied
- **Azure Blob Storage**: File storage for exports/backups
- **Azure Key Vault**: Secure secret management
- **Application Insights**: Monitoring and telemetry

## Security Features

- **Managed Identity**: App Service uses system-assigned managed identity
- **Key Vault**: SQL credentials stored securely
- **HTTPS Only**: Web app enforces HTTPS
- **Network Security**: Public access with proper firewall rules

## Post-Deployment Steps

1. **Verify Resources**: Check Azure Portal for created resources
2. **Test Database**: Connect to SQL DB and verify schema
3. **Set up CI/CD**: Configure GitHub Actions for automatic deployments
4. **Configure Monitoring**: Set up alerts in Application Insights
5. **Test Application**: Access the web app and verify functionality

## Files in this folder

- `README.md` - This deployment guide
- `deploy.ps1` - Complete PowerShell deployment script
- `deploy.azcli` - Complete Azure CLI deployment script
- `parameters.env.sample` - Sample deployment parameters
=======
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
>>>>>>> origin/main
