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

