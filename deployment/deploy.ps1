# Complete Deployment Script for focusBreaker
# This script deploys the Azure infrastructure using Bicep and sets up the database schema

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName = "rg-focusbreaker",

    [Parameter(Mandatory=$false)]
    [string]$Location = "southeastasia",

    [Parameter(Mandatory=$true)]
    [securestring]$SqlAdminPassword
)

# Ensure Azure CLI is logged in
Write-Host "Checking Azure CLI login..."
az account show 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Please log in to Azure CLI first:"
    az login
    exit 1
}

# Set subscription if needed (uncomment and modify)
# az account set --subscription "your-subscription-id"

# Generate unique deployment name
$deploymentName = "focusBreakerDeployment-$(Get-Date -Format 'yyyyMMddHHmmss')"

# Deploy Bicep infrastructure
Write-Host "Deploying Azure infrastructure with Bicep..."
az deployment sub create `
    --name $deploymentName `
    --location $Location `
    --template-file "deployment/main.bicep" `
    --parameters resourceGroupName=$ResourceGroupName `
                 location=$Location `
                 sqlAdminPassword=(ConvertFrom-SecureString $SqlAdminPassword -AsPlainText -Force)

if ($LASTEXITCODE -ne 0) {
    Write-Error "Bicep deployment failed"
    exit 1
}

# Get deployment outputs
Write-Host "Getting deployment outputs..."
$outputs = az deployment sub show `
    --name $deploymentName `
    --query "properties.outputs" | ConvertFrom-Json

$webAppUrl = $outputs.webAppUrl.value
$sqlServer = $outputs.sqlServer.value

Write-Host "Web App URL: $webAppUrl"
Write-Host "SQL Server: $sqlServer"

# Deploy database schema
Write-Host "Deploying database schema..."
$sqlPasswordPlain = ConvertFrom-SecureString $SqlAdminPassword -AsPlainText -Force

# Read schema file
$schemaPath = "deployment/database-schema.sql"
if (!(Test-Path $schemaPath)) {
    Write-Error "Database schema file not found at $schemaPath"
    exit 1
}

$schemaSql = Get-Content $schemaPath -Raw

# Execute schema on Azure SQL
$sqlCommand = @"
sqlcmd -S "$sqlServer.database.windows.net" -d "focusbreakerdb" -U "sqladminuser" -P "$sqlPasswordPlain" -Q "$schemaSql"
"@

Write-Host "Executing schema deployment..."
Invoke-Expression $sqlCommand

if ($LASTEXITCODE -ne 0) {
    Write-Error "Database schema deployment failed"
    exit 1
}

# Set up GitHub Actions secret for deployment (if GitHub repo exists)
Write-Host "Setting up GitHub Actions deployment..."
$repoUrl = git config --get remote.origin.url
if ($repoUrl) {
    Write-Host "Detected GitHub repository: $repoUrl"
    Write-Host "Please manually add the following secrets to your GitHub repository:"
    Write-Host "- AZURE_CREDENTIALS: (Service Principal credentials)"
    Write-Host "- AZURE_RESOURCE_GROUP: $ResourceGroupName"
    Write-Host "- AZURE_WEBAPP_NAME: $($outputs.webAppName.value)"
    Write-Host "- AZURE_SUBSCRIPTION_ID: $(az account show --query id -o tsv)"
}

Write-Host "Deployment completed successfully!"
Write-Host "Next steps:"
Write-Host "1. Push your code to GitHub"
Write-Host "2. Set up GitHub Actions secrets"
Write-Host "3. The app will deploy automatically on push to main branch"
Write-Host "4. Access your app at: $webAppUrl"