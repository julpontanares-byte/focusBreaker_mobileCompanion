# Implementation Plan – CSEC 3 Final Project (Azure)

This plan is based on:
- Current workspace analysis (`fB_web` is a Next.js timer app with no backend/API or Azure deployment assets yet)
- Project requirements in `PROJECT_REQUIREMENTS.md`

---

## 1) Workspace Analysis Summary

## Current State (What already exists)
- ✅ Frontend web app (Next.js 16 + React 19) with multiple routes under `/timer`
- ✅ Good UI foundation and client-side features (history, settings, analytics)
- ✅ TypeScript project setup and build scripts (`pnpm dev/build/start`)

## Gaps vs Final Project Requirements
- ❌ No Azure infrastructure artifacts yet (`deployment/`, IaC scripts, Portal screenshots)
- ❌ No cloud data layer (currently localStorage only)
- ❌ No security controls configured in Azure yet
- ❌ No architecture diagram yet
- ❌ No cost estimate report yet
- ❌ No `CHANGELOG.md` yet
- ❌ No CI/CD pipeline yet

---

## 2) Recommended Project Direction

## Suggested Scenario
### **Scenario E (Custom) – "Student Productivity Portal"**
> Convert the existing timer app into a cloud-backed productivity portal for students (task sessions + study stats + optional file uploads).

Why this is recommended:
- Reuses current codebase instead of rebuilding from scratch
- Keeps app logic simple (allowed by requirements)
- Lets the team focus on cloud architecture and optimizations

> ⚠️ Since Scenario E requires instructor approval, prepare a 3–5 sentence proposal and get approval early.

## Fallback Scenario (if custom is not approved)
### **Scenario C – Student Enrollment System**
Reuse Next.js UI framework and implement enrollment forms + submissions storage.

---

## 3) Target Azure Architecture

## Baseline (must be deployed and publicly accessible)
1. **Azure App Service Plan** (Linux)
2. **Azure App Service (Web App)** with **2+ instances**
3. **Azure SQL Database** (or Cosmos DB)
4. **Azure Storage Account** (Blob for exported data/uploads)

## Security Control (minimum one required)
- **Azure Key Vault** for connection strings/secrets
- App Service uses managed identity to access Key Vault

## Recommended Cloud Optimizations (MVP includes all 3)
### **Required optimizations for this project MVP**
1. **Security/DevOps:** GitHub Actions CI/CD deployment pipeline
2. **Scalability:** App Service autoscale rule (CPU > 70%)
3. **Monitoring/Ops:** Application Insights + Azure Monitor alerts

This gives 4–6 distinct services total, exceeding the minimum of 3.

---

## 4) Implementation Work Plan by Deliverable

## Deliverable 1 – Architecture Diagram (20 pts)
### Tasks
- Create baseline and improved architecture diagrams in `diagram/architecture.png`
- Explicitly label:
  - public vs private boundary
  - protocol/flow arrows (HTTPS, SQL, Managed Identity)
  - optimization components (autoscale, monitoring)

### Acceptance Checklist
- [ ] All Azure resources shown and labeled
- [ ] Arrows with relationships/protocols included
- [ ] Security boundary visible
- [ ] At least 2 optimizations highlighted

---

## Deliverable 2 – Deployment Documentation (30 pts)

Use the Bicep-based method as the main deployment approach:

### Method A (Recommended): Infrastructure-as-Code with Bicep
Create:
- `deployment/main.bicep` + parameters, or the repo's existing `fB_web/deployment/main.bicep` stack
- `deployment/README.md` with exact deployment steps

Must include creation/configuration of:
1. Resource Group
2. App Service Plan + Web App (2+ instances or autoscale-capable config)
3. Data resource (SQL/Cosmos/Storage)
4. Security control (Key Vault / Managed Identity / NSG / WAF)

### Acceptance Checklist
- [ ] Deployment reproducible
- [ ] No hardcoded secrets in repo
- [ ] Clear step-by-step docs
- [ ] `CHANGELOG.md` maintained throughout
- [ ] Bicep templates are the source of truth for Azure resource provisioning

---

## Deliverable 3 – Cost Estimate Report (15 pts)

Create `report/cost-estimate.md`:
- Architecture summary
- Itemized monthly costs per service
- Embedded screenshot from Azure Pricing Calculator
- At least 1 cost optimization with estimated effect

### Acceptance Checklist
- [ ] All deployed resources represented in costs
- [ ] Pricing calculator screenshot included
- [ ] Cost-saving note is realistic and specific

---

## Deliverable 4 – Live Demo + Video (35 pts)

Create final presentation flow in `README.md`:
- Architecture walkthrough (3 min)
- Live app demo + Azure Portal walkthrough (5 min)
- Cost review (2 min)
- Conclusion/challenges/lessons (2 min)

### Acceptance Checklist
- [ ] Video length 10–15 min
- [ ] All members speak meaningfully
- [ ] App works end-to-end live
- [ ] Portal resources and deployment method shown

---

## 5) Required Repository Structure to Implement

Create and populate:

- `diagram/architecture.png`
- `deployment/deploy.azcli` or `deployment/main.bicep`
- `deployment/README.md`
- `report/cost-estimate.md`
- `CHANGELOG.md`
- Root `README.md` updates (team members, demo URL, unlisted YouTube link)

---

## 6) App Engineering Tasks (Codebase Changes)

To align the current timer app with cloud architecture requirements:

1. **Add backend/API layer** (Next.js route handlers)
   - Save/retrieve sessions from Azure SQL (or Cosmos)
   - Keep client-side experience similar
2. **Add environment configuration**
   - `DATABASE_URL`, storage config, app insights key (managed securely)
3. **Replace local-only persistence (optional hybrid)**
   - Keep localStorage for offline fallback
   - Primary persistence via cloud DB
4. **Add health endpoint**
   - Useful for monitoring and demo (`/api/health`)

---

## 7) Team Execution Plan (2–3 members)

## Suggested role split
- **Member A (Cloud/IaC):** Azure resources, deployment docs, CI/CD
- **Member B (App/Backend):** API routes, DB integration, app updates
- **Member C (Ops/Documentation):** Cost report, diagram, changelog quality, video editing

## Contribution policy
- Each member must produce at least 5 meaningful `CHANGELOG.md` entries
- Commit early/often to show regular contribution timeline

---

## 8) Definition of Done (Rubric-Aligned)

Project is submission-ready only if:
- [ ] Baseline app is publicly accessible on Azure
- [ ] Minimum 3 distinct Azure services are connected and visible
- [ ] All 3 project optimizations are implemented and demonstrable (CI/CD + autoscale + monitoring)
- [ ] Diagram, deployment docs, cost report, changelog, and demo link are complete
- [ ] Team can answer Q&A on any design decision

---

## 9) Immediate Next Actions (Start Now)

1. Finalize scenario choice (custom vs fallback)
2. Create folders/files from Section 5
3. Start `CHANGELOG.md` today (do not delay)
4. Implement baseline Azure deployment first
5. Then implement all 3 optimizations and capture evidence (screenshots/logs)

### Optimization lock-in for your team
- **Required Optimization #1:** GitHub Actions CI/CD
- **Required Optimization #2:** App Service Autoscale
- **Required Optimization #3:** Monitoring (Application Insights + Azure Monitor alerts)
