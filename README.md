# E-Commerce ELT Pipeline using Fivetran, BigQuery and dbt

📌 Project Overview -- ECOMMERCE_SALES 

This project demonstrates an end-to-end **ELT (Extract, Load, Transform) data pipeline** using:

* **Google Sheets** as the source system
* **Fivetran** for automated data ingestion
* **Google BigQuery** as the cloud data warehouse
* **dbt (Data Build Tool)** for data transformation, modeling, and data quality testing

The project simulates an e-commerce business where customer, product, and order information is maintained in Google Sheets.

The data is first loaded into BigQuery using Fivetran and then transformed using dbt into clean staging models and business-ready dimensional models.

---

# 🏗️ Architecture

```text
                   Google Sheets
                        │
                        │
                        ▼
                    Fivetran
                        │
                        │ Automated Ingestion
                        ▼
                  Google BigQuery
                        │
                ┌───────┴────────┐
                │                │
                ▼                ▼
          ecommerce_raw     Raw Tables
          ├── customers
          ├── products
          └── orders
                │
                │ dbt source()
                ▼
             dbt Staging
          ├── stg_customers
          ├── stg_products
          └── stg_orders
                │
                │ dbt ref()
                ▼
             dbt Marts
          ├── dim_customers
          ├── dim_products
          └── fct_orders
                │
                ▼
        ecommerce_analytics
```

---

# 🎯 Project Objectives

The main objectives of this project are:

1. Extract data from Google Sheets.
2. Load the data automatically into BigQuery using Fivetran.
3. Maintain raw/source data separately from transformed data.
4. Use dbt to build a staging layer.
5. Clean and standardize source data.
6. Create dimension and fact tables.
7. Apply business transformations.
8. Establish relationships between customers, products, and orders.
9. Add data quality tests.
10. Build a reusable and scalable ELT architecture.

---

# 🛠️ Technologies Used

| Technology      | Purpose                           |
| --------------- | --------------------------------- |
| Google Sheets   | Source data                       |
| Fivetran        | Data ingestion                    |
| Google BigQuery | Data warehouse                    |
| dbt             | Transformation and testing        |
| SQL             | Data transformation               |
| GitHub          | Version control and documentation |

---

# 📂 Source Data

The project contains three source tables.

## 1. Customers

| customer_id | customer_name | email                                       | city        | country | signup_date |
| ----------: | ------------- | ------------------------------------------- | ----------- | ------- | ----------- |
|         101 | Shruti        | [shruti@gmail.com](mailto:shruti@gmail.com) | Bhubaneswar | India   | 2025-01-10  |
|         102 | Rahul         | [rahul@gmail.com](mailto:rahul@gmail.com)   | Bangalore   | India   | 2025-02-15  |
|         103 | Priya         | [priya@gmail.com](mailto:priya@gmail.com)   | Mumbai      | India   | 2025-03-20  |
|         104 | John          | [john@gmail.com](mailto:john@gmail.com)     | London      | UK      | 2025-04-10  |
|         105 | Sarah         | [sarah@gmail.com](mailto:sarah@gmail.com)   | New York    | USA     | 2025-05-05  |

---

## 2. Products

| product_id | product_name | category    | price |
| ---------: | ------------ | ----------- | ----: |
|          1 | Laptop       | Electronics | 70000 |
|          2 | Mouse        | Electronics |  1200 |
|          3 | Keyboard     | Electronics |  2500 |
|          4 | Office Chair | Furniture   |  8000 |
|          5 | Desk         | Furniture   | 12000 |

---

## 3. Orders

| order_id | customer_id | product_id | order_date | quantity | amount | status    |
| -------: | ----------: | ---------: | ---------- | -------: | -----: | --------- |
|     5001 |         101 |          1 | 2026-09-01 |        1 |  70000 | Completed |
|     5002 |         102 |          2 | 2026-09-01 |        2 |   2400 | Completed |
|     5003 |         101 |          4 | 2026-09-02 |        1 |   8000 | Completed |
|     5004 |         103 |          3 | 2026-09-02 |        1 |   2500 | Cancelled |
|     5005 |         104 |          5 | 2026-09-03 |        1 |  12000 | Completed |
|     5006 |         105 |          1 | 2026-09-03 |        1 |  70000 | Completed |

---

# 🚀 Step 1: Create Google Sheets Source

Three Google Sheets were created to represent the source systems:

```text
customers
products
orders
```

The sheets contain the customer, product, and order data described above.

Google Sheets was selected as the source because it is simple to maintain and is commonly used as a lightweight source system for small business datasets.

---

# 🚀 Step 2: Create BigQuery Project

A Google Cloud project was created for the project.

### Project ID

```text
fivetranlearning02
```

