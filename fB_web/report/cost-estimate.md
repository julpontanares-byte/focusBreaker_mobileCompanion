# Cost Estimate Report

Project: focusBreaker — Student Focus & Productivity Tracker

## Architecture summary

- Azure App Service hosts the Next.js application.
- Azure SQL Database stores session history, settings, and analytics inputs.
- Azure Blob Storage stores exported backups and downloadable data snapshots.
- Azure Key Vault stores secrets and connection strings.
- Application Insights collects telemetry and application health data.

## Itemized cost breakdown

Fill these values using the Azure Pricing Calculator.

| Resource | SKU / Tier | Estimated Monthly Cost |
|---|---|---:|
| App Service Plan | B1 or similar | ______ |
| Azure SQL Database | S0 or similar | ______ |
| Blob Storage | Standard_LRS | ______ |
| Key Vault | Standard | ______ |
| Application Insights | Pay-as-you-go | ______ |

## Screenshot

Add a screenshot of the completed Azure Pricing Calculator estimate here.

## Cost optimization notes

- Use a lower App Service tier during development and demos.
- Enable autoscale so capacity increases only when needed.
- Store only the data required for the demo in Azure SQL.
- Use lifecycle rules or low-cost storage tiers for backups.
