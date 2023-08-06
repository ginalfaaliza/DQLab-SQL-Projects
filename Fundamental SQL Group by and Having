# Tampilkan customer yang mendapatkan pinalty akibat telat bayar
SELECT customer_id, sum(pinalty) total_pinalty 
FROM invoice
GROUP BY customer_id
HAVING sum(pinalty) > 1;

# Mencari yang mengganti layanan
SELECT 
  a.Name,
  GROUP_CONCAT(c.product_name)
FROM customer a 
JOIN subscription b ON a.id = b.customer_id 
JOIN product c ON b.product_id = c.ID 
WHERE a.id IN(
  SELECT customer_id
  FROM subscription 
  GROUP BY customer_id 
  HAVING COUNT(customer_id) > 1)
GROUP BY 1;