BigQuery was selected as the target data warehouse.

---

# 🚀 Step 3: Create Raw Dataset

A BigQuery dataset was created:

```text
ecommerce_raw
```

This dataset is used to store the data ingested by Fivetran.

The raw layer contains:

```text
ecommerce_raw
├── customers
├── products
└── orders
```

The raw layer is intentionally kept separate from the transformed data.

---

# 🚀 Step 4: Configure Fivetran

Fivetran was used to create an automated pipeline from Google Sheets to BigQuery.

### Source

```text
Google Sheets
```

### Destination

```text
Google BigQuery
```

### Raw Dataset

```text
ecommerce_raw
```

Fivetran handles the extraction and loading process.

The resulting architecture is:

```text
Google Sheets
      ↓
   Fivetran
      ↓
BigQuery ecommerce_raw
```

---

# 🚀 Step 5: Verify Fivetran Data in BigQuery

After the Fivetran connection was successfully configured, the raw tables were verified in BigQuery.

The tables were:

```text
fivetranlearning02.ecommerce_raw.customers
fivetranlearning02.ecommerce_raw.products
fivetranlearning02.ecommerce_raw.orders
```

Example BigQuery query:

```sql
SELECT *
FROM `fivetranlearning02.ecommerce_raw.customers`;
```

This confirmed that the source data had successfully reached BigQuery.

---

# 🚀 Step 6: Create Analytics Dataset

A separate BigQuery dataset was created for dbt transformations:

```text
ecommerce_analytics
```

The reason for creating a separate dataset is to keep raw data and transformed data separate.

### Raw Layer

```text
ecommerce_raw
```

Contains Fivetran-managed source data.

### Analytics Layer

```text
ecommerce_analytics
```

Contains dbt-managed transformed models.

Final structure:

```text
BigQuery
│
├── ecommerce_raw
│   ├── customers
│   ├── products
│   └── orders
│
└── ecommerce_analytics
    ├── staging models
    └── mart models
```

---

# 🚀 Step 7: Create dbt Project

A dbt project was created with the name:

```text
ecommerce_sales
```

The project is responsible for transforming the raw BigQuery data.

The dbt project uses BigQuery as its warehouse.

---

# 🚀 Step 8: Configure dbt BigQuery Connection

The dbt connection was configured to use:

```text
Project:
fivetranlearning02

Target Dataset:
ecommerce_analytics
```

The target dataset is important because dbt will create its models inside this dataset.

The raw dataset remains:

```text
ecommerce_raw
```

and is referenced using dbt `source()`.

---

# 🚀 Step 9: Define dbt Sources

A `sources.yml` file was created:

```text
models/
└── staging/
    └── sources.yml
```

The source configuration tells dbt where the raw Fivetran tables are located.

```yaml
version: 2

sources:
  - name: ecommerce_raw
    database: fivetranlearning02
    schema: ecommerce_raw

    tables:
      - name: customers
      - name: products
      - name: orders
```

This allows the raw tables to be referenced using:

```sql
{{ source("ecommerce_raw", "customers") }}
```

instead of hardcoding the BigQuery table name.

---

# 🚀 Step 10: Understand `source()` in dbt

The `source()` function is used to reference tables that exist outside the dbt model layer.

For example:

```sql
SELECT *
FROM {{ source("ecommerce_raw", "customers") }}
```

dbt resolves this to:

```text
fivetranlearning02.ecommerce_raw.customers
```

The same concept is used for:

```sql
{{ source("ecommerce_raw", "products") }}
```

and:

```sql
{{ source("ecommerce_raw", "orders") }}
```

---

# 🚀 Step 11: Create Staging Layer

The staging layer performs basic cleaning and standardization.

The staging models are:

```text
models/
└── staging/
    ├── sources.yml
    ├── stg_customers.sql
    ├── stg_products.sql
    └── stg_orders.sql
```

---

# 🚀 Step 12: Create `stg_customers`

File:

```text
models/staging/stg_customers.sql
```

SQL:

```sql
SELECT
    customer_id,
    TRIM(customer_name) AS customer_name,
    LOWER(TRIM(email)) AS email,
    TRIM(city) AS city,
    TRIM(country) AS country,
    CAST(signup_date AS DATE) AS signup_date

FROM {{ source("ecommerce_raw", "customers") }}
```

### Transformations

The following transformations were applied:

* Removed unwanted spaces using `TRIM()`.
* Standardized email addresses using `LOWER()`.
* Converted `signup_date` into a proper `DATE`.
* Standardized text fields.

---

# 🚀 Step 13: Create `stg_products`

File:

```text
models/staging/stg_products.sql
```

SQL:

