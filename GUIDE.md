# focusBreaker Project Guide

This guide collects the practical steps for understanding, running, and deploying the **focusBreaker** app. It is written for the current repository state and the Azure architecture already scaffolded in the codebase.

## 1) What this project is

**focusBreaker** is a student focus and productivity tracker built with Next.js. It provides:

- a Pomodoro-style timer
- session history
- productivity analytics
- configurable settings
- a simple server snapshot API for shared state
- Azure deployment scaffolding for App Service, Azure SQL, Storage, Key Vault, and Application Insights

### Main app areas

- `fB_web/app/timer/page.tsx` — main dashboard UI
- `fB_web/app/timer/history/page.tsx` — session history
- `fB_web/app/timer/analytics/page.tsx` — analytics dashboard
- `fB_web/app/timer/settings/page.tsx` — timer settings and data management
- `fB_web/lib/timer-context.tsx` — shared timer state, hydration, and timer actions
- `fB_web/lib/timer-storage.ts` — browser `localStorage` persistence plus server sync
- `fB_web/lib/server/timer-store.ts` — Azure SQL-aware snapshot store with file fallback
- `fB_web/app/api/timer/route.ts` — snapshot API
- `fB_web/app/api/health/route.ts` — readiness check

---

## 2) Current architecture in plain English

The app uses a **single snapshot contract**.

1. The browser loads the app.
2. `TimerProvider` reads the local cache first.
3. The client calls `GET /api/timer` to hydrate from the server snapshot.
4. User actions update local state and `localStorage`.
5. The browser attempts to sync the snapshot back to `PUT /api/timer`.
6. The server writes the snapshot to **Azure SQL** if a connection string exists.
7. If Azure SQL is unavailable in development, the server falls back to `.data/timer-store.json`.

This keeps the UI simple while still allowing cloud-backed persistence.

---

## 3) Important data model

### Timer types

`fB_web/lib/timer-types.ts` defines the core shapes:

- `SessionMode` — `work`, `short-break`, `long-break`
- `SessionQuality` — `perfect`, `good`, `skipped`
- `TimerSettings` — work/break durations, audio, notifications, theme, auto-start, timestamps
- `TimerSession` — one recorded timer session
- `DailyStats` — per-day productivity summary
- `TimerState` — current live timer state in the browser

### Snapshot shape

`fB_web/lib/timer-data.ts` defines `TimerSnapshot`:

- `settings`
- `sessions`
- `stats`
- `exportDate`
- `updatedAt`

---

## 4) Code paths worth knowing

### Client hydration and sync

`fB_web/lib/timer-context.tsx` does the heavy lifting:

- loads the initial settings from `localStorage`
- hydrates from `/api/timer`
- keeps the timer running state in React context
- records sessions when a timer completes
- saves settings back through `TimerStorageManager`

### Browser persistence

`fB_web/lib/timer-storage.ts` handles:

- `localStorage` reads and writes
- export/import of timer data
- sync calls to `/api/timer`
- clearing local and remote snapshots

### Server persistence

`fB_web/lib/server/timer-store.ts`:

- uses Azure SQL when `AZURE_SQL_CONNECTION_STRING` or related connection env vars are present
- creates the timer tables if missing
- falls back to `.data/timer-store.json` if SQL is not reachable
- uses a single logical profile, `profileId = 'default'`

### API routes

`fB_web/app/api/timer/route.ts` supports:

- `GET` — load the snapshot
- `PUT` — replace the snapshot
- `DELETE` — clear the snapshot

`fB_web/app/api/health/route.ts` returns deployment health and storage mode.

---

## 5) Minimal code examples you should keep aligned

### Snapshot API contract

The app expects these routes to exist and behave consistently:

```ts
GET /api/timer
PUT /api/timer
DELETE /api/timer
GET /api/health
```

### Hydration pattern

The client should keep this behavior:

```ts
useEffect(() => {
  let cancelled = false

  const hydrateFromServer = async () => {
    const snapshot = await fetchTimerSnapshot()

    if (!snapshot || cancelled) return

    TimerStorageManager.importData(JSON.stringify(snapshot), false)
    setState((prev) => ({
      ...prev,
      settings: snapshot.settings ?? prev.settings,
    }))
  }

  void hydrateFromServer()

  return () => {
    cancelled = true
  }
}, [])
```

### Azure SQL-aware snapshot fallback

The server store currently uses this sequence:

```ts
const sqlSnapshot = await readSnapshotFromSql()
if (sqlSnapshot) return sqlSnapshot
return readSnapshotFromFile()
```

That pattern is important because it preserves local dev usability.

### Bicep app settings to keep

