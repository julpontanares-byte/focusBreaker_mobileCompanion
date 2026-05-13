# Architecture diagram guidance

Create an architecture diagram (draw.io, Lucidchart or similar) showing the following components:

- Users (Browser)
- Azure Front Door or App Service (Web App)
- App Service Plan (Autoscale)
- Azure SQL Database (session data)
- Azure Blob Storage (exports/backups)
- Azure Key Vault (secrets, connection strings)
- Application Insights / Azure Monitor

Label:
- Public vs Private boundaries
- Protocols (HTTPS, SQL/SSL)
- Managed Identity usage for App Service -> Key Vault / SQL

Save the final diagram as `diagram/architecture.png` and include it in the repository.