```sql
SELECT
    product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    CAST(price AS NUMERIC) AS price

FROM {{ source("ecommerce_raw", "products") }}
```

### Transformations

* Removed unwanted spaces from product names.
* Removed unwanted spaces from categories.
* Converted price to a numeric data type.

---

# 🚀 Step 14: Create `stg_orders`

File:

```text
models/staging/stg_orders.sql
```

SQL:

```sql
SELECT
    order_id,
    customer_id,
    product_id,
    CAST(order_date AS DATE) AS order_date,
    CAST(quantity AS INT64) AS quantity,
    CAST(amount AS NUMERIC) AS amount,
    TRIM(status) AS status

FROM {{ source("ecommerce_raw", "orders") }}
```

### Transformations

* Converted order date into a DATE.
* Converted quantity into an integer.
* Converted amount into NUMERIC.
* Removed unwanted spaces from status.

---

# 🚀 Step 15: Create dbt Marts Layer

After creating the staging layer, a marts layer was created for business-ready data.

Structure:

```text
models/
├── staging/
│   ├── sources.yml
│   ├── stg_customers.sql
│   ├── stg_products.sql
│   └── stg_orders.sql
│
└── marts/
    ├── dim_customers.sql
    ├── dim_products.sql
    └── fct_orders.sql
```

The marts layer contains:

* Dimension tables
* Fact tables
* Business transformations

---

# 🚀 Step 16: Create Customer Dimension

File:

```text
models/marts/dim_customers.sql
```

The customer dimension transforms the staging customer data into a business-friendly dimension.

Key transformations include:

### Country standardization

```sql
CASE
    WHEN UPPER(country) = 'UK'
        THEN 'United Kingdom'
    WHEN UPPER(country) = 'USA'
        THEN 'United States'
    WHEN UPPER(country) = 'INDIA'
        THEN 'India'
    ELSE country
END AS country
```

### Signup year

```sql
EXTRACT(YEAR FROM signup_date) AS signup_year
```

### Signup month

```sql
EXTRACT(MONTH FROM signup_date) AS signup_month
```

### Region

```sql
CASE
    WHEN UPPER(country) = 'INDIA'
        THEN 'APAC'
    WHEN UPPER(country) = 'UK'
        THEN 'Europe'
    WHEN UPPER(country) = 'USA'
        THEN 'North America'
    ELSE 'Other'
END AS region
```

### Customer tenure

```sql
DATE_DIFF(
    CURRENT_DATE(),
    signup_date,
    MONTH
) AS customer_tenure_months
```

The model uses:

```sql
{{ ref('stg_customers') }}
```

The `ref()` function creates a dependency between the staging and mart models.

---

# 🚀 Step 17: Create Product Dimension

File:

```text
models/marts/dim_products.sql
```

Business transformations were applied to the product data.

### Price category

```sql
CASE
    WHEN price >= 50000 THEN 'Premium'
    WHEN price >= 10000 THEN 'Mid-Range'
    ELSE 'Budget'
END AS price_category
```

### Category grouping

```sql
CASE
    WHEN category = 'Electronics' THEN 'Technology'
    WHEN category = 'Furniture' THEN 'Home & Office'
    ELSE 'Other'
END AS category_group
```

The resulting table provides additional business classifications for products.

---

# 🚀 Step 18: Create Orders Fact Table

File:

```text
models/marts/fct_orders.sql
```

The orders fact table combines:

```text
stg_orders
     +
dim_customers
     +
dim_products
```

The models are joined using:

```sql
LEFT JOIN {{ ref('dim_customers') }} c
    ON o.customer_id = c.customer_id

LEFT JOIN {{ ref('dim_products') }} p
    ON o.product_id = p.product_id
```

The fact table contains information such as:

* Order ID
* Order date
* Customer information
* Product information
* Quantity
* Amount
* Order status
* Completed amount

---

# 🚀 Step 19: Create Completed Amount

A business transformation was created to calculate revenue from completed orders.

```sql
CASE
    WHEN o.status = 'Completed'
        THEN o.amount
    ELSE 0
END AS completed_amount
```

This ensures that cancelled orders do not contribute to completed sales.

For example:

```text
Order 5001
Amount = 70000
Status = Completed

Completed Amount = 70000
```

While:

```text
Order 5004
Amount = 2500
Status = Cancelled

Completed Amount = 0
```

---

# 🚀 Step 20: Configure dbt Materializations

The dbt project was configured so that staging models are created as views and mart models are created as tables.

Example:

```yaml
models:
  ecommerce_sales:

    staging:
      +materialized: view

    marts:
      +materialized: table
```

This means:

```text
staging
    ↓
Views

marts
    ↓
Tables
```

This approach keeps the staging layer lightweight while creating physical tables for business-ready models.