The current Azure template wires these app settings:

```bicep
appSettings: [
  {
    name: 'AZURE_SQL_CONNECTION_STRING'
    value: sqlConnectionString
  }
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: appInsights.properties.ConnectionString
  }
  {
    name: 'WEBSITE_NODE_DEFAULT_VERSION'
    value: '20-lts'
  }
]
```

---

## 6) Local development setup

### Prerequisites

- Node.js 20+
- pnpm
- Git
- Optional: Azure CLI if you want to deploy

#### Windows install steps

If `node`, `npm`, and `pnpm` are not recognized in PowerShell or cmd, install Node.js first. On Windows, the quickest path is usually:

1. Install **Node.js LTS** from the official site, or use `winget`:

  ```powershell
  winget install OpenJS.NodeJS.LTS
  ```

2. Close and reopen your terminal so PATH updates apply.
3. Verify Node is available:

  ```powershell
  node -v
  npm -v
  ```

4. Enable Corepack and activate pnpm:

  ```powershell
  corepack enable
  corepack prepare pnpm@latest --activate
  pnpm -v
  ```

If Corepack is unavailable for any reason, you can install pnpm globally after Node is installed:

```powershell
npm install -g pnpm
pnpm -v
```

#### PowerShell note

On some Windows setups, PowerShell may try to run `npm.ps1` and block it. If that happens, use the command shim directly:

```powershell
& 'C:\Program Files\nodejs\npm.cmd' -v
& 'C:\Program Files\nodejs\corepack.cmd' -v
```

You can also run Node tools through `cmd /c` if you prefer:

```powershell
cmd /c npm -v
cmd /c pnpm -v
```

### Run locally

From the repository root:

```bash
cd fB_web
npm install
npm run dev
```

### Build and lint

```bash
cd fB_web
npm run build
npm run lint
```

### Local data behavior

- browser data is stored in `localStorage`
- server snapshot fallback is `.data/timer-store.json`
- if Azure SQL is configured, the server store prefers SQL automatically

---

## 7) Azure portal setup guide

Use this when creating the Azure environment manually in the portal.

### A. Create the resource group

1. Open **Azure Portal**.
2. Search for **Resource groups**.
3. Select **Create**.
4. Choose:
   - Subscription: your project subscription
   - Resource group: `rg-focusbreaker` or your preferred name
   - Region: `East US` or the region used in the repo
5. Review and create.

### B. Create the App Service Plan

1. Search for **App Service plans**.
2. Select **Create**.
3. Choose:
   - OS: **Linux**
   - Pricing tier: start with **B1** for the scaffold
   - Resource group: the one you created above
   - Region: same region as the resource group
4. Create the plan.

### C. Create the Web App

1. Search for **App Services**.
2. Select **Create** → **Web App**.
3. Fill in:
   - Publish: **Code**
   - Runtime stack: **Node.js 20 LTS**
   - Operating System: **Linux**
   - Region: same as the App Service Plan
   - App Service Plan: choose the plan you created
4. Enable **Health check** later with `/api/health`.

### D. Enable system-assigned managed identity

1. Open the Web App.
2. Go to **Identity**.
3. Under **System assigned**, switch **Status** to **On**.
4. Save.

This identity is intended for secure access to Azure resources instead of hardcoded secrets.

### E. Create Azure SQL Database

1. Search for **SQL databases**.
2. Select **Create**.
3. Create or select a logical SQL server.
4. Set:
   - SQL admin login
   - strong SQL admin password
   - database name such as `fbsqldb`
   - pricing tier `S0` for the scaffold
5. After creation, confirm **Networking** settings.

### F. Configure SQL networking

If you are using the portal setup only:

- allow the Web App to reach the SQL server
- if needed for demo/testing, temporarily allow Azure services or add a firewall rule
- for production, prefer tighter network rules and managed identity-based access patterns where possible

### G. Create the Storage Account

1. Search for **Storage accounts**.
2. Select **Create**.
3. Use:
   - `StorageV2`
   - `Standard_LRS`
   - HTTPS only
   - public blob access disabled
4. This supports exports and backup-style storage.

### H. Create Key Vault

1. Search for **Key vaults**.
2. Create a vault in the same resource group.
3. Add secrets for:
   - SQL admin password
   - SQL connection string if you want to keep it out of App Settings
4. Use access policies or RBAC based on your security preference.

### I. Create Application Insights

1. Search for **Application Insights**.
2. Create a web-type resource.
3. Link it to the same region and resource group.
4. Copy the **connection string**.

### J. Add App Settings in the Web App

Go to **Configuration** → **Application settings** and add:

