#### Project Data Analysis for B2B Retail: Customer Analytics Report
Source : https://academy.dqlab.id/main/package/project/246?pf=0

----

#### Memahami table
Sebelum memulai menyusun query SQL dan membuat Analisa dari hasil query, hal pertama yang perlu dilakukan adalah menjadi familiar dengan tabel yang akan digunakan. Hal ini akan sangat berguna dalam menentukan kolom mana sekiranya berkaitan dengan problem yang akan dianalisa, dan proses manipulasi data apa yang sekiranya perlu dilakukan untuk kolom – kolom tersebut, karena tidak semua kolom pada tabel perlu untuk digunakan.</br>
</br>
Mengecek tabel orders_1 :SELECT * FROM orders_1 limit 5;</br>
Mengecek tabel orders_2 :SELECT * FROM orders_2 limit 5;</br>
Mengecek tabel customer :SELECT * FROM customer limit 5;

```sql
SELECT * FROM orders_1 LIMIT 5;
SELECT * FROM orders_2 LIMIT 5;
SELECT * FROM customer LIMIT 5;
```

<details>
<summary markdown="span">orders_1</summary>

| orderNumber | orderDate  | requiredDate | shippedDate | status  | customerID | productCode | quantity | priceeach |
|-------------|------------|--------------|-------------|---------|------------|-------------|----------|-----------|
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S72_1253    |       40 |     45690 |
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S700_2047   |       29 |     83280 |
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S24_3816    |       31 |     78830 |
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S24_3420    |       25 |     65090 |
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S24_2841    |       44 |     67140 |

</details>

<details>
<summary markdown="span">orders_2</summary>

| orderNumber | orderDate  | requiredDate | shippedDate | status  | customerID | productCode | quantity | priceeach |
|-------------|------------|--------------|-------------|---------|------------|-------------|----------|-----------|
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S18_2581    |       24 |     81950 |
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S24_1785    |       23 |     89720 |
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S24_3949    |       33 |     55270 |
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S24_4278    |       40 |     63030 |
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S32_1374    |       41 |     90900 |

</details>

<details>
<summary markdown="span">customer</summary>

| customerID | customerName               | contactLastName | contactFirstName | city      | country   | createDate |
|------------|----------------------------|-----------------|------------------|-----------|-----------|------------|
|        103 | Atelier graphique          | Schmitt         | Carine           | Nantes    | France    | 2004-02-05 |
|        112 | Signal Gift Stores         | King            | Jean             | Las Vegas | USA       | 2004-02-05 |
|        114 | Australian Collectors, Co. | Ferguson        | Peter            | Melbourne | Australia | 2004-02-20 |
|        119 | La Rochelle Gifts          | Labrune         | Janine           | Nantes    | France    | 2004-02-05 |
|        121 | Baane Mini Imports         | Bergulfsen      | Jonas            | Stavern   | Norway    | 2004-02-05 |

</details>

----

#### Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)
Dari tabel orders_1 lakukan penjumlahan pada kolom quantity dengan fungsi aggregate sum() dan beri nama “total_penjualan”, kalikan kolom quantity dengan kolom priceEach kemudian jumlahkan hasil perkalian kedua kolom tersebut dan beri nama “revenue”</br>
</br>
Perusahaan hanya ingin menghitung penjualan dari produk yang terkirim saja, jadi kita perlu mem-filter kolom ‘status’ sehingga hanya menampilkan order dengan status “Shipped”.</br>
</br>
Lakukan Langkah 1 & 2, untuk tabel orders_2.</br>

```sql
select 
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceeach) AS revenue
FROM 
  orders_1
WHERE 
  status="shipped";
```

<details>
<summary markdown="span">OUTPUT :</summary>
  
| total_penjualan | revenue   |
|-----------------|-----------|
|            8694 | 799579310 |

</details>

```sql
select 
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceeach) AS revenue
FROM 
  orders_2
WHERE 
  status="shipped";
```
  
<details>
<summary markdown="span">OUTPUT :</summary>

| total_penjualan | revenue   |
|-----------------|-----------|
|            6717 | 607548320 |

</details>

----

#### Menghitung persentasi keseluruhan penjualan
Kedua tabel orders_1 dan orders_2 masih terpisah, untuk menghitung persentasi keseluruhan penjualan dari kedua tabel tersebut perlu digabungkan :</br>
1. Pilihlah kolom “orderNumber”, “status”, “quantity”, “priceEach” pada tabel orders_1, dan tambahkan kolom baru dengan nama “quarter” dan isi dengan value “1”. Lakukan yang sama dengan tabel orders_2, dan isi dengan value “2”, kemudian gabungkan kedua tabel tersebut.</br>
2. Gunakan statement dari Langkah 1 sebagai subquery dan beri alias “tabel_a”.</br>
3. Dari “tabel_a”, lakukan penjumlahan pada kolom “quantity” dengan fungsi aggregate sum() dan beri nama “total_penjualan”, dan kalikan kolom quantity dengan kolom priceEach kemudian jumlahkan hasil perkalian kedua kolom tersebut dan beri nama “revenue”</br>
4. Filter kolom ‘status’ sehingga hanya menampilkan order dengan status “Shipped”.</br>
5. Kelompokkan total_penjualan berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.

```sql
SELETC 
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
```
<details>
<summary markdown="span">OUTPUT :</summary>
  
| quarter | total_penjualan | revenue   |
|---------|-----------------|-----------|
|       1 |            8694 | 799579310 |
|       2 |            6717 | 607548320 |
  
</details>

----

#### Perhitungan Growth Penjualan dan Revenue
Untuk project ini, perhitungan pertumbuhan penjualan akan dilakukan secara manual menggunakan formula yang disediakan di bawah.
</br>
%Growth Penjualan = (6717 – 8694)/8694 = -22%</br>
%Growth Revenue = (607548320 – 799579310)/ 799579310 = -24%

----

#### Apakah jumlah customers xyz.com semakin bertambah?
Penambahan jumlah customers dapat diukur dengan membandingkan total jumlah customers yang registrasi di periode saat ini dengan total jumlah customers yang registrasi diakhir periode sebelumnya.</br>
1. Dari tabel customer, pilihlah kolom customerID, createDate dan tambahkan kolom baru dengan menggunakan fungsi QUARTER(…) untuk mengekstrak nilai quarter dari CreateDate dan beri nama “quarter”</br>
2. Filter kolom “createDate” sehingga hanya menampilkan baris dengan createDate antara 1 Januari 2004 dan 30Juni 2004.</br>
3. Gunakan statement Langkah 1 & 2 sebagai subquery dengan alias tabel_b.</br>
4. Hitunglah jumlah unik customers à tidak ada duplikasi customers dan beri nama “total_customers”</br>
5. Kelompokkan total_customer berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.

```sql
SELECT 
  quarter, 
  count(distinct customerid) AS total_customers
FROM
  (SELECT customerid, createdate, quarter(createdate) AS quarter 
  FROM customer WHERE QUARTER(createdate) <= 2) AS table_b
GROUP BY quarter;
```

<details>
<summary markdown="span">OUTPUT :</summary>

| quarter | total_customers |
|---------|-----------------|
|       1 |              43 |
|       2 |              35 |


</details>

----

####



