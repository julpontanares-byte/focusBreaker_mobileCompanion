# deployment/ — Azure deployment helpers

This folder contains helper scripts and templates to deploy the focusBreaker app to Azure. These are scaffolds — review and adjust before running in your subscription.

Prerequisites
- Azure CLI installed and logged in (`az login`)
- Subscription where you have rights to create resources
- `jq` (optional, for JSON parsing in scripts)
- Environment variables (see `parameters.env.sample`)

Quick deploy (example)

```bash
# set required environment variables (example values)
export RG_NAME="rg-focusbreaker"
export LOCATION="eastus"
export APP_NAME="fb-web-$(date +%s)"
export STORAGE_NAME="fbstorage$(date +%s)"
export SQL_ADMIN="sqladminuser"
export AZ_SQL_ADMIN_PASSWORD="<set-via-env-or-keyvault>"

# run the script (bash)
bash deployment/deploy.azcli
```

Notes
- The `deploy.azcli` script uses environment variables for secrets (no hardcoded passwords). Use Azure Key Vault to store secrets in production.
- After deployment, configure CI/CD by adding the `AZURE_CREDENTIALS` secret or using publish profile.
