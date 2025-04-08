
-- 1. Create Table

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    price FLOAT
);

CREATE TABLE Inventory (
	inventory_id INTEGER PRIMARY KEY,
  	product_id INTEGER,
  	quantity INTEGER,
  	location TEXT NOT NULL,
  	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Orders (
	order_id INTEGER PRIMARY KEY, 
	customer_id INTEGER, 
	order_date TEXT NOT NULL
);

CREATE TABLE OrderDetails (
	order_detail_id INTEGER PRIMARY KEY, 
	order_id INTEGER, 
	product_id INTEGER,
	quantity INTEGER,
	FOREIGN KEY (order_id) REFERENCES Orders(order_id),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);



-- 2. Insert value into Products table

INSERT INTO Products (product_id, product_name, category, price)
VALUES (1, 'Laptop', 'Elektronik', 999.99);

INSERT INTO Products (product_id, product_name, category, price)
VALUES (2, 'Meja Kursi', 'Perabot', 199.99);

INSERT INTO Products (product_id, product_name, category, price)
VALUES (3, 'Printer', 'Elektronik', 299.99);

INSERT INTO Products (product_id, product_name, category, price)
VALUES (4, 'Rak Buku', 'Perabot', 149.99);



-- 3. Show product_name & price with Descending Order
SELECT product_name, price FROM Products
ORDER BY price DESC;



-- 4. Insert value into Inventory table

INSERT INTO Inventory (inventory_id, product_id, quantity, location) 
VALUES (1, 1, 50, 'Warehouse A');

INSERT INTO Inventory (inventory_id, product_id, quantity, location) 
VALUES (2, 2, 30, 'Warehouse B');

INSERT INTO Inventory (inventory_id, product_id, quantity, location) 
VALUES (3, 3, 20, 'Warehouse A');

INSERT INTO Inventory (inventory_id, product_id, quantity, location) 
VALUES (4, 4, 40, 'Warehouse B');
	


-- 5. Write query to show product_name, quantity & location

SELECT Products.product_name, 
	Inventory.quantity, 
    Inventory.location 
FROM Inventory 
Join Products ON Inventory.product_id = Products.product_id;



-- 6. Update Laptop's price
 
UPDATE Products SET price = 1099.99 WHERE product_name = 'Laptop';



-- 7. Make total_value collumn and grouping it based on Warehouse

SELECT Inventory.location, 
	SUM(Products.price * Inventory.quantity) AS total_price
FROM Inventory
JOIN Products ON Inventory.product_id = Products.product_id
GROUP BY Inventory.location;



-- 8. Insert some value into Orders & OrderDetails tables.

INSERT INTO Orders (order_id, customer_id, order_date) VALUES
	(1, 101, '2024-08-12'), (2, 102, '2024-08-13');

INSERT INTO OrderDetails(order_detail_id, order_id, product_id, quantity) VALUES
	(1, 1, 1, 2), (2, 1, 3, 1), (3, 2, 2, 1), (4, 2, 4, 2);



-- 9. Make total_amount collumn

SELECT Orders.order_id,
	Orders.order_date,
    SUM(OrderDetails.quantity * Products.price) AS total_amount
FROM OrderDetails
JOIN Orders ON OrderDetails.order_id = Orders.order_id
JOIN Products ON OrderDetails.product_id = Products.product_id
GROUP BY OrderDetails.order_id;



-- 10. Search some unordered products

SELECT Products.product_id,
	Products.product_name
FROM Products
JOIN OrderDetails ON OrderDetails.product_id = Products.product_id 
WHERE Products.product_id != OrderDetails.product_id;



-- 11. Shows the recent stock of the product

SELECT Products.product_name,
	Inventory.quantity,
    Inventory.location
FROM Products
JOIN Inventory ON Products.product_id = Inventory.product_id;