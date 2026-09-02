# Meridian Fund Partners S.A. - AUM & Revenue Analytics Dashboard

## Project Overview

This project demonstrates the design and implementation of an end-to-end Business Intelligence solution for a fictional Luxembourg asset management firm, **Meridian Fund Partners S.A.**

The objective was to build a management reporting environment capable of monitoring:

- Assets Under Management (AUM)
- Fund distribution activity
- Subscription and redemption trends
- Relationship Manager performance
- Geographic distribution channels
- Fee revenue generation

The solution combines:

- Google BigQuery
- SQL
- Star Schema Data Modelling
- Data Quality Controls
- Power BI Dashboard Development
- Asset Management Reporting Concepts

The project is designed to demonstrate practical analytical, BI, and financial-services reporting skills relevant to Luxembourg's asset-management industry.

## Business Problem

Senior management requires visibility into:

- AUM growth and target attainment
- Distribution partner performance
- Revenue generation by fund and asset class
- Net fund flows
- Regional distribution trends
- Relationship Manager effectiveness

The objective is to provide timely management information that supports distribution strategy, commercial oversight, and revenue monitoring.

## Project Scope

The project covers:

- Data model design
- Dimensional modelling
- Dataset simulation
- SQL engineering
- Data quality validation
- Power BI reporting

The solution was built using a monthly reporting hierarchy covering:

**Fund x Distributor x Month**

## Technology Stack

| Component | Technology |
|---|---|
| Database | Google BigQuery |
| Modelling | Star Schema |
| Query Language | SQL |
| Reporting | Power BI |
| Data Preparation and Review | Excel |
| Documentation | Markdown |

## Data Architecture

```text
Dimension Tables
    |
    +-- dim_date
    +-- dim_fund
    +-- dim_distributor
    +-- dim_region
    +-- dim_relationship_manager
            |
            v
fact_aum_revenue_monthly
            |
            v
Power BI Semantic Model
            |
            v
Management Dashboards
```

### Fact Table

#### `fact_aum_revenue_monthly`

Monthly reporting fact table containing:

- Opening AUM
- Closing AUM
- Average AUM
- Target AUM
- Gross Subscriptions
- Gross Redemptions
- Net Subscriptions
- Market Movements
- Management Fee Rate
- Fee Revenue

The fact table is modelled at **Fund x Distributor x Month** grain. The `fact_aum_revenue_monthly.csv` file is the table used as the Power BI data source.

### Dimension Tables

#### `dim_date`

Month-end reporting calendar hierarchy.

#### `dim_fund`

Fund reference information, including fund name, promoter, asset class, sub-asset class, domicile, base currency, share class, management fee and launch date.

#### `dim_distributor`

Distribution partner information, including distributor type, country, region, tier and default Relationship Manager.

#### `dim_region`

Regional segmentation and market maturity classification.

#### `dim_relationship_manager`

Relationship Manager structure, coverage, seniority and AUM target information.

The `meridian_bi_sql_dataset.xlsx` workbook is the raw dataset containing the dimension tables. It is retained as a raw data deliverable rather than being reformatted as an analyst workbook.

## Dashboard Pages
🔗 **View the published dashboard**

