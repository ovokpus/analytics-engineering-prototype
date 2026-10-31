# Business case: Analytics Engineering Prototype (Northwind trading desk)

**Getting reporting off the operational database and onto a tested dimensional model.**

## Who buys this

The buyer is the finance or operations director at a small or mid-sized distributor, importer or wholesaler whose reports run directly against the order-entry database. The users are the sales, purchasing and inventory managers who read those reports, and the one or two people who maintain them.

## The problem and what it costs

Running reports on the database that takes orders causes two problems. Heavy queries slow down order entry. And every report computes "net sales" or "on-hand stock" its own way, so numbers disagree between meetings. The standard fix is to copy the data to a warehouse and build a dimensional (star schema) model with shared, tested definitions.

Poor data quality is expensive at organisation level. Gartner research puts the average at **at least US$12.9 million a year per organisation**, from a self-reported 2020 survey of 154 reference customers of data-quality vendors ([Gartner](https://www.gartner.com/en/data-analytics/topics/data-quality)). That figure fits large firms better than a small importer, so it is context only.

Warehouse compute is cheap at this scale. BigQuery on-demand pricing is **US$6.25 per TiB scanned, with the first 1 TiB each month free** ([Google Cloud BigQuery pricing](https://cloud.google.com/bigquery/pricing)).

## How the repo solves it

| Need | What in the repo does it |
|---|---|
| Land and stage the extract | dbt staging models over the Northwind seed (`ae_prototype/`) |
| One definition per metric | A Kimball star schema (facts and conformed dimensions) built with dbt, with `dbt test` on every build |
| Reports that are simple to query | Three one-big-table models: `obt_sales_overview`, `obt_customer_reporting` and `obt_product_inventory` |
| A cloud warehouse, or a laptop | A BigQuery profile for the cloud, and a local Postgres profile run with `docker compose up` |
| Something a manager can click | A Streamlit desk with Overview, Sales, Customers and Inventory views that reads only the OBT layer |
| Scheduling | An `orchestration/` folder for scheduled runs |

## Use-case scenarios

All of these organisations are fictional.

1. **A specialty-foods importer's Monday meeting.** Sales, purchasing and finance read the same net-sales figure from `obt_sales_overview`, because it is defined once in dbt and tested.
2. **The purchasing manager's reorder check.** The Inventory view lists products under their reorder level from `obt_product_inventory`, without a query against the order system during business hours.
3. **A finance controller checking a figure.** dbt's lineage graph shows exactly which source columns and transformations produced a revenue number, which helps at audit time.

## ROI: a worked model (illustrative)

These figures are **illustrative assumptions**, apart from the BigQuery price.

| Input | Value | Basis |
|---|---|---|
| Hours a week spent producing and reconciling reports by hand | 8 | Assumption |
| Share removed by a tested model and self-serve desk | 60% | Assumption |
| Analyst hourly cost | US$70 | BLS May 2024 median for data scientists, used as a proxy for an analyst: about $54 an hour ([BLS](https://www.bls.gov/ooh/math/data-scientists.htm)). Multiplied by an assumed 1.3. |
| Data scanned a month | under 1 TiB | Assumption for a business of this size |

Labour saved: 8 × 52 × 60% ≈ **250 hours, about US$17,500 a year**. Warehouse query cost: **US$0** inside BigQuery's free monthly TiB, plus small storage charges. The benefit that isn't counted is order entry that no longer slows down when someone runs a report.

## Path to production

1. Replace the Northwind seed with a scheduled extract from the real order system (change-data capture or a nightly export).
2. Agree the metric definitions with finance and record them in dbt docs.
3. Schedule `dbt build` with alerts on test failures, and add freshness checks on sources.
4. Point the BI tool of choice at the OBT layer. The Streamlit desk can stay as a lightweight option.

`PRODUCTIONIZING.md` lists the engineering steps.

## Risks and limits

- The sample data is the classic Northwind set from 2006, so it shows the pattern, not real performance.
- The value depends on agreeing definitions with the business. The code is the easier half.
- One analyst can maintain this, but it still needs an owner.

## Sources

- Google Cloud, BigQuery pricing: https://cloud.google.com/bigquery/pricing
- Gartner, Data Quality topic page ($12.9M figure): https://www.gartner.com/en/data-analytics/topics/data-quality
- U.S. Bureau of Labor Statistics, Data Scientists: https://www.bls.gov/ooh/math/data-scientists.htm
