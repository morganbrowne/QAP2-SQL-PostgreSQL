--Scenario:
--You are developing a system to manage products, customers, and their orders in an online store.


-- =====================
-- Create all tables: 

-- Create products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0)
);

-- Create customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Create orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
        ON DELETE CASCADE
);

-- Create order items table
CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE
);

--===============================
-- Insert Data into tables: 

-- Insert data into products table
INSERT INTO products (product_name, price, stock_quantity)
VALUES 
    ('Engine Oil', 35.99, 35),
    ('Windsheild Wipers', 20.99, 45),
    ('Clay Bar', 7.99, 60),
    ('Shop Towel', 10.99, 50),
    ('Spray Bottle', 8.99, 25);



-- Insert data into customers table...
INSERT INTO customers (first_name, last_name, email)
VALUES 
    ('Paul', 'Walker', 'paul.walker@example.com'),
    ('Ken', 'Block', 'ken.block@example.com'),
    ('Doc', 'Hudson', 'doc.hudson@example.com'),
    ('Lewis', 'Hamilton', 'lewis.hamilton@example.com');


INSERT INTO orders (customer_id, order_date)
VALUES 
    (1, '2024-10-10'), 
    (2, '2024-10-11'), 
    (1, '2024-10-11'), 
    (3, '2024-10-12'), 
    (4, '2024-10-13');

-- Insert Data into orders items table... 

INSERT INTO order_items (order_id, product_id, quantity)
VALUES 
    -- This is the first order with 2 bottles of engine oil and 1 windsheild wiper..
    (1, 1, 2),
    (1, 2, 1), 

    -- Second Order with 1 clay bar and 3 shop towels...
    (2, 3, 1), 
    (2, 4, 3), 

    -- Third order with 1 spray bottle and 1 bottle of engine oil... 
    (3, 5, 1), 
    (3, 1, 1), 

   -- Fourth order with 2 windsheild wipers and 1 clay bar... 
    (4, 2, 2), 
    (4, 3, 1), 

    -- Fifth order with 2 shop towels and 1 spray bottle... 
    (5, 4, 2),
    (5, 5, 1);



--===================
-- SQL Queires:

-- 1: Gather names and stock quantities... 

SELECT product_name, stock_quantity
FROM products;

-- 2: Gather the product name and quantities of an oder that has been placed... 

SELECT p.product_name, oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 2;

-- 3: Get every order palced by one person... 

SELECT o.id AS order_id, o.order_date, oi.product_id, oi.quantity
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.customer_id = 1
ORDER BY o.order_date;


--==========================

-- Update Data: Perform an update to simulate the reducing of stock quantities of items after a customer places an order. Please describe or indicate which order you are simulating the reducton for...

-- Update stock for id 5 (sray bottle)
UPDATE products
SET stock_quantity = stock_quantity - 2
WHERE id = 5;

-- Update stock for id 1 (Engine Oil)
UPDATE products
SET stock_quantity = stock_quantity - 3
WHERE id = 1;

-- Delete Data... 

-- Remove one of the orders and associated order items... 
-- Delete Order ID 4 and its order items
DELETE FROM orders
WHERE id = 4;

-- How to verify the order hac been deleted...
-- Check if Order ID 4 exists in orders table
SELECT * FROM orders WHERE id = 4;

-- Check if Order ID 4 exists in order_items table
SELECT * FROM order_items WHERE order_id = 4;