[Open Meridian Fund Partners S.A. - AUM & Revenue Analytics Dashboard](https://frelotraders-my.sharepoint.com/:u:/g/personal/joylorna_frelotraders_onmicrosoft_com/IQB9T_JnjoypT6mWzpxhq8WhAQPOC_1bBCVloizjIBn8Oso?e=Kw6O7X)

### 1. Executive AUM & Revenue Summary

Provides:

- Total AUM
- AUM target attainment
- Net subscriptions
- Fee revenue
- Effective fee yield
- AUM trend versus target
- Gross subscriptions versus gross redemptions
- Closing AUM by region

<img width="659" height="364" alt="image" src="https://github.com/user-attachments/assets/9b847ffa-3497-4dc2-bf44-5c27be7de75b" />

Designed for executive-level performance monitoring.

### 2. Fund Distribution Breakdown

Provides:

- Fund-level AUM analysis
- Asset-class performance
- Distributor-level activity
- Subscription and redemption pressure
- Revenue contribution by asset class
- Closing AUM by fund

<img width="659" height="368" alt="image" src="https://github.com/user-attachments/assets/54d216aa-7ea9-48d0-b483-74a18f3745d2" />

Designed for distribution, product and commercial management teams.

### 3. Relationship Manager Performance

Provides:

- Relationship Manager ranking
- AUM managed
- AUM target attainment
- Distributor book performance
- Fee revenue generation
- Distributor AUM trends

<img width="659" height="365" alt="image" src="https://github.com/user-attachments/assets/736ed8ef-7f6d-4668-a01b-e4f8e6fdb122" />

Designed for commercial management oversight.

## Reporting Period and Dashboard Timestamp

The dataset covers **January 2024 to June 2025** at month-end frequency.

**Dashboard data as of: 30 June 2026**

The data-as-of statement is documented here because the submitted dashboard is a completed portfolio output. In a production reporting environment, the timestamp would normally be displayed dynamically within the report interface.

## KPI Definitions

| KPI | Definition |
|---|---|
| Opening AUM | AUM at the start of the reporting month. |
| Closing AUM | Opening AUM plus gross subscriptions, less gross redemptions, plus market movement. |
| Average AUM | Arithmetic average of opening and closing AUM for the month. |
| Gross Subscriptions | Total simulated investor inflows during the reporting month. |
| Gross Redemptions | Total simulated investor outflows during the reporting month. |
| Net Subscriptions | Gross subscriptions less gross redemptions. |
| Market Movement | Simulated change in AUM attributable to market performance. |
| Target AUM | Simulated cumulative monthly AUM target used for management reporting. |
| AUM Target Attainment | Closing AUM divided by the applicable simulated AUM target. |
| Management Fee Rate | Annual management fee expressed in basis points. |
| Fee Revenue | Average AUM multiplied by the annual management fee rate, divided by 12. |
| Effective Fee Yield | Fee revenue expressed relative to the applicable AUM base and converted to basis points. |
| RM Rank | Relationship Manager ranking based on fee revenue within the active report filter context. |

## Calculation Methodology

### AUM Roll-Forward

```text
Opening AUM
+ Gross Subscriptions
- Gross Redemptions
+ Market Movement
= Closing AUM
```

### Net Subscriptions

```text
Gross Subscriptions
- Gross Redemptions
= Net Subscriptions
```

### Average AUM

```text
(Opening AUM + Closing AUM) / 2
= Average AUM
```

### Monthly Fee Revenue

```text
Average AUM
x Management Fee Rate in basis points
/ 10,000
/ 12
= Monthly Fee Revenue
```

### Target AUM

The simulation creates a target AUM for each Fund x Distributor book and allocates the target progressively across the 18-month reporting period. This creates a simplified linear target path for dashboard demonstration.

The target methodology is illustrative. It does not represent a production sales-planning, budgeting or forecasting methodology.

## Data Quality Controls

The repository includes dedicated SQL control routines covering:

### Completeness Checks

- Confirmation that each Fund x Distributor book contains 18 monthly records.

### Roll-Forward Checks

- Reconciliation of current-month opening AUM to prior-month closing AUM.

### Formula Validation

- Closing AUM recalculation.
- Net-subscription recalculation.
- Fee-revenue recalculation.

### Referential Integrity Checks

- Orphan date-key detection.
- Orphan fund-key detection.
- Orphan distributor-key detection.
- Orphan region-key detection.
- Orphan Relationship Manager key detection.

### Reasonableness Checks

- Negative opening AUM testing.
- Negative closing AUM testing.
- Negative average AUM testing.

The control queries return exceptions for investigation rather than silently correcting records.

## BigQuery Constraint Behaviour

The BigQuery table definitions declare primary-key and foreign-key relationships using `NOT ENFORCED` constraints.

The constraints document the intended model relationships but do not, by themselves, prevent duplicate keys or orphan records. Data integrity is therefore supported through:

- Controlled dimension seed scripts
- Primary-key design
- Fact-to-dimension relationship logic
- Dedicated orphan-key checks
- Formula and roll-forward validation queries

This distinction is important: the project demonstrates a controlled analytical model, but it does not claim that BigQuery physically enforces every declared relationship.

## Numeric Precision in Raw Exports

The raw `fact_aum_revenue_monthly.csv` export may display extended floating-point representations, for example values ending in `...999999` or `...000001`.

These values arise from the simulation and export process. The SQL load process casts final calculated amounts to BigQuery `NUMERIC` after rounding to two decimal places, while the raw CSV preserves the exported representation available from the source process.

The raw file has intentionally not been manually altered because it serves as the Power BI source-table extract. Report visuals apply presentation-level number formatting for readability. Users reproducing the project should rely on the SQL calculation and casting logic rather than interpreting excess displayed decimal places as economically meaningful precision.

## Simulation Disclosure

This project uses a fully simulated business environment.

The following are fictional:

- Meridian Fund Partners S.A.
- Fund names and ISINs
- Fund promoters
- Distributors
- Relationship Managers
- Client and distribution relationships
- AUM balances
- Fund flows
- Market movements
- Revenue figures
- Targets and performance results

The simulation was created solely for portfolio demonstration and educational purposes. No real client, investor, fund, distributor or confidential company information is used.

This project does not claim:

- Regulatory approval
- CSSF compliance certification
- Production deployment
- Independent model validation
- Suitability for investment decisions
- Suitability for regulatory reporting

## Assumptions and Limitations

The project intentionally simplifies several real-world asset-management processes:

- AUM targets follow an illustrative linear monthly progression.
- Fund flows are simulated using randomized ranges linked to opening AUM.
- Market movements are simulated by asset-class-specific ranges.
- Management fees are simplified to a single annual basis-point rate per fund.
- Fee revenue excludes fee breakpoints, rebates, share-class-specific arrangements, performance fees, retrocessions, waivers, equalisation and day-count effects.
- Relationship Manager allocation follows the default distributor assignment in the dimension data.
- The model does not include investor-level transactions, NAV accounting, transfer-agency processing, hedging, FX translation or fund expense accruals.
- Targets are management-reporting assumptions, not regulatory limits or approved commercial budgets.
- The dashboard is a static portfolio deliverable rather than an operational production report.

## Future Enhancement Roadmap

The following enhancements are intentionally documented rather than retrofitted into the completed raw datasets and dashboard.

### Dynamic Dashboard Timestamp

A future report version could display a dynamic data-refresh timestamp and selected reporting period directly within each dashboard page.

### Standardized Export Presentation

A presentation-layer export could round monetary fields to two decimal places while preserving the unchanged raw Power BI source extract for reproducibility.

### Architecture Diagram

A future documentation release could add a rendered architecture diagram showing:

```text
SQL build scripts
    -> BigQuery dataset
    -> Star schema tables
    -> Quality-control queries
    -> Power BI source extract
    -> Semantic model and DAX measures
    -> Dashboard pages
```

### Benchmark Framework

Potential additions include:

- Fund benchmark assignments
- Benchmark-return history
- Relative return measures
- Excess-return analysis
- Tracking error
- Benchmark-relative reporting by fund and asset class

A benchmark framework would require additional return data and a separate methodology. It is outside the current AUM, distribution and fee-revenue reporting scope.

### Concentration Metrics

Potential additions include:

- Top distributor share of AUM
- Top distributor share of fee revenue
- Top five distributor concentration
- Regional AUM concentration
- Fund concentration by distributor
- Herfindahl-Hirschman Index for selected distributions

These measures could strengthen commercial dependency and concentration-risk analysis but are not required to demonstrate the current dashboard's core purpose.

### Sensitivity Analysis

Potential additions include:

- Market-movement shocks
- Subscription slowdown scenarios
- Redemption stress scenarios
- Management-fee compression scenarios
- AUM target changes
- Fee-revenue sensitivity to AUM and fee-rate assumptions

A future version should define scenario severity, calculation logic, assumptions and limitations before presenting scenario outputs.

## Reproduction Guide

### Prerequisites

- A Google Cloud project with BigQuery access
- Permission to create a dataset, tables and views
- Power BI Desktop
- The repository files

### SQL Execution Order

Run the scripts in this order:

1. `Create the dataset.sql`
2. `Create the star schema tables.sql`
3. `Date dimension data.sql`
4. `Dimension seed data.sql`
5. `fact table simulation.sql`
6. `Create Power BI-friendly views.sql`
7. `data quality audit checks.sql`

### Environment Configuration

The SQL scripts contain a project-specific Google Cloud project identifier. Before execution, replace the project identifier with the identifier for the user's own Google Cloud project while retaining the `meridian_bi` dataset name, or update both consistently throughout the scripts.

### Reproducibility Note

The fact-table simulation uses `RAND()`. Re-running the simulation will therefore generate a new valid synthetic dataset rather than reproducing the exact published balances and flows.

The submitted `fact_aum_revenue_monthly.csv` preserves the data used for the published Power BI dashboard. Use that file when exact reconciliation to the dashboard screenshots is required.

## Repository Contents

```text
README.md

sql/
|-- Create the dataset.sql
|-- Create the star schema tables.sql
|-- Date dimension data.sql
|-- Dimension seed data.sql
|-- fact table simulation.sql
|-- Create Power BI-friendly views.sql
`-- data quality audit checks.sql

data/
|-- meridian_bi_sql_dataset.xlsx
`-- fact_aum_revenue_monthly.csv

dashboard/
|-- Meridian Power BI report.pbix
`-- screenshots/
    |-- executive_aum_revenue_summary.png
    |-- fund_distribution_breakdown.png
    `-- relationship_manager_performance.png
```

The actual repository structure should reflect only the files published with the project. The private Luxembourg analyst roadmap is a personal build guide and is not part of the public repository.

## Key Skills Demonstrated

- Financial-services analytics
- Asset-management management reporting
- AUM and fee-revenue analysis
- Fund-distribution analysis
- Relationship Manager reporting
- Dimensional data modelling
- Star-schema design
- Google BigQuery SQL
- Synthetic dataset generation
- Data-quality and reconciliation controls
- Power BI dashboard development
- Analytical documentation

## Professional Positioning

This project is positioned as a **portfolio demonstration of Business Intelligence, SQL, data modelling and management reporting in a Luxembourg asset-management context**.

The project is not presented as a regulatory model, official fund report, audited financial statement, client deliverable or production system.

## Author and Project Classification

**Author:** Joy Lorna  
**Project Type:** Professional Portfolio Project  
**Industry Focus:** Luxembourg Asset Management and Fund Distribution  
**Data Classification:** Fully Simulated  
**Reporting Period:** January 2024 to June 2025  
**Latest Data Date:** 30 June 2026
