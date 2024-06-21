# Overview tables

SELECT*FROM orders_1 limit 5;
SELECT*FROM orders_2 limit 5;
SELECT*FROM customer limit 5;

# Total Penjualan dan Revenue pada Quarter 1 (Jan, Feb, Mar) dan Quarter 2 (Apr, Mei, Jun)

--- Quater 1
SELECT
	SUM(quantity) AS total_penjualan,
	SUM(quantity*priceeach) AS revenue
FROM orders_1
WHERE status="Shipped";

--- Quater 2
SELECT
	SUM(quantity) AS total_penjualan,
	SUM(quantity*priceeach) AS revenue
FROM orders_2
WHERE status="Shipped";

# Menghitung persentasi keseluruhan penjualan 

SELECT 
	quarter,
	SUM(quantity) AS total_penjualan,
	SUM(quantity*priceeach) AS revenue
FROM (SELECT orderNumber,status,quantity,priceeach,'1' AS quarter 
	FROM orders_1
	WHERE status='Shipped'
        UNION
	SELECT orderNumber,status,quantity,priceeach,'2' AS quarter
	FROM orders_2
	WHERE status='Shipped') AS tabel_a
GROUP BY quarter;

# Apakah jumlah customer xyz.com semakin bertambah?

SELECT quarter, COUNT(DISTINCT customerID) AS total_customers
FROM(SELECT
	 customerID,
	 createDate,
	 quarter(createDate) as quarter
FROM customer
WHERE createDate BETWEEN '2004-01-01' AND '2004-06-30'
) AS tabel_b
GROUP BY quarter;

# Seberapa banyak customer yang sudah melakukan transaksi?

SELECT quarter,COUNT(DISTINCT customerID) AS total_customers
FROM(SELECT customerID, createDate, quarter(createDate) AS quarter 
	FROM customer
	WHERE createDate BETWEEN '2004-01-01'AND'2004-06-30') AS tabel_b
WHERE customerID IN(
	SELECT DISTINCT customerID FROM orders_1
	UNION
	SELECT DISTINCT customerID FROM orders_2)
GROUP BY quarter;

#Category produk apa saja yang paling banyak di order oleh customers di quarter 2

SELECT * 
FROM (
SELECT categoryID, COUNT(DISTINCT orderNumber) AS total_order, SUM(quantity) AS total_penjualan 
      FROM ( 
       SELECT productCode, orderNumber, quantity,status, 
       LEFT(productCode,3) AS categoryID
	FROM orders_2
	WHERE status = "Shipped") tabel_c
	GROUP BY categoryID ) tabel_c
ORDER BY total_order DESC;

# Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertama
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;

SELECT "1" as quarter, (COUNT(DISTINCT customerID)*100)/25 as Q2
FROM orders_1
WHERE customerID IN(SELECT DISTINCT customerID FROM orders_2);


					













