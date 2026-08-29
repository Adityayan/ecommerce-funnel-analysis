# ecommerce-funnel-analysis
SQL-based e-commerce customer behavior and sales funnel analysis, covering data validation, customer journey, conversion rates, drop-off analysis, and actionable business insights.
```mermaid
flowchart TD
ReadMe[RAW EVENT TABLE] --> A(sequential_funnel_users VIEW)
   A(sequential_funnel_users VIEW)-->B(Q2 Conversion Rates)
    A(sequential_funnel_users VIEW)-->C(Q3 Drop-off)
   A(sequential_funnel_users VIEW)-->D(Q4 Traffic Sources)
    A(sequential_funnel_users VIEW)-->E(Q5 A/B-style Analysis)
    
    style ReadMe fill:#f9f,stroke:#333,stroke-width:2px
    
```

