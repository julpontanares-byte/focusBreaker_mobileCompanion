# Cost Estimate — focusBreaker (draft)

Architecture summary
- App Service (Linux) hosting the Next.js app
- Azure SQL Database (S0) for session history and settings
- Storage Account (Standard_LRS) for export/backups
- Application Insights for monitoring

Itemized estimate (fill with values from Azure Pricing Calculator)
- App Service Plan (B1) — $/month: ______
- Azure SQL Database (S0) — $/month: ______
- Storage Account (Standard_LRS) — $/month: ______
- Application Insights — $/month: ______

Screenshot: include a screenshot of the Azure Pricing Calculator here

Cost optimization notes
- Use Free/Student tier where available
- Turn on autoscale and lower instance size during off-hours
- Use dev/test pricing during evaluation
