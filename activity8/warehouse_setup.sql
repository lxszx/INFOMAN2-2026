-- Customers
CREATE TABLE public.customers (
    id INT PRIMARY KEY,
    full_name TEXT NOT NULL,
    region_code TEXT
);

-- Products
CREATE TABLE public.products (
    id INT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT,
    unit_price NUMERIC(10,2)
);

-- Branches
CREATE TABLE public.branches (
    id INT PRIMARY KEY,
    branch_name TEXT NOT NULL,
    city TEXT,
    region TEXT
);

-- Sales Transactions
CREATE TABLE public.sales_txn (
    id INT PRIMARY KEY,
    txn_date DATE NOT NULL,
    customer_id INT NOT NULL REFERENCES public.customers(id),
    product_id INT NOT NULL REFERENCES public.products(id),
    branch_id INT NOT NULL REFERENCES public.branches(id),
    qty INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);


INSERT INTO public.customers(id, full_name, region_code) VALUES
(1, 'Alice Johnson', 'North'),
(2, 'Bob Smith', 'East'),
(3, 'Carol Lee', 'West'),
(4, 'David Kim', 'South'),
(5, 'Eva Brown', 'North');

INSERT INTO public.products(id, product_name, category, unit_price) VALUES
(1, 'Espresso', 'Coffee', 3.50),
(2, 'Latte', 'Coffee', 4.50),
(3, 'Cappuccino', 'Coffee', 4.00),
(4, 'Blueberry Muffin', 'Pastry', 2.75),
(5, 'Chocolate Croissant', 'Pastry', 3.25);

INSERT INTO public.branches(id, branch_name, city, region) VALUES
(1, 'Downtown Cafe', 'New York', 'North'),
(2, 'Riverside Cafe', 'Boston', 'East'),
(3, 'Central Cafe', 'Chicago', 'West'),
(4, 'Sunset Cafe', 'Miami', 'South');

INSERT INTO public.sales_txn(id, txn_date, customer_id, product_id, branch_id, qty, unit_price) VALUES
(1, '2026-03-01', 1, 1, 1, 2, 3.50),
(2, '2026-03-01', 2, 2, 2, 1, 4.50),
(3, '2026-03-02', 3, 3, 3, 3, 4.00),
(4, '2026-03-02', 4, 4, 4, 2, 2.75),
(5, '2026-03-03', 5, 5, 1, 1, 3.25),
(6, '2026-03-03', 1, 2, 1, 1, 4.50),
(7, '2026-03-04', 2, 3, 2, 2, 4.00),
(8, '2026-03-04', 3, 1, 3, 1, 3.50),
(9, '2026-03-05', 4, 5, 4, 3, 3.25),
(10,'2026-03-05', 5, 4, 1, 2, 2.75);


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

CREATE INDEX idx_fact_sales_date ON dw.fact_sales(date_key);
CREATE INDEX idx_fact_sales_branch ON dw.fact_sales(branch_key);