---

# 🚀 Step 21: Build dbt Models

The dbt models were executed using:

```bash
dbt run --select stg_customers
```

Similarly:

```bash
dbt run --select stg_products
```

```bash
dbt run --select stg_orders
```

and:

```bash
dbt run --select dim_customers
```

```bash
dbt run --select dim_products
```

```bash
dbt run --select fct_orders
```

dbt executes the SQL models and creates the corresponding views/tables in BigQuery.

---

# 🚀 Step 22: Use `ref()` for Model Dependencies

Instead of directly referencing physical BigQuery tables, dbt models use:

```sql
{{ ref('stg_customers') }}
```

and:

```sql
{{ ref('dim_customers') }}
```

This allows dbt to understand the dependency graph.

For example:

```text
customers
    ↓
stg_customers
    ↓
dim_customers
    ↓
fct_orders
```

Similarly:

```text
products
    ↓
stg_products
    ↓
dim_products
    ↓
fct_orders
```
<img width="545" height="250" alt="image" src="https://github.com/user-attachments/assets/99b1bdbb-8332-4a98-9b0b-49dcf6091abe" />

---

# 🚀 Step 23: Data Quality Testing

dbt tests were added to validate the data.

Example:

```yaml
version: 2

models:

  - name: stg_customers
    columns:
      - name: customer_id
        tests:
          - not_null
          - unique

  - name: stg_products
    columns:
      - name: product_id
        tests:
          - not_null
          - unique

  - name: stg_orders
    columns:
      - name: order_id
        tests:
          - not_null
          - unique
```

These tests verify that primary identifiers are:

* Not NULL
* Unique

---

# 🚀 Step 24: Relationship Tests

Relationships between orders, customers, and products were also validated.

For example:

```yaml
- name: customer_id
  tests:
    - not_null
    - relationships:
        to: ref('stg_customers')
        field: customer_id
```

This validates that every customer referenced by an order exists in the customer table.

Similarly:

```yaml
- name: product_id
  tests:
    - not_null
    - relationships:
        to: ref('stg_products')
        field: product_id
```

This validates the product relationship.

---

# 🚀 Step 25: Run dbt Build

After creating the models and tests, the complete pipeline can be executed using:

```bash
dbt build
```

`dbt build` can execute models and their associated tests according to their dependencies.

The expected flow is:

```text
Source
  ↓
Staging Models
  ↓
Dimension Models
  ↓
Fact Models
  ↓
Data Quality Tests
```

---

# 📊 Final Data Model

The final warehouse structure is:

```text
fivetranlearning02
│
├── ecommerce_raw
│   ├── customers
│   ├── products
│   └── orders
│
└── ecommerce_analytics
    │
    ├── stg_customers
    ├── stg_products
    ├── stg_orders
    │
    ├── dim_customers
    ├── dim_products
    └── fct_orders
```

---

# 🔄 End-to-End Data Flow

```text
                         SOURCE
                           │
                           ▼
                    ┌─────────────┐
                    │Google Sheets│
                    └──────┬──────┘
                           │
                           ▼
                       Fivetran
                           │
                           ▼
                    ┌─────────────┐
                    │  BigQuery   │
                    │ Raw Dataset │
                    └──────┬──────┘
                           │
             ┌─────────────┼─────────────┐
             ▼             ▼             ▼
         customers      products       orders
             │             │             │
             └─────────────┼─────────────┘
                           │
                       dbt source()
                           │
                           ▼
                    ┌─────────────┐
                    │   STAGING   │
                    ├─────────────┤
                    │stg_customers│
                    │stg_products │
                    │stg_orders   │
                    └──────┬──────┘
                           │
                       dbt ref()
                           │
                           ▼
                    ┌─────────────┐
                    │    MARTS    │
                    ├─────────────┤
                    │dim_customers│
                    │dim_products │
                    │fct_orders   │
                    └──────┬──────┘
                           │
                           ▼
                  Business-ready data
```

---

# 📚 Key Concepts Demonstrated

This project demonstrates practical knowledge of:

### Fivetran

* Source connection
* Destination connection
* Automated data ingestion
* Raw data loading

### BigQuery

* Dataset creation
* Raw data storage
* Analytics dataset
* SQL querying
* Warehouse organization

### dbt

* dbt project setup
* BigQuery connection
* Sources
* `source()`
* `ref()`
* Staging models
* Mart models
* Views
* Tables
* Fact tables
* Dimension tables
* Model dependencies
* Data quality tests
* Relationship tests
* `dbt run`
* `dbt build`

### SQL

* `SELECT`
* `TRIM`
* `LOWER`
* `UPPER`
* `CAST`
* `CASE`
* `EXTRA



### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
