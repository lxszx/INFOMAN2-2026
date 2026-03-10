```sql
CREATE TABLE customers (
    id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    region_code VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE branches (
    id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

CREATE TABLE sales_txn (
    id INT PRIMARY KEY,
    txn_date DATE NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    branch_id INT NOT NULL,
    qty INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

INSERT INTO customers (id, full_name, region_code) VALUES
(1,'Juan Dela Cruz','NCR'),
(2,'Maria Santos','CAR'),
(3,'Pedro Reyes','Region I'),
(4,'Ana Lopez','Region II'),
(5,'Carlos Mendoza','Region III');

INSERT INTO products (id, product_name, category, unit_price) VALUES
(1,'Caffe Latte','Hot Coffee',150.00),
(2,'Cappuccino','Hot Coffee',145.00),
(3,'Caramel Macchiato','Hot Coffee',165.00),
(4,'Iced Americano','Cold Coffee',130.00),
(5,'Mocha Frappuccino','Blended',175.00);

INSERT INTO branches (id, branch_name, city, region) VALUES
(1,'SM Baguio Branch','Baguio','CAR'),
(2,'Session Road Branch','Baguio','CAR'),
(3,'SM Manila Branch','Manila','NCR');

INSERT INTO sales_txn (id, txn_date, customer_id, product_id, branch_id, qty, unit_price) VALUES
(1,'2026-03-01',1,1,1,2,150),
(2,'2026-03-01',2,2,1,1,145),
(3,'2026-03-01',3,3,2,1,165),
(4,'2026-03-02',4,4,2,3,130),
(5,'2026-03-02',5,5,3,2,175),
(6,'2026-03-03',1,3,1,1,165),
(7,'2026-03-03',2,1,2,2,150),
(8,'2026-03-03',3,2,3,1,145),
(9,'2026-03-04',4,5,1,2,175),
(10,'2026-03-04',5,4,2,1,130),
(11,'2026-03-05',1,2,3,3,145),
(12,'2026-03-05',2,3,1,2,165),
(13,'2026-03-06',3,4,2,2,130),
(14,'2026-03-06',4,1,3,1,150),
(15,'2026-03-07',5,5,1,2,175),
(16,'2026-03-07',1,4,2,1,130),
(17,'2026-03-08',2,2,3,2,145),
(18,'2026-03-08',3,3,1,1,165),
(19,'2026-03-09',4,1,2,2,150),
(20,'2026-03-09',5,5,3,1,175);
