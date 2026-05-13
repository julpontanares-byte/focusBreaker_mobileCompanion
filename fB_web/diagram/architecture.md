# Architecture Diagram Source

Use this as the basis for a polished diagram in draw.io or another diagram tool.

```mermaid
flowchart LR
  U[Users / Browser] -->|HTTPS| W[Azure App Service Web App]
  W -->|SQL over TLS| S[(Azure SQL Database)]
  W -->|Managed Identity + Secrets| K[Azure Key Vault]
  W -->|Upload / Download| B[(Azure Blob Storage)]
  W -->|Telemetry| A[Application Insights / Azure Monitor]

  subgraph Public Boundary
    U
    W
  end

  subgraph Private Data Boundary
    S
    K
    B
  end

  subgraph Operations
    A
  end
```

Callouts to highlight in the final diagram
- Baseline: App Service + Azure SQL + Blob Storage
- Optimization 1: autoscale on the App Service Plan
- Optimization 2: Managed Identity + Key Vault for secrets
- Optional: Application Insights alerts and dashboard

Save the final exported image as `diagram/architecture.png`.
