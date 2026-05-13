# focusBreaker

Custom scenario for the CSEC 3 Azure final project: a Student Focus & Productivity Tracker.

Repository layout
- `fB_web/` - Next.js app and Azure snapshot API
- `deployment/` - Azure CLI scaffold and deployment notes
- `diagram/` - architecture source and diagram guidance
- `report/` - cost estimate template
- `CHANGELOG.md` - project log

Quick start

```bash
cd fB_web
pnpm install
pnpm dev
```

What is implemented
- Main timer, history, analytics, and settings screens
- Shared timer state in `fB_web/lib/timer-context.tsx`
- Server snapshot API in `fB_web/app/api/timer/route.ts`
- Azure SQL-aware snapshot store with file fallback in `fB_web/lib/server/timer-store.ts`
- CI/CD scaffold in `.github/workflows/deploy.yml`

Cloud story
- Baseline: App Service + Azure SQL Database + Blob Storage
- Optimizations: autoscale, Managed Identity, Key Vault, Application Insights
- Health probe: `fB_web/app/api/health/route.ts`

Next steps
1. Deploy the app to Azure App Service
2. Set `AZURE_SQL_CONNECTION_STRING` in the App Service configuration
3. Export the architecture diagram as `diagram/architecture.png`
4. Capture the Azure Pricing Calculator screenshot for the cost report
