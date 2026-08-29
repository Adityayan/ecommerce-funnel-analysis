# E-Commerce-funnel-analysis
SQL-based e-commerce customer behaviour and sales funnel analysis, covering data validation, customer journey, conversion rates, drop-off analysis, and actionable business insights.

## Entity Relationship Diagram

```mermaid
erDiagram
  USERS ||--o{ USER_EVENT : generates
  PRODUCT ||--o{ USER_EVENT : "viewed in"
  TRAFFIC_SOURCE ||--o{ USER_EVENT : refers

  USERS {
    int user_id PK
  }
  PRODUCT {
    int product_id PK
  }
  TRAFFIC_SOURCE {
    string source PK
  }
  USER_EVENT {
    int event_id PK
    int user_id FK
    string event_type
    timestamp event_date
    int product_id FK
    float amount
    string traffic_source FK
  }
```

> Note: `SEQUENTIAL_FUNNEL_USERS` is a derived SQL view built from `USER_EVENT`
> (pivoted by `user_id`), not a relational entity with a foreign key — so it's
> intentionally left out of this ERD. See the pipeline/lineage diagram
> separately for how the view is built.

## Analytical Workflow
This is my *SQL Mental Model*
- **VIEW = reusable analytical layer**
- **CTE = temporary intermediate step**


### RAW DATA

The raw table contains individual user events such as:

- page_view
- add_to_cart
- checkout_start
- payment_info
- purchase

Each row represents an event performed by a user.

**Goal**: Validate and understand the raw data before performing analysis.

### sequential_funnel VIEW

The raw event data is transformed into a user-level sequential funnel.

Instead of multiple event rows per user, we create a structured view where each user has a single timestamp for each funnel stage.

The sequence is validated to ensure:

Page View → Add to Cart → Checkout → Payment → Purchase

This becomes the reusable analytical layer for the rest of the project.

**Goal**: Create a reliable, user-level representation of the customer journey.

## Business Questions Structure  

- **Q1 — Funnel Size**

How many users reach each stage?

- **Q2 — Conversion Rates**

How efficiently do users move between stages?

- **Q3 — Drop-off Analysis**

Where is the biggest bottleneck?

- **Q4 — Traffic Source Analysis**

Which sources perform differently?

- **Q5 — Statistical Comparison**

Is the observed difference meaningful or potentially just noise?

```mermaid
flowchart TD
ReadMe[RAW EVENT TABLE] --> A(sequential_funnel_users VIEW)
A(sequential_funnel_users VIEW)-->A1(Q1 Funnel Counts)
A(sequential_funnel_users VIEW)-->B(Q2 Conversion Rates)
A(sequential_funnel_users VIEW)-->C(Q3 Drop-off)
C(Q3 Drop-off)-->D(Q4 Traffic Sources)
D(Q4 Traffic Sources)-->E(Q5 A/B-style Analysis)
    
    style ReadMe fill:#f9f,stroke:#333,stroke-width:2px
    
```

