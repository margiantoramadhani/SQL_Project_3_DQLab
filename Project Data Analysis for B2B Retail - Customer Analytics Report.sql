# Memahami table

SELECT * FROM orders_1 LIMIT 5;
SELECT * FROM orders_2 LIMIT 5;
SELECT * FROM customer LIMIT 5;

# Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)

SELECT 
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceeach) AS revenue
FROM 
  orders_1
WHERE 
  status="shipped";
  
SELECT 
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceeach) AS revenue
FROM 
  orders_2
WHERE 
  status="shipped";

# Menghitung persentasi keseluruhan penjualan

SELECT 
  quarter, 
  SUM(quantity) AS total_penjualan,
  SUM(quantity*priceeach) AS revenue
FROM
  (SELECT ordernumber, status, quantity, priceeach, 1 AS quarter from orders_1
UNION
  SELECT ordernumber, status, quantity, priceeach, 2 AS quarter from orders_2) AS table_a
WHERE 
  status="shipped"
GROUP BY 
  quarter;

# Perhitungan Growth Penjualan dan Revenue
# %Growth Penjualan = (6717 – 8694)/8694 = -22%
# %Growth Revenue = (607548320 – 799579310)/ 799579310 = -24%

# Apakah jumlah customers xyz.com semakin bertambah?

SELECT 
  quarter, 
  count(distinct customerid) AS total_customers
FROM
  (SELECT customerid, createdate, quarter(createdate) AS quarter 
  FROM customer WHERE QUARTER(createdate) <= 2) AS table_b
GROUP BY quarter;

# Seberapa banyak customers tersebut yang sudah melakukan transaksi?

SELECT 
  quarter, 
  count(distinct customerid) AS total_customers 
FROM 
  (SELECT 
    customerid, 
    createdate, 
    quarter(createdate) AS quarter 
  FROM 
    customer
  WHERE 
    createdate between "2004-01-01" and "2004-06-30") AS table_b
WHERE 
  customerid 
  IN
    (SELECT DISTINCT customerid
    FROM
      orders_1
    UNION
    SELECT DISTINCT customerid
    FROM
      orders_2)
GROUP BY 
  quarter;

# Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?

SELECT 
  * 
FROM
  (SELECT 
    categoryid, 
    count(distinct ordernumber) AS total_order, 
    sum(quantity) AS total_penjualan
  FROM
    (SELECT productcode, 
      ordernumber, 
      quantity, 
      status,
      LEFT(productcode,3) AS categoryid 
    FROM 
      orders_2
    WHERE status="shipped") AS table_c
  GROUP BY categoryid) a
ORDER BY 
  total_order
DESC;


# Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?

#Menghitung total unik customers yang transaksi di quarter_1
SELECT 
  COUNT(DISTINCT customerID) AS total_customers 
FROM 
  orders_1;
#output = 25

SELECT
  1 as quarter, 
  (COUNT(DISTINCT customerid)/25*100) AS Q2 
FROM 
  orders_1 
WHERE 
  customerid 
  IN(SELECT DISTINCT customerid FROM orders_2);