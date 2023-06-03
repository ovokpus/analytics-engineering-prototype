# Analytics Engineering Prototype Project

This project implements the use of Analytics Engineering Best practices to build a dimensional data model, using dbt (data build tool) and BigQuery.

[!image](https://github.com/ovokpus/analytics-engineering-prototype/blob/main/img/dbt-bigquery.png)

## Hypothetical use case
This is an import-export company that trades around the world for specialty foods. Their existing architecture is mostly a mix of on-premise and legacy systems, including a relational database as their primary operational database. This is where all the sales transactions are recorded between the company and its customers. This same database is also being used to generate reports and build analytics solutions.

The company is struggling to keep up with reporting requirements, which cause the database performance to degrade, negatively impacting their daily business operations. Their goal now is to mordernize their data and reporting solution and move away from on-prem infrastructure. The new solution must achieve:
1. Better scalability.
2. Reduced load on operational and transactional systems.
3. Improved reporting speed.
4. Improved data security.

To achieve this, the OLTP data has to be migrated periodically to BigQuery, refreshing the transactional data, which will be used for downstream reporting, analytics and possible Machine Learning Experimentation.

## Dataset
The Dataset used is the publicly available northwind database, which is a sample database curated by Microsoft. This has been repurposed as relational database tables migrated into BigQuery through some ingestion process.

### OLTP data to be migrated
Database Diagram
[!image](https://github.com/ovokpus/analytics-engineering-prototype/blob/main/img/northwind-oltp-erd.png)

---

### Requirements Gathering
Below is the Requirements Gathering process for this project use case
#### Define Business Processes
##### Sales Overview
Overall sales reports to understand better our customers what is being sold, what sells the most, in what locations, and also whay sells the least. This is for a general overview of how the business is going.

##### Sales Agent Tracking
Tracking sales and performance of each sales agent to adjust commmissions, reward high performers and empower low performers.

##### Product Inventory
Understanding the current inventory levels, in order to improve stock management; knowing which suppliers we have in our books and how much merchandise is being purchased from them. This will allow us to understand Stock Management, and potentially broker better deals with suppliers.

##### Customer Reporting
Allows customers to understand their purchase orders, how much and when they are buying. This will empower them to make data-driven decisions and utilize the data to join to their sales data.

---

### Architecture Design
The architecture for this is a Dimensional Data Warehouse, with a Dimensionally Modeled layer within BigQuery
[!image](https://github.com/ovokpus/analytics-engineering-prototype/blob/main/img/Architecture.png)

### Dimensional Modelling
#### What
A Dimensional Model is a denormalized Data Warehouse structure, optimized for faster retrieval of data. This is easy to understand and use, well suited for Data Warehouse and Business Intelligence Applications. It groups the data according to business categories. Dimensional modelling was pioneered by Ralph Kimball and the models are often referred to as `Star Schemas`
#### How - process
1. Select the Business Process: Operational activities performed by your organization.
2. Declare the grain: Establishing what a single row of data represents.
3. Identify dimensions: The 'who', 'what', 'when', 'why', and 'how' context of a business process.
4. Identify the facts: Measurements in numeric values that result from a business process.

---

### Physical Data Warehouse design and implementation
[!image](https://github.com/ovokpus/analytics-engineering-prototype/blob/main/img/ae-bootcamp-erd-physical.drawio.png)

---

#### Data Profiling
This is done to understand the data, as it relates to the business, ensure the Data Quality, and how it fits into the business logic. Here we:
1. Perform some exploratory analysis on the data to determine it's quality. For example, relational data should have unique and not null IDs. Queries like the one below are run for each relational table to find out total number of rows, and other high level summary statistics that help us understand the data better.
2. Create and utilize Business Matrices and mapping information.

```SQL
SELECT
  id as column_name,
  sum(case when id is null then 0 else 1 end) / cast(count(*) as numeric) as not_null_proportion,
  count(distinct id) / cast(count(*) as numeric) as distinct_proportion,
  count(distinct id) as distince_count,
  count(distinct id) = count(*) as is_unique,
  current_timestamp() as profiled_at
FROM `mlops-zoomcamp-360507.dl_northwind.customer`
group by column_name
order by column_name
```
---


## Final Implementation and next steps
Model is finally Implemented on dbt, with some technical implementation to follow in a later phase of this project.
1. dbt on BigQuery
2. Orchestration of Pipeline with Apache Airflow - locally and also with Google Cloud Composer
3. Automation of CI/CD builds within Google Cloud Platform

---

### dbt Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
