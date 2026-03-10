# Activity 8 Answer Template

## Part 1: Star Schema Design

### 1. Fact Table Grain

The fact table is created with one row per **sales transaction**, identifiable by sales_txn.id.
Each record indicates a **product sale** to a consumer at a certain branch on a specified date.

### 2. Fact Measures

The fact table stores the following numerical measures:

**qty** – the number of units sold in the transaction

**unit_price** – the price per unit of the product

**total_amount** – the total value of the transaction, calculated as:

**total_amount** = qty * unit_price

### 3. Dimension Tables and Attributes

**dim_date**: date_key (PK), txn_date, year, quarter, month, day, weekday

**dim_customer**: customer_key (PK), source_id, full_name, region_code

**dim_product**: product_key (PK), source_id, product_name, category, unit_price 

**dim_branch**: branch_key (PK), source_id, branch_name, city, region

### 4. Relationship Summary

fact_sales.date_key → dim_date.date_key

fact_sales.customer_key → dim_customer.customer_key

fact_sales.product_key → dim_product.product_key

fact_sales.branch_key → dim_branch.branch_key

## Part 2: Warehouse DDL

```sql
CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE dw.dim_date (
    date_key SERIAL PRIMARY KEY,
    txn_date DATE UNIQUE,
    year INT,
    quarter INT,
    month INT,
    day INT,
    weekday INT
);

CREATE TABLE dw.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    source_id INT UNIQUE,
    full_name TEXT,
    region_code TEXT
);

CREATE TABLE dw.dim_product (
    product_key SERIAL PRIMARY KEY,
    source_id INT UNIQUE,
    product_name TEXT,
    category TEXT,
    unit_price NUMERIC(10,2)
);

CREATE TABLE dw.dim_branch (
    branch_key SERIAL PRIMARY KEY,
    source_id INT UNIQUE,
    branch_name TEXT,
    city TEXT,
    region TEXT
);

CREATE TABLE dw.fact_sales (
    sales_key SERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES dw.dim_date(date_key),
    customer_key INT NOT NULL REFERENCES dw.dim_customer(customer_key),
    product_key INT NOT NULL REFERENCES dw.dim_product(product_key),
    branch_key INT NOT NULL REFERENCES dw.dim_branch(branch_key),
    qty INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    source_id INT UNIQUE NOT NULL
);

CREATE TABLE dw.etl_log (
    run_ts TIMESTAMP DEFAULT NOW(),
    status TEXT,
    rows_loaded INT,
    error_message TEXT
);

CREATE INDEX idx_fact_sales_date 
    ON dw.fact_sales(date_key);

CREATE INDEX idx_fact_sales_branch 
    ON dw.fact_sales(branch_key);
```

## Part 3: ETL Procedure

### 1. Procedure Code

```sql
CREATE OR REPLACE PROCEDURE dw.run_sales_etl()
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_loaded INT := 0;
BEGIN

    INSERT INTO dw.dim_date(txn_date, year, quarter, month, day, weekday)
    SELECT DISTINCT 
        txn_date,
        EXTRACT(YEAR FROM txn_date)::INT,
        EXTRACT(QUARTER FROM txn_date)::INT,
        EXTRACT(MONTH FROM txn_date)::INT,
        EXTRACT(DAY FROM txn_date)::INT,
        EXTRACT(DOW FROM txn_date)::INT
    FROM public.sales_txn s
    ON CONFLICT (txn_date) DO NOTHING;

    INSERT INTO dw.dim_customer(source_id, full_name, region_code)
    SELECT 
        id,
        full_name,
        region_code
    FROM public.customers
    ON CONFLICT (source_id) DO UPDATE
        SET full_name = EXCLUDED.full_name,
            region_code = EXCLUDED.region_code;

    INSERT INTO dw.dim_product(source_id, product_name, category, unit_price)
    SELECT 
        id,
        product_name,
        category,
        unit_price
    FROM public.products
    ON CONFLICT (source_id) DO UPDATE
        SET product_name = EXCLUDED.product_name,
            category = EXCLUDED.category,
            unit_price = EXCLUDED.unit_price;

    INSERT INTO dw.dim_branch(source_id, branch_name, city, region)
    SELECT 
        id,
        branch_name,
        city,
        region
    FROM public.branches
    ON CONFLICT (source_id) DO UPDATE
        SET branch_name = EXCLUDED.branch_name,
            city = EXCLUDED.city,
            region = EXCLUDED.region;

    INSERT INTO dw.fact_sales(
        date_key,
        customer_key,
        product_key,
        branch_key,
        qty,
        unit_price,
        total_amount,
        source_id
    )
    SELECT 
        d.date_key,
        c.customer_key,
        p.product_key,
        b.branch_key,
        s.qty,
        s.unit_price,
        s.qty * s.unit_price,
        s.id
    FROM public.sales_txn s
    JOIN dw.dim_date d 
        ON s.txn_date = d.txn_date
    JOIN dw.dim_customer c 
        ON s.customer_id = c.source_id
    JOIN dw.dim_product p 
        ON s.product_id = p.source_id
    JOIN dw.dim_branch b 
        ON s.branch_id = b.source_id
    WHERE s.id NOT IN (SELECT source_id FROM dw.fact_sales)
      AND s.qty > 0
      AND s.unit_price > 0;

    GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;

    INSERT INTO dw.etl_log(status, rows_loaded)
    VALUES ('SUCCESS', v_rows_loaded);

EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO dw.etl_log(status, rows_loaded, error_message)
        VALUES ('FAIL', 0, SQLERRM);

END;
$$;
```

### 2. Procedure Execution

![](/activity8/images/image2.png)

### 3. ETL Log Output

![](/activity8/images/image1.png)

## Part 4: Analytical Queries

### Query 1: Monthly Revenue by Branch Region

```sql
SELECT
    d.year,
    d.month,
    b.region,
    SUM(f.total_amount) AS monthly_revenue
FROM dw.fact_sales f
JOIN dw.dim_date d 
    ON f.date_key = d.date_key
JOIN dw.dim_branch b 
    ON f.branch_key = b.branch_key
GROUP BY 
    d.year, 
    d.month, 
    b.region
ORDER BY 
    d.year, 
    d.month;
```

Interpretation: This query returns the total sales income earned by region for each month. Management may use this data to evaluate which sites perform best over time.


### Query 2: Top 5 Products by Total Revenue

```sql
SELECT
    p.product_name,
    SUM(f.total_amount) AS total_revenue
FROM dw.fact_sales f
JOIN dw.dim_product p 
    ON f.product_key = p.product_key
GROUP BY 
    p.product_name
ORDER BY 
    total_revenue DESC
LIMIT 5;
```

Interpretation: This query finds the five goods that generate the most money. It assists management in selecting the most profitable menu items.

### Query 3: Customer Region Contribution to Sales

```sql
SELECT
    c.region_code,
    SUM(f.total_amount) AS region_sales
FROM dw.fact_sales f
JOIN dw.dim_customer c 
    ON f.customer_key = c.customer_key
GROUP BY 
    c.region_code
ORDER BY 
    region_sales DESC;
```

Interpretation: This query displays the total income generated by each client area. It assists the organization in determining which regions contribute the most to overall sales.