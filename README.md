# focusBreaker

Custom scenario for the CSEC 3 Azure final project: a Student Focus & Productivity Tracker.

Repository layout
- `fB_web/` - Next.js app and Azure snapshot API
- `deployment/` - Bicep-based deployment notes and Azure setup guidance
- `diagram/` - architecture source and diagram guidance
- `report/` - cost estimate template
- `CHANGELOG.md` - project log

Quick start

```bash
cd fB_web
npm install
npm run dev
```

What is implemented
- Main timer, history, analytics, and settings screens
- Shared timer state in `fB_web/lib/timer-context.tsx`
- Server snapshot API in `fB_web/app/api/timer/route.ts`
- Azure SQL-aware snapshot store with file fallback in `fB_web/lib/server/timer-store.ts`
- CI/CD scaffold in `.github/workflows/deploy.yml`
- Production build and lint validation completed successfully in `fB_web`
- Deployment docs now center the Bicep-first Azure Portal flow

Cloud story
- Baseline: Linux App Service + Azure SQL Database + Blob Storage + Key Vault + Application Insights
- Optimizations: Managed Identity, CI/CD workflow, monitoring, and Bicep-first provisioning
- Health probe: `fB_web/app/api/health/route.ts`

Next steps
1. Commit and push the cleaned deployment-ready changes
2. Finalize the Azure Portal provisioning / deployment notes if the team wants a step-by-step handoff
3. Set `AZURE_SQL_CONNECTION_STRING` in the App Service configuration for the target repo
4. Export the architecture diagram as `diagram/architecture.png`
5. Prepare the cost report in `report/cost-estimate.md`
