# Overview of Table
SELECT*FROM orders_1 limit 5;
SELECT*FROM orders_2 limit 5;
SELECT*FROM customer limit 5;

# Total sales and Revenue in the Quarter 1 and Quarter 2
--- Q1
SELECT
	SUM(quantity) AS total_penjualan, SUM(quantity*priceeach) AS revenue
FROM orders_1
WHERE status= "Shipped";
--- Q2
SELECT
	SUM(quantity) AS total_penjualan, SUM(quantity*priceeach) AS revenue
FROM orders_2
WHERE status= "Shipped";

# Precentage of Total Sales
SELECT 
	quarter,
	SUM(quantity) AS total_penjualan,
	SUM(quantity*priceeach) AS revenue
FROM(
  	SELECT orderNumber,status,quantity,priceeach,'1' AS quarter
	FROM orders_1
	WHERE status='Shipped'
UNION
	SELECT orderNumber,status,quantity,priceeach,'2' AS quarter
	FROM orders_2
	WHERE status='Shipped') AS tabel_a
GROUP BY quarter;

# Customers Growth
SELECT 
	quarter,
	COUNT(DISTINCT customerID) AS total_customers
FROM(SELECT
	 customerID,
	 createDate,
	 quarter(createDate) as quarter
FROM customer
WHERE createDate BETWEEN '2004-01-01' AND '2004-06-30'
)AS tabel_b
GROUP BY quarter;

# Customer Transactions Record
SELECT
	quarter,
	COUNT(DISTINCT customerID) AS total_customers
FROM(
  	SELECT customerID,createDate,quarter(createDate) AS quarter
	FROM customer
	WHERE createDate BETWEEN '2004-01-01'AND'2004-06-30')AS tabel_b
WHERE customerID IN(SELECT DISTINCT customerID FROM orders_1
UNION
SELECT DISTINCT customerID FROM orders_2)
GROUP BY quarter;

# The highest Category Product Sales
SELECT * 
FROM(SELECT 
  	categoryID, 
  	COUNT(DISTINCT orderNumber) AS total_order, 
  	SUM(quantity) AS total_penjualan 
     FROM (SELECT 
		productCode,
		orderNumber,
		quantity,status, 
		LEFT(productCode,3) AS categoryID
	   FROM orders_2
           WHERE status = "Shipped")c
     GROUP BY categoryID)b
ORDER BY total_order DESC;