- `AZURE_SQL_CONNECTION_STRING`
- `APPLICATIONINSIGHTS_CONNECTION_STRING`
- `WEBSITE_NODE_DEFAULT_VERSION` = `20-lts`

If you keep secrets in Key Vault, store only references or use a secure retrieval pattern.

### K. Configure health checks

In the Web App settings:

- set **Health check path** to `/api/health`
- enable **Always On** if available in the selected plan

### L. Deploy the app

Use your preferred deployment path:

- GitHub Actions
- Azure DevOps
- ZIP deploy
- Azure CLI

The repo already includes deployment scaffolding in `deployment/deploy.azcli` and Bicep in `fB_web/deployment/main.bicep`.

---

## 8) Infrastructure-as-code guide

### Bicep entry point

`fB_web/deployment/main.bicep` is the subscription-scope entry point.

It creates:

- resource group
- app stack module
- outputs for web app URL and resource names

### App stack module

`fB_web/deployment/app-stack.bicep` creates:

- App Service Plan
- Storage Account
- Application Insights
- SQL Server and Database
- Key Vault and secrets
- Web App with managed identity

### Parameter file

`fB_web/deployment/main.bicepparam` provides non-secret defaults.

### Deployment scaffold

The root `deployment/deploy.azcli` script is a more manual scaffold that expects environment variables such as:

- `RG_NAME`
- `LOCATION`
- `APP_NAME`
- `STORAGE_NAME`
- `SQL_SERVER_NAME`
- `SQL_DB_NAME`
- `SQL_ADMIN`
- `AZ_SQL_ADMIN_PASSWORD`

### Important note

The repository currently has **two deployment tracks**:

- `deployment/` at the repo root for scaffold/docs
- `fB_web/deployment/` for the actual app infra module and API flow docs

For implementation work, treat the `fB_web/deployment/` files as the source of truth for the current app stack.

---

## 9) Recommended implementation tasks

These are the concrete tasks the repo still needs to be polished:

1. Finalize the Azure deployment and secrets flow.
2. Make the App Service → SQL / Key Vault / Insights configuration explicit.
3. Keep the snapshot API contract stable.
4. Verify history and analytics calculations against persisted sessions.
5. Decide whether the file fallback is dev-only or part of the supported runtime story.
6. Publish the final architecture diagram as `diagram/architecture.png`.
7. Capture Azure pricing screenshots for the report.
8. Run lint/build checks before deployment.

---

## 10) Validation checklist

Before calling the project finished, confirm:

- `pnpm lint` passes
- `pnpm build` passes
- `/api/health` returns `ok`
- `/api/timer` returns a snapshot
- the Web App can reach Azure SQL
- settings persist after refresh
- history and analytics display session data correctly
- Key Vault secrets are not hardcoded in source files

---

## 11) File map for quick reference

### App

- `fB_web/app/page.tsx` — redirects to `/timer`
- `fB_web/app/layout.tsx` — root layout and theme provider
- `fB_web/app/timer/page.tsx` — main dashboard page
- `fB_web/app/timer/history/page.tsx` — history page
- `fB_web/app/timer/analytics/page.tsx` — analytics page
- `fB_web/app/timer/settings/page.tsx` — settings page

### API

- `fB_web/app/api/health/route.ts` — health endpoint
- `fB_web/app/api/timer/route.ts` — snapshot CRUD endpoint

### Library

- `fB_web/lib/timer-context.tsx` — shared state and timer actions
- `fB_web/lib/timer-storage.ts` — browser storage and sync
- `fB_web/lib/timer-api.ts` — client-side API helper
- `fB_web/lib/timer-data.ts` — snapshot shape and factory
- `fB_web/lib/server/timer-store.ts` — persistence backend

### Deployment

- `fB_web/deployment/main.bicep` — subscription-scope Bicep entry point
- `fB_web/deployment/app-stack.bicep` — resource group app stack
- `fB_web/deployment/main.bicepparam` — parameter defaults
- `fB_web/deployment/api-flow.md` — backend flow description
- `deployment/deploy.azcli` — Azure CLI scaffold
- `deployment/parameters.env.sample` — environment variable sample

---

## 12) Suggested next step

If you want the project to be submission-ready, the best order is:

1. finish the infra/deployment wiring
2. validate the app against Azure SQL
3. create the final diagram
4. capture screenshots for the report
5. run build/lint and do a final pass on docs

---

## 13) Short version

The app is already functionally shaped. The remaining work is mostly about making the deployment story clean, secure, and easy to demonstrate. Once the Azure pieces are finalized and the docs/diagram are aligned, the project should be presentation-ready.
