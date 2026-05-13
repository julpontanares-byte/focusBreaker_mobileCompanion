# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]


### Added
- Created the `roagnote` branch to begin development on mobile companion features.
- Integrated the system architecture diagram (`architecture.png`) into the `diagram/` folder.

### Added
- Azure deployment scaffolding and documentation
- App Router shell for the Next.js timer app
- Server snapshot API and Azure SQL-aware persistence
- Bicep-first deployment docs for Azure Portal + GitHub Actions workflow

### Changed
- Updated the root project summary to reflect the validated build/lint status and Bicep-first deployment flow
- Added deployment handoff notes for the current Azure Portal setup and migration-ready repo state

### Fixed
- Clarified the current cloud story so it matches the validated Linux App Service deployment path

---

## [2026-05-13] - Deployment Readiness Refresh

### Added
- [Enime] Documented the validated deployment handoff state in the README
- [Enime] Captured the latest build and lint validation status in the project summary

### Changed
- [Enime] Updated the cloud story to reflect the current Linux App Service, Azure SQL, Blob Storage, Key Vault, and Application Insights architecture
- [Enime] Reworded the next steps to emphasize commit/push readiness and repository migration prep

### Fixed
- [Enime] Added a new top-level changelog entry separator and standardized the author surname format

---

## [2026-05-13] - Structuring Project Setup & Early Updates

### Added
- Azure deployment scaffolding and documentation
- App Router shell for the Next.js timer app
- Server snapshot API and Azure SQL-aware persistence
- Bicep-first deployment docs for Azure Portal + GitHub Actions workflow

### Changed
- Updated the project to match the custom Student Focus & Productivity Tracker scenario
- Synchronized the README with the current Azure-ready structure
- Reworked deployment notes to treat `fB_web/deployment/main.bicep` as the source of truth
- Updated the root project summary to reflect the validated build/lint status and Bicep-first deployment flow

### Fixed
- Added missing App Router bridges so the existing timer routes resolve correctly
- Added settings hydration so the UI follows the snapshot loaded from the server

## [2026-05-13] - Project Initialization

### Added
- `GitHub` - Initial repository scaffolding and templates
- `focusBreaker` - Initial timer app structure under `fB_web/`

---
