# ecommerce-funnel-analysis
SQL-based e-commerce customer behavior and sales funnel analysis, covering data validation, customer journey, conversion rates, drop-off analysis, and actionable business insights.
```mermaid
flowchart TD
    ReadMe[RAW EVENT TABLE] --> Guides[Guides]
    ReadMe --> APIRef[API Reference]
    
    Guides --> Editor[Editor UI]
    Editor --> Slash[Slash Commands]
    Slash --> Mermaid[Mermaid Diagrams]
    Slash --> Other[Other Blocks]
    
    APIRef --> OpenAPI[OpenAPI Spec]
    APIRef --> Manual[Manual Editor]
    
    style ReadMe fill:#f9f,stroke:#333,stroke-width:4px
    style Mermaid fill:#bbf,stroke:#333,stroke-width:2px
```
RAW EVENT TABLE
      │
      ▼
sequential_funnel_users VIEW
      │
      │  one row = one user
      │
      ├──────────────► Q1 Funnel Counts
      │
      ├──────────────► Q2 Conversion Rates
      │
      ├──────────────► Q3 Drop-off
      │
      ├──────────────► Q4 Traffic Sources
      │
      └──────────────► Q5 A/B-style Analysis
